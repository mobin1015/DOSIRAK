package com.dosirak.prj.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.dosirak.prj.service.UserService;

import lombok.RequiredArgsConstructor;

@RequestMapping("/user")
@RequiredArgsConstructor
@Controller
public class UserController {

  private final UserService userService;
  
  // 헤더 마이페이지
  @GetMapping("/mypage.do")
  public String mypage(@RequestParam int userNo, Model model) {
    model.addAttribute("user", userService.getUserByNo(userNo));
    //model.addAttribute("blogCount", userService.getblogCount());
    return "user/mypage";
  }
  
  // 마이페이지 프로필버튼
  @GetMapping("/profile.do")
  public String edit(@RequestParam int userNo, Model model) {
    model.addAttribute("user", userService.getUserByNo(userNo));
    return "user/profile";
  }
  
  // 마이페이지 블로그 리스트
  @GetMapping(value="/getProfileBlogList.do", produces = "application/json")
  public ResponseEntity<Map<String, Object>> getBlogList(HttpServletRequest request) {
   // System.out.println("getProfileBlogList 요청이 수신되었습니다.");
   // ResponseEntity<Map<String, Object>> responseEntity = userService.getMypageBlogList(request);
   // System.out.println("getProfileBlogList 응답을 반환합니다.");
    return userService.getMypageBlogList(request);
  }
  
  // 마이페이지 블로그 카운트
  @GetMapping("/blogCount.do")
  public ResponseEntity<Integer> getUserBlogCount (@RequestParam int userNo) {
    int blogCount = userService.getblogCount(userNo);
    return ResponseEntity.ok(blogCount);
  }
 
  // 마이페이지 블로그 상
  @GetMapping("/detail.do")
  public String detail(@RequestParam(value="blogListNo", required=false, defaultValue="0") int blogListNo
                     , Model model) {
    userService.loadBlogByNo(blogListNo, model);
    return "blog/detail";
  }
  
}
