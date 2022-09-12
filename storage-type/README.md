# Storage Type
File Storage, Block Storage는 OS단에서 동작하지만 Object Storage는 어플리케이션 단에서 동작한다.
Object Storage는 S3나 Cloud Storage의 형식으로 물리적 제약이 없는 논리적인 스토리지라고 할 수 있다.

- **블록 스토리지**가 데이터를 블록으로 나누어 관리한다.
- **파일 시스템**이 계층형 구조의 디렉토리에 저장한다.
- **오브젝트 스토리지**는 데이터를 object 단위로 관리한다.

![](https://miro.medium.com/max/770/1*wbpNIDluXRa6aV26tpbwbQ.gif)

## File Storage
폴더와 파일로 계층구조를 갖는 스토리지이다.
- 데이터가 디렉토리에 저장된다.
- 파일마다 파일의 위치, 크기, 생성일, 블록 위치 등에 대한 메타 정보를 갖고 있어 탐색 및 수정 작업을 OS 내에서 지원하게 된다.

## Block Storage
정해진 블록 안에 데이터를 저장하는 스토리지이다. SQL에서 테이블을 명시하고 데이터 삽입시 정해진 포맷에 맞춰 데이털르 저장하는 것이 이와 유사하다.
낮은 I/O latency로 RDB 같은 데이터베이스에 적합하다.

- 블록 저장방식의 경우, 데이터를 Block이라는 고정 크기의 단위로 나뉘어 저장한다. 
- 각 블록은 저장된 위치에 대한 고유 주소를 갖고 있어, 주소만 알고 있으면 분산 저장된 데이터를 찾아 하나의 데이터로 재구성한다.

## Object Storage
클라우드에서 확장성, 속도, 가격 때문에 Object Storage를 많이 사용한다. Key - Value만 저장하면 HTTP 로 요청하여 파일을 받을 수 있다.  
파일에 대한 메타 정보가 적기 때문에 File이나 Block Storage에 비해 빠르게 작동하고, 공간을 효율적으로 사용할 수 있다.  
하지만 트랜젝션으로 일관성을 유지하는 방식이 아니기 때문에 데이터 수정이 어렵다. 파일을 덮어쓰는 방법을 이용하여 수정한다.   

![](https://medium.com/harrythegreat/%ED%81%B4%EB%9D%BC%EC%9A%B0%EB%93%9C%EC%83%81-%EC%98%A4%EB%B8%8C%EC%A0%9D%ED%8A%B8-%EC%8A%A4%ED%86%A0%EB%A6%AC%EC%A7%80-object-storage-%EB%9E%80-9d9c2da57649)

- object에는 데이터와 식별번호, 메타 정보가 포함되어 있다.
- 식별 번호(UUID로 128비트 integer로 구성)를 통해 빠르게 데이터를 검색할 수 있다.
- 계층형의 파일 시스템과는 다르게 평면적인 구조라고 할 수 있다. 
- 메타 데이터에는 파일 종류 및 이름, 생성일 등에서 정보를 추가할 수 있다.

### Object Storage vs. File system
Object storage는 평면적인 구조기에 확장성이 뛰어나다. 기존의 파일 시스템은 계층형 구조를 캐싱해야 하는데 파일이 많을수록 메모리 리소스 사용량이 많아진다.   
분산 파일 시스템의 경우 어느 정도 한계점을 해소할 수 있다(NAS). 또한 POSIX를 지원하여 공유 파일 수정 시 충돌을 방지한다. NAS는 주로 on-premise 환경에서 비정형 데이터를 위한 고성능 스토리지로 활용되어 왔다.  

> 출처 : https://tech.gluesys.com/blog/2021/04/20/storage_9_intro.html