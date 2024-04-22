<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%session.setAttribute("userNo", 2);%>   
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>

<jsp:include page="../layout/header.jsp">
  <jsp:param value="${user.nickname}의 브런치스토리" name="title"/>
</jsp:include>

<style>
  .header-wrap {
    width: 1920px;
    height: 120px;
    background-color: #F8F8F8
  }
  
  .profile-wrap {
    width: 700px;
    height: 167px;
    margin: 10px auto;
  }
  
  .tab-contents {
    width: 700px;
    height: 59px;
    margin: 10px auto;
  }
  
  .profile-user-image {
    width: 100px;
    height: 100px;
    border-radius: 100px;
    margin-left: 605px;
  }
  
  .nickname {
    display:block;
    box-sizing: border-box;
    width: 700px;
    height: 39px;
    padding-right: 170px;
    font-size: 28px;
    font-weight: 400;
  }
  
  .blog-contents {
    display: block;
    padding-top: 5px;
    font-size: 13px;
    line-height: 20px;
    color: #959595;
  }
  
  .profile-btn-wrap {
    padding: 22px 0px 0px 0px;
    margin-left: 515px;
  }
  
  .btn-profile{
   width: 94px;
   color: #959595;
   border-color: #ddd;
  }
  
  .tab-contents {
  display: flex;  
  justify-content: center;  
  align-items: center;
  }

.post-list-wrap {width: 100%;}

#post-list a {width: 100%;}
.list-wrap {overflow: left; border-bottom: 1px solid #eee; padding: 30px 20px;}
.contents-wrap .list-title {font-size: 20px; text-align: left; letter-spacing: -1px;}
.contents-wrap {display: flex; flex-wrap: wrap; align-items: center; margin-top: 6px; justify-content: space-between;}
.contents-wrap .list-item p img {display: none;}
.contents-wrap .list-item .list-content {max-height: 45px; text-align: left; color: #666; font-size: 14px; line-height: 21px;}
.list-info span {color: #959595; font-size: 12px; padding-top: 20px; margin-right: 10px;}
.list-content{}

/*    .post {
   position: relative;
   width: 700px;
   padding: 24px 0 27px;
   border-bottom: 1px solid #666;
  }

  .tit-article {
  font-weight: 400;
  font-size: 20px;
  }
  
  .sub-contents {
  overflow: hidden;
  text-overflow: ellipsis;
  max-height: 50px;
  padding-top: 5px;
  font-size: 14px;
  padding-top: 6px;
  color: #666;
  }
  
  .post-append {
  display: block;
  overflow: hidden;
  padding-top: 21px;
  font-size: 12px;
  color: #959595;
  } */
  
  
</style>


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
       <%--  <c:if test="${not empty sessionScope.loggeInUser}">
          <c:if test="${sessionScope.loggeInUser.userNo == user.userNo}"> --%>
           <button class="btn-profile nav-btn" type="button">프로필편집</button>
           <button class="btn-write nav-btn" type="button">글쓰기</button>
         <%--  </c:if>
        </c:if> --%>
      </div>

    </div>

    <div class="wrap-main">
      <div class="tab-contents">
        <span>글</span>
        <span class="num-contents">${blogCount}</span>        
      </div>
      <div class="post-list-wrap">
        <ul id="post-list"></ul>
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
	  url: '${contextPath}/user/getProfileBlogList.do?userNo=3&page=' + page,
	  // 응답
	  dataType: 'json',
	  success: (resData) => {
			console.log("success");
		  totalPage = resData.totalPage;
		  const postList = $('#post-list'); 
		  postList.empty();
		  $.each(resData.blogList, (i, post) => {
			  let str = '<a href="">';
			      str += '<li class="post" data-user-no="'+ post.user.userNo +'"  data-blog-no="' + post.blogListNo + '">';
			       str += '<div class="contents-wrap">';
			        str += '<div class="list-item">';
			         str += '<h4 class="list-title">' + post.title + '</h4>';
               str += '<div class="list-content">' + post.contents + '</div>';
               str += '<div class="list-info">';
                str += '<span>댓글   </span>';
                str += '<span class="num-comment"></span>';
                str += '<span class="publish-time">'+ moment(post.createDt).format('MMM DD.YYYY') +'</span>';
               str += '</div>';
              str += '</div>';
              str += '<div class="list-item">썸네일이미지</div>';
            str += '</div>';   
          str += '</div>';   
          str += '</li>'
          str += '</a>'  
			 
	      postList.append(str);
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


fnWriteBlog();
fnEditProfile(); 
fnGetProfileBlogList();
//fnScrollHandler();


</script>


<%@ include file="../layout/footer.jsp" %>