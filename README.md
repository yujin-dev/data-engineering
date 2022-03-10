# Database

## Transaction

Transaction state의 흐름은 아래와 같다.

![Untitled](png/Untitled.png)

Read/Write operation이 들어오면 임시적으로 저장된다.( partially commited ). Commit이 되면 영구적으로 저장되고  operation이 실패하면 Rollback되어 임시 저장된 데이터는 삭제된다.

트랜잭션은 operation 의 순서를 정하는 스케줄이 있다. Serial( Serializable ) 스케줄이라 하는데 트랜잭션이 하나씩 순차적으로 실행되는 것을 의미한다. 이로써 데이터 일관성을 유지할 수 있다.

생성된 트랜잭션 스케줄이 serial schedule과 동일할 때 serializable라고 하는데 여기서 2가지 개념으로 계산된다. 

- Conflict Serializability : non-conflict operation의 순서를 바꿔 serial schedule로 변환이 된다.
    - conflict operations : 2개의 서로 다른 트랜잭션에서 같은 데이터에 대한 operation이 있을 때 하나의 operation이 write인 경우이다( 아래에서 S1, S2, S3 케이스다. )
    
    ![Untitled](png/Untitled%201.png)
    
- View Serializability

![Untitled](png/Untitled%202.png)

**Precedence Graph**

스케줄의 conflict serializability을 테스트할 때 사용되는 그래프이다. 각 트랜잭션이 Graph의 노드라고 하고 트랜잭션 간 conflict가 있을 때 화살표( directed edge )로 표시한다. 만약 cycle이 없다면 conflict serializable 스케줄이 된다. 

![Untitled](png/Untitled%203.png)

위의 경우 cycle이 생기므로 conflict serializable 스케줄이 될 수 없다.

결론적으로 스케줄은 serializable을 만족해야 하고 복구 가능해야 한다. 

아래에서 T1 → T2 순의 트랜잭션이 있을 때 복구 불가능한 경우는 T1의 commit 전에 T2에서 commit이 되어 T1이 실패하면 일관성이 깨지게 된다. T1에서 commit 이후에 T2에서 commit을 해야 복구가 가능하다. 즉, 스케줄은 Cascadeless해야 한다.

![Untitled](png/Untitled%204.png)

**COMMIT & ROLLBACK**

COMMIT을 통해 트랜잭션을 완료한다.

COMMIT, ROLLBACK 이전의 데이터는

- 메모리 버퍼에만 영향을 받았기에 데이터 변경 이전으로 복구할 수 있다.
- 현재 사용자는 SELECT문으로 결과를 확인할 수 있으나,
- 다른 사용자는 현재 사용자가 수정한 결과를 확인할 수 없다.
- 변경된 행은 잠금이 걸려있어 다른 사용자가 동시에 수정할 수 없다.

**COMMIT**

COMMIT 이후의 데이터는

- 변경 사항이 DB에 반영된다.
- 이전 데이터는 폐기된다.
- 모든 사용자는 결과를 확인할 수 있다.
- 관련된 행에 대한 잠금이 풀려 다른 사용자가 수정할 수 있다.

 **ROLLBACK**

COMMIT 이전이면 ROLLBACK을 통해 데이터 변경 사항이 취소되어 이전 상태로 복구된다.

[[DATABASE] TCL 이란? COMMIT, ROLLBACK, SAVEPOINT](https://mozi.tistory.com/209)

## Recovery

트랜잭션의 operation이 실행 중 장애가 발생하면 rollback되어야 하는 Atomicity와 장애 후 commit된 트랜잭션 데이터는 유지되어야 한다는 Durability을 만족시키기 위한 recovery 시스템이 있다. 여기서 write-ahead log(WAL)를 활용한다. 

- 변경된 내용은 디스크에 먼저 기록한다( Atomicity보장 )
- Commit전에 모든 내용에 대한 기록이 저장되어야 한다( Durability )

### **WAL**

- UNDO log : crash 후에 commit되지 않은 변경 사항은 UNDO( 취소 )

![Untitled](png/Untitled%205.png)

Old값( A: 8, B: 8 )에 대한 log를 기록한다 →변경 사항을 반영된 후 commit로그를 flush한다.

- REDO log : crash 후에 commit된 변경 사항은 REDO( raplay )

![Untitled](png/Untitled%206.png)

New값( A: 16, B: 16 )에 대한 log를 기록한다 → commit 로그를 flush한 후 변경 사항을 반영한다 → END log를 기록한다.

## Storage

**Disk Space Management**

테이블은 여러 개의 page단위로 분할되어 저장되는데 disk space 관리는 page에 대한 할당/비할당, Read/Write 와 연관된다.  

**Buffer Management**

![Untitled](png/Untitled%207.png)

buffer cache는 RAM에 저장되는 구조이다. buffer cache를 통해 RAM과 disk에 접슨하는 시간 차이를 줄인다. 

Buffer Pool에서 page를 저장할 때 free frame이 있으면 해당 공간에 저장하고 없으면 LRU에 의해 오래된 frame을 unpin하여 저장한다. *pin*은 page를 사용하는 사용자가 있음을 알려주기 위한 수단인데 pin_count를 통해 표시한다. page 사용이 끝나면 unpin을 해준다. 

**Search for a page in the cache**

프로세스가 page를 읽을 때면 hash table을 이용해 buffer cache에서 탐색한다. 필요한 page를 찾으면 프로세스는 pin count를 증가시켜 buffer를 *pin*시킨다.

[WAL in PostgreSQL: 1. Buffer Cache](https://habr.com/en/company/postgrespro/blog/491730/)

**Record Formats**

Record를 표시하는데 주로 사용하는 방식은 Variable Length이다. 다음 2가지 방식이 있다.

![Untitled](png/Untitled%208.png)

Option1은 특정 문자( $ )로 field를 구분하고, Option2는 각 필드에 대한 offset를 저장하여 직접 접근이 가능하도록 한다. 

**테이블 데이터가 저장되는 방식**

![Untitled](png/Untitled%209.png)

데이터베이스는 Tablespace라는 논리적 저장 영역 단위로 나뉘어진다.

- Tablespace에는 다수의 논리적 Blocks가 있다.( 블록의 크기는 기본 8kb이고, 2kb ~ 32kb이다. ) Blocks은 가장 작은 논리적 I/O 단위이다.
- 연속된 논리적 블록이 일정 갯수가 되면 extent가 형성된다.
- 논리적 구조에 할당된 extent 집합은 하나의 segment를 형성하게 된다.

![Untitled](png/Untitled%2010.png)

논리적으로, Table은 각 Column의 값이 기입된 Row들로 구성된다.  각 Row는 데이터베이스 블록에 저장된다.

**DBA( Data Block Address )**

데이터 블록에서 고유 주소값으로 디스크에서 몇 번 데이터 파일의 몇 번째 블록인지를 의미한다.

인덱스를 이용해 테이블 레코드를 읽을 때 인덱스 ROW ID를 이용하며 ROW ID는 DBA + Row 번호로 구성된다.

### **Random Access**

- **랜덤 액세스**는 데이터를 저장하는 블록을 한번에 여러 개 접근하는 것이 아니라 한 번에 하나의 블록만을 접근하는 싱글 블록 I/O 방식이다.
    
    반대로, Table Full Scan은 한 번에 여러 개의 블록을 접근하는 멀티 블록 I/O 방식인다.
    
    Index Scan시 Read 블록에는 테이블의 행을 가리키는 ROW ID가 존재한다. Index Scan에서 데이터를 탐색하는 주소 값인 ROW ID를 확인하여 테이블에 액세스한다.
    

![Untitled](png/Untitled%2011.png)

- 확인 랜덤 액세스 : `WHERE`조건에서 컬럼이 인덱스에 존재하지 않아 테이블을 액세스한다.
- 추출 랜덤 액세스 : `SELECT`절의 컬럼을 결과로 추출하기 위해 테이블에 액세스한다.
- 정렬 랜덤 액세스 : `ORDER BY`, `GROUP BY`절 컬럼이 인덱스에 존재하지 않아 추가하기 위해 테이블에 액세스한다.

랜덤액세스 중 추출되는 데이터를 감소시키는 확인 랜덤 액세스르르 감소시키는 방안이 성능에서 중요하다.

[랜덤 액세스에 대하여](https://blackhairdeveloper.tistory.com/3)

**Sequential Access vs. Random Access**

![Untitled](png/Untitled%2012.png)

Sequential Access는 논리적, 물리적으로 연결된 순서에 따라 차례대로 블록을 읽어들이는 방식이다.

인덱스 Reaf 블록은 앞뒤를 가리키는 주소값으로 연결되어 있기에 이를 이용하여 순차적으로 스캔한다.(Full Scan)

Random Access는 논리적, 물리적 순서가 아닌 레코드 하나를 위기 위해 한 블록씩 접근하는 방식이다.

[시퀀셜 액세스와 랜덤 액세스](https://wedul.site/400)

## **이중화 HA, OPS, RAC 구성**

1. HA 구성 

HA(High Availability)는 2개의 서버로 구성되어 하나는 active, 나머지 하나는 standby 상태로 해놓는다.

active 서버가 모든 부하를 담당하며 장애가 발생하면 standby 서버가 active가 되면서 다시 서비스를 정상 작동할 수 있도록 한다.

active 서버가 멈추면 standby 서버가 활성화될 때 트랜잭션이 모두 유실될 수 있다. 따라서 실시간 트랜잭션이 많은 서비스에는 사용하기 힘들다.

기본적으로

- 데이터 복제 기능 : 2개의 서버 데이터가 항상 동일해야 한다는 무결성이 필요하다.
- 장애 감시 기능
1. OPS 구성

OPS( Oracle Paralled Server )는 인스턴스가 모두 active로 동작하기에 이론적으로는 부하를 50%씩 분산할 수 있고, 속도도 2배 빨라질 수 있다.

하나의 스토리지를 사용하여 동기화에도 문제가 없다.

RAC Ping은 같은 사용자가 2개의 서버에 동시 접근할 경우 인스턴스2에서 변경이 완료된 데이터를 인스턴스2로 가져오기 위해 저장하고 복사해야 한다.

1. RAC 구성

RAC( Real Application Cluster )는 RAC Ping문제가 개선된 것으로 서로 다른 인스턴스에서 변경된 데이터를 디스크를 거치지 않고 바로 가져올 수 있는 Cache Fusion이라는 기능이 사용된다.

[[DB] 이중화 HA, OPS, RAC 구성](https://yoo-hyeok.tistory.com/120)