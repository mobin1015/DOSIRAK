package com.dosirak.prj.service;

import java.util.Map;
import java.util.Optional;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.dosirak.prj.dto.UserDto;
import com.dosirak.prj.mapper.UserMapper;
import com.dosirak.prj.utils.MyFileUtils;
import com.dosirak.prj.utils.MyPageUtils;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

  private final UserMapper userMapper;
  private final MyFileUtils myFileUtils;
  private final MyPageUtils myPageUtils;
  
  @Override
  public UserDto getUserByNo(int userNo) {
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
    Map<String, Object> map = Map.of("begin", myPageUtils.getBegin()
                                    , "end", myPageUtils.getEnd());
    
    // 목록 화면으로 반환할 값 (목록 + 전체 페이지 수)
    return new ResponseEntity<>(Map.of("blogList", userMapper.getBlogList(map)
        , "paging", myPageUtils.getAsyncPaging()
        , "blogCount", total)
        , HttpStatus.OK) ;
    
 }
  
  @Override
  public void loadBlogByNo(int blogListNo, Model model) {
    model.addAttribute("blog", userMapper.getBlogByNo(blogListNo));
    
  }
  
  
  
}
