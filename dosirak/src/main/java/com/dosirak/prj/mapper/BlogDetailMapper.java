package com.dosirak.prj.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.dosirak.prj.dto.BlogDetailDto;
import com.dosirak.prj.dto.ImageDto;


@Mapper
public interface BlogDetailMapper {
  // 블로그글작성 
  int insertBlogDetail(BlogDetailDto blog);
  // 블로그글 안에 이미지를 image 테이블에 작성
  int insertImages(ImageDto image);
//  int getBlogCount();
//  List<BlogDetailDto> getBlogList(Map<String, Object> map); 
//  BlogDetailDto getBlogByNo(int blogNo);
//  int removeBlog(int blogNo);
  
  
  List<BlogDetailDto> getKeywordNo(int keywordNo);
  int getKeywordCount(int keywordNo);
  List<BlogDetailDto> getKeywordList(Map<String, Object> map);
  
  int updateCommentCount(int blogListNo);
  ImageDto getHasThumbnail(int imageNo);
  
  
}
