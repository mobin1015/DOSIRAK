package com.dosirak.prj.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

@Service
public class KeywordServiceImpl implements KeywordService {
  @Override
  public ResponseEntity<Map<String, Object>> getKeywordList(HttpServletRequest request) {
    // TODO Auto-generated method stub
    return null;
  }
}
