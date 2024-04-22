package com.dosirak.prj.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;

import com.dosirak.prj.dto.UserDto;

public interface UserService {

  UserDto getUserByNo(int userNo);
  int getblogCount();
  ResponseEntity<Map<String, Object>> getMypageBlogList(HttpServletRequest request);
  void loadBlogByNo(int blogListNo, Model model);
}
