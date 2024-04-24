<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<jsp:include page="../layout/header.jsp">
  <jsp:param value="Sign Up" name="title"/>
</jsp:include>

<h1 class="title">Sign Up</h1>

<form method="POST"
      action="${contextPath}/user/signup.do"
      id="frm-signup">


  <hr class="my-3">
  
  <div class="row">
    <label for="inp-email" class="col-sm-2 col-form-label">아이디</label>
    <div class="col-sm-4"><input type="text" id="inp-email" name="email" class="form-control"  value="${naverUser.email}" readonly="readonly"></div>
    <div class="col-sm-3"id="msg-email"></div>
  </div>
  
  <div class="row mb-3">
    <label for="inp-name" class="col-sm-3 col-form-label">이름</label>
    <div class="col-sm-9"><input type="text" name="name" id="inp-name" class="form-control" value="${naverUser.name}" readonly="readonly"></div>
    <div class="col-sm-3"></div>
    <div class="col-sm-9" id="msg-name"></div>
  </div>

  <div class="row mb-3">
    <label for="inp-mobile" class="col-sm-3 col-form-label">휴대전화번호</label>
    <div class="col-sm-9"><input type="text" name="mobile" id="inp-mobile" class="form-control" value="${naverUser.mobile}" readonly="readonly"></div>
    <div class="col-sm-3"></div>
    <div class="col-sm-9" id="msg-mobile"></div>
  </div>

  <div class="row mb-3">
    <label class="col-sm-3 form-label">성별</label>
    <div class="col-sm-1">
      <input type="radio" name="gender"  id="rdo-none" class="form-check-input" value="${naverUser.gender}" readonly="readonly" checked>
      ${naverUser.gender}
    </div> 
    
  </div>
  
  <hr class="my-3">
    <input type="text" name="singupKind" class="form-control"  style= 'display: none'; value=1>
  <div class="m-3">
    <button type="submit" id="btn-signup" class="btn btn-primary">가입하기</button>
  </div>

<script>
 

</script>


<%@ include file="../layout/footer.jsp" %>