package com.dosirak.prj.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.dosirak.prj.dto.UserDto;
import com.dosirak.prj.service.UserService;

import org.springframework.ui.Model;
import lombok.RequiredArgsConstructor;

@RequestMapping("/user")
@RequiredArgsConstructor
@Controller
public class UserController {

  private final UserService userService;
  
  @GetMapping("/signup.page")
  public String signupPage() {
    return "user/signup";
  }
  
  @PostMapping(value="/checkEmail.do", produces="application/json")
  public ResponseEntity<Map<String, Object>> checkEmail(@RequestBody Map<String, Object> params) {
  	System.out.println(params);
    return userService.checkEmail(params);
  }
  
  @PostMapping(value="/sendCode.do", produces="application/json")
  public ResponseEntity<Map<String, Object>> sendCode(@RequestBody Map<String, Object> params) {
    return userService.sendCode(params);
  }
  
  @PostMapping("/signup.do")
  public void signup(HttpServletRequest request, HttpServletResponse response) {
    userService.signup(request, response);
  }
  
  @GetMapping("/leave.do")
  public void leave(HttpServletRequest request, HttpServletResponse response) {
    userService.leave(request, response);
  }
  
  @GetMapping("/login.page")
  public String loginPage(HttpServletRequest request
  											, Model model) {
  	
  	// Log In 페이지로 url 넘겨 주기 (로그인 후 이동할 경로를 의미함)
  	model.addAttribute("url", userService.getRedirectURLAfterLogin(request));
  	  	
  	// Log In 페이지로 naverLoginURL 넘겨 주기 (네이버 로그인 요청 주소를 의미함)
  	model.addAttribute("naverLoginURL", userService.getNaverLoginURL(request));
  	
  	return "user/login";
  }
  
  @PostMapping("/login.do")
  public void login(HttpServletRequest request, HttpServletResponse response) {
    userService.login(request, response);
  }
  
  @GetMapping("/naver/getAccessToken.do")
  public String getAccessToken(HttpServletRequest request) {
  	String accessToken = userService.getNaverLoginAccessToken(request);
  	return "redirect:/user/naver/getProfile.do?accessToken=" + accessToken;
  }
  
  @GetMapping("/naver/getProfile.do")
  public String getProfile(HttpServletRequest request, Model model) {
  	
  	// 네이버로부터 받은 프로필 정보
  	UserDto naverUser = userService.getNaverLoginProfile(request.getParameter("accessToken"));
  	
  	// 반환 경로
  	String path = null;
  	
  	// 프로필이 DB에 있는지 확인 (있으면 Log IN, 없으면 Sign UP)
  	if(userService.hasUser(naverUser)) {
  		// Log In
  		userService.naverLogin(request, naverUser);
  		path = "redirect:/main.page";
  	} else {
  		// Sign Up (네이버 가입 화면으로 이동)
  		model.addAttribute("naverUser", naverUser);
  		path = "user/naver_signup";
  	}
  	return path;
  }
 
  @GetMapping("/logout.do")
  public void logout(HttpServletRequest request, HttpServletResponse response) {
    userService.logout(request, response);
  }
  
}

   
  

