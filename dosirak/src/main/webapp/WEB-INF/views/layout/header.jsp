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

<!-- include custom css/js -->
<link rel="stylesheet" href="${contextPath}/resources/css/init.css?dt=${dt}">
<link rel="stylesheet" href="${contextPath}/resources/css/header.css?dt=${dt}">

</head>
<body>

  <div class="header-wrap">
    <div class="header-in">
      <div class="left">
        <div class="menu-btn"></div>
        <div class="logo"></div>
      </div>
      <div class="right">
        <!-- Sign In 안 된 경우 -->
        <c:if test="${sessionScope.user == null}">  
        <div class="login-btn">로그인</div>
        </c:if>
        <!-- Sign In 된 경우 -->
        <c:if test="${sessionScope.user != null}">
        <div class="login-btn">로그아웃</div>
        </c:if>
        <div class="search-btn"></div>
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
              <p class="slogan">
              You can make anything<br>
              by writing
              </p>
              <p class="slogan-writer">C.S.Lewis</p>
              <div class="btn-request logout">브런치스토리 시작하기</div>
            </div>
           </div>
        </c:if>

        <!-- Sign In 된 경우 -->
        <c:if test="${sessionScope.user != null}">
          <div class="nav-profile">
            <div class="profile-default">
                <img  class="profile-login-image">
                <p class="profile-name">이름</p>
                <p class="profile-id">user-email</p>
                <div class="profile-top">
                  <div class="nav-btn">글쓰기</div>
                  <div class="nav-btn">마이페이지</div>
                </div> 
            </div>
          </div>
          <div class="nav-bottom">
            <div class="nav-btn">탈퇴하기</div>
            <div class="nav-btn">로그아웃</div>
          </div>
         </c:if>

    </div>
    
    
    
    <script>
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
    
