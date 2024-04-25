package com.dosirak.prj.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

import com.dosirak.prj.dto.BlogDetailDto;

public interface BlogService {
  ResponseEntity<Map<String, Object>> summernoteImageUpload(MultipartFile multipartFile);
  boolean registerBlog(HttpServletRequest request);
  ResponseEntity<Map<String, Object>> getSearchBlogList(HttpServletRequest request);

  List<BlogDetailDto> getKeywordNo(int keywordNo);
  Map<String, Object> getKeywordList(HttpServletRequest request);

  BlogDetailDto  getBlogDetailByNo(int blogListNo);
  ResponseEntity<Map<String, Object>> getCommentList(int blogListNo);
  int registerComment(HttpServletRequest request);
  int registerReply(HttpServletRequest request);
  int removeComment(int commentNo);
  ResponseEntity<Map<String, Object>> getLikeList(int blogListNo);
  int insertLike(HttpServletRequest request);
  int deleteLike(HttpServletRequest request);
  int removeBlog(int blogListNo);
  int modifyBlog(HttpServletRequest request);
  
  ResponseEntity<Map<String, Object>> getBlogList(HttpServletRequest request);
}
