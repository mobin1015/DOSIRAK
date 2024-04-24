<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<jsp:include page="../layout/header.jsp">
  <jsp:param value="프로필편집" name="title"/>
</jsp:include>


<div id="mArticle">

  <!-- 다시 수정 -->
      <form  id="edit-form"
             method="POST"
             action="${contextPath}/user/modify.do"
             enctype="multipart/form-data" >

        <div class="edit-coverimg">
          <div class="edit-cover-in">
            <div class="bloger-thumb">
              <c:if test="${empty blogImgPath}">
               <img class="preview img-thumb" src="${contextPath}/resources/images/profile_default.png"  >
              </c:if>
              <c:if test="${not empty blogImgPath}">
               <img class="preview img-thumb" src="${contextPath}${blogImgPath}" >
              </c:if>
              
              <span class="profile-image-span">
               <input id="profile-image-input" type="file" name="blogImgPath" value="" accept="image/*"> 
              </span> 
            </div>
          </div>
        </div>
        
        <div class="form-in">
          <input type="hidden" name="userNo" value="${sessionScope.user.userNo}">
        
          <label for="nickname">작가명</label>
          <!-- c;if empty써서 없을 시, -->
          <div class="input-box ff">
            <input type="text" id="nickname" name="nickname" value="${nickname}" placeholder="이름을 입력해주세요">
            <p id="nickname-notice" class="input-notice noto"></p>
          </div>
          <label for="blog-contents">소개</label>
          <!-- c;if empty써서 없을 시, -->
          <div class="input-box"> 
            <textarea id="blog-contents" name="blogContents" placeholder="간단한 소개를 입력해주세요" maxlength="100">${blogContents}</textarea>
            <p id="contents-notice" class="input-notice"></p>
          </div>
          <div class="info-tip">
            <span class="tip-icon">TIP</span> 
            <p class=tip-txt>
            작가 소개에 포함되는 내용은 포털 검색 등을 통해 외부에 공개되는 정보이므로<br>
            작성 시 불필요한 개인정보가 포함되지 않도록 주의가 필요합니다.
            </p>
            <p class="blog-notice"></p>
          </div>
          
          <div class=button-wrap>
            <button id="cancel-btn" class="noto" type="button">취소하기</button>
            <button id="submit-btn" class="noto" type="submit">수정완료</button>
          </div>
        </div>
    
        <!-- <img src="${contextPath}/resources/images/icon_camera.png">  -->

      </form>
  
  <!-- 프로필 이미지 -->
    <!-- 프로필 입력폼 -->  
   <script>
   
   const fileDOM = document.querySelector('#profile-image-input');
   const preview = document.querySelector('.preview');

   fileDOM.addEventListener('change', () => {
     const reader = new FileReader();
     reader.onload = ({ target }) => {
       preview.src = target.result;
     };
     reader.readAsDataURL(fileDOM.files[0]);
   });



   const fnProfileSubmit = (e) => {
     document.getElementById('edit-form').addEventListener('submit', (e) => {
    	 
       let nickname = document.getElementById('nickname');
       let regNickname =  /^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z\s]*$/;
       let blogContents = document.getElementById('blog-contents');
       let nicknameNotice = document.getElementById('nickname-notice');
       let contentsNotice = document.getElementById('contents-notice');

       if (nickname.value === '') {
         e.preventDefault();
         nicknameNotice.innerHTML = '작가명을 입력해주세요'
         nicknameNotice.style.display = 'block';
         return;
       }
       
       if (!regNickname.test(nickname.value)){
    	   e.preventDefault();
    	   nicknameNotice.innerHTML = '한글, 영문, 띄어쓰기만 사용할 수 있습니다.';
    	   nicknameNotice.style.display = 'block';
    	   return;
       }
       
       if (blogContents.value === '') {
         e.preventDefault();
         contentsNotice.innerHTML = '소개 문구를 입력해주세요';
         contentsNotice.style.display = 'block';
         return;
       }
     });
   }

   const fnProfileCancel = () => {
     document.getElementById('cancel-btn').addEventListener('click', (e) => {
       if (confirm('편집중인 내용을 저장하지 않고 나가시겠습니까?')) {
         location.href = '${contextPath}/user/mypage.do';
       }
     });
   }
   
   fnProfileSubmit();
   fnProfileCancel();
  
   </script>

   

  <style>
    #mArticle{}
    .edit-coverimg{background-color: #f8f8f8;height: 120px;}
    .edit-cover-in{position: relative;width:700px;height:100%;margin:0 auto;}
    .bloger-thumb{position: absolute;bottom: -35%;right: 0%;z-index: 5;
    width: 100px;height: 100px;margin-left: 250px;}

    .img-thumb{display: block;width: 100px;height: 100px;border-radius: 100px;}
    .profile-image-span{display:inline-block;width:42px;height:42px;
    background:url('${contextPath}/resources/images/icon_camera.png');
    background-size:100% 100%;
    position:absolute;bottom:0px;right:-10px;}
    #profile-image-input{width:42px;height:42px;background:transparent;text-indent:-9999px}
    .edit-profile{width:100%;margin:0 auto;}
    #edit-form{width:100%;;margin:0px auto  0;position:Relative;}
    #edit-form .form-in{width:700px;margin:40px auto 0;}
    #edit-form label{display:inline-block;font-size: 12px;
    font-weight: normal;
    line-height: 14px;
    margin-right: 10px;
    padding-bottom:13px;
    padding-right:10px;
    position:relative;}
    #edit-form label::after{content:'*';position:Absolute;top:-2px;right:0;color:#00c6be;font-size:16px;}
    #edit-form .input-box{width:100%;border-bottom:1px solid #eee;padding-bottom:6px;}
    #edit-form .ff{margin-bottom:60px}
    #edit-form input{display:block;width:100%;height:40px;
    font-size:28px;line-height:34px;color: #333;font-weight:300;}
    #edit-form input#profile-image-input{border-bottom:none;cursor:pointer;}
    #edit-form input#nickname{}
    #edit-form textarea{display:block;padding:15px 20px 13px;resize: none;font-size: 13px;font-weight:300;
    line-height: 24px;color: #333;border: 1px solid #eee;}
    #edit-form .input-notice{display:none;color:#ff4040;font-size:12px;font-weight:300;margin-bottom:0;margin-top:10px;}
    #edit-form .info-tip{padding-top: 17px;}
    #edit-form  .tip-icon{border: 1px solid #00c6be;
    border-radius: 8px;
    color: #00c6be;
    float: left;
    font-size: 10px;
    line-height: 15px;
    margin: 4px 6px 0 0;
    padding: 0 4px;}
    #edit-form  .tip-txt{color: #959595;
    font-size: 12px;
    line-height: 20px;
    overflow: hidden;}
    
    #edit-form .button-wrap{display:flex;justify-content: center;gap:6px;margin-top:30px;}
    #edit-form .button-wrap button{background:#fff;width:80px;height:32px;line-height:32px;color:#666;border:1px solid #bbb;border-radius:20px;
    font-size:13px;font-weigh:100;}
    #edit-form .button-wrap #submit-btn{border: 1px solid #00c6be;border-radius: 20px;color: #00c6be;}
    
    
  </style>



<%@ include file="../layout/footer.jsp" %>