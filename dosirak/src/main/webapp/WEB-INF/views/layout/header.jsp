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
  
    <div class="logo"></div>

    <div class="user-wrap">
      <!-- Sign In 안 된 경우 -->
      <c:if test="${sessionScope.user == null}">  
        <a href="${contextPath}/user/signin.page"><i class="fa-solid fa-arrow-right-to-bracket"></i>Sign In</a>
        <a href="${contextPath}/user/signup.page"><i class="fa-solid fa-user-plus"></i>Sign Up</a>
      </c:if>
      <!-- Sign In 된 경우 -->
      <c:if test="${sessionScope.user != null}">
        ${sessionScope.user.name}님 반갑습니다
        <a href="${contextPath}/user/signout.do">로그아웃</a>
        <a href="${contextPath}/user/leave.do">회원탈퇴</a>
      </c:if>
    </div>
    
    <div class="gnb-wrap">
      <ul class="gnb">
        <li><a href="${contextPath}/bbs/list.do">계층형게시판</a></li>
        <li><a href="${contextPath}/blog/list.page">댓글형게시판</a></li>
        <li><a href="${contextPath}/upload/list.do">첨부형게시판</a></li>
      </ul>
    </div>

  </div>

  <div class="main-wrap">
