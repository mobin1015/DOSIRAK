package com.dosirak.prj.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.dosirak.prj.dto.UserDto;
import com.dosirak.prj.service.BlogService;
import com.dosirak.prj.service.UserService;

import lombok.RequiredArgsConstructor;

@RequestMapping("/user")
@RequiredArgsConstructor
@Controller
public class UserController {

  private final UserService userService;
  
  @GetMapping("/")
  public String login(HttpServletRequest session) {
    UserDto user = userService.getUserByNo(1);
    session.setAttribute("loggeInUser", user);
    return "redirect:/user/mypage.do?userNo=" + user.getUserNo();
  }
  
  @GetMapping("/mypage.do")
  public String mypage(@RequestParam int userNo, Model model) {
    model.addAttribute("user", userService.getUserByNo(userNo));
    model.addAttribute("blogCount", userService.getblogCount());
    return "user/mypage";
  }
  
  @GetMapping("/profile.do")
  public String edit(@RequestParam int userNo, Model model) {
    model.addAttribute("user", userService.getUserByNo(userNo));
    return "user/profile";
  }
  
  @GetMapping(value="/getProfileBlogList.do", produces = "application/json")
  public ResponseEntity<Map<String, Object>> getBlogList(HttpServletRequest request) {
   // System.out.println("getProfileBlogList 요청이 수신되었습니다.");
   // ResponseEntity<Map<String, Object>> responseEntity = userService.getMypageBlogList(request);
   // System.out.println("getProfileBlogList 응답을 반환합니다.");
    return userService.getMypageBlogList(request);
  }
 
  
}
