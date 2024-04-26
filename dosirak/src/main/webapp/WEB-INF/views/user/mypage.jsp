<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<c:choose>
  <c:when test="${empty user.nickname}">
    <jsp:include page="../layout/header.jsp">
      <jsp:param value="${user.name}의 브런치스토리" name="title"/>
    </jsp:include>
  </c:when>
  <c:otherwise>
    <jsp:include page="../layout/header.jsp">
      <jsp:param value="${user.nickname}의 브런치스토리" name="title"/>
    </jsp:include>
  </c:otherwise>
</c:choose>


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
          <img class="profile-user-image" src="${contextPath}/resources/images/profile_default.png" alt="프로필 이미지">
         </c:if>
       </div>
       <div class="blog-wrap">
        <c:choose>
          <c:when test="${empty user.nickname}">
            <strong class="nickname">${user.name}</strong>
          </c:when>
          <c:otherwise>
            <strong class="nickname">${user.nickname}</strong>
          </c:otherwise>
        </c:choose>
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
    success: (resData) => {
      totalPage = resData.totalPage;
      const blogList = $('#blog-list');
      if (page === 1) {
        blogList.empty();
      }
      if (resData.blogList.length === 0) {
        blogList.append('<p class="none-blog">등록된 게시물이 없습니다.</p>');
      } else {
        $.each(resData.blogList, (i, blog) => {
          let str = '<a class="blog" data-user-no="' + blog.user.userNo + '"  data-blog-list-no="' + blog.blogListNo + '">';
          str += '<div class="list-wrap">';
          str += '<div class="contents-wrap">';
          str += '<div class="list-item">';
          str += '<h4 class="list-title">' + blog.title + '</h4>';

          // 썸네일 이미지 처리
          if (blog.contents.includes('<img')) {
            let thumbnailUrl = $(blog.contents).find('img').first().attr('src');
            str += '<div class="list-thumbnail"><img src="' + thumbnailUrl + '"></div>';
          } else {
            str += '<div class="list-thumbnail" style="display: none;"></div>';
          }

          // 이미지를 포함한 게시글인 경우만 썸네일을 표시, 그렇지 않은 경우에는 숨김 (list_has_image class명으로 조정)
          str += '<div class="list-content' + (blog.contents.includes('<img') ? ' list_has_image' : '') + '">' + stripHtml(blog.contents) + '</div>';
          str += '<div class="list-info">';
          str += '<span>댓글</span>';
          str += '<span class="num-comment">' + blog.commentCount + '</span>';
          str += '<span class="ico-dot">' + '&#8729;' + '</span>';

          // 블로그 게재시간 표시
          const publishTime = moment(blog.createDt);
          const now = moment();
          const diffHours = now.diff(publishTime, 'hours');
          if (diffHours <= 12) {
            str += '<span class="publish-time">' + publishTime.locale('ko').fromNow() + '</span>';
          } else {
            str += '<span class="publish-time">' + publishTime.format('MMM DD.YYYY') + '</span>';
          }
          str += '</div>';
          str += '</div>';
          str += '</div>';
          str += '</div>';
          str += '</a>';

          blogList.append(str);
        });
      }
    },
    error: (jqXHR) => {
      alert(jqXHR.statusText + '(' + jqXHR.status + ')');
    }
  });
}

const stripHtml = (html)=>{
    let doc = new DOMParser().parseFromString(html, 'text/html');
    return doc.body.textContent || "";
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
        if(page >= totalPage) {
          return;
        }
        page++;
        fnGetMypageBlogList();
      }
      
    }, 500);
    
  })
}

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