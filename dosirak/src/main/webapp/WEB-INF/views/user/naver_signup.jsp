<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<jsp:include page="../layout/header.jsp">
  <jsp:param value="Sign Up" name="title"/>
</jsp:include>

<style type="text/css">
   .title{
    font-weight: bold;
   }
   .form{
    width:650px;
    margin:0 auto;
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
    background-color: #E2E2E2;
    }
   .btn{
    width:110px;
    background-color: rgba(153, 255, 153, 0.2);
    }
   .btn button{
    background-color: rgba(0,0,0,0);
    }
   .jb-division-line {
    border-top: 1px solid #808080;
    margin: 30px auto;
    width:700px; 
    }
   .button{
    display: block;
    box-sizing: border-box;
    width: 100%;
    padding: 6px 0;
    border: 1px solid #c6c6c6;
    background-color: rgba(153, 255, 153, 0.2);
    }
   .button button{
    display: block;
    font-size: 20px;
    line-height: 18px;
    color: #929294;
    text-align: center;
    width: 100%;
    height: 100%;
    background-color:rgba(0,0,0,0);
    }
    .btn:active {
    box-shadow: inset -.3rem -.1rem 1.4rem  #FBFBFB, inset .3rem .4rem .8rem #BEC5D0; 
    cursor: pointer;
    }
   .form_radio_btn {
    padding: 15px 10px;
    display: block;
    box-sizing: border-box;
    width: 100%;
    padding: 6px 0;
    border: 1px solid #c6c6c6;
    background-color: #E2E2E2;
    }
   .form_radio_btn input[type=radio]{
    display: none;
    }
   .form_radio_btn input[type=radio]+label{
    display: block;
    cursor: pointer;
    height: 100%;
    width: 100%;
    line-height: 24px;
    text-align: center;
    font-size: 20px;
    }
   .form_radio_btn input[type=radio]+label{
    background-color: rgba(153, 255, 153, 0.2);
    color: #333;
    }
   .form_radio_btn input[type=radio]:checked+label{
    background-color: rgba(153, 255, 153, 0.2);
    font-weight: 700;
    font-size: 30px;
    }
    .jb-division-line {
      position: relative;
    }
    .button-signup{
    position: absolute; 
    left: 50%;
    transform: translateX(-50%);
    width: 300px;
    height: 50px;
    background-color: rgba(100, 210, 100);
    }
</style>

<h1 class="title">SignUp</h1>

<body>
<form method="POST"
      action="${contextPath}/user/signup.do"
      id="frm-signup">
    <div class="form">
        <div class="emailArea">
            <p class="lable">
                이메일
            </p>
            <p class="input" >
                <input type="text" id="inp-email" name="email" value="${naverUser.email}" readonly="readonly"/>
            </p>
        </div>
         <div class="emailArea" id="myElement">
            <p class="lable">
                비밀번호
            </p>
            <p class="input">
                <input type="password" id="inp-pw" name="pw" value="${naverUser.email}"/>
            </p>
        </div>
    </div>   
    <div class="jb-division-line"></div>    
      <div class="form"> 
        <div class="emailArea">
            <p class="lable">
                이름
            </p>
            <p class="input">
                <input type="text" name="name" id="inp-name" value="${naverUser.name}" readonly="readonly"/>
            </p>
        </div>
         <div class="emailArea">
            <p class="lable">
                휴대전화번호
            </p>
            <p class="input">
                <input type="text" name="mobile" id="inp-mobile" value="${naverUser.mobile}" readonly="readonly"/>
            </p>
        </div>
         <div class="emailArea">
            <p class="lable">
                성별
            </p>
            <p class="form_radio_btn">
                <input type="radio" name="gender"  id="rdo-none" class="btn-raido" value="${naverUser.gender}" readonly="readonly" checked>
                ${naverUser.gender}
        </div>
       </div>
        
       <div class="jb-division-line"></div>
         
       <input type="text" name="singupKind" class="form-control"  style= 'display: none'; value=1>
       
       <div class="signup">
       <button type="submit" id="btn-signup" class="button-signup">가입하기</button>
       </div>
  </form>     
  
      
</body>

<script>
document.getElementById("myElement").style.display = "none";
</script>


<%@ include file="../layout/footer.jsp" %>