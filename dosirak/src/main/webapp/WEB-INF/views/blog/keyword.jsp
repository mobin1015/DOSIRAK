<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>
    
<jsp:include page="../layout/header.jsp">
  <jsp:param value="키워드 리스트" name="title"/>
</jsp:include>

<link rel="stylesheet" href="../resources/css/keyword.css"/>

  
  <div class="keyword-title">
    <h3>
      <c:choose>
        <c:when test="${blog.keywordNo == 1}">지구한바퀴 세계여행</c:when>
        <c:when test="${blog.keywordNo == 2}">그림·웹툰</c:when>
        <c:when test="${blog.keywordNo == 3}">IT 트렌드</c:when>
        <c:when test="${blog.keywordNo == 4}">사진·촬영</c:when>
        <c:when test="${blog.keywordNo == 5}">취향저격 영화 리뷰</c:when>
        <c:when test="${blog.keywordNo == 6}">오늘은 이런 책</c:when>
      </c:choose>
    </h3>
  </div>  
  <div class="keyword-wrap">
    <div id="keyword-list"></div>
  </div>

  

  <script>
   
  var page = 1;

  const fnKeywordList = () => {
	  $.ajax({
	    type: 'get',
	    url: '${contextPath}/blog/keywordList.do',
	    data: 'keywordNo=${blog.keywordNo}&page=' + page,
	    dataType: 'json',
	    success: (resData) => {  
	      console.log(resData);  
	      const keywordList = $('#keyword-list');
	      keywordList.empty();
	      $.each(resData.keywordList, (i, blog) => {
	        let str = '<div class="list-wrap">';
                str += '<div class="contents-wrap">';
    	            str += '<div class="list-item">';
    	              str += '<h4 class="list-title">' + blog.title + '</h4>';
                    str += '<div class="list-content">' + blog.contents + '</div>';
                    str += '<div class="list-info">'
                      str += '<span>댓글0</span>';
                      str += '<span>2시간전</span>';
                      str += '<span>by 작성자</span>';
                    str += '</div>';
                  str += '</div>';
                  str += '<div class="list-item">썸네일이미지</div>';
                str += '</div>';   
              str += '</div>';   
          keywordList.append(str);
	      })
	    },
	    error: (jqXHR) => {
	      alert(jqXHR.statusText + '(' + jqXHR.status + ')');
	    }
	  })
	}
  
  fnKeywordList();
  </script>

<%@ include file="../layout/footer.jsp" %>