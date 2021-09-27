# Commands Note

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

출처: https://zetawiki.com/wiki/%EB%A6%AC%EB%88%85%EC%8A%A4_%EB%82%A0%EC%A7%9C_%EA%B8%B0%EC%A4%80%EC%9C%BC%EB%A1%9C_%ED%8C%8C%EC%9D%BC_%EC%82%AD%EC%A0%9C%ED%95%98%EA%B8%B0