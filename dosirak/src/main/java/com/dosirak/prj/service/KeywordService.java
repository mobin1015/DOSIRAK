package com.dosirak.prj.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;

public interface KeywordService {
  ResponseEntity<Map<String, Object>> getKeywordList(HttpServletRequest request);
}
