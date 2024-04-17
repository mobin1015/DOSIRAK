package com.dosirak.prj.interceptor;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

public class RequiredSigninInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

		HttpSession session = request.getSession();
		if (session.getAttribute("user") == null) {
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("if(confirm('Sign In 이 필요한 기능입니다. Sign In 할까요?')){");
			out.println("  location.href='" + request.getContextPath() + "/user/signin.page';");
			out.println("} else {");
			out.println("  history.back();");
			out.println("}");
			out.println("</script>");
			out.flush();
			out.close();
			return false;
		}

		return true;

	}

}
