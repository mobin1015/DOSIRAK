package com.dosirak.prj.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.ResponseEntity;

public interface UserService {

	// 가입
	void singup(HttpServletRequest request, HttpServletResponse response);
  ResponseEntity<Map<String, Object>> checkEmail(Map<String, Object> params);
  ResponseEntity<Map<String, Object>> sendCode(Map<String, Object> params);
	// 로그인 및 로그아웃
	void singin(HttpServletRequest request, HttpServletResponse response);
	void singout(HttpServletRequest request, HttpServletResponse response);

}
