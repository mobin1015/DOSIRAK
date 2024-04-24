<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<jsp:include page="../layout/header.jsp"/>

profile화면

<div>
  <c:if test="${not empty sessionScope.user}">  
    <c:if test="${sessionScope.user.userNo == upload.user.userNo}">
      hi 
    </c:if>
  </c:if>
</div>

<style>

    #mArticle{}
    .edit-coverimg{
      background-color: #f8f8f8;
    min-height: 140px;
    position: relative;
    }
    .bloger-thumb{
    top: -38%;
    height: 100px;
    right: 0%;
    margin-left: 250px;
    position: absolute;
    width: 100px;
    z-index: 5;
    }

    .img-thumb{
    display: block;
    border-radius: 100px;
    height: 100px;
    width: 100px;
    }
    .profile-image-span{display:inline-block;width:42px;height:42px;
    background:url('${contextPath}/resources/images/icon_camera.png');
    background-size:100% 100%;
    position:absolute;bottom:0px;right:-10px;}
    #profile-image-input{width:42px;height:42px;background:transparent;text-indent:-9999px}
</style>

<div id="mArticle">

  <!-- 프로필 이미지 -->

    <!-- 프로필 입력폼 -->  
    <div class="edit-profile"> 
        <div class="edit-coverimg"></div>
       
      <form  id="edit-form"
             method="POST"
             action="${contextPath}/user/modify.do"
             enctype="multipart/form-data" >
        <div class="bloger-thumb">
          <c:if test="${empty user.blogImgPath}">
           <img class="preview img-thumb" src="${contextPath}/resources/images/profile_default.png"  >
          </c:if>
          <c:if test="${not empty user.blogImgPath}">
           <img class="preview img-thumb" src="${contextPath}${user.blogImgPath}" >
          </c:if>
          <span class="profile-image-span">
            <input id="profile-image-input" type="file" name="blogImgPath" value="" accept="image/*"> 
          </span> 
        </div>

        
        <!-- <img src="${contextPath}/resources/images/icon_camera.png">  -->
        <input type="hidden" name="userNo" value="${user.userNo}">
        
        <label for="nickname">작가명</label>
        <!-- c;if empty써서 없을 시, -->
        <input type="text" id="nickname" name="nickname" value="${user.nickname}" placeholder="이름을 입력해주세요">
        <label for="blog-contents">소개</label>
        <!-- c;if empty써서 없을 시, -->
        <textarea id="blog-contents" name="blogContents" placeholder="간단한 소개를 입력해주세요">${user.blogContents}</textarea>
        <div class="info-tip">
          <span class="tip-icon">TIP</span> 
          <p class=tip-txt>
          작가 소개에 포함되는 내용은 포털 검색 등을 통해 외부에 공개되는 정보이므로<br>
          작성 시 불필요한 개인정보가 포함되지 않도록 주의가 필요합니다.
          </p>
          <p class="blog-notice"></p>
        </div>
        
        <div class=button-wrap>
          <button id="cancel-btn" type="button">취소하기</button>
          <button id="submit-btn" type="submit">수정완료</button>
        </div>
        
      </form>
    </div>
  </div>

   <script>
   
   const fileDOM = document.querySelector('#profile-image-input');
   const preview = document.querySelector('.preview');

   fileDOM.addEventListener('change', () => {
     const reader = new FileReader();
     console.log("현재 src" + preview.src);
     reader.onload = ({ target }) => {
       preview.src = target.result;
       console.log("현재 src" + preview.src);
     };
     reader.readAsDataURL(fileDOM.files[0]);
   });

   
   const fnAsyncUpload2 = ()=>{
      const inputFiles = document.getElementById('profile-image-input');
      let formData = new FormData();
      console.log(fornData);
      /*
      for(let i = 0; i < inputFiles.files.length; i++){
        formData.append('files', inputFiles.files[i]);
      }
      */
      if (inputFiles.files.length > 0) {
          formData.append('blogImgPath', inputFiles.files[0]);
      }
      $.ajax({
        type: 'POST',
        url: '${contextPath}/user/modify.do',
        contentType: false,  
        data: formData,      
        processData: false,  
        dataType: 'json'
      }).done(resData=>{
        if(resData.success === 1){
          alert('저장되었습니다.');
        } else {
          alert('저장실패했습니다.');
        }
      })
    }
   
   let blogContents = document.getElementById('blog-contents').value;
   console.log(blogContents);
   
   const fnProfileSubmit = () =>{
	   document.getElementById('edit-form').addEventListener('submit', (e) => {
		   
		   
		   let blogContents = document.getElementById('blog-contents')
		   
		   if(blogContents.value === ''){
			   alert('블로그소개글을 확인하세요');
			   e.preventDefault();
			   return;
		   }
		   
		   
	   })
   }
 
   fnProfileSubmit();
   </script>

  <style>
    
    /*header 다시 수정!!!*/
    .header-wrap{position:fixed;top:0;left:0;margin-top:0;z-index:1000;width:100%;background:#f8f8f8;display:flex;}
    .header-in{width:100%}


    .edit-profile{width:100%;margin:0 auto;}
    #edit-form{width:700px;margin:40px auto  0;position:Relative;}
    #edit-form label{display:block;font-size: 12px;
    font-weight: normal;
    line-height: 14px;
    margin-right: 10px;
    padding-bottom:13px}
    #edit-form input{
    display:block;width:100%;height:34px;padding-bottom:6px;border-bottom:1px solid #eee;
    font-size:28px;line-height:34px;color: #333;}
    #edit-form input#nickname{
    margin-bottom:60px}
    #edit-form textarea{display:block;padding:15px 20px 13px;    resize: none;    font-size: 13px;
    line-height: 24px;color: #333;border: 1px solid #eee;}
    .info-tip{padding-top: 17px;}
    
    .tip-icon{    border: 1px solid #00c6be;
    border-radius: 8px;
    color: #00c6be;
    float: left;
    font-size: 10px;
    line-height: 15px;
    margin: 4px 6px 0 0;
    padding: 0 4px;}
    .tip-txt{color: #959595;
    font-size: 12px;
    line-height: 20px;
    overflow: hidden;}
    
    .button-wrap{display:flex;justify-content: center;gap:6px}
    .button-wrap button{width:80px;height:32px;line-height:32px;colof:#666;border:1px solid #bbb;border-radius:20px}
    .button-wrap #submit-btn{}
  </style>



<%@ include file="../layout/footer.jsp" %>