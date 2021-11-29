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