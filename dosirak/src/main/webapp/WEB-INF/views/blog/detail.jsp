<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"/>
<c:set var="dt" value="<%=System.currentTimeMillis()%>"/>


<jsp:include page="../layout/header.jsp" />

<!-- include moment.js -->
<script src="${contextPath}/resources/moment/moment-with-locales.min.js"></script>
</head>

<body>

<div>
  <c:if test="${sessionScope.user.userNo == blog.user.userNo}">
    <form id="frm-btn" method="POST">  
      <input type="hidden" name="blogListNo" value="${blog.blogListNo}">
      <button type="button" id="btn-edit-blog" class="btn btn-warning btn-sm">편집</button>
      <button type="button" id="btn-remove-blog" class="btn btn-danger btn-sm">삭제</button>
    </form>
  </c:if>
</div>
    <div class="container">
        <div class="contets-wrap">
        <div class="blog-detail-title nanum">
         <h1>${blog.title}</h1>
        </div>
        <br>
        <div class="blog-detail-wirter">
         <c:if test="${empty blog.user.nickname}"><a>${blog.user.userNo}</a> </c:if>
         <c:if test="${!(empty blog.user.nickname)}"><a>${blog.user.nickname}</a> </c:if>
         
        </div>
        <br>
        <br>
        <div class="blog-detail-contents">
         <p>${blog.contents}</p>
        </div>
        <hr>
       <div class="utils-wrap">
           <button  id="like-btn" type="button"  style="width: 50px; height: 50px; background-color: blue;">
            
           </button>
           <button id="comment-btn" type="button">
            댓글
           </button>
       </div> 
       <div id="comments"></div>
       
       
       <div id="comments-register" style="display:none">
<form id="frm-comment">
  <textarea id="contents" name="contents"></textarea>
  <input type="hidden" name="blogListNo" value="${blog.blogListNo}">
  <c:if test="${not empty sessionScope.user.userNo}">  
    <input type="hidden" name="userNo" value="${sessionScope.user.userNo}">
  </c:if>
  <button type="button" id="btn-comment-register">댓글등록</button>
</form>
       </div>
       
    </div>
    
    </div>
    <div class="container2">
      <div class="writerinfo-wrap">
        <span  class="writer-name">
        <a href="${contextPath}/user/bloger.do?userNo=${blog.user.userNo}">${blog.user.nickname}</a>
        </span>
        <span class="writer-iamge" >
        <a href="${contextPath}/user/bloger.do?userNo=${blog.user.userNo}">${blog.user.blogImgPath}</a>
        </span>
        <br>
        <br>
        <div  class="writer-contents">
       <a href="${contextPath}/user/bloger.do?userNo=${blog.user.userNo}">${blog.user.blogContents}</a>
        </div>
        </div> 
     </div>
     
</body>

<script>


const url = new URL(window.location);
const likeBtn = document.getElementById('like-btn');
const commentBtn = document.getElementById('comment-btn');
const comments = $('#comments');
const commentsRegister = document.getElementById('comments-register');

var flag = 0;

//로그인 여부 체크
const fnCheckSignin = () => {
  if('${sessionScope.user.userNo}' === '') {
    if(confirm('Sign In 이 필요한 기능입니다. Sign In 할까요?')) {
      location.href = '${contextPath}/user/login.page';
    } else {
      return;
    }
  }
}



$(commentBtn).click(()=>{
	 if(flag===0) {
         flag=1;
         fnCommentList();
         commentsRegister.style.display ="";           
} else {
    flag =0;           
    comments.text(" ");
    commentsRegister.style.display = 'none';
}
})

const fnCommentList = () => {
    $.ajax({
        type: 'GET',
        url: '${contextPath}/blog/CommentList.do?blogListNo=${blog.blogListNo}',
        dataType: 'json',
        success: (resData) => {                    
                   if(resData.commentList.length === 0) {
                      comments.append('<div>첫 번째 댓글의 주인공이 되어 보세요</div>');
                           return;
                         }
                   
                   if(comments.textContent != " ") {
                	   comments.text(" ");
                   }
                   

                   
                   comments.append('<div>댓글 ' + resData.commentList.length +'</div>');
                 $.each(resData.commentList, (i, comment) => {
                   let str = '';
                   // 댓글은 들여쓰기 (댓글 여는 <div>)
         
                   
                   if(comment.depth === 0) {
                     str += '<div class="'+ comment.groupNo+'">';
                   } else {
                     str += '<div style="padding-left: 32px" class="'+ comment.groupNo+'">'
                   }
                   str += '<hr>';
                   // 댓글 내용 표시
                   if(comment.state === 0){
                     str += '<div>삭제된 댓글입니다.</div>';
                   } else {
                	   if(comment.user.nickname === null) {
                		   str += '<div>' +comment.user.userNo+ '</div>';
                	   }
                	   else{
                		   str += '<div>' +comment.user.nickname+ '</div>';
                	   }
                     str +=   moment(comment.createDt).format('YYYY.MM.DD') ;
                     str += '<div>' + comment.contents + '</div>';
                     str += '<button type="button" class="btn btn-success btn-reply">답글</button>';
                     // 삭제 버튼 (내가 작성한 댓글에만 삭제 버튼이 생성됨)
                     if(Number('${sessionScope.user.userNo}') === comment.user.userNo) {
                       str += '<button type="button" class="btn btn-danger btn-remove-comment" data-comment-no="' + comment.commentNo + '">삭제</button>';
                     }
                   }
                   /************************ 답글 입력 화면 ************************/
                  const btnReply = $('.btn-reply')
                  btnReply.click(function() { 
                     
                  })
                   /****************************************************************/
                   // 댓글 닫는 <div>
                   str += '</div><div></div>';
                   // 목록에 댓글 추가
                   comments.append(str);
        })
                                       
            },
        error: (jqXHR) => {
          alert(jqXHR.statusText + '(' + jqXHR.status + ')');
        }
    
  }
  )
}

const fnRegisterComment = () => {
    $('#btn-comment-register').on('click', (evt) => {
    	   
        if('${sessionScope.user.userNo}' === '') {
            if(confirm('Sign In 이 필요한 기능입니다. Sign In 할까요?')) {
              location.href = '${contextPath}/user/login.page';
              return;
            } 
            return;
          }
      $.ajax({
        // 요청
        type: 'POST',
        url: '${contextPath}/blog/registerComment.do',
        data: $('#frm-comment').serialize(),  // <form> 내부의 모든 입력을 파라미터 형식으로 보낼 때 사용, 입력 요소들은 name 속성을 가지고 있어야 함
        // 응답
        dataType: 'json',
        success: (resData) => {  // resData = {"insertCount": 1}
          if(resData.insertCount === 1) {
            alert('댓글이 등록되었습니다.');
            $('#contents').val('');
            fnCommentList();
          } else {
            alert('댓글 등록이 실패했습니다.');
          }
        },
        error: (jqXHR) => {
          alert(jqXHR.statusText + '(' + jqXHR.status + ')');
        }
      })
      
    })
  }


const fnSwitchingReplyInput = () => {
     $(document).on('click', '.btn-reply', (evt) => {
          const classNo = evt.target.parentElement.getAttribute('class');
         var elements = document.getElementsByClassName(classNo);
         var lastElement = elements[elements.length - 1];
         
     
         if(lastElement.nextSibling.children[0]){
            lastElement.nextSibling.children[0].remove();
         }
        // }else{
        
          if (elements.length > 0) {
           var lastElement = elements[elements.length - 1];
           var newDiv = document.createElement('div');
           var userId = evt.target.parentElement.children[1].textContent;
           var usertag='';
           
           if(evt.target.parentElement.getAttribute('style') != null){
              usertag = '@'+userId +' ';   
           }else{
              usertag = '';
           }
         
           let str = '<div class="div-frm-reply blind" style="padding-left: 32px">';
             str += '  <form class="frm-reply">';
             str += '    <input type="hidden" name="groupNo" value="' + classNo + '">';
             str += '    <input type="hidden" name="blogListNo" value="${blog.blogListNo}">';
             str += '    <input type="hidden" name="userNo" value="${sessionScope.user.userNo}">';
             str += '    <textarea name="contents" class="reply-contents" >'+ usertag+'</textarea>';
             str += '    <button type="button" class="btn btn-warning btn-register-reply">작성완료</button>';
             str += '  </form>';
             str += '</div>';
             newDiv.innerHTML= str;
           lastElement.parentNode.insertBefore(newDiv, lastElement.nextSibling);
     }
   })
}
    
const fnRegisterReply = () => {
     $(document).on('click', '.btn-register-reply', (evt) => {
         if('${sessionScope.user.userNo}' === '') {
             if(confirm('Sign In 이 필요한 기능입니다. Sign In 할까요?')) {
               location.href = '${contextPath}/user/login.page';
               return;
             } 
             return;
           }
       $.ajax({
         type: 'POST',
         url: '${contextPath}/blog/registerReply.do',
         data: $(evt.target).closest('.frm-reply').serialize(),
         dataType: 'json',
         success: (resData) => {
           if(resData.insertReplyCount === 1) {
             alert('답글이 등록되었습니다.');
             $(evt.target).prev().val('');
             fnCommentList();
           } else {
             alert('답글 등록이 실패했습니다.');
           }
         },
         error: (jqXHR) => {
           alert(jqXHR.statusText + '(' + jqXHR.status + ')');
         }
       })
     })
   }
   
const fnRemoveComment = () => {
     $(document).on('click', '.btn-remove-comment', (evt) => {
         fnCheckSignin();
       if(!confirm('해당 댓글을 삭제할까요?')){
         return;
       }
       $.ajax({
         // 요청
         type: 'post',
         url: '${contextPath}/blog/removeComment.do',
         data: 'commentNo=' + $(evt.target).data('commentNo'),
         // 응답
         dataType: 'json',
         success: (resData) => {  // resData = {"removeResult": "댓글이 삭제되었습니다."}
           alert(resData.removeResult);
           fnCommentList();
         }
       })
     })
   }
   
const fnClickLike = () => {
       $(likeBtn).click(function() {
    	   if('${sessionScope.user.userNo}' === '') {
               if(confirm('Sign In 이 필요한 기능입니다. Sign In 할까요?')) {
                 location.href = '${contextPath}/user/login.page';
                 return;
               } 
               return;
             }
          if(likeBtn.style.backgroundColor === 'red' ){
              $('#like-btn').text(Number(likeBtn.innerText) -1);
             likeBtn.style.backgroundColor = 'blue';
               $.ajax({
                   type: 'GET',
                   url: '${contextPath}/blog/removeLike.do?blogListNo=${blog.blogListNo}' + '&userNo=${blog.user.userNo}',
                   dataType: 'json',
                   error: (jqXHR) => {
                     alert(jqXHR.statusText + '(' + jqXHR.status + ')');
                   }
                 })
             
          } else {
              $('#like-btn').text(Number(likeBtn.innerText) + 1);
             likeBtn.style.backgroundColor = 'red';
                $.ajax({
                    type: 'GET',
                    url: '${contextPath}/blog/registerLike.do?blogListNo=${blog.blogListNo}'  + '&userNo=${blog.user.userNo}',
                    dataType: 'json',
                    error: (jqXHR) => {
                      alert(jqXHR.statusText + '(' + jqXHR.status + ')');
                    }
                  })
          }
       });
      }
      
const fnGetBlogList = () => {
     $.ajax({
       type: 'GET',
       url: '${contextPath}/blog/LikeList.do?blogListNo=${blog.blogListNo}',
       dataType: 'json',
       success: (resData) => {  
           $('#like-btn').append(resData.LikeList.length);
           $.each(resData.LikeList, (i, like) => {
              if(like.userNo == '${sessionScope.user.userNo}') {
                 likeBtn.style.backgroundColor = "red";
                 return false;
               } 
             });
           /*$.each(resData.LikeList, (i, like) => {
               let str = '<div>';
               str += '<span>' + like.likeNo + '</span>';
               str += '<span>' + like.blogListNo + '</span>';
               str += '<span>' + like.userNo + '</span>';
               str += '</div>';
               $('#like-list').append(str);
             })*/
       },
       error: (jqXHR) => {
         alert(jqXHR.statusText + '(' + jqXHR.status + ')');
       }
     })
   }
   
var frmBtn = $('#frm-btn');  

//블로그 편집 화면으로 이동
const fnEditBlog = () => {
  $('#btn-edit-blog').on('click', (evt) => {
    frmBtn.attr('action', '${contextPath}/blog/editBlog.do');
    frmBtn.submit();
  })
}

// 블로그 수정 결과 메시지
const fnModifyResult = () => {
  const modifyResult = '${modifyResult}';
  if(modifyResult !== '') {
    alert(modifyResult);
  }
}

// 블로그 삭제
const fnRemoveBlog = () => {
  $('#btn-remove-blog').on('click', (evt) => {
     fnCheckSignin();
    if(confirm('블로그를 삭제하면 모든 댓글이 함께 삭제됩니다. 삭제할까요?')){
      frmBtn.attr('action', '${contextPath}/blog/removeBlog.do');
      frmBtn.submit();
    }
  })
}
   
   

fnGetBlogList();
fnClickLike();
fnSwitchingReplyInput();
fnRegisterReply();
fnRemoveComment();
fnRegisterComment();
fnEditBlog();
fnModifyResult();
fnRemoveBlog();
</script>