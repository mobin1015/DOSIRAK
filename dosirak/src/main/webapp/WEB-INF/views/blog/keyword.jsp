<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>
    
  <c:choose>
    <c:when test="${blog[0].keywordNo == 1}">
      <jsp:include page="../layout/header.jsp">
        <jsp:param value="브런치 키워드: 지구한바퀴 세계여행" name="title"/>
      </jsp:include>
    </c:when>
    <c:when test="${blog[0].keywordNo == 2}">
      <jsp:include page="../layout/header.jsp">
        <jsp:param value="브런치 키워드: 그림·웹툰" name="title"/>
      </jsp:include>
    </c:when>
    <c:when test="${blog[0].keywordNo == 3}">
      <jsp:include page="../layout/header.jsp">
        <jsp:param value="브런치 키워드: IT 트렌드" name="title"/>
      </jsp:include>
    </c:when>
    <c:when test="${blog[0].keywordNo == 4}">
      <jsp:include page="../layout/header.jsp">
        <jsp:param value="브런치 키워드: 사진·촬영" name="title"/>
      </jsp:include>
    </c:when>
    <c:when test="${blog[0].keywordNo == 5}">
      <jsp:include page="../layout/header.jsp">
        <jsp:param value="브런치 키워드: 취향저격 영화 리뷰" name="title"/>
      </jsp:include>
    </c:when>
    <c:when test="${blog[0].keywordNo == 6}">
      <jsp:include page="../layout/header.jsp">
        <jsp:param value="브런치 키워드: 오늘은 이런 책" name="title"/>
      </jsp:include>
    </c:when>
  </c:choose> 

<link rel="stylesheet" href="../resources/css/keyword.css"/>

  
  <div class="keyword-title">
    <h3>
      <c:choose>
        <c:when test="${blog[0].keywordNo == 1}">지구한바퀴 세계여행</c:when>
        <c:when test="${blog[0].keywordNo == 2}">그림·웹툰</c:when>
        <c:when test="${blog[0].keywordNo == 3}">IT 트렌드</c:when>
        <c:when test="${blog[0].keywordNo == 4}">사진·촬영</c:when>
        <c:when test="${blog[0].keywordNo == 5}">취향저격 영화 리뷰</c:when>
        <c:when test="${blog[0].keywordNo == 6}">오늘은 이런 책</c:when>
      </c:choose>  
    </h3>
  </div>  
  <div class="keyword-wrap">
    <div id="keyword-list"></div>
  </div>

  <script>
   
  var page = 1;
  var totalPage = 0;
  var loading = false;
  
  /* 키워드 리스트 불러오는 함수 */
  const fnKeywordList = () => {
    const keywordList = $('#keyword-list');
    moment.locale('ko');
    const stripHtml = (html)=>{
      let doc = new DOMParser().parseFromString(html, 'text/html');
      return doc.body.textContent || "";
    }
    $.ajax({
      type: 'get',
      url: '${contextPath}/blog/keywordList.do',
      data: 'keywordNo=' + ${blog[0].keywordNo} + '&page=' + page,
      dataType: 'json',
      beforeSend: () => { // 요청 보내기 전에 로딩 상태 설정
        loading = true;
      },
      success: (resData) => {
        if(resData.totalPage > 0) {
        	totalPage = resData.totalPage;
          $.each(resData.keywordList, (i, blog) => {
        	  let plainContents = stripHtml(blog.contents);
            let str = '<a href="${contextPath}/blog/detail.do?blogListNo=' + blog.blogListNo + '">';
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
            
            str += '<div class="list-content' + (blog.contents.includes('<img') ? ' list_has_image' : '') + '">' + plainContents + '</div>';
            str += '<div class="list-info">';
            str += '<span>댓글 ' + blog.commentCount + '</span>';
            // 블로그 게재시간 표시
            const publishTime = moment(blog.createDt);
            const now = moment();
            const diffHours = now.diff(publishTime, 'hours');
            if (diffHours <= 12) {
              str += '<span class="publish-time">' + publishTime.locale('ko').fromNow() + '</span>';
            } else {
              str += '<span class="publish-time">' + publishTime.format('MMM DD.YYYY') + '</span>';
            }
            if(blog.user.nickname === null) {
            		str += '<span>by ' + blog.user.name + '</span>';
            } else {
              str += '<span>by ' + blog.user.nickname + '</span>';
            }
            str += '</div>';
            str += '</div>';
            str += '</div>';
            str += '</div>';
            str += '</a>'
            keywordList.append(str);
          });
        }
      loading = false; // AJAX 요청이 완료되면 loading 상태를 해제합니다.
      },
      error: (jqXHR) => {
        alert('해당 키워드에 등록된 글이 없습니다.');
        loading = false; // AJAX 요청이 완료되면 loading 상태를 해제합니다.
        location.href = '${contextPath}/main.page';
      }
    });
	}
	
  /* 무한 스크롤 함수 */
	const fnScrollHandler = () => {
    let loading = false;
    let lastScrollTop = 0;

    $(window).on('scroll', () => {
      const scrollTop = $(window).scrollTop();
      const documentHeight = $(document).height();
      const windowHeight = $(window).height();
      const bottomOffset = 50; // 스크롤 이벤트를 발생시킬 화면 하단과의 거리

      if (!loading && (scrollTop + windowHeight + bottomOffset >= documentHeight)) {
          loading = true;
          page++;
          fnKeywordList();
      }

      // 스크롤 위치 저장
      lastScrollTop = scrollTop;
    });
	};
  
  fnKeywordList();
  fnScrollHandler();
  </script>

<%@ include file="../layout/footer.jsp" %>