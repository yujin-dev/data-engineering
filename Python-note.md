# Python Note

## [ 21.07.21 ] python 경로 확인
```python
import sys
sys.executable
```

```console
$ python -m site
```

## [ 21.07.23 ] python 가상환경 설치
```console
$ virtualenv -p python3 env_name
```


## [ 21.07.27 ] python 가상환경 jupyter notebook 추가
jupyter 설치할 가상환경 활성화시키고
 
```console
$ pip3 install ipykernel  
$ python3 -m ipykernel install --user --name myvenv --display-name "venv_py3.8"

```

## [ 21.08.16 ] JIT 
바이트 코드를 기계가 실행할 수 있는 형태로 변경하는데 방식은 2가지가 있다.
- interpreter: 바이트코드 명령어를 하나씩 읽어 해석하고 실행한다. 하나씩 실행하기에 해석은 빠르나 실행 자체는 느리다는 단점이 있다. 이는 파이썬에서 적용하는 방식이다.
- JIT : 인터프리터의 단점을 보완하기 위해 도입된 방식으로 인터프리터로 실행하다가 적절한 시점에 바이트코드 전체를 컴파일한다. 컴퓨터가 읽을 수 있는 코드로 변경하고 이 후 해당 코드가 실행될때마다 네이티브 코드로 직접 실행한다. 
하나씩 실행하는 것보다 빠르며 네이티브 코드는 캐시로 저장되기에 한번 컴파일되면 빠르게 수행 가능하다.

출처: https://hamait.tistory.com/476

## [ 21.08.16 ] python heap memory
python에서는 python memory manager를 통해 스토리지를 동적으로 관리한다. 여기에는 메모리의 공유, 세분화, 사전할당, 캐싱이 있다.

힙 영역의 메모리를 인터프리터가 포인터를 통해 범위를 조정한다.

[ 파이썬의 메모리 구조 ]    
![](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FHcHSy%2FbtqyfM968FQ%2FFck3dNkPczLfRMKkmr5ii1%2Fimg.png)

+1의 raw memory allocator가 os와 소통하며 heap 영역에 메모리를 할당할 수 있는지 확인한다. 가비지 콜렉터와 같은 메커니즘으로 함수가 호출됨에 따라 그에 맞는 메모리를 필요한 순간에 할당하고 결과값이 반환되는 종료되는 시점에 메모리를 소멸한다. 

출처: https://armontad-1202.tistory.com/entry/%ED%8C%8C%EC%9D%B4%EC%8D%AC%EC%9D%98-%EB%A9%94%EB%AA%A8%EB%A6%AC-%EC%98%81%EC%97%AD