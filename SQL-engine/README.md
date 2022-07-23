*SQL 처리*

SQL은 *structured*, *set-based*, *declarative*한 특징이 있다. 
# SQL 최적화
SQL 최적화는 DBMS 내부에서 프로시저를 작성, 컴파일하여 실행 가능한 형태로 만드는 모든 과정을 의미한다.

최적화 과정은 다음과 같다.
1. SQL 파싱 
2. SQL 최적화 : 옵티마이저를 통해 다양한 실행 경로를 비교하여 가장 효율적인 하나를 선택한다. 비용 기반 옵티마이저는 통계 정보를 기반으로 쿼리 수행시 발생할 I/O 횟수와 소요 시간을 예상하여 최저 비용 경로를 정한다.
3. 로우 소스 생성 : 옵티마이저가 선택한 경로를 실제 실행 가능한 코드 및 프로시저로 포맷팅한다.

# SQL 재사용
*라이브러리 캐시*란 내부 프로시저를 반복하여 사용할 수 있도록 캐싱하는 메모리 공간이다. 

*SGA( System Global Area )*는 서버 프로세스, 백그라운드 프로세스가 공통으로 접근하는 데이터와 제어 부분을 캐싱하는 메모리 공간이다. SGA의 Shared Pool에 라이브러리 캐시가 존재한다. SQL을 파싱하면 다음 2가지 중 하나가 발생한다.
- *소프트 파싱* : 파싱한 SQL을 캐시에 바로 찾아 실행한다.
- *하드 파싱* : 캐시에서 찾지 못해 최적화하여 로우 소스를 생성한다.

# Disk Space Management
SQL이 느린 이유는 보통 **디스크 I/O 때문**이다. I/O가 처리되는 동안 CPU는 wait queue에서 대기해야 하므로 I/O 병목이 문제가 되는 경우가 대부분이다.  
따라서 SQL 튜닝은 곧 I/O 튜닝이다.

## 데이터 저장 구조
테이블은 여러 개의 블록(페이지)단위로 분할되어 저장되는데 disk space 관리는 page에 대한 할당/비할당, read/write 와 연관된다.  

![Untitled](../png/Untitled%209.png)

- Block : 데이터를 읽고 쓰는 단위로 가장 작은 논리적 I/O 단위이다. 블록의 크기는 기본 8kb이고, 2kb ~ 32kb이다. 블록은 각 Column의 값이 기입된 Rows로 구성된다.
- Extent : 공간을 확장하는 단위로 연속된 블록의 집합이다.
- Segment : 데이터 저장공간이 필요한 오브젝토로 테이블, 인덱스, 파티션은 하나의 세그먼트이다.
- Tablespace : Segment를 담은 컨테이너이다.  

데이터 파일은 디스크상의 물리적인 OS 파일이다.

### *DBA*

*DBA( Data Block Address )* 는 **블록에서 고유 주소값**으로 디스크에서 몇 번 데이터 파일의 몇 번째 블록인지 의미한다.  
인덱스를 이용해 테이블 레코드를 읽을 때 인덱스 ROWID를 사용하는데, ROWID는 DBA + Row 번호로 구성된다.

### Buffer Management
buffer cache는 RAM에 저장되는 구조이다. buffer cache를 통해 메모리와 디스크에 접근하는 시간을 줄일 수 있다.

![Untitled](../png/Untitled%207.png)

- Buffer Pool에서 page를 저장할 때 free frame이 있으면 해당 공간에 저장하고, 없으면 LRU에 의해 오래된 frame을 unpin하여 데이터를 저장한다. 
- *pin*은 page를 사용하는 사용자가 있음을 알려주기 위한 수단인데 pin_count를 통해 표시한다. page 사용이 끝나면 unpin을 해준다. 

### Search for a page in the cache

프로세스가 page를 읽을 때면 hash table을 이용해 buffer cache에서 탐색한다. 
필요한 page를 찾으면 프로세스는 pin count를 증가시켜 buffer를 *pin*시킨다.


## Record Format

Record를 표시하는데 주로 사용하는 방식은 Variable Length이다. 다음 2가지 방식이 있다.

![Untitled](../png/Untitled%208.png)

- Option 1 : 특정 문자( $ )로 field를 구분한다.
- Option 2 : 각 필드에 대한 offset를 저장하여 직접 접근이 가능하도록 한다. 

## Sequential Access vs. Random Access

![Untitled](../png/Untitled%2012.png)

*Sequential Access*란 논리적, 물리적으로 **연결된 순서에 따라 차례대로 블록을 읽어들이는** 방식이다. 
인덱스 Reaf 블록은 앞뒤를 가리키는 주소값으로 연결되어 있기에 이를 이용하여 순차적으로 스캔한다(Multi Block I/O 방식). Table Full Scan에서 사용하는 방식이다.

*Random Access*란 논리적, 물리적 순서가 아닌 레코드 하나를 위기 위해 **한 블록씩 접근**하는 방식이다(Single Block I/O 방식). Index Scan에서 사용하는 방식이다. Index Scan에서는 아래와 같이 테이블의 행을 가리키는 ROWID를 확인하여 블록에 액세스한다.

![Untitled](../png/Untitled%2011.png)

랜덤 액세스는 다음과 같이 있다.
- 확인 랜덤 액세스 : `WHERE`조건에서 컬럼이 인덱스에 존재하지 않아 테이블을 액세스한다.
- 추출 랜덤 액세스 : `SELECT`문의 컬럼을 결과로 추출하기 위해 테이블에 액세스한다.
- 정렬 랜덤 액세스 : `ORDER BY`, `GROUP BY`절 컬럼이 인덱스에 존재하지 않아 추가하기 위해 테이블에 액세스한다.

랜덤액세스 중 추출되는 데이터를 감소시키는 확인 랜덤 액세스를 감소시키는 방안이 성능에서 중요하다.

> 출처 :   
[WAL in PostgreSQL: 1. Buffer Cache](https://habr.com/en/company/postgrespro/blog/491730/)  
[시퀀셜 액세스와 랜덤 액세스](https://wedul.site/400)  
[랜덤 액세스에 대하여](https://blackhairdeveloper.tistory.com/3)  
친절한 SQL 튜닝