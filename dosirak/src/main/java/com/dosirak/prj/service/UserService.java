package com.dosirak.prj.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

import com.dosirak.prj.dto.UserDto;

public interface UserService {

	//가입
	void signup(HttpServletRequest request, HttpServletResponse response);
	void leave(HttpServletRequest request, HttpServletResponse response);
	ResponseEntity<Map<String, Object>> checkEmail(Map<String, Object> params);
	ResponseEntity<Map<String, Object>> sendCode(Map<String, Object> params);
	// 로그인 및 로그아웃
	String getRedirectURLAfterLogin(HttpServletRequest request);
	void login(HttpServletRequest request, HttpServletResponse response);
	void logout(HttpServletRequest request, HttpServletResponse response);
	// 네이버 로그인
<<<<<<< HEAD
  String getNaverLoginURL(HttpServletRequest request);
  String getNaverLoginAccessToken(HttpServletRequest request);
  UserDto getNaverLoginProfile(String accessToken);
  boolean hasUser(UserDto user);
  void naverSignin(HttpServletRequest request, UserDto naverUser);
=======
	String getNaverLoginURL(HttpServletRequest request);
	String getNaverLoginAccessToken(HttpServletRequest request);
	UserDto getNaverLoginProfile(String accessToken);
	boolean hasUser(UserDto user);
  void naverLogin(HttpServletRequest request, UserDto naverUser);
  
  
  

  
  
>>>>>>> ec02a7ba5d40f977d7f06bfae49d03077ca3f6a8
}
