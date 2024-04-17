package com.dosirak.prj.service;

import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;

import com.dosirak.prj.dto.UserDto;
import com.dosirak.prj.mapper.UserMapper;
import com.dosirak.prj.utils.MySecurityUtils;

@Service
public class UserServiceImpl implements UserService {

	private final UserMapper userMapper;

	@Override
	public void singup(HttpServletRequest request, HttpServletResponse response) {

		// 전달된 파라미터
		String email = request.getParameter("email");
		String pw = MySecurityUtils.getSha256(request.getParameter("pw"));
		String name = MySecurityUtils.getPreventXss(request.getParameter("name"));
		String gender = request.getParameter("gender");
		String mobile = request.getParameter("mobile");
		String event = request.getParameter("event");

		// Mapper 로 보낼 UserDto 객체 생성
		UserDto user = UserDto.builder()
											.email(email)
											.pw(pw)
											.name(name)
											.gender(gender)
											.mobile(mobile)
										  .eventAgree(event == null ? 0 : 1)
									 .build();
		
		// 회원 가입
		int insertCount = userMapper.insertUser(user);
		
		// 응답 만들기 (성공하면 sign in 처리하고 /main.do 이동, 실패하면 뒤로 가기)
		try {
			
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			out.print("<script>");
			
			// 가입 성공
			if(insertCount == 1) {
				
				// Sign In 및 접속 기록을 위한 Map
				Map<String, Object>
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void singin(HttpServletRequest request, HttpServletResponse response) {
		// TODO Auto-generated method stub

	}

	@Override
	public void singout(HttpServletRequest request, HttpServletResponse response) {
		// TODO Auto-generated method stub

	}

}
