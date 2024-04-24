package com.dosirak.prj.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.math.BigInteger;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.SecureRandom;
import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.dosirak.prj.dto.BlogDetailDto;
import com.dosirak.prj.dto.UserDto;
import com.dosirak.prj.mapper.UserMapper;
import com.dosirak.prj.utils.MyFileUtils;
import com.dosirak.prj.utils.MyJavaMailUtils;
import com.dosirak.prj.utils.MyPageUtils;
import com.dosirak.prj.utils.MySecurityUtils;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

  private final UserMapper userMapper;
  private final MyFileUtils myFileUtils;
  private final MyPageUtils myPageUtils;
  
  @Override
  public UserDto getUserByNo(int userNo) {
    System.out.println(userMapper.getUserByNo(userNo));
    return userMapper.getUserByNo(userNo);
  }
  
  @Override
  public int getblogCount(int userNo) {
    return userMapper.getBlogCount(userNo);
  }
  
  @Override
  public ResponseEntity<Map<String, Object>> getMypageBlogList(HttpServletRequest request) {
    
    // 전체 블로그 개수 + 스크롤 이벤트마다 가져갈 목록의 개수 + 현재 페이지 번호
    int userNo = Integer.parseInt(request.getParameter("userNo"));
    int total = userMapper.getBlogCount(userNo);
    int display = 10;
    
    Optional<String> opt = Optional.ofNullable(request.getParameter("page"));
    int page = Integer.parseInt(opt.orElse("1"));
    
    //int blogListNo = Integer.parseInt(request.getParameter("blogListNo"));

    // 페이징 처리 
    myPageUtils.setPaging(total, display, page);

    // 목록 가져올 때 전달 할 Map 생성
    Map<String, Object> map = Map.of("userNo", userNo
                                    , "begin", myPageUtils.getBegin()
                                    , "end", myPageUtils.getEnd());
    
    // 목록 화면으로 반환할 값 (목록 + 전체 페이지 수)
    return new ResponseEntity<>(Map.of("blogList", userMapper.getBlogList(map)
        , "paging", myPageUtils.getAsyncPaging()
        , "blogCount", total)
        , HttpStatus.OK) ;
    
 }
  
  @Override
  public BlogDetailDto getBlogByNo(int blogListNo) {
    return userMapper.getBlogByNo(blogListNo);
  }
  
  private final MyJavaMailUtils myJavaMailUtils;

	@Override
	public ResponseEntity<Map<String, Object>> checkEmail(Map<String, Object> params) {
		boolean enableEmail = userMapper.getUserByMap(params) == null
				 && userMapper.getLeaveUserByMap(params) == null;	
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
	public void signup(HttpServletRequest request, HttpServletResponse response) {

		// 전달된 파라미터
		String email = request.getParameter("email");
		String pw = MySecurityUtils.getSha256(request.getParameter("pw"));
		String name = MySecurityUtils.getPreventXss(request.getParameter("name"));
		String gender = request.getParameter("gender");
		String mobile = request.getParameter("mobile");

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
	public void leave(HttpServletRequest request, HttpServletResponse response) {
		
		try {
			
			// 세션에 저장된 user 값 확인
			HttpSession session = request.getSession();
			UserDto user = (UserDto) session.getAttribute("user");
			
			// 세션 만료로 user 정보가 세션에 없을 수 있음
		  if(user == null) {
		  	response.sendRedirect(request.getContextPath() + "/main.page");
		  }
		  		  
		  // 탈퇴 처리
		  int deleteCount = userMapper.deleteUser(user.getUserNo());
		  
		  // 탈퇴 이후 응답 만들기
		  response.setContentType("text/html");
		  PrintWriter out = response.getWriter();
		  out.println("<script>");
		  
		  // 탈퇴 성공
		  if(deleteCount == 1) {
		  	
		  	// 세션에 저장된 모든 정보 초기화
		  	session.invalidate();		// SessionStatus 객체의 setComplete() 메소드 호출
		  	
		  	out.println("alert('탈퇴되었습니다. 이용해 주셔서 감사합니다.');");
		  	out.println("location.href='" + request.getContextPath() + "/main.page';");
		  	
		  } else {
		  	// 탈퇴 실패
		  	out.println("alert('탈퇴되지 않았습니다.');");
		  	out.println("history.back();");
		  }
		  out.println("</script>");
		  
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	
	@Override
	public String getRedirectURLAfterLogin(HttpServletRequest request) {
		
		// Log In 페이지 이전의 주소가 저장되어 있는 Request Header 의 referer 값 확인
		String referer = request.getHeader("referer");
		
		// referer 로 돌아가면 안 되는 예외 상황 (아이디/비밀번호 찿기 화면, 가입 화면 등)
		String[] excludeURLs = {"/findId.page", "/findPw.page", "/signup.page", "/upload/edit.do"};
		
		// Sign In 이후 이동할 url
		String url = referer;
		if(referer != null) {
			for(String excludeURL : excludeURLs) {
				if(referer.contains(excludeURL)) {
					url = request.getContextPath() + "/main.page";
					break;
				}
			}
		} else {
			url = request.getContextPath() + "/main.page";
		}
		
		return url;
	}

	@Override
	public void login(HttpServletRequest request, HttpServletResponse response) {
		
		
		
		try {
			
		
		// 입력한 아이디
		String email = request.getParameter("email");
		
		// 입력한 비밀번호 + SHA-256 방식의 암호화
		String pw = MySecurityUtils.getSha256(request.getParameter("pw"));
		
		// 접속 IP (접속 기록을 남길 때 필요한 정보)
		String ip = request.getRemoteAddr();
		
		// 접속 수단 (요청 헤더의 User-Agent 값)
		String userAgent = request.getHeader("User-Agent");
		
		// DB로 보낼 정보 (email/pw: USER_T , email/ip/userAgent/sessionId: ACCESS_HISTORY_T)
		Map<String, Object> params = Map.of("email", email
																			, "pw", pw
																			, "ip", ip
																			, "userAgent", userAgent
																			, "sessionId", request.getSession().getId());
		
		// email/pw 가 일치하는 회원 정보 가져오기
		UserDto user = userMapper.getUserByMap(params);
		
		// 일치하는 회원 있음 (LogIn 성공)
		if(user != null) {
			
			
			
			// 접속 기록 ACCESS_HISTORY_T 에 남기기
		  // userMapper.insertAccessHistory(params);
			
			// 회원 정보를 세션(브라우저 닫기 전까지 정보가 유지되는 공간, 기본 30분 정보 유지)에 보관하기
			HttpSession session = request.getSession();
			session.setAttribute("user", user);
			session.setMaxInactiveInterval(60 * 60);		// 세션 유지 시간 60분 설정
			
			// Sign In 후 페이지 이동
			response.sendRedirect(request.getParameter("url"));
		
		} else {
			// 일치하는 회원 없음 (Login In 실패)
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('일치하는 회원이 없습니다.');");
			out.println("location.href='" + request.getContextPath() + "/main.page';");
			out.println("</script>");
			out.flush();
			out.close();
		}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	

	@Override
	public void logout(HttpServletRequest request, HttpServletResponse response) {
		
		try {
			
		
		// Log Out 기록 남기기
		HttpSession session = request.getSession();
		String sessionId = session.getId();
		userMapper.updateAccessHistory(sessionId);
		
		//세션에 저장된 모든 정보 초기화
		session.invalidate();
		
		//메인 페이지로 이동 
		response.sendRedirect(request.getContextPath() + "/main.page");
		
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	@Override
	public String getNaverLoginURL(HttpServletRequest request) {

		// 네이버 로그인 1
		// 네이버 로그인 요청 주소를 만들어서 반환하는 메소드
		String redirectUri = "http://localhost:8080" + request.getContextPath() + "/user/naver/getAccessToken.do";
		String state = new BigInteger(130, new SecureRandom()).toString();
		
		StringBuilder builder = new StringBuilder();
		builder.append("https://nid.naver.com/oauth2.0/authorize");
		builder.append("?response_type=code");
		builder.append("&client_id=NSIlxRD3gSk0BEHeKhk4");
		builder.append("&redirect_uri=" + redirectUri);
		builder.append("&state=" + state);
		
		return builder.toString();
	}
	
	@Override
	public String getNaverLoginAccessToken(HttpServletRequest request) {
		
		// 네이버 로그인2
		// 네이버 로그인 1단계에서 전달한 redirect_uri 에서 동작하는 서비스
		// code 와 state 파라미터를 받아서 Access Token 을 발급 받을 때 사용
		
		String code = request.getParameter("code");
		String state = request.getParameter("state");
		
		String spec = "https://nid.naver.com/oauth2.0/token";
		String grantType = "authorization_code";
		String clientId = "NSIlxRD3gSk0BEHeKhk4";
		String clientSecret = "qBkPHuLERa";
		
		StringBuilder builder = new StringBuilder();
		builder.append(spec);
		builder.append("?grant_type=" + grantType);
		builder.append("&client_id=" + clientId);
		builder.append("&client_secret=" + clientSecret);
		builder.append("&code=" + code);
		builder.append("&state=" + state);
		
		HttpURLConnection con = null;
		JSONObject obj = null;
		
		try {
			
		
		// 요청
		URL url = new URL(builder.toString());
		con = (HttpURLConnection) url.openConnection();
		con.setRequestMethod("GET"); // 반드시 대문자로 작성해야 한다.
		
		// 응답 스트림 생성
		BufferedReader reader = null;
		int responseCode = con.getResponseCode();
		if(responseCode == HttpURLConnection.HTTP_OK) {
			reader = new BufferedReader(new InputStreamReader(con.getInputStream()));
		} else {
			reader = new BufferedReader(new InputStreamReader(con.getErrorStream()));
		}
		
		// 응답 데이터 받기
		String line = null;
		StringBuilder responsBody = new StringBuilder();
		while((line = reader.readLine()) != null) {
			responsBody.append(line);
		}
		
		// 응답 데이터를 JSON 객체로 변환하기
		obj = new JSONObject(responsBody.toString());
		
		// 응답 스트림 닫기
		reader.close();
		} catch (Exception e) {	
			e.printStackTrace();
		}
		
		con.disconnect();
		
		return obj.getString("access_token");
		
	}
	
	@Override
	public UserDto getNaverLoginProfile(String accessToken) {
		
		// 네이버 로그인 3
		// 네이버로부터 프로필 정보(이메일, [이름, 성별, 휴대전화번호]) 을 발급 받아 반환하는 메소드
		
	  String spec = "https://openapi.naver.com/v1/nid/me";
	  
	  HttpURLConnection con = null;
	  UserDto user = null;
	  
	  try {
			
	  	// 요청
	  	URL url = new URL(spec);
	  	con = (HttpURLConnection) url.openConnection();
	  	con.setRequestMethod("GET");
	  	
	  	// 요청 헤더
	  	con.setRequestProperty("Authorization", "Bearer " + accessToken);
	  	
	  	// 응답 스트림 생성
	  	BufferedReader reader = null;
	  	int responseCode = con.getResponseCode();
	  	if(responseCode == HttpURLConnection.HTTP_OK) {
	  		reader = new BufferedReader(new InputStreamReader(con.getInputStream()));
	  	} else {
	  		reader = new BufferedReader(new InputStreamReader(con.getErrorStream()));
	  	}
	  	
	  	// 응답 데이터 받기
	  	String line = null;
	  	StringBuilder responsBody = new StringBuilder();
	  	while((line = reader.readLine()) != null) {
	  		responsBody.append(line);
	  	}
	  	
	  	// 응답 데이터를 JSON 객체로 변환하기
	  	JSONObject obj = new JSONObject(responsBody.toString());
	  	JSONObject response = obj.getJSONObject("response");
	  	user = UserDto.builder()
	  						.email(response.getString("email"))
	  						.gender(response.has("gender") ? response.getString("gender") : null)
	  						.name(response.has("name") ? response.getString("name") : null)
	  						.mobile(response.has("mobile") ? response.getString("mobile") : null)
	  					.build();
	  	
	  	// 응답 스트림 닫기
	  	reader.close(); 
		} catch (Exception e) {
			e.printStackTrace();
		}
	  
	  con.disconnect();
	  
		return user;
	}
	
	@Override
	public boolean hasUser(UserDto user) {
		return userMapper.getLeaveUserByMap(Map.of("email", user.getEmail())) != null;
	}
	
	@Override
	public void naverLogin(HttpServletRequest request, UserDto naverUser) {

		Map<String, Object> map = Map.of("email", naverUser.getEmail(), 
																		 "ip", request.getRemoteAddr());
		
		UserDto user = userMapper.getUserByMap(map);
		request.getSession().setAttribute("user", user);
		userMapper.insertAccessHistory(map);
				
	}

}
