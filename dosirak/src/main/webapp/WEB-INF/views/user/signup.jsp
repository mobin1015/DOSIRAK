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

  <div class="form_content">
    <div class="form_section">
      <div class="form_list">
          <label class="form_item user error1">아이디</label>
          <div class="form_item user error2">
            <input type="text" id="id" name="id" placeholder="example@example.com">
          </div>
          <div class="form_item user error3">
          <button type="button" id="code" class="primary">인증코드받기</button>
          </div>
        </div>  
      </div>
    </div>
  </div>
  
</form>

<script>
    const fnGetContextPath = () => {
      const host = location.host;
      const url = location.href;
      const begin = url.indexOf(host) + host.length;
      const end = url.indexOf('/', begin + 1);
      return url.substring(begin, end);
    }

    const fnCheckEmail = ()=> {
      
      let inpEmail = document.getElementById('inp-email');
      let regEmail = /^[A-Za-z0-9-_]{2,}@[A-Za-z0-9]+(\.[A-Za-z]{2,6}){1,2}$/;
      if(!regEmail.test(inpEmail.value)) {
        alert('이메일 형식이 올바르지 않습니다.');
        emailCheck = false;
        return;
      }
      
      fetch(fnGetContextPath() + '/user/checkEmail.do', {
        method: 'POST',
        headers: {
          'Content-Type' : 'application/json'
        },
        body: JSON.stringify({
          'email': inpEmail.value
        })
      })
      .then(response => response.json())
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
          .then(resData => {
            alert(inpEmail.value + '로 인증코드를 전송했습니다.');
            let inpCode = document.getElementById('inp-code');
            let btnverifycode = document.getElementById('btn-verify-code');
            inpCode.disabled = false;
            btnverifycode.disabled = false;
            btnverifycode.addEventListener('click', (evt) => {
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
          document.getElementById('msg-email').innerHTML = '이미 사용 중인 이메일입니다.' ;
          emailCheck = false;
          return;
        }
      })
    }
      
    const fnCheckPassword = () => {
         <%-- 비밀번호 4~12자, 영문/숫자/특수문자 중 2개 이상 포함 --%>
        let inpPw = document.getElementById('inp-pw');        
        let validCount = /[A-Za-z]/.test(inpPw.value)        <%-- 영문 포함되어 있으면 true (JavaScript 에서 true는 숫자 1 같다.)--%>
                       + /[0-9]/.test(inpPw.value)           <%-- 숫자 포함돠어 있으면 ture --%>
                       + /[^A-Za-z0-9]/.test(inpPw.value)    <%-- 영문/숫자가 아니면 ture--%>
        let passwordLength = inpPw.value.length;
        passwordCheck = passwordLength >= 4
                     && passwordLength <= 12
                     && validCount >= 2
        let msgPw = document.getElementById('msg-pw');
        if(passwordCheck){
          msgPw.innerHTML = '사용 가능한 비밀번호입니다.';
        } else {
          msgPw.innerHTML = '비밀번호 4~12자, 영문/숫자/툭수문자 중 2개 이상 포함';
        }
      }

      const fnCheckName = () => {
        let inpName = document.getElementById('inp-name');
        let name = inpName.value;
        let totalByte = 0;
        for(let i = 0; i < name.length; i++){
          if(name.charCodeAt(i) > 127 ) { <%-- 코드값이 127 초과이면 한 글자 당 2바이트 처리한다. --%>
            totalByte += 2;
          } else {
            totalByte++;
          }
        }
        nameCheck = (totalByte <= 100);
        let msgName = document.getElementById('msg-name');
        if(!nameCheck){
          msgName.innerHTML = '이름은 100바이트를 초과할 수 없습니다.';
        } else {
          msgName.innerHTML = '';
        }
      }

      const fnCheckMobile = () => {
        let inpMoblie = document.getElementById('inp-mobile');
        let mobile = inpMoblie.value;
        mobile = mobile.replaceAll(/[^0-9]/g, '');
        mobileCheck = /^010[0-9]{8}$/.test(mobile);
        let msgMobile = document.getElementById('msg-mobile');
        if(mobileCheck) {
          msgMobile.innerHTML = '';
        } else {
          msgMobile.innerHTML = '휴대전화를 확인하세요.';
        }
      }

      const fnCheckAgree = ()  => {
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
          } else if(!passwordCheck || !passwordConfirm) {
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
  
fnGetContextPath();
fnCheckEmail();
fnCheckPassword();
fnCheckName();
fnCheckMobile();
fnCheckAgree();
fnSignup();
  </script>

<%@ include file="../layout/footer.jsp" %>