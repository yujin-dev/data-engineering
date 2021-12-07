# Distributed Storage

## Hadoop
- 하둡은 대용량 데이터를 분산 처리할 수 있는 자바 기반 프레임워크 
- 분산시스템인 HDFS( Hadoop Distributed File )에 데이터를 저장하고, MapReduce로 데이터를 처리한다.
    - 여러 대의 서버에 데이터를 저장하고 동시에 각 서버에서 처리하는 방식이다.
- RDBMS는 트랜젝션이나 무결성을 보장하는 데이터 처리에 특화되어 있고 하둡은 배치로 데이터를 처리하는데 적합한 시스템이다.

### HDFS
- 대용량 파일을 분산된 서버에 저장하고 그 저장된 데이터를 빠르게 처리할 수 있는 파일시스템
    - 블록 구조의 시스템으로 특정 크기의 블록으로 나누어 분산된 서버에 저장한다.
- 스트리밍 방식으로 데이터를 접근하는 방식으로 배치 작업과 처리량이 많은 데이터에 사용된다.

#### HDFS vs. Cloud Storage
**[ Cloud Storage 단점 ]**
- 데이터에 대한 I/O 분산이 크다 : Cloud Storage는 데이터를 연속적으로 저장하지 않기에 데이터 지역성 문제가 있을 수 있다.( HBase, NoSQL )  
- 파일의 append / truncates가 필요한 경우 : Object Storage는 데이터를 하나의 객체로 처리하기에 객체 변경이 불가능하다. 한 번 업로드된 객체는 변경하려면 기존 객체를 삭제 후 새로 생성해야 한다.
- 어플리케이션에서 POSIX 연산을 사용해야 하는 경우

**[ Cloud Storage 장점 ]** 
- 데이터 저장을 위한 가격이 현저히 낮다.
- 스토리지와 컴퓨팅 리소스를 분리할 수 있다.
- 스토리지로 인한 오버헤드가 없다.


*(출처)*
- https://yookeun.github.io/java/2015/05/24/hadoop-hdfs/
- https://nathanh.tistory.com/91

## Storage Type
File Storage, Block Storage는 OS단에서 동작하지만 Object Storage는 어플리케이션 단에서 동작한다.
Object Storage는 S3나 Cloud Storage의 형식으로 물리적 제약이 없는 논리적인 스토리지라고 할 수 있다.

![](https://miro.medium.com/max/770/1*wbpNIDluXRa6aV26tpbwbQ.gif)

### File Storage
폴더와 파일로 계층구조를 갖는 스토리지이다.
### Block Storage
정해진 블록 안에 데이터를 저장하는 스토리지이다. SQL에서 테이블을 명시하고 데이터 삽입시 정해진 포맷에 맞춰 데이털르 저장하는 것이 이와 유사하다.
낮은 I/O latency로 RDB 같은 데이터베이스에 적합하다.

### Object Storage
클라우드에서 확장성, 속도, 가격 때문에 Object Storage를 많이 사용한다. Key - Value만 저장하면 HTTP 로 요청하여 파일을 받을 수 있다.  
파일에 대한 메타 정보가 적기 때문에 File이나 Block Storage에 비해 빠르게 작동하고, 공간을 효율적으로 사용할 수 있다.  
하지만 트랜젝션으로 일관성을 유지하는 방식이 아니기 때문에 데이터 수정이 어렵다. 파일을 덮어쓰는 방법을 이용하여 수정한다.   
![](https://medium.com/harrythegreat/%ED%81%B4%EB%9D%BC%EC%9A%B0%EB%93%9C%EC%83%81-%EC%98%A4%EB%B8%8C%EC%A0%9D%ED%8A%B8-%EC%8A%A4%ED%86%A0%EB%A6%AC%EC%A7%80-object-storage-%EB%9E%80-9d9c2da57649)


## AWS Glue
AWS Glue를 통해 데이터 웨어하우스, 데이터 레이크의 스토리지에 데이터를 구성/정리/검증/포맷 할 수 있다.
서버리스 환경에서 작동하여 사용한 리소스에 대해서만 비용을 지불할 수 있다.

### AWS Glue Data Catalog
AWS Glue 데이터 카탈로그는 모든 데이터의 정형, 운영 메타 데이터를 관리하는 중앙 저장소이다.
테이블 정의를 추가하면 이를 ETL에 사용할 수 있고 쿼리할 수 있다.

Glue 크롤러가 정기적으로 실행되도록 하여 메타데이터가 항상 최신으로 유지되고 기본 데이터와 동기화되도록 한다.
AWS Glue 크롤러는 데이터 스토어에 연결하여 우선순위에 따라 분류 목록을 거쳐 데이터 스키마 등을 추출한 후, 이러한 메타데이터를 카탈로그에 채운다.

데이터 웨어하웃, 데이터 레이크를 생성하기 위해 데이터의 카탈로그를 작성하는데 주로 데이터의 위치, 스키마, 실행 시간 측정치에 대한 인덱스이다.
ETL 구조에서 데이터 스키마를 이용해서 데이터 처리를 한다.

*(참고)*
- AWS Glue ETL : https://tech.cloud.nongshim.co.kr/2021/08/19/hands-on-aws-glue-studio-etl/