# Network Note

## Web Design Pattern - MVC vs. MTV

### MVC(Model-View-Controller)
![](https://media.vlpt.us/images/inyong_pang/post/9205bb36-7b6b-45d3-bca5-f03e6c22ff92/image.png)

유저가 Controller를 조작하면 Model을 통해 데이터를 가져오고 데이터를 View를 통해 전달한다.
- Model : 쿼리에 대한 정보를 정의하여 DB에 접근하고 CRUD를 명시한다.  
- View : Controller로부터의 데이터를 브라우저에 랜더링하도록 변환한다.
- Controller : Model과 View사이의 로직을 담당하여 유저가 Model에 맞는 인자값을 요청한다.

## HTTP
HTTP(HyperText Transfer Protocol)은 stateless 프로토콜이다. 

- TCP/IP 상에서 작동 
- Connectless :  
요청해서 응답을 받으면 연결을 끊는다.
- Stateless :   
    stataless는 데이터를 주고 받는 요청이 서로 독립적이라는 의미다.  
    즉, 이전과 이후의 데이터 요청은 관련이 없다.
    이에 따라 서버는 세션과 같은 추가 정보를 관리하지 않아도 되고 다수의 요청에 의한 부하를 줄일 수 있는 이점이 있다. 하지만 클라이언트가 이전에 로그인 되더라도 
    정보를 유지할 수 없어 HTTP는 Cookie를 이용한다.


### HTTP Request & HTTP Response
![](https://joshua1988.github.io/images/posts/web/http/http-full-structure.png)

- URL 분석 및 접속 : 서버 IP주소와 port를 이용하여 TCP/IP 연결을 요청한다.
- Request Header 전송
- Request Body 전송
- Response Header 해석 : 상태 코드를 확인하고 Body의 Content-Type을 해석한다.
- Reponse Body 해석

#### Request
![](https://media.vlpt.us/images/dnjscksdn98/post/319733fc-8fcb-48d3-8880-7932485162ee/http_request.png)

#### Response
![](https://media.vlpt.us/images/dnjscksdn98/post/42caeb0f-83f0-41e3-bfc7-ad169dbed518/http_response.png)


### URL Format
![](https://joshua1988.github.io/images/posts/web/http/url-structure.png)

### HTTP Methods
- GET( 요청 )
- POST( 생성 )
- PUT( 수정 )
- DELETE( 삭제 )
- HEAD( 서버 헤더 정보, Body 반환하지 않음 )
- OPTIONS( 서버 옵션 확인 )

### HTTP 상태 코드
- 2xx : 성공( 200, 204, .. )
- 3xx : redirection( 301, 303, .. )
- 4xx : 클라이언트 오류( 400, 401, 403, ..)
- 5xx : 서버 오류( 501, 503, ..)

### vs. HTTPS
SSL은 보안을 위해 개발한 통신 layer이다. HTTPS는 SSL위에 HTTP를 통과시켜 암호화해서 주고 받는 형식이다.

![](https://media.vlpt.us/images/dnjscksdn98/post/e0fc9ec6-24fb-402b-a6bc-9492c5371a5b/https.png)


*(출처)*
- https://joshua1988.github.io/web-development/http-part1/
- https://velog.io/@dnjscksdn98/HTTP-%ED%94%84%EB%A1%9C%ED%86%A0%EC%BD%9C%EC%97%90-%EB%8C%80%ED%95%98%EC%97%AC