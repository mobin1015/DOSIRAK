package com.dosirak.prj.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.dosirak.prj.service.UserService;

import lombok.RequiredArgsConstructor;

@RequestMapping("/user")
@RequiredArgsConstructor
@Controller
public class UserController {

  private final UserService userService;
  
  
  //mypage로 넘어가는거임ㅅ시
  
  @GetMapping("/mypage.do")
  public String myPage(@RequestParam(value="userNo", required=false, defaultValue="2") int userNo,
                                    Model model) {
    userService.loadUserByNo(userNo, model);

    return "user/mypage";
  }
  
  // ★★★ 불러오기
  /*
  @GetMapping("profile")
  public String profile() {
    return "/user/profile";
  }
  단순페이지이동:확인용 -> 그냥 페이지 확인하려던거니까 나중에 날려
 */ 
  
 // profile jsp 로 user정보 담아서 이동
  @GetMapping("/profile.do")
  public String profile(@RequestParam(value="userNo", required=false, defaultValue="2") int userNo,
                                      Model model){
    userService.loadUserByNo(userNo, model);
    //model.addAttribute("user", userService.getUserByNo(userNo));
    return "user/profile";
  }
  
  // userNo 에 강제로 숫자 넣어서 이동함
 
 /*
 @GetMapping("/profile.do")
 public String profile(Model model){
   int userNo = 1;
   model.addAttribute("user", userService.getUserByNo(userNo));
   return "user/profile"; 
 }
*/
  
  @PostMapping("/modify.do")
  public String modifyProfile(@RequestParam("blogImgPath") MultipartFile blogImgPath,
                              @RequestParam("userNo") int userNo,
                              @RequestParam("nickname") String nickname,
                              @RequestParam("blogContents") String blogContents) {
      int modifyCount = userService.modifyProfile(userNo, nickname, blogContents, blogImgPath);
      // 수정 결과에 따라 리다이렉트할 주소와 함께 리턴
      return "redirect:/user/mypage.do";
  }

}
