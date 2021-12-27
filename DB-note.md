# DB Note 

## 이중화 HA, OPS, RAC 구성

1. HA 구성
HA(High Availability)는 2개의 서버로 구성되어 하나는 active, 나머지 하나는 standby 상태로 해놓는다.
active 서버가 모든 부하를 담당하며 장애가 발생하면 standby 서버가 active가 되면서 다시 서비스를 정상 작동할 수 있도록 한다.
active 서버가 멈추면 standby 서버가 활성화될 때 트랜잭션이 모두 유실될 수 있다. 따라서 실시간 트랜잭션이 많은 서비스에는 사용하기 힘들다.

기본적으로
- 데이터 복제 기능 : 2개의 서버 데이터가 항상 동일해야 한다는 무결성이 필요하다.
- 장애 감시 기능

2. OPS 구성
OPS( Oracle Paralled Server )는 인스턴스가 모두 active로 동작하기에 이론적으로는 부하를 50%씩 분산할 수 있고, 속도도 2배 빨라질 수 있다.
하나의 스토리지를 사용하여 동기화에도 문제가 없다.

RAC Ping은 같은 사용자가 2개의 서버에 동시 접근할 경우 인스턴스2에서 변경이 완료된 데이터를 인스턴스2로 가져오기 위해 저장하고 복사해야 한다.

3. RAC 구성
RAC( Real Application Cluster )는 RAC Ping문제가 개선된 것으로 서로 다른 인스턴스에서 변경된 데이터를 디스크를 거치지 않고 바로 가져올 수 있는 Cache Fusion이라는 기능이 사용된다. 

*(출처)https://yoo-hyeok.tistory.com/120*