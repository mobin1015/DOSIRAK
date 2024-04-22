package com.dosirak.prj.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.dosirak.prj.dto.BlogDetailDto;
import com.dosirak.prj.dto.UserDto;

@Mapper
public interface UserMapper {

  UserDto getUserByNo (int userNo);
  //블로그글 개수 조회
  int getBlogCount();
  // 댓글 개수 조회
  // int getCommentCount(int blogListNo);
  // 블로그글 목록 조회
  List<BlogDetailDto> getBlogList(Map<String, Object> map);
  // 블로그글 상세 조회
  BlogDetailDto getBlogByNo(int blogNo);
  
}