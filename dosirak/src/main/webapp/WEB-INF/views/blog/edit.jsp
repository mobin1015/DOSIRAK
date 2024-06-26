<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>


<jsp:include page="../layout/header-write.jsp">
  <jsp:param value="블로그 편집" name="title" />
</jsp:include>
<link rel="stylesheet" href="../resources/css/write.css"/>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>


<form id="frm-blog-register"
      method="POST"
      action="${contextPath}/blog/modifyBlog.do">

  <div class="editor">
  <div>
        <input type="text" name="title" id="title"  value="${blog.title}">
  </div>
  </div>
  
  <div class="summernote">
    <textarea id="contents" name="contents" >${blog.contents}</textarea>
  </div>
  
  
  <div class="editor" id="btn-wrap">
    <input type="hidden" name="userNo" value="${sessionScope.userNo}">
   <input type="hidden" name="blogListNo" value="${blog.blogListNo}">
  </div>
      
</form>

<script>

const fnSummernoteEditor = () => {

    $('#contents').summernote({
      width: 700,
      height: 700,
      toolbar: [
            // [groupName, [list of button]]
            ['fontname', ['fontname']],
            ['fontsize', ['fontsize']],
            ['style', ['bold', 'italic', 'underline','strikethrough', 'clear']],
            ['color', ['forecolor','color']],
            ['para', ['paragraph']],
            ['insert',['picture','link','video']],
            ['view', ['help']]
          ],
        fontNames: ['맑은 고딕','궁서','굴림체','굴림','돋움체','바탕체', 'Nanum Myeongjo', 'Noto Sans KR'],
        fontSizes: ['8','9','10','11','12','14','16','18','20','22','24','28','30','36','50','72'],
      lang: 'ko-KR',
      callbacks: {
        onImageUpload: (images)=>{
          // 비동기 방식을 이용한 이미지 업로드
          for(let i = 0; i < images.length; i++) {
            let formData = new FormData();
            formData.append('image', images[i]);
            fetch('${contextPath}/blog/summernote/imageUpload.do', {
              method: 'POST',
              body: formData
              /*  submit 상황에서는 <form enctype="multipart/form-data"> 필요하지만 fetch 에서는 사용하면 안 된다. 
              headers: {
                'Content-Type': 'multipart/form-data'
              }
              */
            })
            .then(response=>response.json())
            .then(resData=>{
              $('#contents').summernote('insertImage', '${contextPath}' + resData.src);
            })
          }
        }
      }
    })
  }
const fnRegisterBlog = (evt) => {
    if(document.getElementById('title').value === '') {
      alert('제목을 입력해주세요');
      evt.preventDefault();
      return;
    } else if(document.getElementById('contents').value === ''){
      alert('내용을 입력해주세요');
      evt.preventDefault();
      return;
    }
  }
// submit event
document.getElementById('frm-blog-register').addEventListener('submit', (evt) => {
    fnRegisterBlog(evt);
  })

// button click event
document.getElementById('btn-register').addEventListener('click', (evt) => {
  document.getElementById('frm-blog-register').submit();

})  

  
  fnSummernoteEditor();

</script>

<%@ include file="../layout/footer.jsp" %>