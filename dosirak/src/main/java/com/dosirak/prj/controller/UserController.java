package com.dosirak.prj.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.dosirak.prj.dto.UserDto;
import com.dosirak.prj.mapper.UserMapper;
import com.dosirak.prj.service.UserService;

import lombok.RequiredArgsConstructor;

@RequestMapping("/user")
@RequiredArgsConstructor
@Controller
public class UserController {

  private final UserService userService;
  //추가
  
  
  // 헤더 마이페이지
   @GetMapping("/mypage.do")
   public String mypage(@RequestParam int userNo, Model model) {
     model.addAttribute("user", userService.getUserByNo(userNo));
     //model.addAttribute("blogCount", userService.getblogCount());
     return "user/mypage";
   }
  
  // 블로거페이지
  @GetMapping("/bloger.do")
  public String blogerPage(@RequestParam int userNo, Model model) {
    model.addAttribute("user", userService.getUserByNo(userNo));
    //model.addAttribute("blogCount", userService.getblogCount());
    return "user/bloger";
  }
  
  // 마이페이지 프로필편집

  // 마이페이지 블로그 리스트
  @GetMapping(value="/getBlogList.do", produces = "application/json")
  public ResponseEntity<Map<String, Object>> getBlogList(@RequestParam int userNo, HttpServletRequest request) {
    return userService.getBlogList(request);
  }
  
  // 마이페이지 블로그 카운트
  @GetMapping("/blogCount.do")
  public ResponseEntity<Integer> getUserBlogCount (@RequestParam int userNo) {
    int blogCount = userService.getblogCount(userNo);
    return ResponseEntity.ok(blogCount);
  }
 
  // 마이페이지 블로그 상세페이지 이동 
  @GetMapping("/detail.do")
  public String detail(@RequestParam int blogListNo, Model model) {
    model.addAttribute("blog", userService.getBlogByNo(blogListNo));
    return "blog/detail";
  }
  
  @GetMapping("/signup.page")
  public String signupPage() {
    return "user/signup";
  }
  
  @PostMapping(value="/checkEmail.do", produces="application/json")
  public ResponseEntity<Map<String, Object>> checkEmail(@RequestBody Map<String, Object> params) {
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
    
    // 프로필이 DB에 있는지 확인 (있으면 Sign In, 없으면 Sign Up)
    if(userService.hasUser(naverUser)) {
      // Sign In
      userService.naverSignin(request, naverUser);
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
  
  
  
  
  // ★ 산들 Profile영역
  @GetMapping("/profile.do")
  public String modifyProfile(@RequestParam("userNo") int userNo, Model model) {
      // userNo를 기반으로 사용자 정보를 가져옴
      UserDto user = userService.loadUserByNo(userNo);

      // 사용자의 닉네임 사용하기
      String nickname = user.getNickname();
      String blogContents = user.getBlogContents();
      String blogImgPath = user.getBlogImgPath();

      // 모델에 사용자 정보를 추가하여 프로필 페이지로 전달
      model.addAttribute("nickname", nickname);
      model.addAttribute("blogContents", blogContents);
      model.addAttribute("blogImgPath",blogImgPath);

      // 프로필 페이지로 이동
      return "user/profile";
  }
  
  

  
  @PostMapping("/modify.do")
  public String modifyProfile(@RequestParam(value = "blogImgPath", required = false) MultipartFile blogImgPath,
                              @RequestParam("userNo") int userNo,
                              @RequestParam("nickname") String nickname,
                              @RequestParam("blogContents") String blogContents,
                              HttpSession session,
                              Model model) {
       int modifyCount = userService.modifyProfile(userNo, nickname, blogContents, blogImgPath);
       
       if (modifyCount == 1) {
         // 수정된 사용자 정보 세션에 업데이트
         UserDto updatedUser = userService.loadUserByNo(userNo);
         session.setAttribute("user", updatedUser);
       }
       
      // 수정 성공 시 메시지
      model.addAttribute("msg", "프로필이 수정되었습니다.");
      // 되돌아갈 주소
      model.addAttribute("url", "/user/mypage.do");
      model.addAttribute("no", userNo);
      return "/user/modifyalert";
  }
  
}

   
  

