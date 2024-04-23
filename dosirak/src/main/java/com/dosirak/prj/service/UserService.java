package com.dosirak.prj.service;

import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

import com.dosirak.prj.dto.UserDto;

public interface UserService {
  //★★★ 불러오기
  //UserDto getUserByNo(int userNo);
  void loadUserByNo(int userNo, Model model);
  
//★★★ 수정하기
  int modifyProfile(int userNo, String nickname, String blogContents, MultipartFile blogImgPath);
}
