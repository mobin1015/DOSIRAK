<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>
    
    
<jsp:include page="../layout/header.jsp" />

<link rel="stylesheet" href="../resources/css/keyword.css"/>

  
  <div class="keyword-title">
    <h3>11${keyword.keywordName}</h3>
  </div>  
  <div class="keyword-wrap">
    <div id="keyword-list"></div>
  </div>

  

  <script>

  // 아래 2개의 함수에서 page 를 공유해줘야한다. -> 전역변수 필요
  var page = 1;
  var totalPage = 0;

  // 초기 페이지를 보여주는 함수 
  const fnGetKeywordList = () => {
    
    // page 에 해당하는 목록 요청
    $.ajax({
      // 요청
      type: 'GET',
      url: '${contextPath}/blog/keyword.do',
      data: 'page=' + page,
      // 응답
      dataType: 'json',
      success: (resData) => {   // resData = {"blogList": [], "totalPage": 10}
        totalPage = resData.totalPage; // 가져와서 갱신해준다
        $.each(resData.keywordList, (i, blogDetail) => {
          let str = '<div class="keyword" >';
          str += '<span>' + blogDetail.title + '</span>';
          str += '<span>' + blog.hit + '</span>';
          /* str += '<span>' + moment(blog.createDt).format('YYYY.MM.DD') + '</span>'; */
          str += '</div>';
          $('#keyword-list').append(str);
        })
      },
      error: (jqXHR)=>{
        alert(jqXHR.statusText + '(' + jqXHR.status + ')');
      }
    });
    
  }
  
  // 페이지를 바꿔주는 함수
  const fnScrollHandler = () => {
    
    // 스크롤이 바닥에 닿으면 page 증가(최대 totalPage 까지) 후 새로운 목록 요청
    // window.addEventListener('scroll', (evt) => {})
    
    // 타이머 id (동작한 타이머의 동작 취소를 위한 변수)
    // 목록 가져오기를 타이머에 넣은 건 타이머는 취소하기 쉬움. 한번 동작하고나면 타이머가 동작을 취소하도록 짠 것.
    var timerId; // undifined, boolean 의 의미로는 false
    $(window).on('scroll', (evt) => {
      
      if(timerId) {   // timerId 가 undefined 이면 false, 아니면 true
                      // timerId 가 undefined 이면 setTimeout() 함수가 동작한 적 없음
        
        clearTimeout(timerId);  // setTimeout() 함수 동작을 취소함 -> 목록을 가져오지 않는다. 
      }
      
      // 500밀리초 (0.5초) 후에 () => {} 동작하는 setTimeout 함수
      timerId = setTimeout(() => {      
        let scrollTop = $(window).scrollTop();
        let windowHeight = $(window).height();
        let documentHeight = $(document).height();
        
        if( (scrollTop + windowHeight + 50) >= documentHeight ) {   // 스크롤바와 바닥 사이 크기가 50px 이하인 경우
          if(page > totalPage) {
            return;
          }
          page++;
          fnGetBlogList();        
        }
      }, 500);            
      // scrollTop + windowHeight = documentHeight : 같을 때 scroll 이 바닥에 닿았다라고 생각.
      // scrollTop + windowHeight + @ = documentHeight : 바닥이 @만큼 있을 때 바닥에 닿았다라고 생각할 수 있음.
      
    })    
  }
  
  fnGetKeywordList();
  </script>

<%@ include file="../layout/footer.jsp" %>