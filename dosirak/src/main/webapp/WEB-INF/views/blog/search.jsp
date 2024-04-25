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
    <div class="search-btn" onclick='fnSearchResult();'></div>    
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
    moment.locale('ko');
    searchType = $("select[name=type]").val();
    searchQuery = $("#query").val().trim();
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
        // 검색 결과 출력
        if(document.getElementById('div-result') === null){
        	if(resData.totalBlog === 0){
        		result = '<div id="none-result"><span class="highlight">' + searchQuery +'</span>'+' 에 대한 검색 결과가 없습니다.</div>';
        		result += '<div><span>검색어의 단어 수를 줄이거나, 보다 일반적인 검색어로 다시 검색해보세요.</span></div>';
        		result += '<div><span>두 단어 이상을 검색하신 경우, 정확하게 띄어쓰기를 한 후 검색해보세요.</span><div>';
        		
        	}else{ 		
            if(searchType === 'contents'){
              result = '<div id="div-result">내용/제목 검색 결과 '+ resData.totalBlog + '건</div>';                    
            } else if(searchType === 'writer'){
              result = '<div id="div-result">작성자 검색 결과 '+ resData.totalBlog + '건</div>';          
            }
        	}
        searchList.append(result);
        }
        
        // 블로그 리스트 출력
        $.each(resData.blogList, (i, blog) => { 
          let str = '<a href="${contextPath}/blog/detail.do?blogListNo=' + blog.blogListNo + '">';
          let plainContents = stripHtml(blog.contents);

          str += '<div class="list-wrap">';
          str += '<div class="contents-wrap">';
          str += '<div class="list-item">';

          // 검색어 하이라이트 추가
          if (searchType === 'contents') {
        	  // 타이틀 하이라이트
            let titleWithHighlight = blog.title.replace(searchQuery, '<span class="highlight">' + searchQuery + '</span>');
            str += '<h4 class="list-title">' + titleWithHighlight + '</h4>';
            
            // 컨텐츠 하이라이트
            let queryIndex = plainContents.indexOf(searchQuery);
            let start = queryIndex - 50 < 0 ? 0 : queryIndex - 50;
            let end = plainContents.indexOf('\n', queryIndex) !== -1 ? plainContents.indexOf('\n', queryIndex) : queryIndex + 50;
            let shortContents = plainContents.substring(start, end);
            if (start > 0) {
                shortContents = '…' + shortContents;
            }
            if (end < plainContents.length) {
                shortContents += '…';
            }
            shortContents = shortContents.replace(new RegExp(searchQuery, 'gi'), '<span class="highlight">' + searchQuery + '</span>');
            str += '<div class="list-content">' + shortContents + '</div>';
            } else {
              str += '<h4 class="list-title">' + blog.title + '</h4>';
              str += '<div class="list-content">' + blog.contents + '</div>';
            }

            str += '<div class="list-info">';
            str += '<span>댓글 ' + blog.commentCount + ' • </span>';
            str += '<span>' + moment(blog.createDt).fromNow() + ' • </span>';
            str += '<span>by ' + blog.user.nickname + '</span>';
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
          searchList.append(str);
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
          fnSearchBlogList();
        }
        
      }, 500);
      
    })
    
  }
  
  // 검색할 때 마다 초기화하는 함수
  const fnSearchResult = () => {
    page=1;
    if($.trim(searchList.html()) !== ""){
        searchList.empty();
        fnSearchBlogList();
      } else{
        fnSearchBlogList();
      }
  };

  fnScrollHandler();

</script>

<%@ include file="../layout/footer.jsp" %>