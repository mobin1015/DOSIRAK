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
     <c:if test="${not empty sessionScope.user.userNo}"> 
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
         <c:if test="${sessionScope.user.userNo == user.userNo}"> 
           <button class="btn-profile nav-btn" type="button">프로필편집</button>
           <button class="btn-write nav-btn" type="button">글쓰기</button>
         </c:if> 
       </div>  
      </c:if> 
    </div>

  <div class="wrap-main">
      <div class="tab-contents">
        <span>글</span>
        <span id="blogCount"></span>        
      </div>
      <div class="blog-list-wrap">
        <div id="blog-list"></div>
      </div>
      
    </div>

  </div>


<script>

// 전역변수
var totalPage = 0;
var page = 1;

//로그인 체크
/* const fnCheckSignin = () => {
    if('${sessionScope.user.userNo}' === '') {  // session에 저장된 유저가 없을 때
      if(confirm('세션이 만료되어 Sign In 이 필요합니다. Sign In 할까요?')) {
        location.href = '${contextPath}/user/signin.page';
      }
    }
  } */

// 글쓰기 버튼
const fnWriteBlog = ()=> {
  $('.btn-write').on('click', (evt)=>{
    location.href = '${contextPath}/blog/write.page';
  })
}

// 프로필편집 버튼
const fnEditProfile = () => {
  $('.btn-profile').on('click', (evt)=>{
        location.href = '${contextPath}/user/profile.do?userNo=${sessionScope.user.userNo}';
  })
}

// 블로그 카운트
$(document).ready(function() {
    // 페이지가 로드되면 사용자의 블로그 총 개수를 가져오는 ajax 요청을 보낸다.
    $.ajax({
        type: 'GET',
        url: '${contextPath}/user/blogCount.do',
        data: 'userNo=${user.userNo}', 
        dataType: 'json',
        success: function(response) {
            $('#blogCount').text(response);
        },
        error: function(jqXHR, textStatus, errorThrown) {
            console.error('Error:', textStatus, '(' + jqXHR.status + '):', errorThrown);
        }
    });
})

// 블로그 리스트 
const fnGetMypageBlogList = () => {
  
  $.ajax({
    // 요청
    type: 'GET',
    url: '${contextPath}/user/getBlogList.do',
    data: 'userNo=${user.userNo}&page=' + page,
    // 응답
    dataType: 'json',
    success: (resData) => {
      console.log("success");
      totalPage = resData.totalPage;
      const blogList = $('#blog-list'); 
      blogList.empty();
      if (resData.blogList.length === 0) {
          blogList.append('<p class="none-blog">등록된 게시물이 없습니다.</p>');
        } else {
      $.each(resData.blogList, (i, blog) => {
        let str = '<a class="blog" data-user-no="'+ blog.user.userNo +'"  data-blog-list-no="' + blog.blogListNo + '">';
           str += '<div class="list-wrap">';
             str += '<div class="contents-wrap">';
              str += '<div class="list-item">';
               str += '<h4 class="list-title">' + blog.title + '</h4>';
               
               // 썸네일 이미지 처리
               if(blog.contents.includes('<img')) {
                 let thumbnailUrl = $(blog.contents).find('img').first().attr('src');
                 str += '<div class="list-thumbnail"><img src="' + thumbnailUrl + '"></div>';
               } else {
                 str += '<div class="list-thumbnail">썸네일없음</div>';
               }
               
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
        });
      }
    },
    error: (jqXHR) => {
    	  alert(jqXHR.statusText + '(' + jqXHR.status + ')');
    }
  });
}

// 무한 스크롤
const fnMypageScrollHandler = () => {
  
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
          fnGetMypageBlogList();
        }
      }, 500);
   })
}

// 블로그 상세페이지 이동
const fnMypageBlogDetail = () => {
  $(document).on('click', '.blog', function(evt) {
    let blogListNo = $(this).attr('data-blog-list-no');
      location.href = '${contextPath}/blog/detail.do?blogListNo=' + blogListNo;
  });
}


  
//fnCheckSignin();  
fnWriteBlog();
fnEditProfile(); 
fnGetMypageBlogList();
//fnMypageScrollHandler();
fnMypageBlogDetail();


</script>


<%@ include file="../layout/footer.jsp" %>