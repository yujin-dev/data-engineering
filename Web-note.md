# Design Pattern

## Web Design Pattern - MVC vs. MTV

### MVC(Model-View-Controller)
![](https://media.vlpt.us/images/inyong_pang/post/9205bb36-7b6b-45d3-bca5-f03e6c22ff92/image.png)

유저가 Controller를 조작하면 Model을 통해 데이터를 가져오고 데이터를 View를 통해 전달한다.
- Model : 쿼리에 대한 정보를 정의하여 DB에 접근하고 CRUD를 명시한다.  
- View : Controller로부터의 데이터를 브라우저에 랜더링하도록 변환한다.
- Controller : Model과 View사이의 로직을 담당하여 유저가 Model에 맞는 인자값을 요청한다.

