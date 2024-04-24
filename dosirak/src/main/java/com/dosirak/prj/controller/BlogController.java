package com.dosirak.prj.controller;

import java.util.Collections;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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

import com.dosirak.prj.service.BlogService;

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
  public String register(HttpServletRequest request, RedirectAttributes redirectAttributes) {
    redirectAttributes.addFlashAttribute("insertCount", blogService.registerBlog(request));
    return "redirect:/main.page";
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
  
  @GetMapping("/search.page")
  public String search() {
    return "blog/search";
  }
  
  @GetMapping(value = "searchBlog.do", produces="application/json")
  public ResponseEntity<Map<String, Object>> searchBlog(HttpServletRequest request) {
    return blogService.getSearchBlogList(request);
  }

}
