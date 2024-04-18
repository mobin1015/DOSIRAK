<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<jsp:include page="../layout/header.jsp">
  <jsp:param value="${blogInfo.nickname}의 브런치스토리" name="title"/>
</jsp:include>

<style>
  .header-wrap {
    width: 1920px;
    height: 120px;
    background-color: #F8F8F8
  }
  
  .profile-wrap {
    width: 700px;
    height: 167px;
  }
  .tab-contents {
    width: 700px;
    height: 59px;
  }
  
</style>


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
      <div class="article-list-wrap"></div>
    </div>

  </div>



<%@ include file="../layout/footer.jsp" %>