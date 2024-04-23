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

  <div class="row">
    <label for="inp-email" class="col-sm-2 col-form-label">아이디</label>
    <div class="col-sm-4"><input type="text" id="inp-email" name="email" class="form-control" placeholder="example@example.com"></div>
    <div class="col-sm-3"><button type="button" id="btn-code" class="btn btn-primary">인증코드받기</button></div>
    <div class="col-sm-2"></div>
    <div class="col-sm-3"id="msg-email"></div>
  </div>
  <div class="row">
    <label for="inp-code" class="col-sm-2 col-form-label">인증코드</label>
    <div class="col-sm-4"><input type="text" id="inp-code" class="form-control" placeholder="인증코드입력" disabled></div>
    <div class="col-sm-3"><button type="button" id="btn-verify-code" class="btn btn-primary" disabled>인증하기</button></div>
  </div>
  
  <hr class="my-3">

  <div class="row mb-3">
    <label for="inp-pw" class="col-sm-2 col-form-label">비밀번호</label>
    <div class="col-sm-4"><input type="password" id="inp-pw" name="pw" class="form-control"></div>
    <div class="col-sm-6"></div>
    <div class="col-sm-2"></div>
    <div class="col-sm-4" id="msg-pw"></div>
  </div>
  <div class="row mb-3">
    <label for="inp-pw2" class="col-sm-3 col-form-label">비밀번호 확인</label>
    <div class="col-sm-6"><input type="password" id="inp-pw2" class="form-control"></div>
    <div class="col-sm-3"></div>
    <div class="col-sm-9" id="msg-pw2"></div>
  </div>
  
  <hr class="my-3">
  
  <div class="row mb-3">
    <label for="inp-name" class="col-sm-3 col-form-label">이름</label>
    <div class="col-sm-9"><input type="text" name="name" id="inp-name" class="form-control"></div>
    <div class="col-sm-3"></div>
    <div class="col-sm-9" id="msg-name"></div>
  </div>

  <div class="row mb-3">
    <label for="inp-mobile" class="col-sm-3 col-form-label">휴대전화번호</label>
    <div class="col-sm-9"><input type="text" name="mobile" id="inp-mobile" class="form-control"></div>
    <div class="col-sm-3"></div>
    <div class="col-sm-9" id="msg-mobile"></div>
  </div>

  <div class="row mb-3">
    <label class="col-sm-3 form-label">성별</label>
    <div class="col-sm-1">
      <input type="radio" name="gender" value="none" id="rdo-none" class="form-check-input" checked>
      <label class="form-check-label" for="rdo-none">선택안함</label>
    </div>
    <div class="col-sm-1">
      <input type="radio" name="gender" value="man" id="rdo-man" class="form-check-input">
      <label class="form-check-label" for="rdo-man">남자</label>
    </div>
    <div class="col-sm-1">
      <input type="radio" name="gender" value="woman" id="rdo-woman" class="form-check-input">
      <label class="form-check-label" for="rdo-woman">여자</label>
    </div>
  </div>
  
  <hr class="my-3">
  
  <div class="m-3">
    <button type="submit" id="btn-signup" class="btn btn-primary">가입하기</button>
  </div>

<script>
 
var emailCheck = false;
var passwordCheck = false;
var passwordConfirm = false;
var nameCheck = false;
var mobileCheck = false;
var agreeCheck = false;

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
      document.getElementById('msg-email').innerHTML = '이미 사용 중인 이메일입니다.';
      emailCheck = false;
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
    msgPw.innerHTML = '사용 가능한 비밀번호입니다.';
  } else {
    msgPw.innerHTML = '비밀번호 4~12자, 영문/숫자/특수문자 중 2개 이상 포함';
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
    msgPw2.innerHTML = '비밀번호 입력을 확인하세요.';
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
    msgName.innerHTML = '이름은 100 바이트를 초과할 수 없습니다.';
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
    msgMobile.innerHTML = '휴대전화를 확인하세요.';
  }
}

const fnCheckAgree = () => {
  let chkService = document.getElementById('chk-service');
  agreeCheck = chkService.checked;
}

const fnSignup = () => {
  document.getElementById('frm-signup').addEventListener('submit', (evt) => {
    fnCheckAgree();
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