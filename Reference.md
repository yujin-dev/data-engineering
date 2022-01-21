## 생활코딩[ 리눅스 ]
### overview
https://www.youtube.com/watch?v=DsG-JWrFJTc&list=PLuHgQVnccGMBT57a9dvEtd6OuWpugF9SH

- I/O Redirection : `>` 로 유닉스에서 standard input, output을 redirection 할 수 있다.
- shell - kernel

![](https://oopy.lazyrockets.com/api/v2/notion/image?src=https%3A%2F%2Fs3-us-west-2.amazonaws.com%2Fsecure.notion-static.com%2F461c81ee-3903-4cce-ba36-f684f905b0d8%2FUntitled.png&blockId=ef5caeb8-3e3f-4a05-9b41-b285f0da08ab)

- 기본 명령어들은 binary 파일이다.
- locate는 파일 시스템을 데이터베이스에 저장하여 파일 위치를 빠르게 찾을 수 있고, find는 실시간으로 파일 위치를 검색할 수 있다.


## 기술블로그[ 데이터 엔지니어링 ]
### 쏘카

#### 딥러닝 서비스 
Input으로 차량 이미지를 받아 Output으로 파손과 관련된 정보를 담은 이미지로 생성하는 서비스를 통합

![](https://tech.socarcorp.kr/img/posts_dl_serving/picture01.png)

- 이미지 수집 :S3
- 사내 시스템 - 모델 : SQS를 사용하여 queue에 전송( protocol buffers를 사용 )
- 로그 수집 : 모델 agent의 상태를 Fluentd로 수집하여 S3에 저장
- 배포 : Git을 활용하여 docker image를 빌드하여 배포
- 스케일링 : 쿠버네티스로 스케일링 확보
- 모니터링 : 보다 상세한 상태는 Prometheus, Grafana를 사용하나, 간단한 확인은 Rancher를 활용. 실시간 로그도 stdout으로 확인 가능

*(출처) https://tech.socarcorp.kr/data/2020/03/10/ml-model-serving.html*

#### 데이터 분석 환경 만들기 
여기 저기 퍼져 있는 데이터를 별도의 저장소로 한번에 모아야 함
- 별도의 통합 저장소 : BigQuery
- 워크플로우 : Airflow

![](https://tech.socarcorp.kr/img/what-socar-data-engineering-team-does/datalake-diagram.001.jpeg)

- 자주 사용하는 데이터는 별도로 정제 및 집계하여 데이터 마트를 구성( SODA Store )
- 분석 및 모델링 결과를 서비스에 반영하는 백엔드 서비스 : 백엔드 서비스를 개발하고 쿠버네티스 환경 배포, HTTP 통신으로 flask를 사용하거나 gRPC 사용
- 로직 최적화 및 캐싱 기법 등 적용
- computing resource 관리 : 알람 메시지로 모니터링

*(출처) https://tech.socarcorp.kr/data/2021/06/01/data-engineering-with-airflow.html*

### 당근마켓

#### 채팅 데이터 파이프라인

![](https://miro.medium.com/max/2000/1*8qOL0AM3kJkxXD-0PHBAMw.png)

- DynamoDB의 변경 이벤트 포착 기능으로 구축( Outbox )
    - DynamoDB는 Read를 반복 수행하면 Capacity Unit을 소진시켜 병목이 발생한다. Eventually Consistent Read는 4KB마다 0.5 RCU를 사용하고, Strong Consistent Read는 4KB 마다 1 RCU를 사용한다. Scan은 주어진 테이블의 모든 항목을 다 읽어오는데 기본적으로 Eventually Consistent Read를 수행한다. 한번에 최대 1MB( 128 RCU = 1MB/4KB * 0.5RCU )를 소비한다. 스캔하는 동안 다른 Read 작업이 throttle 될 위험이 있다.
    - DynamoDB는 테이블 항목 변경을 자동으로 포착하고 스트림 레코드 형태로 반환하는 스트림 기능을 제공한다. 
- S3에 데이터 저장 : 데이터를 한번에 많이 조회하지만 횟수가 많지 않아 S3에 저장하고 Athena로 조회한다.
- 이벤트 스토어 서비스 : 테이블 항목 변경 이벤트를 스트림 레코드 형태로 받아 관리
    - DDB Streams : Lambda 또는 커스텀 어플리케이션만 연결 가능
    - KDS(Kinesis Data Streams) : AWS 의 다른 데이터 프로세싱 서비스에도 연결 가능
    - Kinesis Data Firehose : 다양한 소스로부터 대량의 스트리밍 데이터를 받아 캡쳐하고 변환하여 전송하는 데이터 Delivery 서비스. KDS와 함께 연결하여 사용 가능 
    
*(출처) https://medium.com/daangn/dynamodb-%EB%8D%B0%EC%9D%B4%ED%84%B0-%EB%B3%80%EA%B2%BD-%EC%9D%B4%EB%B2%A4%ED%8A%B8-%ED%8C%8C%EC%9D%B4%ED%94%84%EB%9D%BC%EC%9D%B8-%EA%B5%AC%EC%B6%95%ED%95%98%EA%B8%B0-feat-kinesis-1733db06066*

### 뱅크샐러드
#### 프로덕션 환경에서 사용하는 golang과 gRPC

- 기존 서비스 안정화 작업이나 신규 서비스는 Go로 진행하는데 네트워크 통신에 gRPC를 활용하는 경우가 많아짐
    - gRPC는 HTTP/2 레이어 위에서 protocol buffers를 사용해 직렬화된 Byte 스트림으로 통신하는데 JSON 기반보다 더 가볍고 통신속도가 빠름
- 모든 protobuf는 IDL(Interface Definition Language)는 하나의 리포지토리 안에서 관리
- grpc-gateway 사용 :기존의 JSON 기반의 REST API는 gRPC가 HTTP 통신을 지원하기에 호환

*(출처) https://blog.banksalad.com/tech/production-ready-grpc-in-golang/*

### Data Discovery Platform
*(참고)*
- 정의 : https://news.hada.io/topic?id=3247
- open source : https://eugeneyan.com/writing/data-discovery-platforms/

### 왓챠
#### 로그 분석 플랫폼
로그를 한곳에 통합하고 빠르게 분석, 유연하게 수집 및 가공하기 위한 시스템을 구축

- 멀티 클라우드(GCP, AWS, Elastic Cloud)
- Consul, Prometheus, Grafana : 로그 모니터링 시스템( Consul은 service discovery,Prometheus는 metric수집, Grafana는 visualization )
- Airflow, Embulk : 데이터 가공
- Fluent-Bit( Fluentd )
- PubSub
- BigQuery : 로그 저장 및 분석용
- Golang : Fluent-Bit 플러그인 개발이나 실시간으로 받은 데이터 가공 후 처리
- Protocol Buffers : 직렬화 프로토콜

[ 수집 ]  
![](https://miro.medium.com/max/1225/1*yMT6DthBkvvhelhmquZeeQ.png)
- FireBase : client에서 발생하는 로그를 수집. Bigquery로 migration 가능
- Fluent-Bit : 여러 서비스의 로그 파일에서 로그를 수집. PubSub으로 로그 전송 
- Direct 전송

[ 처리 ]  
![](https://miro.medium.com/max/1225/1*XnUNYbWKif4QYvilBPPLUw.png)
- Embulk를 이용한 BigQuery 저장 
- Elastic Cloud 이용한 실시간 분석 : BigQuery와 같은 빅데이터 분석용은 실시간 분석이나 가벼운 검색이 적합하지 않아 Elastic Search를 이용
- BigQuery의 데이터에서 세부적인 가공이 필요한 경우 airflow로 여러 단계에 걸쳐 가공하여 DataStudio로 시각화

[ 모니터링 ]  
![](https://miro.medium.com/max/1225/1*vndtcMf1qgAQXpS15Wdrkg.png)


- Consul : Fluent-Bit가 Consul에 등록되면 서비스별로 로그 수집 agent 상태를 확인할 수 있다.(주기적인 health check)
- Prometheus : Consul를 통해 서비스별로 live agent리스트를 찾아 직접 접근하여 metric을 수집
- Grafana : Prometheus에서 수집한 metric을 시각화

*(출처) https://medium.com/watcha/%EB%A9%80%ED%8B%B0%ED%81%B4%EB%9D%BC%EC%9A%B0%EB%93%9C%EB%A5%BC-%EC%9D%B4%EC%9A%A9%ED%95%9C-%EB%A1%9C%EA%B7%B8-%EB%B6%84%EC%84%9D-%ED%94%8C%EB%9E%AB%ED%8F%BC-%EA%B0%9C%EB%B0%9C%ED%95%98%EA%B8%B0-8c5f671df559*

### LINE
#### 쇼핑 플랫폼 
[ 데이터를 배치 단위로 처리하다 이벤트 기반(EDA)으로 전환하여 Kafka를 사용 ]  

![](https://engineering.linecorp.com/ko/lineshopping3/)

- 데이터의 변경을 감지하기 위해 MongoDB, MySQL의 로그를 Kafka Connect를 이용하여 전달 : MongoDB의 모든 변경 사항이 kafka의 CDC토픽에 쌓임
- Kafka, Kafka Connect 를 이용하면 변경된 데이터를 쉽게 얻을 수 있음
- 확장성이 필요한 벌크 데이터는 MongoDB에, 트랜잭션 처리는 MySQL에 따로 저장
- 이기종 간 데이터 조인은 Kafka Streams, KSQL로 수행할 수 있음 
    1. MongoDB, MySQL 변경 데이터를 Kafka Connect로 각각의 CDC 토픽으로 전송  
    2. Kafka Streams, KSQL로 두 토픽을 실시간으로 조인  
    ![](https://engineering.linecorp.com/ko/lineshopping4/)

[ HBase를 이용한 데이터 변경 추적 ]  
![](https://engineering.linecorp.com/ko/lineshopping6/)

- 데이터가 어느 시점에 어떤 값이었는지 추적하기 위한 용도
- Hbase는 칼럼형 DB로  변경된 데이터만 칼럼 단위로 저장해 저장 공간 사용을 최소화할 수 있음
- Hive로 대량 데이터 기반 SQL 사용 가능

*(출처) https://engineering.linecorp.com/ko/blog/line-shopping-platform-kafka-mongodb-kubernetes/*

#### Airflow on Kubernetes
*참고* 
- [Kubernetes를 이용한 효율적인 데이터 엔지니어링(Airflow on Kubernetes VS Airflow Kubernetes Executor)](https://engineering.linecorp.com/ko/blog/data-engineering-with-airflow-k8s-1/)

#### Kafka 사용
*참고*
- [LINE에서 Kafka를 사용하는 방법](https://engineering.linecorp.com/ko/blog/page/13/)

### Airbnb
#### 로그 시스템
![](https://miro.medium.com/max/1400/1*93TvjWjYDVgBw2NNNS2Kvg.png)


### 우아한 형제들
사용 Tip 위주로 
*참고*
- [우아한 형제들](https://techblog.woowahan.com/)