package com.dosirak.prj.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.ResponseEntity;

import com.dosirak.prj.dto.BlogDetailDto;
import com.dosirak.prj.dto.UserDto;

public interface UserService {

  
  // 마이페이지 블로그 리스트 
  ResponseEntity<Map<String, Object>> getMypageBlogList(HttpServletRequest request);
  UserDto getUserByNo(int userNo);
  int getblogCount(int userNo);
  BlogDetailDto getBlogByNo(int blogListNo);

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
	String getNaverLoginURL(HttpServletRequest request);
	String getNaverLoginAccessToken(HttpServletRequest request);
	UserDto getNaverLoginProfile(String accessToken);
	boolean hasUser(UserDto user);
  void naverLogin(HttpServletRequest request, UserDto naverUser);

}
