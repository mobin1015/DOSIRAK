<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<jsp:include page="../layout/header.jsp">
  <jsp:param value="Sign In" name="title"/>
</jsp:include>

<style type="text/css">
   .cantainer {
    width:650px;
    margin:0 auto;
   }
   .title{
    font-weight: bold;
    margin-bottom : 40px;
   }
   .form{
    width:650px;
    margin:0 auto;
    border:1px solid #333;
    padding : 20px 30px 30px ; 
    }
   .emailArea{
    border:1px solid #333;
    border-top:none;
    border-radius: 4px;
    display:flex;
    height:40px;
    }
   .emailArea:first-child{
    border-top:1px solid #333;}
   .emailArea p{
    height:100%;
    }
   .lable{
    text-align: center;
    width:110px;
    min-width:110px;
    border-right:1px solid #333;
    line-height:40px;
    }
   .input{
    flex:1 
    }
   .input input{
    width:100%;
    height:100%;
    font-size: 20px;
    font-weight: bold;
    }
   .buttons {
   display:flex;
   justify-content: space-evenly;
   margin-top:20px;
   }
   .button {
    width:150px;
    border:1px solid #333;
    text-align: center;
    height: 40px;
    line-height: 38px;
    overflow:hidden;
   }
   .a {
   display: block;
   }
   .naver img {
    height:100%;
     vertical-align:baseline;
}
</style>


<body>
<form method="POST"
      action="${contextPath}/user/login.do">
     
  <div class="cantainer">  
  
<h1 class="title">LogIn</h1>

    <div class="form">
        <div class="emailArea">
            <p class="lable">
                아이디
            </p>
            <p class="input" >
                <input type="text" id="inp-email" name="email" />
            </p>
         </div>
         <div class="emailArea">
            <p class="lable">
                비밀번호
            </p>
            <p class="input">
                <input type="password" id="inp-pw" name="pw"/>
            </p>
        </div>
      </div>
      
  <div class="buttons">
    <div class="button login">
       <button type="submit" id="btn-signup" class="button-signup">로그인</button>
    </div>
    <div class="button signup">
    <a class="a signup" href="${contextPath}/user/signup.page">회원가입</a>
    </div>
    <div class="button naver">
      <a class="a naver" href="${naverLoginURL}">
      <img src="${contextPath}/resources/2021_Login_with_naver_guidelines_Kr/btnW_완성형.png">
      </a>
    </div>
  </div>
  <div>
  <!-- Sign In 된 경우 -->
        <c:if test="${sessionScope.user != null}">
        <a href="${contextPath}/user/leave.do" onclick="confirmWithdrawal()">회원탈퇴</a>
        </c:if>
        <c:if test="${sessionScope.user != null}">
        <a href="${contextPath}/user/logout.do">로그아웃</a>
        </c:if>
  </div>
</div>  
</form>
</body>

<script>
</script>
  
<%@ include file="../layout/footer.jsp" %>
