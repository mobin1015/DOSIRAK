package com.dosirak.prj.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.dosirak.practice.dto.BlogDetailDto;


@Mapper
public interface BlogDetailMapper {
  // 블로그 글
  int insertBlogDetail(BlogDetailDto blog);
//  int getBlogCount();
//  List<BlogDetailDto> getBlogList(Map<String, Object> map); 
//  BlogDetailDto getBlogByNo(int blogNo);
//  int removeBlog(int blogNo);
  
  
  
  
}
