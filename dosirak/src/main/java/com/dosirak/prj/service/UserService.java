package com.dosirak.prj.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface UserService {

	// 가입
	void singup(HttpServletRequest request, HttpServletResponse response);

	// 로그인 및 로그아웃
	void singin(HttpServletRequest request, HttpServletResponse response);

	void singout(HttpServletRequest request, HttpServletResponse response);

}
