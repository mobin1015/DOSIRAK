<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

  
<c:if test="${not empty user.nickname}">
  <jsp:include page="../layout/header.jsp">
    <jsp:param value="${user.nickname}의 프로필편집" name="title"/>
  </jsp:include>
</c:if>
<c:if test="${empty user.nickname}">
  <jsp:include page="../layout/header.jsp">
    <jsp:param value="${user.name}의 프로필편집" name="title"/>
  </jsp:include>
</c:if>






<link rel="stylesheet" href="../resources/css/profile.css?dt=${dt}"/>

  <div id="mArticle">

      <form  id="edit-form"
             method="POST"
             action="${contextPath}/user/modify.do"
             enctype="multipart/form-data" >

        <div class="edit-coverimg">
          <div class="edit-cover-in">
            <div class="bloger-thumb">
              <c:if test="${empty blogImgPath}">
               <img class="preview img-thumb" src="/prj${user.user.blogImgPath}" >
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

      </form>
 </div>

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
       
       if (!confirm("프로필을 수정하시겠습니까?")) {
    	      e.preventDefault(); 
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

    
    
  </style>



<%@ include file="../layout/footer.jsp" %>