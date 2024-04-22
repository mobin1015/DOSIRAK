package com.dosirak.prj.service;

import java.io.File;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.dosirak.prj.dto.BlogDetailDto;
import com.dosirak.prj.dto.ImageDto;
import com.dosirak.prj.dto.UserDto;
import com.dosirak.prj.mapper.BlogDetailMapper;
import com.dosirak.prj.utils.MyFileUtils;
import com.dosirak.prj.utils.MyPageUtils;

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
    String title = request.getParameter("title");
    String contents = request.getParameter("contents");
    int keywordNo = Integer.parseInt(request.getParameter("keyword"));
    String keywordName = request.getParameter("keywordName");
    int userNo = Integer.parseInt(request.getParameter("userNo"));
    
    // count 변수
    int insertBlogDetailCount = 0;
    int insertImageCount = 0;
    
    switch(keywordNo) {
    case 1:
      keywordName = "TRAVEL";
      break;
    case 2:
      keywordName = "WEBTOON";
      break;
    case 3:
      keywordName = "IT";
      break;
    case 4:
      keywordName = "PHOTO";
      break;
    case 5:
      keywordName = "MOVIE";
      break;      
    case 6:
      keywordName = "BOOK";
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
    
    // BlogDetail 삽입 
    insertBlogDetailCount = blogDetailMapper.insertBlogDetail(blog);
    
    Document document = Jsoup.parse(contents);
    Elements elements = document.getElementsByTag("img");
    int elementCount = elements.size();

    if(elements != null) {
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
    
    return (insertBlogDetailCount == 1 && insertImageCount == elementCount)? true: false;
    
  }
  
  @Override
  public ResponseEntity<Map<String, Object>> getSearchBlogList(HttpServletRequest request) {
    // TODO Auto-generated method stub
    return null;
  }
  
  @Override
  public List<BlogDetailDto> getKeywordNo(int keywordNo) {
    return blogDetailMapper.getKeywordNo(keywordNo);
  }
  
  @Override
  public int getCommentCount(int blogListNo) {
    return blogDetailMapper.getCommentCount(blogListNo);
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
                                   , "end", myPageUtils.getEnd());
    
    return Map.of("keywordList", blogDetailMapper.getKeywordList(map)
                , "paging", myPageUtils.getTotalPage());
  }
  
  
  
}
