<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<jsp:include page="../layout/header.jsp">
  <jsp:param value="${user.nickname}의 브런치스토리" name="title"/>
</jsp:include>

<!-- include custom css/js -->
<link rel="stylesheet" href="${contextPath}/resources/css/mypage.css?dt=${dt}">

<div class="wrap">

    <div class="profile-wrap">
      <div class="bloger-thumb" data-user-no="${user.userNo}">    
       <!-- 프로필 이미지 있을 때 -->
       <c:if test="${not empty user.blogImgPath}">
        <img src="${contextPath}${user.blogImgPath}">
       </c:if>
       <!-- 프로필 이미지 없을 때 (기본이미지 첨부 됨) -->
       <c:if test="${empty user.blogImgPath}">
        <img class="profile-user-image" src="${contextPath}/resources/images/check1.png" alt="프로필 이미지">
       </c:if>
      </div>
      <div class="blog-wrap">
        <strong class="nickname">${user.nickname}</strong>
        <span class="blog-contents">${user.blogContents}</span>
      </div>
      <div class="profile-btn-wrap">
        <c:if test="${not empty sessionScope.userNo}">
          <c:if test="${sessionScope.userNo == user.userNo}"> 
           <button class="btn-profile nav-btn" type="button">프로필편집</button>
           <button class="btn-write nav-btn" type="button">글쓰기</button>
          </c:if>
        </c:if> 
      </div>

    </div>

    <div class="wrap-main">
      <div class="tab-contents">
        <span>글</span>
        <span id="blogCount"></span>        
      </div>
      <div class="blog-list-wrap">
        <ul id="blog-list"></ul>
      </div>
      
    </div>

  </div>


<script>
//글쓰기
const fnWriteBlog = ()=> {
  $('.btn-write').on('click', (evt)=>{
    location.href = '${contextPath}/blog/write.page';
  })
}

// 프로필편집
const fnEditProfile = () => {
  $('.btn-profile').on('click', (evt)=>{
        location.href = '${contextPath}/user/profile.do?userNo=${user.userNo}';
  })
}

// 전역변수
var totalPage = 0;
var page = 1;

const fnGetProfileBlogList = () => {
	
	$.ajax({
		// 요청
	  type: 'GET',
	  url: '${contextPath}/user/getProfileBlogList.do?userNo=${userNo}&page=' + page,
		//data: 'userNo=${sessionScope.userNo}&page=' + page
	  // 응답
	  dataType: 'json',
	  success: (resData) => {
			console.log("success");
		  totalPage = resData.totalPage;
		  const blogList = $('#blog-list'); 
		  blogList.empty();
		  $.each(resData.blogList, (i, blog) => {
			  let str = '<a class="blog">';
			     str += '<div class="list-wrap" data-user-no="'+ blog.user.userNo +'"  data-blog-no="' + blog.blogListNo + '">';
			       str += '<div class="contents-wrap">';
			        str += '<div class="list-item">';
			         str += '<h4 class="list-title">' + blog.title + '</h4>';
               str += '<div class="list-content">' + blog.contents + '</div>';
               str += '<div class="list-info">';
                str += '<span>댓글</span>';
                str += '<span class="num-comment">'+ blog.commentCount +'</span>';
                str += '<span class="ico-dot">'+ '&#8729;' +'</span>';
                str += '<span class="publish-time">'+ moment(blog.createDt).format('MMM DD.YYYY') +'</span>';
               str += '</div>';
              str += '</div>';
              str += '<div class="list-item">썸네일이미지</div>';
            str += '</div>';   
          str += '</div>';   
          str += '</a>'  
			 
	      blogList.append(str);
		  })
	  },
	  error: (jqXHR) => {
	      alert(jqXHR.statusText + '(' + jqXHR.status + ')');
	  }
	});
}

const fnScrollHandler = () => {
	
	var timerId;
	
	$(window).on('scroll', (evt) => {                          
		  
    if(timerId) {                                               
        clearTimeout(timerId);   
    }
    timerId = setTimeout(() => {
        
        let scrollTop = $(window).scrollTop();
        let windowHeight = $(window).height();
        let documentHeight = $(document).height();
    
        if( (scrollTop + windowHeight + 50 ) >= documentHeight ){ 
          if(page > totalPage) {
            return;
          }
          page++;
          fnGetProfileBlogList();
        }
      }, 500);
   })
}

$(document).ready(function() {
    // 페이지가 로드되면 사용자의 블로그 총 개수를 가져오는 AJAX 요청을 보냅니다.
    $.ajax({
        type: 'GET',
        url: '${contextPath}/user/blogCount.do',
        data: 'userNo=${userNo}', // 사용자 번호를 지정하세요.
        dataType: 'json',
        success: function(response) {
            // 성공적으로 블로그 총 개수를 가져왔을 때, 해당 값을 화면에 표시합니다.
            $('#blogCount').text(response);
        },
        error: function(jqXHR, textStatus, errorThrown) {
            // AJAX 요청이 실패한 경우 에러를 콘솔에 출력합니다.
            console.error('Error:', textStatus, '(' + jqXHR.status + '):', errorThrown);
        }
    });
})

  const fnBlogDetail = () => {
	$(document).on('click', '.blog', (evt) => {
		location.href = '${contextPath}/blog/detail.do?blogListNo=${blogListNo}';
	});
} 

fnWriteBlog();
fnEditProfile(); 
fnGetProfileBlogList();
//fnScrollHandler();
fnBlogDetail();


</script>


<%@ include file="../layout/footer.jsp" %>