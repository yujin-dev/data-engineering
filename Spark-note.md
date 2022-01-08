# Spark Note

## Spark
- MapReduce : 디스크로부터 데이터를 읽은 후 Map을 통해 데이터를 key-value로 묶은 후 Reduce를 통해 중복된 데이터를 제거하고 가공하여 디스크에 저장한다. 
- MapReduce 같은 파일 기반의 디스크 I/O는 성능이 좋지 않고 In-Memory기반의 연산을 통해 처리 성능을 향상시키기 위해 Spark가 등장
- Fault Tolerance & Data Parallelism
- 클러스터를 관리하는 Cluster Manager와 데이터를 분산 저장하는 Distributed Storage System이 필요하다.
    - Cluster Mananer로는 Hadoop의 YARN이나 Apache Mesos 등이 있다.
    - Distributed Storage System로는 HDFS, Cassandra, S3, Kudu 등이 있다.

### API
- RDD : 여러 클러스터에 분산되어 있으며 fault-tolerant한 방식으로 유지되는 read-only형태의 데이터 모음이다. 
    ```
    lines = spark.textFile("hdfs://...") # HDFS로부터 데이터를 읽어옴
    errors = lines.filter(_.startWith("Error")) # ERROR로 시작되는 데이터만 필터링하여 RDD 생성
    errors.persist() # In-Memory에 errors RDD를 persist
    errors.count() 
    errors.filter(_.contains("HDFS"))\
        .map(_.split('\t')(3))\
        .collect()
    ```
- DataFrame : 스키마를 가진 RDD로 RDB의 테이블과 비슷하다.
- DataSet

*(출처) https://mangkyu.tistory.com/128*

## Spark, Hadoop 설치
**[ 도커 띄워서 spark 설치 ]**
우분투 이미지를 받는다.
```console
$ docker pull ubuntu
$ docker run -itd --name spark-base ubuntu
$ docker exec -it spark-base bashapt-get update
$ apt-get install vim wget unzip ssh openjdk-8-jdk python3-pip
$ pip3 install pyspark
```

openjdk 환경변수를 등록한다.
```console
$ vi ~/.bashrc
$ export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
```
하둡을 설치한다. 
```console
$ mkdir /opt/hadoop && cd /opt/hadoop
$ wget <https://mirror.navercorp.com/apache/hadoop/common/hadoop-3.2.2/hadoop-3.2.2.tar.gz>
$ tar -xzf hadoop-3.2.2.tar.gz
$ rm hadoop-3.2.2.tar.gz

# 환경변수 등록
$ vi ~/.bashrc
$ export HADOOP_HOME=/opt/hadoop/hadoop-3.2.2
$ export PATH=${HADOOP_HOME}/bin:$PATH
$ source ~/.bashrc
```

스파크를 설치한다.
```console
# 폴더 생성 및 하둡 바이너리 파일 다운로드 / 압축 해제
$ mkdir /opt/spark && cd /opt/spark
$ wget https://mirror.navercorp.com/apache/spark/spark-3.1.2/spark-3.1.2-bin-hadoop3.2.tgz
$ tar -xzf spark-3.1.1-bin-hadoop2.7.tgz
$ rm spark-3.1.1-bin-hadoop2.7.tgz

# 환경변수 등록
$ vi ~/.bashrc
$ export SPARK_HOME=/opt/spark/spark-3.1.1-bin-hadoop2.7.tgz
$ export PATH=${SPARK_HOME}/bin:$PATH
$ export PYSPARK_PYTHON=/usr/bin/python3
$ source ~/.bashrc
```
*(출처) https://eprj453.github.io/spark/2021/05/08/spark-docker-ubuntu-%EC%BB%A8%ED%85%8C%EC%9D%B4%EB%84%88%EB%A1%9C-spark-%EC%8B%A4%EC%8A%B5%ED%99%98%EA%B2%BD-%EB%A7%8C%EB%93%A4%EA%B8%B0-1.-%EC%BB%A8%ED%85%8C%EC%9D%B4%EB%84%88-%EC%A4%80%EB%B9%84/*

**[ 로컬에 설치 ]**
*(참고) https://dreamlog.tistory.com/607*

## Postgresql 연동
Spark에서 PostgreSQL 데이터를 읽어오려면 JDBC를 이용해야 한다.


*(출처)
- https://urame.tistory.com/entry/Spark-PostgreSQL-%EC%97%B0%EB%8F%99-%EB%B0%A9%EB%B2%95-jdbc-spark-sql
