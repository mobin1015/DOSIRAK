<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>


<jsp:include page="./layout/header.jsp" />

  <div class="wrap">
    
    <div class="section">
      <div class="main-title nanum">
        <h1>작품이 되는 이야기, 브런치스토리</h1>
        <p>브런치스토리에 담긴 아름다운 작품을 감상해 보세요.<br/>
        그리고 다시 꺼내 보세요.<br/>
        <span>서랍 속 간직하고 있는 글과 감성을.</span></p>
      </div>
    </div>
    <div class="section">
      <div></div>
    </div>
    <div class="section">
      <div class="s-title">
        <h3 class="nanum">BRUNCH KEYWORD</h3>
        <p>키워드로 분류된 다양한 글 모음</p>
      </div>
      <div class="keyword-wrap">
        <ul>
          <li><a href=""><span>지구한바퀴<br/>세계여행</span></a></li>
          <li><a href=""><span>그림·웹툰</span></a></li>
          <li><a href=""><span>알수록 좋은 경제</span></a></li>
          <li><a href=""><span>IT<br/>트렌드</span></a></li>
          <li><a href=""><span>사진·촬영</span></a></li>
          <li><a href=""><span>취향저격<br/>영화 리뷰</span></a></li>
        </ul>
      </div>
    </div>
    
  </div>

<%@ include file="./layout/footer.jsp" %>