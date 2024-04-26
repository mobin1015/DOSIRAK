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
   .cantainer {
    width:700px;
    margin:0 auto;
   }
   .cantainer input{
    padding:0 8px;}
   .title{
    font-weight: bold;
    margin-bottom : 40px;
   }
   .form{
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
    flex:1; 
    }
   .input input{
    width:100%;
    height:100%;
    font-size: 20px;
    font-weight: bold;
    background-color: #fff;
    }
   .input input code{
    background-color: #E2E2E2;
    } 
   .btn{
    width:110px;
    padding:0;
    }
   .btn button{
    background-color: #fff;
    width:100%;
    height:100%;
    display:block;
    color: #666;
    transition:all 0.3s;
    border_radius: 1px solid #333;
    }
    .btn button:hover{
    background-color: #eee;
    color: #666;
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
    background-color: #32D0CA;
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
    background-color: #00C6BE;
    color: #fff;
    }
   .form_radio_btn input[type=radio]:checked+label{
    background-color: #00C6BE;
    font-weight: bold;
    font-size: 20px;
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
    font-weight: bold;
    font-size: 20px;
    color: #fff;
    background-color: #00C6BE;
    }
</style>



<div class="cantainer">
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
                <input type="text" id="inp-email" name="email"  placeholder="example@example.com"/>
            </p>
            <p class="btn">
                <button type="button" id="btn-code">인증코드받기</button>
            </p>
        </div>
         <div class="emailArea">
            <p class="lable">
                인증코드
            </p>
            <p class="input code">
                <input type="text" id="inp-code"  placeholder="인증코드입력" disabled/>
            </p>
            <p class="btn">
                <button type="button" id="btn-verify-code"  disabled>인증하기</button>
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
         <div class="emailArea">
            <p class="lable">
                비밀번호확인
            </p>
            <p class="input">
                <input type="password" id="inp-pw2"/>
            </p>
        </div>     
    <div id="msg-email"></div>
    <div id="msg-pw"></div>
    <div id="msg-pw2"></div>
    </div>   
   
    <div class="jb-division-line"></div>    
    
      <div class="form"> 
        <div class="emailArea">
            <p class="lable">
                이름
            </p>
            <p class="input">
                <input type="text" name="name" id="inp-name"/>
            </p>
        </div>
         <div class="emailArea">
            <p class="lable">
                휴대전화번호
            </p>
            <p class="input">
                <input type="text" name="mobile" id="inp-mobile"/>
            </p>
        </div>
         <div class="emailArea">
            <p class="lable">
                성별
            </p>
            <p class="form_radio_btn">
                 <input type="radio" name="gender" value="none" id="rdo-none" class="btn-raido" checked>
                 <label for="rdo-none">선택안함</label>
            </p>
            <p class="form_radio_btn">
                 <input type="radio" name="gender" value="M" id="rdo-man" class="btn-raido">
                 <label for="rdo-man">남자</label>
            </p>
            <p class="form_radio_btn">
                 <input type="radio" name="gender" value="F" id="rdo-woman" class="btn-raido">
                 <label for="rdo-woman">여자</label> 
            </p>
        </div>
        <div id="msg-name"></div>
        <div id="msg-mobile"></div>
       </div>
        
       <div class="jb-division-line"></div>
         
       <input type="text" name="singupKind" class="form-control"  style= 'display: none'; value=0>
       
       <div class="signup">
       <button type="submit" id="btn-signup" class="button-signup">가입하기</button>
       </div>
  </form>
</div>
</body>

<script>

    var emailCheck = false;
    var passwordCheck = false;
    var passwordConfirm = false;
    var nameCheck = false;
    var mobileCheck = false;
    
    const fnGetContextPath = ()=>{
      const host = location.host;  /* localhost:8080 */
      const url = location.href;   /* http://localhost:8080/mvc/getDate.do */
      const begin = url.indexOf(host) + host.length;
      const end = url.indexOf('/', begin + 1);
      return url.substring(begin, end);
    }
    
    const fnCheckEmail = ()=>{
      
      
      let inpEmail = document.getElementById('inp-email');
      let regEmail = /^[A-Za-z0-9-_]{2,}@[A-Za-z0-9]+(\.[A-Za-z]{2,6}){1,2}$/;
      if(!regEmail.test(inpEmail.value)){
        alert('이메일 형식이 올바르지 않습니다.');
        emailCheck = false;
        return;
      }
      
      fetch(fnGetContextPath() + '/user/checkEmail.do', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          'email': inpEmail.value
        })
      })
      .then(response => response.json())  // .then( (response) => { return response.json(); } )
      .then(resData => {
        if(resData.enableEmail){
          document.getElementById('msg-email').innerHTML = '';
          fetch(fnGetContextPath() + '/user/sendCode.do', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify({
              'email': inpEmail.value
            })
          })
          .then(response => response.json())
          .then(resData => {  // resData = {"code": "123qaz"}
            alert(inpEmail.value + '로 인증코드를 전송했습니다.');
            let inpCode = document.getElementById('inp-code');
            let btnVerifyCode = document.getElementById('btn-verify-code');
            inpCode.disabled = false;
            btnVerifyCode.disabled = false;
            btnVerifyCode.addEventListener('click', (evt) => {
              if(resData.code === inpCode.value) {
                alert('인증되었습니다.');
                emailCheck = true;
              } else {
                alert('인증되지 않았습니다.');
                emailCheck = false;
              }
            })
          })
        } else {
        	var msgElement = document.getElementById('msg-email');
        	msgElement.innerHTML = '⚫ 이미 사용 중인 이메일입니다.';
        	msgElement.style.fontSize = '15px'; 
        	msgElement.style.fontWeight = 'bold'; 
        	msgElement.style.color = 'red'; 
          return;
        }
      })
    }
    
    const fnCheckPassword = () => {
      // 비밀번호 4~12자, 영문/숫자/특수문자 중 2개 이상 포함
      let inpPw = document.getElementById('inp-pw');
      let validCount = /[A-Za-z]/.test(inpPw.value)     // 영문 포함되어 있으면 true (JavaScript 에서 true 는 숫자 1 같다.)
                     + /[0-9]/.test(inpPw.value)        // 숫자 포함되어 있으면 true
                     + /[^A-Za-z0-9]/.test(inpPw.value) // 영문/숫자가 아니면 true
      let passwordLength = inpPw.value.length;
      passwordCheck = passwordLength >= 4
                   && passwordLength <= 12
                   && validCount >= 2
      let msgPw = document.getElementById('msg-pw');
      if(passwordCheck){
        msgPw.innerHTML = '⚫ 사용 가능한 비밀번호입니다.';
        msgPw.style.fontSize = '15px'; 
        msgPw.style.fontWeight = 'bold';
        msgPw.style.color = 'green'; 
      } else {
        msgPw.innerHTML = '⚫ 비밀번호 4~12자, 영문/숫자/특수문자 중 2개 이상 포함';
        msgPw.style.fontSize = '15px'; 
        msgPw.style.fontWeight = 'bold'; 
        msgPw.style.color = 'red'; 
      }
    }
    
    const fnConfirmPassword = () => {
      let inpPw = document.getElementById('inp-pw');
      let inpPw2 = document.getElementById('inp-pw2');
      passwordConfirm = (inpPw.value !== '')
                     && (inpPw.value === inpPw2.value)
      let msgPw2 = document.getElementById('msg-pw2');
      if(passwordConfirm) {
        msgPw2.innerHTML = '';
      } else {
        msgPw2.innerHTML = '⚫ 비밀번호 입력을 확인하세요.';
        msgPw2.style.fontSize = '15px'; 
        msgPw2.style.fontWeight = 'bold';
        msgPw2.style.color = 'red';
      }
    }
    
    const fnCheckName = () => {
      let inpName = document.getElementById('inp-name');
      let name = inpName.value;
      let totalByte = 0;
      for(let i = 0; i < name.length; i++){
        if(name.charCodeAt(i) > 127) {  // 코드값이 127 초과이면 한 글자 당 2바이트 처리한다.
          totalByte += 2;
        } else {
          totalByte++;
        }
      }
      nameCheck = (totalByte <= 100);
      let msgName = document.getElementById('msg-name');
      if(!nameCheck){
        msgName.innerHTML = '⚫ 이름은 100 바이트를 초과할 수 없습니다.';
        msgName.style.fontSize = '15px'; 
        msgName.style.fontWeight = 'bold';
        msgName.style.color = 'red';
      } else {
        msgName.innerHTML = '';
      }
    }
    
    const fnCheckMobile = () => {
      let inpMobile = document.getElementById('inp-mobile');
      let mobile = inpMobile.value;
      mobile = mobile.replaceAll(/[^0-9]/g, '');
      mobileCheck = /^010[0-9]{8}$/.test(mobile);
      let msgMobile = document.getElementById('msg-mobile');
      if(mobileCheck) {
        msgMobile.innerHTML = '';
      } else {
        msgMobile.innerHTML = '⚫ 휴대전화를 확인하세요.';
        msgMobile.style.fontSize = '15px'; 
        msgMobile.style.fontWeight = 'bold';
        msgMobile.style.color = 'red';
      }
    }
    
    
    
    const fnSignup = () => {
      document.getElementById('frm-signup').addEventListener('submit', (evt) => {
        if(!emailCheck) {
          alert('이메일을 확인하세요.');
          evt.preventDefault();
          return;
        } else if(!passwordCheck || !passwordConfirm){
          alert('비밀번호를 확인하세요.');
          evt.preventDefault();
          return;
        } else if(!nameCheck) {
          alert('이름을 확인하세요.');
          evt.preventDefault();
          return;
        } else if(!mobileCheck) {
          alert('휴대전화를 확인하세요.');
          evt.preventDefault();
          return;
        } 
      })
    }
    
    
document.getElementById('btn-code').addEventListener('click', fnCheckEmail);
document.getElementById('inp-pw').addEventListener('keyup', fnCheckPassword);
document.getElementById('inp-pw2').addEventListener('blur', fnConfirmPassword);
document.getElementById('inp-name').addEventListener('blur', fnCheckName);
document.getElementById('inp-mobile').addEventListener('blur', fnCheckMobile);
fnSignup();
</script>


<%@ include file="../layout/footer.jsp" %>