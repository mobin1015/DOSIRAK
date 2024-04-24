package com.dosirak.prj.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.dosirak.prj.dto.BlogCommentDto;
import com.dosirak.prj.dto.BlogDetailDto;
import com.dosirak.prj.dto.ImageDto;
import com.dosirak.prj.dto.LikeDto;


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
  
  
//블로그 상세보기
 BlogDetailDto getBlogDetailByNo(int blogListNo);
 List<BlogCommentDto> getCommentList(int blogListNo);
 int insertComment(BlogCommentDto comment);
 int insertReply(BlogCommentDto comment);
 int deleteComment(int commentNo);
 List<LikeDto> getLike(int blogListNo);
 int insertLike(Map<String, Object> map);
 int deleteLike(Map<String, Object> map);
 List<ImageDto> getBlogImageList(int blogListNo);
 int deleteBlogImage(String filesystemName);
 int updateBlog(BlogDetailDto blog);
 int deleteBlog(int blogListNo);
 int deleteBlogImageList(int blogListNo);
  
}
