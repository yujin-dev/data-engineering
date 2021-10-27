# OS Note

## linux 파일/폴더 복사
### 원격 복사
```console
$ scp {host}:{복사하려는 원격 파일경로} {폴더 위치}
```
### 파일 복사 
```console
$ cp {복사하려는 경로} {대상 경로}
```
- `-a` : 파일 속성까지 복사
- `-p` : 원본 파일의 소유자, 그룹, 권한까지 복사
- `-i` : 덮어쓰기 여부를 물음
- `-r` : 하위 디렉토리 , 파일까지 복사
- `-v` : 현재 복사 진행 상황 표시
- `-u` : 최신 파일이면 복사
- `-b` : 이미 존재하는 파일이면 백업 생성

출처: https://jframework.tistory.com/6


## linux 파일 시간 확인
- 접근 시간 확인: `ls-lu`
- 수정 시간 확인: `ls-l`
- 변경 시간 확인: `ls-lc`

[ 폴더에서 pkl 파일 중 수정 시간이 3일 경과된 파일 갯수 ]
```console 
$ find [folder_name] -name '*.pkl' -mtime +3 | wc -l
```
`-mtime`/`-ctime`/`-atime` +일수 : 수정시간/생성시간/접근시간 일수 이전

`-mtime`/`-ctime`/`-atime` -일수 : 수정시간/생성시간/접근시간 일수 이내

[ 특정 시간 경과한 파일 제거 ]
```console
$ find 폴더 -name 파일명 -mtime +일수 -delete
$ find 폴더 -name 파일명 -mtime +일수 -exec rm -f {} \;
```

*출처:* https://zetawiki.com/wiki/%EB%A6%AC%EB%88%85%EC%8A%A4_%EB%82%A0%EC%A7%9C_%EA%B8%B0%EC%A4%80%EC%9C%BC%EB%A1%9C_%ED%8C%8C%EC%9D%BC_%EC%82%AD%EC%A0%9C%ED%95%98%EA%B8%B0

## Windows Performance Monitoring 
### 성능 모니터 기록하기
- https://nogan.tistory.com/17
- https://sagittariusof85s.tistory.com/82


### 주요 성능 카운터 
- https://tshooter.tistory.com/93
- https://www.nextstep.co.kr/121

현재 기록중인 카운터는 
Memory 
- Memory: Commited Bytes( 서버에서 실행 중인 프로세스의 메모리 사용량 ) 
- Memory:Pages/sec( 페이지가 디스크에서 물리 메모리로 쓰여지거나 디스크로 페이지를 옮겨 쓰는 속도 )
- Paging File: %Usage( 현재 사용중인 페이징 파일의 % )
Disk
- Physcial Disk: %Disk Time( 디스크가 읽고 쓰는 요청 )
- Process: Private Bytes( 가상 메모리의 크기 ) 
Network
- Server:Bytes Total/sec( 서버가 네트워크 데이터를 송수신하는 속도 )
- Network Interface: Bytes Total/sec( 네트워크 카드가 데이터를 송수신하는 속도 )
Postgres
- Process: Working Set( 프로세스가 데이터를 저장하기 위해 사용하는 RAM 사용량 측정 )  

## 하드디스크 파티션 생성 및 마운트
/dev/sda, /dev/sdb 등이 하드디스크, /dev/sda1 등이 파티션이다

### 파티션 생성
```console
$ fdisk /dev/sdb
```
### 마운트
파티션을 특정 디렉토리에 연결하여 사용한다.

/dev/sdb1을 /home 디렉토리에 마운트한다.
```console
$ mount /dev/sdb1 /home
```

마운트 해제는 아래와 같다.
```console
$ umount /dev/sdb1
```

#### 리눅스에서 윈도우 파티션 마운트
1. 윈도우 파티션을 연결할 디렉토리를 생성한다.
```console
$ sudo mkdir /mnt/windows
```

2. 마운트할 파티션을 찾는다.
```console
$ sudo fdisk -l 
-------------------------------------------------------------------------------
Device          Start        End    Sectors   Size Type
/dev/sda1        2048    1023999    1021952   499M Windows recovery environment
/dev/sda2     1024000    1228799     204800   100M EFI System
/dev/sda3     1228800    1261567      32768    16M Microsoft reserved
/dev/sda4     1261568 1208397291 1207135724 575.6G Microsoft basic data
/dev/sda5  1952405504 1953521663    1116160   545M Windows recovery environment
/dev/sda6  1208397824 1952405503  744007680 354.8G Linux filesystem
```

3. 파티션을 마운트한다.
```console
$ sudo mount /dev/sda4 /mnt/windows
```

``console
$ df
Filesystem     1K-blocks      Used Available Use% Mounted on

...
/dev/sda4      603567860 247545508 356022352  42% /mnt/windows
```
mount되었음을 알 수 있다.