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
- 파일의 append / truncates가 필요한 경우 : Object Storage는 데이터를 하나의 객체로 처리하기에 객체 변경이 불가능하다. 한 번 업로드된 객체는 변경하려면 기존 객체를 삭제 후 새로 생성해야 한다.`
- 어플리케이션에서 POSIX 연산을 사용해야 하는 경우

**[ Cloud Storage 장점 ]** 
- 데이터 저장을 위한 가격이 현저히 낮다.
- 스토리지와 컴퓨팅 리소스를 분리할 수 있다.
- 스토리지로 인한 오버헤드가 없다.


*(출처)*
- https://yookeun.github.io/java/2015/05/24/hadoop-hdfs/
- https://nathanh.tistory.com/91