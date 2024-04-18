package com.dosirak.prj.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.dosirak.prj.dto.UserDto;

@Mapper
public interface UserMapper {
	int insertUser(UserDto user);
	UserDto getUserByMap(Map<String, Object> map);
}