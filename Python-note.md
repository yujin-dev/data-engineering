# Python Note

## python 경로 확인
```python
import sys
sys.executable
```

```console
$ python -m site
```

## python 가상환경 설치
```console
$ virtualenv -p python3 env_name
```


## python 가상환경 jupyter notebook 추가
jupyter 설치할 가상환경 활성화시키고
 
```console
$ pip3 install ipykernel  
$ python3 -m ipykernel install --user --name myvenv --display-name "venv_py3.8"

```

## JIT 
바이트 코드를 기계가 실행할 수 있는 형태로 변경하는데 방식은 2가지가 있다.
- interpreter: 바이트코드 명령어를 하나씩 읽어 해석하고 실행한다. 하나씩 실행하기에 해석은 빠르나 실행 자체는 느리다는 단점이 있다. 이는 파이썬에서 적용하는 방식이다.
- JIT : 인터프리터의 단점을 보완하기 위해 도입된 방식으로 인터프리터로 실행하다가 적절한 시점에 바이트코드 전체를 컴파일한다. 컴퓨터가 읽을 수 있는 코드로 변경하고 이 후 해당 코드가 실행될때마다 네이티브 코드로 직접 실행한다. 
하나씩 실행하는 것보다 빠르며 네이티브 코드는 캐시로 저장되기에 한번 컴파일되면 빠르게 수행 가능하다.

출처: https://hamait.tistory.com/476

## python heap memory
python에서는 python memory manager를 통해 스토리지를 동적으로 관리한다. 여기에는 메모리의 공유, 세분화, 사전할당, 캐싱이 있다.

힙 영역의 메모리를 인터프리터가 포인터를 통해 범위를 조정한다.

[ 파이썬의 메모리 구조 ]    
![](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FHcHSy%2FbtqyfM968FQ%2FFck3dNkPczLfRMKkmr5ii1%2Fimg.png)

+1의 raw memory allocator가 os와 소통하며 heap 영역에 메모리를 할당할 수 있는지 확인한다. 가비지 콜렉터와 같은 메커니즘으로 함수가 호출됨에 따라 그에 맞는 메모리를 필요한 순간에 할당하고 결과값이 반환되는 종료되는 시점에 메모리를 소멸한다. 

출처: https://armontad-1202.tistory.com/entry/%ED%8C%8C%EC%9D%B4%EC%8D%AC%EC%9D%98-%EB%A9%94%EB%AA%A8%EB%A6%AC-%EC%98%81%EC%97%AD


## functools.wraps
어떤 함수의 데코레이터로 
```python

@filings_cache
@check_filing_type
def method():
    pass
```
와 같이 쓰인다고 할 때 해당 데코레이터 함수는 아래와 같다.

```python
from edgar.util import save_cache, read_cache
from functools import wraps
import inspect
import os
from functools import wraps

def check_filing_type(func):

    @wraps(func) 
    def call(*args, **kwargs):
        core = kwargs.get("self", None)
        if core is None:
            core = args[0]
        if core.submission_type == core.filing_type:
            return func(*args, **kwargs)
        else:
            return None
    return call


def filings_cache(func):
    signature = inspect.signature(func)

    def call(*args, **kwargs):
        bound_arguments = signature.bind(*args, **kwargs)
        bound_arguments.apply_defaults()
        kwargs = bound_arguments.arguments
        core = kwargs.get("self", None)
        ...
        if not os.path.exists(core.file):
            result = func(*args, **kwargs)
            save_cache(result, filename)
        else:
            result = read_cache(filename)
        return result

    return call
```
`check_filing_type`에서 `@wraps`가 있으면 `filings_cache`의 `kwargs` - 아래와 같이 나오지만 
```python 
OrderedDict([('self', <edgar.parser.filing.Filing at 0x7f777aead190>),
             ('target_date', '2019-12-31'),
             ('date_type', 'filed')])

```
`@wraps`가 없으면 아래와 같다. 
```python
OrderedDict([('args', (<edgar.parser.filing.Filing at 0x7f7d8f9d71c0>,)),
             ('kwargs', {'target_date': '2019-12-31', 'date_type': 'filed'})])
```

## `sqlalchemy` connection 

### `sqlalchemy.engine.create_engine` 
- `sqlalchemy`의 가장 낮은 level의 객체
- `engine`은 어플리케이션이 DB와 통신할 때마다 사용하는 *connection pool*을 유지한다.
- 쿼리 실행을 위한 `engine.execute`는 `engine.connect`로 Connection 객체를 얻어 실행된다.
- **ORM을 사용하지 않는 방식**으로, 객체에 바인딩되지 않은 raw string SQL 쿼리 수행에서 이용된다.

### `sqlalchemy.sessionmaker`
- **ORM을 사용하는 경우**, 객체에 바인딩된 쿼리 실행을 위해 `sessionmaker`를 사용한다.
- 아래와 같은 트랜잭션을 단일 작업 단위로 관리하기 좋고 python에서 Context Manager로 사용하기도 한다.

```python
from sqlalchemy import create_engine, declarative_base, sessionmaker
from contextlib import contextmanager

engine = create_engine(...)
session = sessionmaker(bind=engine)
Base = declarative_base()

class TableUser(Base):
    __tablename__ = 'tbl_users'
    
    id = Column(String(64))
    name = Column(String(64))

@contextmanager
def session_scope():
    # transaction 작업
    session = Session()
    try:
        yield session 
        session.commit() #  정상적인 경우
    except:
        session.rollback() # 오류 발생시
        raise
    finally:
        session.close() # 항상 close
        

if __name__ == "__main__":

    with session_scope() as session:
        result = session.que    ry(TableUser).filter(TableUser.name == 'mary').first()

```

***출처: https://planbs.tistory.com/entry/Engine%EA%B3%BC-Session-Scoped-Session***
- 참고: https://yujuwon.tistory.com/entry/SQLALCHEMY-session-%EA%B4%80%EB%A6%AC


### `pool` 

```console

>>> engine.pool.status()
'Pool size: 5  Connections in pool: 1 Current Overflow: -3 Current Checked out connections: 1'
>>> conn2 = engine.connect()
>>> engine.pool.status()
'Pool size: 5  Connections in pool: 0 Current Overflow: -3 Current Checked out connections: 2'
>>> engine.pool._pool.queue
deque([])
>>> engine.pool.status()
'Pool size: 5  Connections in pool: 0 Current Overflow: 1 Current Checked out connections: 6'
```

- 참고: https://spoqa.github.io/2018/01/17/connection-pool-of-sqlalchemy.html

## `telegram`
- telegram bot 생성 후 채널에 추가할시
`/start@{bot_name}`으로 추가해야 정보를 받을 수 있음: 그냥 bot만 그룹에 추가하면 chat_id를 알 수 없음.
- 채널에 추가 후 `https://api.telegram.org/bot{token}/getUpdates`에서 chat_id를 확인
```
"chat": {"id": {ID},"title":"...","type":"group","all_members_are_administrators":true},
"date":1633425417,"text":"/start@{bot_name}","entities":[{"offset":0,"length":20,"type":"bot_command"}]

```

## 파이썬 외부파일 실행
`os.system("실행파일")`
- cmd.exe 내에서 실행하는 것과 같다.
- 메모리에 상주한다.
- 프로그램에 핸들을 반환하지 않아 다음으로 진행되지 않는다.
- os 모듈이라서 cmd.exe 를 통하므로, 스레드에서 실행해야 두개 실행 가능하다.
```python
thread.start_new_thread(os.system, ("...",))
thread.start_new_thread(os.system, ("...",))
```
`os.popen("실행파일")`
- cmd.exe 내에서 실행하는 것과 같다.
- 메모리에 상주한다.
`subprocess.call("실행파일")`
- cmd.exe 통하지 않고 바로 실행된다.
- python.exe 통하므로 파이썬은 자식 process로 된다.
- 프로그램에 핸들을 반환하지 않아 다음으로 진행되지 않는다.
`ShellExecuteA()`
- window API 이므로 ctypes 모듈로 사용해야 한다.
- 부모 프로세스가 없이 바로 실행된다.
```python
ctypes.windll.shell32.ShellExecuteA(0, 'open', calc, None, None, 1)
```
***출처:https://blog.naver.com/PostView.naver?blogId=heennavi1004&logNo=222052800571&parentCategoryNo=&categoryNo=82&viewDate=&isShowPopularPosts=true&from=search***