# NoSQL Note

## MongoDB
Document Oriented 데이터베이스로 Document는 key-value로 구성되어 있다.
Document는 동적인 스키마를 특징이고 같은 collection 안에서 document끼리 다른 스키마를 가질 수 있다.

### Document
MongoDB는 BSON으로 데이터가 쌓이기 때문에 array나 nested 데이터를 쉽게 넣을 수 있다.

![](https://kciter.so/images/2021-02-25-about-mongodb/bson.png)

`Object`는 RDBMS의 Primary Key와 같은 개념인데 클라이언트 측에서 생성한다. 이는 MongoDB 클러스터에서 샤딩된 데이터를 빠르게 가져오기 위함인데 라우터( mongos )는 `ObjectID`를 통해 Shard에서 데이터를 요청할 수 있다.

### 분산 시스템
더 빠른 읽기 성능과 수평 확장이 가능한 조건을 충족시킨다.

## CAP
어떤 분산 시스템도 아래 3가지 조건을 모두 만족시킬 수 없다는 이론이다.

~[](https://kciter.so/images/2021-02-25-about-mongodb/cap.png)

- Consistency(일관성) : 데이터가 업데이트 되면 모든 노드가 동기화되어 일관성 있는 데이터가 된다.
- Availability(가용성) : 하나의 노드에 장애가 발생해도 다른 노드를 통해 데이터를 제공한다.
- Parition tolerance : 노드 간 통신에 문제가 발생해도 시스템이 계속 동작한다.

*(출처) https://kciter.so/posts/about-mongodb*
 
## PACELC 
현실적으로 네트워크 파티션 상황이 절대 발생하지 않는 경우는 없으므로 발생한 경에 따라 정리한 이론이다.

## MongoDB 장단점

- 데이터를 쓸 때 메모리에 저장한 후 백그라운드 쓰레드를 통해 디스크에 기록한다.
    - write 데이터가 많으면 감당하지 못하며 데이터 삭제나 업데이트할 때 단편화 문제로 필요 이상의 메모리를 사용할 수 있다.
- 하둡처럼 대용량 시스템에 적합한 구조가 아니며 스케일 아웃에 한계가 있다.
- MongoDB 속도는 인덱스 사이즈와 메모리에 달려있는데 메모리가 가득 차서 HDD로 내려가 데이터를 처리하는 속도가 급감하게 된다.
- MongoDB에서 카산드라로 이동하는 경우도 있다. 카산드라 외에 HBASE, HIVE같은 데이터 처리 능력이 더 나은 오픈소소도 많다.
*(출처)*
- https://tiger5net.tistory.com/951
- https://www.bloter.net/newsView/blt201203290001`

## MongoDB Indexes
인덱스는 MongoDB 쿼리의 효율적 실행을 위해 필요하다. 인덱스가 설정되어 있지 않으면 collection scan( collection 내에 모든 document 스캔 )을 수행해야 한다. 인덱스는 특정 field(s)의 값은 정렬되어 저장된다. 

![](https://docs.mongodb.com/manual/images/index-for-sort.bakedsvg.svg)

### Default `_id` index
MongoDB는 collection 생성에서 `_id`라는 고유 index를 생성한다. sharded cluster에서 shard key를 `_id` field로 사용하지 않으면 `_id`의 값이 고유함을 보장해야 한다.

![](https://docs.mongodb.com/manual/sharding/)

## AWS DynamoDB
DynamoDB는 기본키를 통해 테이블의 각 항목을 고유하게 식별하고 보조 인덱스를 사용하여 보다 유연한 쿼리를 작성하도록 한다.

![](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/images/HowItWorksPeople.png

- Table : `Person` 테이블
    - schemaless한 특징이 있다.
- Items : 하나의 칸을 item으로 볼 수 있음
- Attributes : 하나의 칸에 속한 여러 속성들. 각 속성은 여러 속성으로 구성될 수 있음
- Primary Key : `PersonID`로 고유키  
    - Partition Key : simple primary key로(1개의 attribute) DynamoDB는 hash function의 input으로 사용된다. hash function의 output은 파티션을 정한다. 
    - Partition Key & Sort Key : composite primary key(2개의 attribute)로 같은 parition key에 대해 sort key에 따라 정렬되어 저장된다. partition key는 hash attribute, sort key는 range attribute라고도 한다.

### Secondary Indexes
여러 개의 보조 인덱스를 가질 수 있다.
- Global secondary index : 서로 다른 partition key와 sort key로 구성된 index
- Local secondary index : 같은 partition key에 다른 sort key로 구성된 index.

![](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/images/HowItWorksGenreAlbumTitle.png)

위에서 Music 테이블은 Partition key인 Artist, Sort key인 SongTitle로 쿼리할 수 있지만 보조 인덱스 GenreAlbumTitle을 통해 Genre, AlbumTitle를 기준으로 쿼리 할 수도 있다. 

### Partitions and Data Distribution
DynamoDB는 partitions에 따라 데이터를 저장한다. 파티션은 SSD에 백업되는 테이블의 스토리지 할당으로 AWS 리젼에 따라 Availability Zones에 자동으로 replicate된다.  
처음 테이블을 생성하면 `CREATING`이라는 상태로 뜬다. 이 때 DynamoDB는 충분한 파티션을 할당한다.  

DynamoDB는 다음에 따라 partition을 추가한다. 파티션 관리는 백그라운드에서 **자동으로** 이루어진다.
- 기존 파티션이 지원 가능한 한도를 초과하여 테이브릐 할당된 처리량을 늘리는 경우
- 기존 파티션 용량이 다 차서 추가 스토리지 공간이 필요한 경우

*(출처) https://docs.aws.amazon.com/ko_kr/amazondynamodb/latest/developerguide/HowItWorks.html*
*(참고)*
- SQL vs. DynamoDB : https://docs.aws.amazon.com/ko_kr/amazondynamodb/latest/developerguide/SQLtoNoSQL.html