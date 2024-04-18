<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<jsp:include page="../layout/header.jsp">
  <jsp:param value="${blogInfo.nickName}의 브런치스토" name="title"/>
</jsp:include>

<div class="wrap">
    
    <div class="header-wrap"></div>

    <div class="profile-wrap">
      <div class="bloger-thumb">
        <img class="profile-user-image" src="" width="100px" height="100px" alt="프로필 이미지">
      </div>
      <div class="blog-wrap">
        <strong class="tit-bloger"></strong>
        <span class="blog-contents"></span>
      </div>
      <div class="profile-btn-wrap ">
       <button class="btn-profile" type="button">프로필편집</button>
       <button class="btn-write" type="button">글쓰기</button>
     </div>

    </div>

    <div class="main-wrap">
      <div class="tab-contents">
        <span>글</span>
        <span class="num-contents"></span>
      </div>
      <div class="article-list-wrap">
        <div class="post">
          <strong class="tit-article"></strong>
          <span class="sub-contents"></span>
          <div class="post-append">
            <span>댓글</span>
            <span class="num-comment"></span>
            <span class="ico-dot"></span>
            <span class="publish-time"></span>
          </div>
          <div class="post-thumb">
            <img class="img-thumb" src="" width="120px" height="120px" alt="포스트 이미지" >
          </div>
        </div>
      </div>
    </div>

  </div>



<%@ include file="../layout/footer.jsp" %>