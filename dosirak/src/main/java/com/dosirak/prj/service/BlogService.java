package com.dosirak.prj.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartFile;

import com.dosirak.prj.dto.BlogDetailDto;

public interface BlogService {
  ResponseEntity<Map<String, Object>> summernoteImageUpload(MultipartFile multipartFile);
  boolean registerBlog(HttpServletRequest request);
  ResponseEntity<Map<String, Object>> getSearchBlogList(HttpServletRequest request);
  
  List<BlogDetailDto> getKeywordNo(int keywordNo);
  Map<String, Object> getKeywordList(HttpServletRequest request);
}
