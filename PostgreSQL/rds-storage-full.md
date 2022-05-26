# RDS - `STORAGE_FULL`

기존에 사용하던 PostgreSQL RDS 인스턴스에 연결이 안되어 state를 확인해보니 `STORAGE_FULL`였다.
STORAGE_FULL 상태는 RDS 인스턴스가 작업을 수행할 충분한 공간이 없는 상태로 [Amazon RDS DB 인스턴스에 스토리지가 부족할 때 발생하는 문제를 해결하려면 어떻게 해야 합니까?](https://aws.amazon.com/ko/premiumsupport/knowledge-center/rds-out-of-storage/)에 따라 스토리지를 늘려야 한다.

근본적으로 스토리지가 늘어난 이유를 해결하기 위해 DB로그 크기를 제어하거나 tempDB 크기를 줄이라고 한다.

이전에 PostgreSQL WAL 로그를 생성하도록 수정해서 발생한 것으로 추정된다.
데이터 크기가 1TB가 안되는데, 스토리지 자동 스케일링을 1.3TB까지만 가능하게 해서 용량 증가 원인이 로그때문으로 파악하였다.

확인해보니 WAL 로그에서 차지하는 스토리지 공간이 아래와 같다.
```sql
select concat(sum(size)/1024^4, 'TB') as total_wal_size from pg_ls_waldir();
total_wal_size   
-------------------
 1.0372314453125TB
(1 row)

```
생각보다 WAL이 차지하는 공간이 크다.

WAL 파일에 대한 설정이 필요하다. [WAL 환경 설정](https://www.postgresql.kr/docs/9.4/wal-configuration.html)에 따라 checkpoint 간격을 늘려보기로 한다.
현재는 아래와 같이 5분으로 설정되어 있는데, 20분으로 설정하였다.
```sql
show checkpoint_timeout;
 checkpoint_timeout
--------------------
 5min
(1 row)
```

### [추가] setting 관련 정의 확인하기
configuration 관련 변수에 대한 설명이나 현재값, 도메인을 확인할 수 있는 테이블이 있다.
```sql
select * from pg_settings where name = 'wal_level';
   name    | setting | unit |          category          |                    short_desc                    | extra_desc |  context   | vartype |       source       | min_val | max_val |         enumvals          | boot_val | reset_val |            sourcefile             | sourceline | pending_restart
-----------+---------+------+----------------------------+--------------------------------------------------+------------+------------+---------+--------------------+---------+---------+---------------------------+----------+-----------+-----------------------------------+------------+-----------------
 wal_level | logical |      | Write-Ahead Log / Settings | Set the level of information written to the WAL. |            | postmaster | enum    | configuration file |         |         | {minimal,replica,logical} | replica  | logical   | /rdsdbdata/config/postgresql.conf |         80 | f
(1 row)
```
`name`, `setting`이 환경 변수 이름, 값이고 정의나 설정 가능한 값이나 범위를 확인할 수 있다.

