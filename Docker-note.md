# Docker Note
## 도커 설치
```console
$ sudo apt update
$ sudo apt install apt-transport-https ca-certificates curl software-properties-common
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
$ sudo apt update
$ apt-cache policy docker-ce
'''
docker-ce:
  설치: (없음)
  후보: 5:20.10.7~3-0~ubuntu-bionic
  버전 테이블:
     5:20.10.7~3-0~ubuntu-bionic 500
        500 https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages
     5:20.10.6~3-0~ubuntu-bionic 500
        500 https://download.docker.com/linux/ubuntu bionic/stable amd64 Packages
     5:20.10.5~3-0~ubuntu-bionic 500
```
실행 결과 위에서 `설치:(없음)`으로 출력된 것은 아직 도커가 설치되지 않았단 뜻. 아래처럼 도커를 설치한다. 
```sh
$ sudo apt install docker-ce # 도커 설치
$ sudo systemctl status docker # 도커 작동 확인
''' 
 docker.service - Docker Application Container Engine
     Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
     Active: active (running) since Fri 2021-07-16 16:51:43 KST; 1min 0s ago
TriggeredBy: ● docker.socket
       Docs: https://docs.docker.com
   Main PID: 21899 (dockerd)
      Tasks: 17
     Memory: 44.1M
     CGroup: /system.slice/docker.service
...
```
sudo로 docker를 실행해야 하므로 권한을 부여한다.
```console
$ sudo usermod -aG docker $USER
'''
-G: 새로운 그룹
-a: 다른 그룹에서 삭제 없이 G에 따른 사용자 추가
```
참고: https://blog.cosmosfarm.com/archives/248/%EC%9A%B0%EB%B6%84%ED%88%AC-18-04-%EB%8F%84%EC%BB%A4-docker-%EC%84%A4%EC%B9%98-%EB%B0%A9%EB%B2%95/


## docker log 확인
```console
$ docker logs {container_id}
```

## docker 재시작
```console
$ docker-compose restart
```

## `RUN` vs. `CMD`
### `RUN`
- 이미지에 새로운 패키지를 설치하거나 명령어를 실행시킬 경우
- 실행때마다 레이어가 생성된다.
```Dockerfile
FROM ubuntu:18.04
RUN apt-get update
RUN apt-get install -y python3 python3-pip wget git less neovim
RUN pip3 install panda
```
보다는 설치를 하나의 레이어로 하면 깔끔하게 관리할 수 있다.
```Dockerfile
FROM ubuntu:18.04
RUN apt-get update \
    && apt-get install -y python3 python3-pip wget git less neovim \
    && pip3 install pandas
```

### `CMD`
- 기본 명령어를 설정하거나 `ENTRYPOINT`의 기본 명령어 파라미터를 설정할 때 사용된다.
- CMD는 여러 번 dockerfile에 작성할 수 있지만, 가장 마지막에 작성된 CMD 만이 실행(override) 된다.
- 주로 컨테이너를 실행할 때 사용할 default를 설정하기 위해 사용된다.

Dockerfile 만들시 아무런 command를 주지 않으면 `CMD` 명령이 실행된다.
`echo "Hello"`와 같은 명령어를 전달하면 `CMD` 명령이 무시되고 해당 커맨드가 실행된다.

```console
$ docker run -it --rm <image-name> echo "Hello"
Hello
```

### `ENTRYPOINT`
- `docker run` 명령어로 컨테이너를 생성 후 실행되는 명령어


*(출처) https://williamjeong2.github.io/blog/10-docker-run-vs-cmd-vs-entryporint/*

## Dockerfile로 이미지 빌드 시 상호작용 방지
`ARG DEBIAN_FRONTEND=noninteractive` 추가할 것

*(출처) https://ykarma1996.tistory.com/93*