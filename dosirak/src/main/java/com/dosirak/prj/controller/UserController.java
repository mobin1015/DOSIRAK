package com.dosirak.prj.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.dosirak.prj.mapper.UserMapper;
import com.dosirak.prj.service.UserService;

@RequestMapping("/user")
@Controller
public class UserController {

	private final UserService userService;
	
	public UserController(UserService userService) {
		super();
		this.userService = userService;
	}
	
	@GetMapping("/signup.page")
	public String signupPage() {
		return "user/signup";
	}
	
	@PostMapping(value="/checkEmail.do", produces="application/json")
	public ResponseEntity<Map<String, Object>> checkEmail(@RequestBody Map<String, Object> params) {
		return userService.checkEmail(params);
	}
	
	@PostMapping(value="/sendCode.do", produces="qpplication/json" )
	public ResponseEntity<Map<String, Object>> sendCode(@RequestBody Map<String, Object> params) {
		return userService.sendCode(params);
	}
	
	@PostMapping("/signup.do")
	public void signup(HttpServletRequest request, HttpServletResponse response) {
		userService.singup(request, response);
	}
	
}
