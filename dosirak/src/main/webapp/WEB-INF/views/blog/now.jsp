<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>
        
<jsp:include page="../layout/header.jsp" />

<link rel="stylesheet" href="../resources/css/now.css"/>

<div class="blog-now">
  <h3>브런치스토리 나우</h3>
</div>
<div class="now-result-wrap">
  <div id="now-result-list"></div>
</div>

<script>

  var page = 1;
  var totalPage = 0;
  
  var nowWrap = $('#now-result-wrap');
  var nowList = $('#now-result-list');
  
  // 검색 ajax
  const fnNowBlogList = (evt)=>{
    moment.locale('ko');
    $.ajax({
      type: 'GET',
      url: '${contextPath}/blog/nowBlog.do?order=DESC&page=' + page,
      dataType: 'json',
      success: (resData)=>{
    	  totalPage = resData.totalPage;
        $.each(resData.blogList, (i, blog) => { 
          let plainContents = stripHtml(blog.contents);
          let str = '<a href="${contextPath}/blog/detail.do?blogListNo=' + blog.blogListNo + '">';
          str += '<div class="list-wrap">';
          str += '<div class="contents-wrap">';
          str += '<div class="list-item">';
          str += '<h4 class="list-title">' + blog.title + '</h4>';
          str += '<div class="list-content">' + plainContents + '</div>'; 
          str += '<div class="list-info">';
          str += '<span>by ' + blog.user.nickname + ' · </span>';
          str += '<span>' + moment(blog.createDt).fromNow() + '</span>';
          str += '</div>';
          str += '</div>';
          str += '<div class="list-item">';
          
          // 썸네일 이미지 처리
          if(blog.contents.includes('<img')) {
            let thumbnailUrl = $(blog.contents).find('img').first().attr('src');
            str += '<div class="list-thumbnail"><img src="' + thumbnailUrl + '"></div>';
          } else {
            str += '<div class="list-thumbnail"></div>';
          }
          str += '</div>';
          str += '</div>';
          str += '</div>';
          str += '</a>'
          nowList.append(str);
        });
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
  
  
  // 무한스크롤
  const fnScrollHandler = () => {
    
    var timerId; 
    
    $(window).on('scroll', (evt) => {
 
      if(timerId) { 
        clearTimeout(timerId);
      }
      
      timerId = setTimeout(() => {
        
        let scrollTop = window.scrollY;
        let windowHeight = window.innerHeight;
        let documentHeight =  $(document).height();
        
        
        if( (scrollTop + windowHeight + 50) >= documentHeight ) {
          if(page > totalPage) {
            return;
          }
          page++;
          fnNowBlogList();
        }
        
      }, 500);
      
    })
    
  }
  
  fnNowBlogList();
  fnScrollHandler();

</script>

<%@ include file="../layout/footer.jsp" %>