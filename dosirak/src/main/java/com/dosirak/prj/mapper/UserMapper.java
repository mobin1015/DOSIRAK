package com.dosirak.prj.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.dosirak.prj.dto.LeaveUserDto;
import com.dosirak.prj.dto.UserDto;



@Mapper
public interface UserMapper {
	UserDto getUserByMap(Map<String, Object> map);
	LeaveUserDto getLeaveUserByMap(Map<String, Object> map);
	int insertUser(UserDto user);
	int deleteUser(int userNo);
	int insertAccessHistory(Map<String, Object> map);
	int updateAccessHistory(String sessionId);
	
	 //SD코드
  //★★★ 불러오기
  //UserDto getUserByNo(int userNo);
   UserDto loadUserByNo(int userNo);
   UserDto getUserByNo(int userNo);
   
 //★★★ 수정하기
   int updateProfile(UserDto user);
   
   String getImgPathByUserNo(int userNo);

}