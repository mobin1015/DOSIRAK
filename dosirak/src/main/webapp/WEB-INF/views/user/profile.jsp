<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<jsp:include page="../layout/header.jsp"/>

profile화면

<div>
  <c:if test="${not empty sessionScope.user}">  
    <c:if test="${sessionScope.user.userNo == upload.user.userNo}">
      hi 
    </c:if>
  </c:if>
</div>

<div id="mArticle">
      <div class="edit-coverimg">
        <div class="bloger-thumb">
          <img src="" alt="" class="img-thumb" style="background:white">
        </div>
      </div>
      <div class="edit-profile"> 
        <form  id="edit-form"
               method="POST"
               action="${contextPath}/user/modify.do" enctype="multipart/form-data">

          <input type="hidden" name="userNo" value="${user.userNo}">
          <input type="hidden" name="blogNo" value="">
          <label for="nickname">작가명</label>
          <!-- c;if empty써서 없을 시, -->
          <input type="text" id="nickname" value="${user.userNo}" placeholder="이름을 입력해주세요">
          <label for="blog-contents">소개</label>
          <!-- c;if empty써서 없을 시, -->
          <textarea id="blog-contents" name="blogContents" placeholder="간단한 소개를 입력해주세요">${user.email}</textarea>

          <a href=""><button id="cancel-btn" type="button">취소하기</button></a>
          <button id="submit-btn" type="submit">수정완료</button>
        </form>

      </div>


    </div>




  <style>
    
    /*header 다시 수정!!!*/
    .header-wrap{position:fixed;top:0;left:0;margin-top:0;z-index:1000;width:100%;background:skyblue;display:flex;}
    .header-in{width:100%}
    .edit-coverimg{
      background-color: #f8f8f8;
    min-height: 120px;
    position: relative;
    }
    .edit-coverimg .bloger-thumb{
    bottom: -50px;
    height: 100px;
    left: 50%;
    margin-left: 250px;
    position: absolute;
    width: 100px;
    z-index: 5;
    }

    .img-thumb{
    display: block;
    border-radius: 100px;
    height: 100px;
    width: 100px;
    }

    .edit-profile{width:700px;margin:0 auto;}
    #edit-form{margin-top:40px}
    #edit-form label{display:block;font-size: 12px;
    font-weight: normal;
    line-height: 14px;
    margin-right: 10px;
    padding-bottom:13px}
    #edit-form input{
    display:block;width:100%;height:34px;padding-bottom:6px;border-bottom:1px solid #eee;
    font-size:28px;line-height:34px;color: #333;}
    #edit-form input#nickname{
    margin-bottom:60px}
    #edit-form textarea{display:block;padding:15px 20px 13px;    resize: none;    font-size: 13px;
    line-height: 24px;color: #333;border: 1px solid #eee;}

  </style>



<%@ include file="../layout/footer.jsp" %>