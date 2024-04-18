package com.dosirak.prj.service;

import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.dosirak.prj.dto.UserDto;
import com.dosirak.prj.mapper.UserMapper;
import com.dosirak.prj.utils.MyJavaMailUtils;
import com.dosirak.prj.utils.MySecurityUtils;

@Service
public class UserServiceImpl implements UserService {

	private final UserMapper userMapper;
	private final MyJavaMailUtils myJavaMailUtils;

	public UserServiceImpl(UserMapper userMapper, MyJavaMailUtils myJavaMailUtils) {
		super();
		this.userMapper = userMapper;
		this.myJavaMailUtils = myJavaMailUtils;
	}
	
	@Override
	public ResponseEntity<Map<String, Object>> checkEmail(Map<String, Object> params) {
		boolean enableEmail = userMapper.getUserByMap(params) == null;
		return new ResponseEntity<>(Map.of("enableEmail", enableEmail)
				, HttpStatus.OK);
	}
	
	@Override
	public ResponseEntity<Map<String, Object>> sendCode(Map<String, Object> params) {
		
		String code = MySecurityUtils.getRandomString(6, true, true);
		
		System.out.println("인증코드 : " + code);
		
		myJavaMailUtils.sendMail((String)params.get("email")
				, "브런치 가입 인증요청"
				, "<div>인증코드는 <strong>" + code + "</strong>입니다.");
		
		return new ResponseEntity<>(Map.of("code", code)
				, HttpStatus.OK);
	}
	
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
											.mobile(mobile)
											.gender(gender)
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
				Map<String, Object> params = Map.of("email", email
																					, "pw", pw
																					, "ip", request.getRemoteAddr() 
																					, "gender", request.getHeader("User-Agent")
																					, "sessionId", request.getSession().getId());
				
				// Sign In (세션에 User 저장하기) 
				request.getSession().setAttribute("user", userMapper.getUserByMap(params));
				
				// 접속 기록 남기기
				// userMapper.insertAccessHistory(params);
				
				out.println("alert('회원 가입되었습니다.');");
				out.println("location.href='" + request.getContextPath() + "/main.page';");
				
			// 가입 실패
			} else {
				out.println("alert('회원 가입되었습니다.');");
				out.println("histroy.back();");
			}
			out.println("</script>");
			out.flush();
			out.close();
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
