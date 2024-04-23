package com.dosirak.prj.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.dosirak.prj.dto.UserDto;

public interface UserMapper {
  //★★★ 불러오기
  //UserDto getUserByNo(int userNo);
   UserDto loadUserByNo(int userNo);
   
 //★★★ 수정하기
   int updateProfile(UserDto user);
  
}