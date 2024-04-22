<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<jsp:include page="../layout/header.jsp">
  <jsp:param value="Sign In" name="title"/>
</jsp:include>

<h1 class="title">Login In</h1>

<div>
  <form method="POST"
        action="${contextPath}/user/login.do">
    <div>
      <label for="email">아이디</label>
      <input type="text" id="email" name="email" placeholder="example@naver.com">
    </div>
    <div>
      <label for="pw">비밀번호</label>
      <input type="password" id="pw" name="pw" placeholder="●●●●">
    </div>
    <div>
      <input type="hidden" name="url" value="${url}">
      <button type="submit">Login In</button>
    </div>
    <div>
      <a href="${naverLoginURL}">
        <button>네이버</button>
      </a>
    </div>
  </form>
  <div>
  <!-- Sign In 된 경우 -->
        <c:if test="${sessionScope.user != null}">
        <a href="${contextPath}/user/leave.do">회원탈퇴</a>
        </c:if>
  </div>
</div>
  
<%@ include file="../layout/footer.jsp" %>

<script>
  function leave() {
	
	  if(window.confirm("탈퇴하시겠습니까?")){
		location.href="/user/leave.do";
	  }
	  
	}
</script>