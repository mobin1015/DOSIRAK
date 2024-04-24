<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>
        
<jsp:include page="../layout/header.jsp" />

<link rel="stylesheet" href="../resources/css/search.css"/>

<div class="search-write-wrap">
  <form name="frm-search" id ="frm-search" onsubmit="return false;">
    <select name="type" class="search-type">
      <option selected value="">선택하세요</option>
      <option value="writer">작성자</option>
      <option value="contents">내용/제목</option>
    </select>
    <input type="text" class ="query" id="query" name="query" placeholder="검색어를 입력해주세요." onkeydown="javascript:if(event.keyCode == 13) fnSearchResult();">
    <button type="button" id="search-btn">검색</button>    
  </form>
</div>
<div class="search-result-wrap">
  <div id="search-result-list"></div>
</div>

<script>

  var page = 1;
  var totalPage = 0;
  
  var searchWrap = $('#search-result-wrap');
  var searchList = $('#search-result-list');
  var searchType;
  var searchQuery;
  
  // 검색 ajax
  const fnSearchBlogList = (evt)=>{
  	  searchType = $("select[name=type]").val();
  	  searchQuery = $("#query").val();
  	  if(searchType === '' || searchType === undefined){
  		  alert('검색 타입을 선택해주세요');
  		  return false;
  	  } else if(searchQuery === '' || searchQuery === undefined){
  		  alert('검색어를 입력해주세요');
  		  return false;
  	  }
  	  $.ajax({
  		  type: 'GET',
  		  url: '${contextPath}/blog/searchBlog.do?type='+searchType+'&query='+searchQuery+'&page='+page,
  			dataType: 'json',
  		  success: (resData)=>{
  			  totalPage = resData.totalPage;
  			  let result='';
  			  if(document.getElementById('div-result') === null){
    			  if(searchType === 'contents'){
    				  result = '<div id="div-result">글 검색 결과 '+ resData.totalBlog + '건</div>';					  			  
    			  } else if(searchType === 'writer'){
    				  result = '<div id="div-result">작성자 검색 결과 '+ resData.totalBlog + '건</div>';				  
    			  }				  
  			  searchWrap.append(result);
  			  }
      	  $.each(resData.blogList, (i, blog) => {	
              let str = '<a href="">';
              str += '<div class="list-wrap">';
              str += '<div class="contents-wrap">';
              str += '<div class="list-item">';
              str += '<h4 class="list-title">' + blog.title + '</h4>';

              // 검색어 하이라이트 추가
              if(searchType === 'contents'){
                let contentWithHighlight = blog.contents.replace(searchQuery, '<span class="highlight">' + searchQuery + '</span>');
                str += '<div class="list-content">' + contentWithHighlight + '</div>';
              } else {
                str += '<div class="list-content">' + blog.contents + '</div>';
              } 
              
              str += '<div class="list-info">';
              str += '<span>댓글 ' + blog.commentCount + '</span>';
              str += '<span>' + moment(blog.createDt).fromNow() + '</span>';
              str += '<span>by ' + blog.user.nickname + '</span>';
              str += '</div>';
              str += '</div>';
              str += '<div class="list-item">';
              
              // 썸네일 이미지 처리
              if(blog.contents.includes('<img')) {
                let thumbnailUrl = $(blog.contents).find('img').first().attr('src');
                str += '<div class="list-thumbnail"><img src="' + thumbnailUrl + '"></div>';
              } else {
                str += '<div class="list-thumbnail">썸네일없음</div>';
              }
              str += '</div>';
              str += '</div>';
              str += '</div>';
              str += '</a>'
    			  searchList.append(str);
  			  });
  		  },
  		  error: (jqXHR) => {
  		    alert(jqXHR.statusText + '(' + jqXHR.status + ')');
  		  } 			  
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
	      
	      let scrollTop = window.scrollY;
	      let windowHeight = window.innerHeight;
	      let documentHeight =  $(document).height();
	      
	      
	      if( (scrollTop + windowHeight + 50) >= documentHeight ) {
	        if(page > totalPage) {
	          return;
	        }
	        page++;
	        fnSearchBlogList();
	      }
	      
	    }, 500);
	    
	  })
	  
	}
  
  // 검색할 때 마다 초기화하는 함수
  const fnSearchResult = () => {
	  page=1;
	  if($.trim(searchWrap.html()) !== ""){
	      searchWrap.empty();
	      fnSearchBlogList();
	    } else{
  	    fnSearchBlogList();
	    	
	    }
  }
  

  
  $('#search-btn').on('click', fnSearchResult);
  fnScrollHandler();



</script>

<%@ include file="../layout/footer.jsp" %>