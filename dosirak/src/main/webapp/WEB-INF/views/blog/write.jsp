<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<jsp:include page="../layout/header-write.jsp">
  <jsp:param value="글작성" name="title"/>
</jsp:include>
<link rel="stylesheet" href="../resources/css/write.css"/>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>


<form id="frm-blog-register"
      method="POST"
      action="${contextPath}/blog/register.do">
  
  <div class="editor">
    <select name="keyword" class="keyword">
      <option value="0" selected>키워드</option>
      <option value="1">지구한바퀴 세계여행</option>
      <option value="2">그림·웹툰</option>
      <option value="3">IT 트렌드</option>
      <option value="4">사진·촬영</option>
      <option value="5">취향저격 영화 리뷰</option>
      <option value="6">오늘은 이런 책</option>

    </select>
    <input type="text" name="title" id="title" placeholder="제목을 입력하세요">
  </div>
  
  <div class="summernote">
    <textarea id="contents" name="contents" placeholder="내용을 입력하세요"></textarea>
  </div>
  
  <div class="editor" id="btn-wrap">
    <input type="hidden" name="userNo" value="${sessionScope.user.userNo}">
  </div>
      
</form>

<script>

// Summernote Editor
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

  // 공백 검사 함수
  const fnRegisterBlog = () => {
    if(document.getElementById('title').value === '') {
      alert('제목을 입력해주세요');
      //evt.preventDefault();
      return false;
    } else if($("select[name=keyword]").val() === '0') {
      alert('키워드를 선택해주세요.');
      //evt.preventDefault();
      return false;
    } else if(document.getElementById('contents').value === ''){
      alert('내용을 입력해주세요');
      //evt.preventDefault();
      return false;
    }
  }
  
  // button click event
  document.getElementById('btn-register').addEventListener('click', (evt) => {
    if(fnRegisterBlog() !== false){
      document.getElementById('frm-blog-register').submit();	
    };
  })  

  fnSummernoteEditor();

</script>

<%@ include file="../layout/footer.jsp" %>