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

     <c:if test="${not empty sessionScope.user.userNo}"> 
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
         <c:if test="${sessionScope.user.userNo == user.userNo}"> 
           <button class="btn-profile nav-btn noto" type="button">프로필편집</button>
           <button class="btn-write nav-btn noto" type="button">글쓰기</button>
         </c:if> 
       </div>  
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
      </c:if> 


<script>

// 전역변수
var totalPage = 0;
var page = 1;
var loading = false;

//로그인 체크
const fnCheckSignin = () => {
    if('${sessionScope.user.userNo}' === '') { 
      if(confirm('세션이 만료되어 Sign In 이 필요합니다. Sign In 할까요?')) {
        location.href = '${contextPath}/user/login.page';
      } else {
    	  location.href = '${contextPath}/main.page'; 
      }
    }
  } 

// 글쓰기 버튼
const fnWriteBlog = () => {
  $('.btn-write').on('click', (evt) => {
    if ('${sessionScope.user.userNo}' === '') { 
      if (confirm('세션이 만료되어 Sign In 이 필요합니다. Sign In 할까요?')) {
        location.href = '${contextPath}/user/login.page';
      } else {
        location.href = '${contextPath}/main.page'; 
      }
    } else {
      location.href = '${contextPath}/blog/write.page';
    }
  });
};

// 프로필편집 버튼
const fnEditProfile = () => {
  $('.btn-profile').on('click', (evt) => {
    if ('${sessionScope.user.userNo}' === '') { 
      if (confirm('세션이 만료되어 Sign In 이 필요합니다. Sign In 할까요?')) {
        location.href = '${contextPath}/user/login.page';
      } else {
        location.href = '${contextPath}/main.page'; 
      }
    } else {
      location.href = '${contextPath}/user/profile.do?userNo=${sessionScope.user.userNo}';
    }
  });
};


// 블로그 카운트
$(document).ready(function() {
    // 페이지가 로드되면 사용자의 블로그 총 개수를 가져오는 ajax 요청 보냄
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
    beforeSend: () => { // 요청 보내기 전에 로딩 상태 설정
        loading = true;
     },
    success: (resData) => {
      console.log("success"); // 구현 완료 후 삭제 필요
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
              str += '<div class="list-item"></div>';
            str += '</div>';   
          str += '</div>';   
          str += '</a>'  
       
         blogList.append(str);
        });
      }
      loading = false; 
    },
    error: (jqXHR) => {
    	  alert(jqXHR.statusText + '(' + jqXHR.status + ')');
    	  loading = false;
    	  window.history.back();
    }
  });
}

//블로그 상세페이지 이동
const fnMypageBlogDetail = () => {
$(document).on('click', '.blog', function(evt) {
 let blogListNo = $(this).attr('data-blog-list-no');
   location.href = '${contextPath}/blog/detail.do?blogListNo=' + blogListNo;
});
}

// 무한스크롤
const fnScrollHandler = () => {
    let loading = false;   // 로딩 상태 변수 추가
    let lastScrollTop = 0; // 스크롤 위치 변수 추가

    $(window).on('scroll', () => {
      const scrollTop = $(window).scrollTop();
      const documentHeight = $(document).height();
      const windowHeight = $(window).height();
      const bottomOffset = 50; // 스크롤 이벤트를 발생시킬 화면 하단과의 거리

      if (!loading && (scrollTop + windowHeight + bottomOffset >= documentHeight)) {
          loading = true;
          page++;
          fnGetMypageBlogList();
      }

      // 스크롤 위치 저장
      lastScrollTop = scrollTop;
    });
  };


//페이지 로드 시 로그인 체크
$(document).ready(() => {
  fnCheckSignin();
});

fnWriteBlog();
fnEditProfile(); 
fnGetMypageBlogList();
fnMypageBlogDetail();
fnScrollHandler();


</script>


<%@ include file="../layout/footer.jsp" %>