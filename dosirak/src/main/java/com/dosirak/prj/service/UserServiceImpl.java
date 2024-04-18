package com.dosirak.prj.service;

import org.springframework.stereotype.Service;

import com.dosirak.prj.mapper.UserMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

  private final UserMapper userMapper;
  
}
