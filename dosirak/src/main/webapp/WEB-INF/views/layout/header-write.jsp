<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- 페이지마다 다른 제목 -->
<title>
  <c:choose>
    <c:when test="${empty param.title}">Welcome</c:when>
    <c:otherwise>${param.title}</c:otherwise>
  </c:choose>
</title>

<!-- include libraries(jquery, bootstrap) -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

<!-- include moment.js -->
<script src="${contextPath}/resources/moment/moment-with-locales.min.js"></script>

<!-- include summernote css/js -->
<link rel="stylesheet" href="${contextPath}/resources/summernote-0.8.18-dist/summernote.min.css">
<script src="${contextPath}/resources/summernote-0.8.18-dist/summernote.min.js"></script>
<script src="${contextPath}/resources/summernote-0.8.18-dist/lang/summernote-ko-KR.min.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.9.0/slick.min.js" integrity="sha512-HGOnQO9+SP1V92SrtZfjqxxtLmVzqZpjFFekvzZVWoiASSQgSr4cw9Kqd2+l8Llp4Gm0G8GIFJ4ddwZilcdb8A==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.9.0/slick-theme.css" integrity="sha512-6lLUdeQ5uheMFbWm3CP271l14RsX1xtx+J5x2yeIDkkiBpeVTNhTqijME7GgRKKi6hCqovwCoBTlRBEC20M8Mg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.9.0/slick.min.css" integrity="sha512-yHknP1/AwR+yx26cB1y0cjvQUMvEa2PFzt1c9LlS4pRQ5NOTZFWbhBig+X9G9eYW/8m0/4OXNx8pxJ6z57x0dw==" crossorigin="anonymous" referrerpolicy="no-referrer" />

<!-- include custom css/js -->

<link rel="stylesheet" href="${contextPath}/resources/css/header.css?dt=${dt}">
<link rel="stylesheet" href="${contextPath}/resources/css/main.css?dt=${dt}">
<style>

.register-btn{
    padding:0 10px;
    height:28px;
    line-height:28px;
    text-align:center;
    border:1px solid #959595;
    border-radius: 16px;
}
button {
    background: none;
    border: none;
    }
p a {color: #333; border: 0; text-decoration:none;}
p a:hover {color: #333; border: 0; text-decoration:none;}

</style>

</head>
<body>


  <div class="header-wrap">
    <div class="header-in">
      <div class="left">
        <div class="menu-btn"></div>
        <a href="${contextPath}/main.page"><div class="logo"></div></a>
      </div>
      <div class="right">
        <div class="register-btn"><button type="button" id="btn-register">저장</button></div>       
       </div>
    </div>
   </div>
    
    <!-- 슬라이드 영역 -->
    <div class="header-nav">
       <!-- Sign In 안 된 경우 -->
       <c:if test="${sessionScope.user == null}">  
          <div class="nav-profile">
            <div class="profile-default">
              <div class="profile-default-image "></div>
              <p class="slogan georgian">
              You can make anything<br>
              by writing
              </p>
              <p class="slogan-writer georgian">C.S.Lewis</p>
              <div class="btn-request noto"><a href="${contextPath}/user/login.page"">브런치스토리 시작하기</a></div>
              <div class="btn-request noto"><a href="${contextPath}/blog/now.page"">브런치스토리 나우</a></div>
              <!-- div type="button" class="nav-btn" id="btn-write" >글쓰기이따지워</div>-->
            </div>
           </div>
        </c:if>
        
        <!-- Sign In 된 경우 -->
        <c:if test="${sessionScope.user != null}">
          <div class="nav-profile nav-profile-login">
            <div class="profile-default">
                <img class="profile-login-image" src="${contextPath}${sessionScope.user.blogImgPath}">
                <p class="profile-name noto">${sessionScope.user.name}</p>
                <p class="profile-id georgian">${sessionScope.user.email}</p>
                <div class="profile-top">
                  <div class="nav-btn noto"><a href="${contextPath}/blog/write.page">글쓰기</a></div>
                  <div class="nav-btn noto"><a href="${contextPath}/user/mypage.do?userNo=${user.userNo}">마이페이지</a></div>
                </div> 
            </div>
          </div>
          <p class="menu1 noto"><a href="${contextPath}/blog/now.page">브런치스토리 나우</a></p>
          
          <div class="nav-bottom">
            <div class="nav-btn noto"><a href="">탈퇴하기</a></div>
            <div class="nav-btn noto"><a href="${contextPath}/user/logout.do">로그아웃</a></div>
          </div>
        </c:if>
    </div>
      
    <div class="wrap">
    <style>
    .menu1{text-align:center;margin-top:30px;font-weight:300}
    </style>
    
    
    <script>
    const fnSearchBlog = ()=>{
      $('.search-btn').on('click', (evt)=>{
        location.href = "${contextPath}/blog/search.page";
      })
    }
    fnSearchBlog();
    
    var aa=true;
    $(".menu-btn").click(function(){
      if(aa){
        $(".header-nav").animate({'left':'0px'},1000);
        aa=false;
      }
    });
    
    
    $(document).on("click", function(event) {
        if (!$(event.target).closest('.header-wrap').length) {
            $(".header-nav").animate({'left': '-100%'});
            aa = true;
        }
    });
    
  // 이벤트 전파 방지
    $(".header-nav").on("click", function(event) {
        event.stopPropagation();
    });
    
    </script>
    
