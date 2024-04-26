package com.dosirak.prj.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.dosirak.prj.dto.BlogDetailDto;
import com.dosirak.prj.dto.LeaveUserDto;
import com.dosirak.prj.dto.UserDto;

@Mapper
public interface UserMapper {

  UserDto getUserByNo (int userNo);
  //블로그글 개수 조회
  int getBlogCount(int userNo);
  // 블로그글 목록 조회
  List<BlogDetailDto> getBlogList(Map<String, Object> map);
  // 블로그글 상세 조회
  BlogDetailDto getBlogByNo(int blogNo);

	UserDto getUserByMap(Map<String, Object> map);
	LeaveUserDto getLeaveUserByMap(Map<String, Object> map);
	int insertUser(UserDto user);
	int deleteUser(int userNo);
	int insertAccessHistory(Map<String, Object> map);
	int updateAccessHistory(String sessionId);

	//산들Profile영역
	UserDto loadUserByNo(int userNo);
  int updateProfile(UserDto user);
  String getImgPathByUserNo(int userNo);
 // UserDto getUserByNo(int userNo);
}