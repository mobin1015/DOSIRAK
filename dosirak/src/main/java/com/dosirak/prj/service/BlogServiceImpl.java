package com.dosirak.prj.service;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.dosirak.prj.dto.BlogCommentDto;
import com.dosirak.prj.dto.BlogDetailDto;
import com.dosirak.prj.dto.ImageDto;
import com.dosirak.prj.dto.UserDto;
import com.dosirak.prj.mapper.BlogDetailMapper;
import com.dosirak.prj.utils.MyFileUtils;
import com.dosirak.prj.utils.MyPageUtils;
import com.dosirak.prj.utils.MySecurityUtils;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class BlogServiceImpl implements BlogService {
  private final BlogDetailMapper blogDetailMapper;
  private final MyFileUtils myFileUtils;
  private final MyPageUtils myPageUtils;
  
  @Override
  public ResponseEntity<Map<String, Object>> summernoteImageUpload(MultipartFile multipartFile) {
    
    // 이미지 저장할 경로 생성
    String uploadPath = myFileUtils.getUploadPath();
    File dir = new File(uploadPath);
    if(!dir.exists()) {
      dir.mkdirs();
    }
    
    // 이미지 저장할 이름 생성
    String filesystemName = myFileUtils.getFilesystemName(multipartFile.getOriginalFilename());
    
    // 이미지 저장
    File file = new File(dir, filesystemName);
    try {
      multipartFile.transferTo(file);
    } catch (Exception e) {
      e.printStackTrace();
    }
    
    
    // 이미지가 저장된 경로를 Map 으로 반환
    return new ResponseEntity<>(Map.of("src", uploadPath + "/" + filesystemName)
                              , HttpStatus.OK);
    
  }
  
  @Override
  public boolean registerBlog(HttpServletRequest request) {
    
    // 요청 파라미터
    String title = MySecurityUtils.getPreventXss(request.getParameter("title"));
    String contents = MySecurityUtils.getPreventXss(request.getParameter("contents"));
    int keywordNo = Integer.parseInt(request.getParameter("keyword"));
    String keywordName = null;
    int userNo = Integer.parseInt(request.getParameter("userNo"));
    int hasThumbnail = 0;
    
    // count 변수
    int insertBlogDetailCount = 0;
    int insertImageCount = 0;
    
    switch(keywordNo) {
    case 1:
      keywordName = "지구한바퀴 세계여행";
      break;
    case 2:
      keywordName = "그림·웹툰";
      break;
    case 3:
      keywordName = "IT 트렌드";
      break;
    case 4:
      keywordName = "사진·촬영";
      break;
    case 5:
      keywordName = "취향저격 영화 리뷰";
      break;      
    case 6:
      keywordName = "오늘은 이런 책";
      break;      
    }
    
    
    // UserDto + BlogDetailDto 객체 생성
    UserDto user = UserDto.builder()
                    .userNo(userNo)
                    .build();
    
    BlogDetailDto blog = BlogDetailDto.builder()
                          .title(title)
                          .contents(contents)
                          .user(user)
                          .keywordNo(keywordNo)
                          .keywordName(keywordName)
                         .build();
    
    Document document = Jsoup.parse(contents);
    Elements elements = document.getElementsByTag("img");
    int elementCount = elements.size();

    if(elements != null) {
      if(elementCount == 0) {
        blog.setHasThumbnail(hasThumbnail);
        insertBlogDetailCount = blogDetailMapper.insertBlogDetail(blog);
        
      } else {
        hasThumbnail = 1;
        blog.setHasThumbnail(hasThumbnail);
        insertBlogDetailCount = blogDetailMapper.insertBlogDetail(blog);
        // BlogDetail 삽입 
        for(Element element : elements) {
          String src = element.attr("src");
          String filesystemName = src.substring(src.lastIndexOf("/") + 1);
          String uploadPath = myFileUtils.getUploadPath();
          /* src 정보를 DB에 저장하는 코드 등이 이 곳에 있으면 된다. */
          /* editor 상에서 삭제했을 때 upload 폴더에 있는 사진과 비교해서 없는 파일은 upload 폴더에서 삭제하기*/
          /* boolean값, myapp의 uploadServiceImpl register 참고*/
          ImageDto image = ImageDto.builder()
              .filesystemName(filesystemName)
              .uploadPath(uploadPath)
              .build();
          insertImageCount += blogDetailMapper.insertImages(image);
        }
      }
      
    } 

    return (insertBlogDetailCount == 1 && insertImageCount == elementCount)? true: false;
    
  }
  
  @Override
  public ResponseEntity<Map<String, Object>> getSearchBlogList(HttpServletRequest request) {
    String type = request.getParameter("type");
    String query = MySecurityUtils.getPreventXss(request.getParameter("query"));
    int page = Integer.parseInt(request.getParameter("page"));
    ResponseEntity<Map<String, Object>> result = null;
    
    int totalBlog = 0;
    int display = 10;
    
    
    Map<String, Object> map = new HashMap<String, Object>();
    
    if(type.equals("writer")) {
      totalBlog = blogDetailMapper.getBlogListCountByWriter(query);
      myPageUtils.setPaging(totalBlog, display, page);
      map.put("begin", myPageUtils.getBegin());
      map.put("end", myPageUtils.getEnd());
      map.put("query", query);
      result = new ResponseEntity<>(Map.of("blogList" , blogDetailMapper.getBlogDetailListByWriter(map)
                                         , "totalPage", myPageUtils.getTotalPage()
                                         , "totalBlog", totalBlog
                                         , "type", type
                                         , "query", query)
          , HttpStatus.OK);
    } else if(type.equals("contents")){
      totalBlog = blogDetailMapper.getBlogListCountByContents(query);
      myPageUtils.setPaging(totalBlog, display, page);
      map.put("begin", myPageUtils.getBegin());
      map.put("end", myPageUtils.getEnd());
      map.put("query", query);
      result =  new ResponseEntity<>(Map.of("blogList" , blogDetailMapper.getBlogDetailListByContents(map)
                                          , "totalPage", myPageUtils.getTotalPage()
                                          , "totalBlog", totalBlog
                                          , "type", type
                                          , "query", query)
          , HttpStatus.OK);
    }
   
    return result;
  }
  
  @Override
  public List<BlogDetailDto> getKeywordNo(int keywordNo) {
    return blogDetailMapper.getKeywordNo(keywordNo);
  }
  
  @Override
  public Map<String, Object> getKeywordList(HttpServletRequest request) {
    
    int keywordNo = Integer.parseInt(request.getParameter("keywordNo"));
    int page = Integer.parseInt(request.getParameter("page"));
    int total = blogDetailMapper.getKeywordCount(keywordNo);
    int display = 10;    
    
    
    myPageUtils.setPaging(total, display, page);
    
    Map<String, Object> map = Map.of("keywordNo", keywordNo
                                   , "begin", myPageUtils.getBegin()
                                   , "end", myPageUtils.getEnd()
                                   , "total", total);   
    
    return Map.of("keywordList", blogDetailMapper.getKeywordList(map)
                , "totalPage", myPageUtils.getTotalPage());
    
  }
  
  
  @Override
  public BlogDetailDto getBlogDetailByNo(int blogListNo) {
    return blogDetailMapper.getBlogDetailByNo(blogListNo);
  }
  
  @Override
  public String getBlogDetailTime(int blogListNo) throws JsonProcessingException {
    ObjectMapper mapper = new ObjectMapper();
    BlogDetailDto blog = blogDetailMapper.getBlogDetailByNo(blogListNo);
    blog.setContents(null);
    return mapper.writeValueAsString(blog);
  }

  @Override
  public ResponseEntity<Map<String, Object>> getCommentList(int blogListNo) {
    List<BlogCommentDto> a =blogDetailMapper.getCommentList(blogListNo);
    Map<String, Object> map = Map.of("blogListNo", blogListNo
        , "commentCount",a.size());    
    blogDetailMapper.updateCommentCount(map);
    return new ResponseEntity<>(Map.of("commentList", a)
        , HttpStatus.OK);
  }

@Override
  public int registerComment(HttpServletRequest request) {
    
    // 요청 파라미터
    String contents = request.getParameter("contents");
    int blogListNo = Integer.parseInt(request.getParameter("blogListNo"));
    int userNo = Integer.parseInt(request.getParameter("userNo"));
    
    // UserDto 객체 생성
    UserDto user = new UserDto();
    user.setUserNo(userNo);
    
    // CommentDto 객체 생성
    BlogCommentDto comment = BlogCommentDto.builder()
                            .contents(contents)
                            .user(user)
                            .blogListNo(blogListNo)
                          .build();
    
    // DB 에 저장 & 결과 반환
    return blogDetailMapper.insertComment(comment);
    
  }
  
  @Override
  public int registerReply(HttpServletRequest request) {
    // 요청 파라미터
    String contents = request.getParameter("contents");
    int groupNo = Integer.parseInt(request.getParameter("groupNo"));
    int blogListNo = Integer.parseInt(request.getParameter("blogListNo"));
    int userNo = Integer.parseInt(request.getParameter("userNo"));
    
    // UserDto 객체 생성
    UserDto user = new UserDto();
    user.setUserNo(userNo);
    
    // CommentDto 객체 생성
    BlogCommentDto reply = BlogCommentDto.builder()
                          .contents(contents)
                          .groupNo(groupNo)
                          .blogListNo(blogListNo)
                          .user(user)
                        .build();
    
    // DB 에 저장하고 결과 반환
    return blogDetailMapper.insertReply(reply);
  }
  
  @Override
  public int removeComment(int commentNo) {
    return blogDetailMapper.deleteComment(commentNo);
  }
 

  @Override
  public ResponseEntity<Map<String, Object>> getLikeList(int blogListNo) {
    return new ResponseEntity<>(Map.of("LikeList", blogDetailMapper.getLike(blogListNo))
        , HttpStatus.OK);
  }
  
  @Override
  public int insertLike(HttpServletRequest request) {
    Map<String, Object> map = Map.of("blogListNo",request.getParameter("blogListNo")
       , "userNo" , request.getParameter("userNo") );
    return blogDetailMapper.insertLike(map);
  }

  @Override
  public int deleteLike(HttpServletRequest request) {
    Map<String, Object> map = Map.of("blogListNo",request.getParameter("blogListNo")
        , "userNo" , request.getParameter("userNo") );
    return blogDetailMapper.deleteLike(map);
  }
  
  @Override
  public int modifyBlog(HttpServletRequest request) {
    
    // 수정할 제목/내용/블로그번호
    String title = request.getParameter("title");
    String contents = request.getParameter("contents");
    int blogListNo = Integer.parseInt(request.getParameter("blogListNo"));
    
    // DB에 저장된 기존 이미지 가져오기
    // 1. blogImageDtoList : BlogImageDto를 요소로 가지고 있음
    // 2. blogImageList    : 이미지 이름(filesystemName)을 요소로 가지고 있음
    List<ImageDto> blogImageDtoList = blogDetailMapper.getBlogImageList(blogListNo);
    List<String> blogImageList = blogImageDtoList.stream()
                                  .map(blogImageDto -> blogImageDto.getFilesystemName())
                                  .collect(Collectors.toList());
        
    // Editor에 포함된 이미지 이름(filesystemName)
    List<String> editorImageList = getEditorImageList(contents);

    // Editor에 포함되어 있으나 DB에 없는 이미지는 BLOG_IMAGE_T에 추가해야 함
    editorImageList.stream()
      .filter(editorImage -> !blogImageList.contains(editorImage))         // 조건 : Editor에 포함되어 있으나 기존 이미지에 포함되어 있지 않다.
      .map(editorImage -> ImageDto.builder()                           // 변환 : Editor에 포함된 이미지 이름을 BlogImageDto로 변환한다.
                            .blogListNo(blogListNo)
                            .uploadPath(myFileUtils.getUploadPath())
                            .filesystemName(editorImage)
                            .build())
      .forEach(blogImageDto -> blogDetailMapper.insertImages(blogImageDto));  // 순회 : 변환된 BlogImageDto를 BLOG_IMAGE_T에 추가한다.
    
    // 블로그를 만들 때는 있었는데 수정할 때는 없는 이미지들 삭제 (수정하면서 지운 이미지들)
    List<ImageDto> removeList = blogImageDtoList.stream()
                                      .filter(blogImageDto -> !editorImageList.contains(blogImageDto.getFilesystemName()))  // 조건 : 기존 이미지 중에서 Editor에 포함되어 있지 않다.
                                      .collect(Collectors.toList());                                                        // 조건을 만족하는 blogImageDto를 리스트로 반환한다.

    for(ImageDto ImageDto : removeList) {
      // BLOG_IMAGE_T 테이블에서 삭제
      blogDetailMapper.deleteBlogImage(ImageDto.getFilesystemName());  // 파일명이 일치하면 삭제(파일명은 UUID로 만들어졌으므로 파일명의 중복은 없다고 생각하면 된다.)
      // 이미지 파일 삭제
      File file = new File(ImageDto.getUploadPath(), ImageDto.getFilesystemName());
      if(file.exists()) {
        file.delete();
      }
    }
    
    // 수정할 제목/내용/블로그번호를 가진 BlogDto
    BlogDetailDto blog = BlogDetailDto.builder()
                    .title(title)
                    .contents(contents)
                    .blogListNo(blogListNo)
                    .build();
    
    // BLOG_T 수정
    int modifyResult = blogDetailMapper.updateBlog(blog);
    
    return modifyResult;
    
  }
 


  @Override
  public int removeBlog(int blogListNo) {
    // BLOG_IMAGE_T 테이블에서 블로그 만들 때 사용한 이미지 파일 삭제
    List<ImageDto> blogImageDtoList = blogDetailMapper.getBlogImageList(blogListNo);
    for(ImageDto blogImage : blogImageDtoList) {
      File file = new File(blogImage.getUploadPath(), blogImage.getFilesystemName());
      if(file.exists()) {
        file.delete();
      }
    }
    // BLOG_IMAGE_T 삭제
    blogDetailMapper.deleteBlogImageList(blogListNo);
    
    // BLOG_T 삭제
    return blogDetailMapper.deleteBlog(blogListNo);
  }
  
  
  public List<String> getEditorImageList(String contents) {
    
    // Summernote Editor에 추가한 이미지 목록 반환하기 (Jsoup 라이브러리 사용)
    
    List<String> editorImageList = new ArrayList<>();
    
    Document document = Jsoup.parse(contents);
    Elements elements =  document.getElementsByTag("img");
    
    if(elements != null) {
      for(Element element : elements) {
        String src = element.attr("src");
        String filesystemName = src.substring(src.lastIndexOf("/") + 1);
        editorImageList.add(filesystemName);
      }
    }
    
    return editorImageList;
    
  }

  
  

  
  
  @Override
  public ResponseEntity<Map<String, Object>> getBlogList(HttpServletRequest request) {
        
    Map<String, Object> map = new HashMap<>();
    List<BlogDetailDto> blogList = blogDetailMapper.getBlogList(map);
    map.put("blogList", blogList);   
        
    return new ResponseEntity<>(map, HttpStatus.OK);
  }
  
  @Override
  public ResponseEntity<Map<String, Object>> getNowBlogList(HttpServletRequest request) {
    
    String order = request.getParameter("order");
    int page = Integer.parseInt(request.getParameter("page"));
    
    int totalBlog = blogDetailMapper.getBlogCount();
    int display = 10;
    
    myPageUtils.setPaging(totalBlog, display, page);
    
    Map<String, Object> map = Map.of("begin", myPageUtils.getBegin() , "end", myPageUtils.getEnd(), "order", order);

    return new ResponseEntity<>(Map.of("blogList" , blogDetailMapper.getBlogDetailListByDesc(map)
        , "totalPage", myPageUtils.getTotalPage()), HttpStatus.OK);
  }
}
