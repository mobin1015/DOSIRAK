package com.dosirak.prj.controller;

import java.io.IOException;
import java.util.Collections;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.dosirak.prj.dto.UserDto;
import com.dosirak.prj.service.BlogService;
import com.fasterxml.jackson.core.JsonProcessingException;

import lombok.RequiredArgsConstructor;

@RequestMapping("/blog")
@RequiredArgsConstructor
@Controller
public class BlogController {

  private final BlogService blogService;
  @GetMapping("write.page")
  public String write() {
    return "blog/write";
  }
  
  @PostMapping(value="/summernote/imageUpload.do", produces="application/json")
  public ResponseEntity<Map<String, Object>> summernoteImageUpload(@RequestParam("image") MultipartFile multipartFile){
    return blogService.summernoteImageUpload(multipartFile);
  }
  
  @PostMapping("/register.do")
  public String register(HttpServletRequest request) {
    blogService.registerBlog(request);
    UserDto user = (UserDto) request.getSession().getAttribute("user");
    int userNo = user.getUserNo();
    return "redirect:/user/mypage.do?userNo=" + userNo;
  }

  @GetMapping("/keyword.do")
  public String keyword(@RequestParam int keywordNo, Model model) {
    model.addAttribute("blog", blogService.getKeywordNo(keywordNo));
    return "blog/keyword";
  }
    
  @GetMapping(value="/keywordList.do", produces="application/json")
  public ResponseEntity<Map<String, Object>> keywordList(HttpServletRequest request) {
    try {
      return ResponseEntity.ok(blogService.getKeywordList(request));      
    } catch (Exception e) {
      return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
          .body(Collections.singletonMap("error", "KeywordNo를 갖고 있는 데이터가 없습니다."));
    }
  }  
  
  @GetMapping("/detail.do")
  public String detail(HttpServletRequest request, Model model) throws JsonProcessingException, NumberFormatException {
    model.addAttribute("blog", blogService.getBlogDetailByNo(Integer.parseInt(request.getParameter("blogListNo"))));
    model.addAttribute("blogtime", blogService.getBlogDetailTime(Integer.parseInt(request.getParameter("blogListNo"))));
    model.addAttribute("url", request.getHeader("referer"));
    return "blog/detail";
  }
  
  @PostMapping("/editBlog.do")
  public String editBlog(@RequestParam int blogListNo, Model model) {
    model.addAttribute("blog", blogService.getBlogDetailByNo(blogListNo));
    return "blog/edit";
  }
  
  @PostMapping("/modifyBlog.do")
  public String modifyBlog(HttpServletRequest request, RedirectAttributes redirectAttributes) {
    int modifyCount = blogService.modifyBlog(request);
    redirectAttributes
      .addAttribute("blogListNo", request.getParameter("blogListNo"))
      .addFlashAttribute("modifyResult", modifyCount == 1 ? "수정되었습니다.": "수정되지 않았습니다.");
    return "redirect:/blog/detail.do?blogListNo={blogListNo}";
  }
  
  @PostMapping("/removeBlog.do")
  public void removeBlog(HttpServletRequest request, HttpServletResponse response
                         , RedirectAttributes redirectAttributes) throws IOException {
    int removeCount = blogService.removeBlog(Integer.parseInt(request.getParameter("blogListNo")));
    redirectAttributes.addFlashAttribute("removeResult", removeCount == 1 ? "블로그가 삭제되었습니다." : "블로그가 삭제되지 않았습니다.");
    response.sendRedirect(request.getParameter("url"));
  }

  @GetMapping(value="CommentList.do", produces="application/json")
  public ResponseEntity<Map<String, Object>> commentList(@RequestParam int blogListNo) {
    return blogService.getCommentList(blogListNo);
  }
  
  @PostMapping(value="/registerComment.do", produces="application/json")
  public ResponseEntity<Map<String, Object>> registerComment(HttpServletRequest request) {
    return ResponseEntity.ok(Map.of("insertCount", blogService.registerComment(request)));
  }

  @PostMapping(value="registerReply.do", produces="application/json")
  public ResponseEntity<Map<String, Object>> registerReply(HttpServletRequest request) {
    return ResponseEntity.ok(Map.of("insertReplyCount", blogService.registerReply(request)));
  }

  @PostMapping(value="removeComment.do", produces="application/json")
  public ResponseEntity<Map<String, Object>> removeComment(@RequestParam(value="commentNo", required=false, defaultValue="0") int commentNo) {
    return ResponseEntity.ok(Map.of("removeResult", blogService.removeComment(commentNo) == 1 ? "댓글이 삭제되었습니다." : "댓글이 삭제되지 않았습니다."));
  }
  
  @GetMapping(value="LikeList.do", produces="application/json")
  public  ResponseEntity<Map<String, Object>>  GetlikeList(@RequestParam int blogListNo) {
    return blogService.getLikeList(blogListNo); 
  }
  
  @GetMapping("/registerLike.do")
  public ResponseEntity<Map<String, Object>> insertLike(HttpServletRequest request) {
    return ResponseEntity.ok(Map.of("insertLike", blogService.insertLike(request)));
  }
  
  @GetMapping("/removeLike.do")
  public ResponseEntity<Map<String, Object>> removeLike(HttpServletRequest request) {
    return ResponseEntity.ok(Map.of("deleteLike", blogService.deleteLike(request)));
  }
  
  @GetMapping(value="/mainList.do", produces="application/json")
  public ResponseEntity<Map<String, Object>> mainList(HttpServletRequest request) {
    return blogService.getBlogList(request);
  }
  
  @GetMapping("/search.page")
  public String search() {
    return "blog/search";
  }
  
  @GetMapping(value = "searchBlog.do", produces="application/json")
  public ResponseEntity<Map<String, Object>> searchBlog(HttpServletRequest request) {
    return blogService.getSearchBlogList(request);

  }
  
  @GetMapping("/now.page")
  public String nowList() {
    return "blog/now";
  }
  
  @GetMapping(value = "nowBlog.do", produces="application/json")
  public ResponseEntity<Map<String, Object>> nowBlog(HttpServletRequest request) {
    return blogService.getNowBlogList(request);
  }
  

}
