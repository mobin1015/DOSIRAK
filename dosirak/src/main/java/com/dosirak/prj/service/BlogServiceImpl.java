package com.dosirak.prj.service;

import java.io.File;
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
import com.dosirak.prj.dto.UserDto;
import com.dosirak.prj.mapper.BlogDetailMapper;
import com.dosirak.prj.utils.MyFileUtils;


import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class BlogServiceImpl implements BlogService {

  private final BlogDetailMapper blogDetailMapper;
  private final MyFileUtils myFileUtils;
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
  public int registerBlog(HttpServletRequest request) {
    
    // 요청 파라미터
    String title = request.getParameter("title");
    String contents = request.getParameter("contents");
    int keywordNo = Integer.parseInt(request.getParameter("keyword"));
    //int blogNo = Integer.parseInt(request.getParameter("blogNo"));
    int userNo = Integer.parseInt(request.getParameter("userNo"));
    
    
    // UserDto + BlogDetailDto 객체 생성
    UserDto user = UserDto.builder()
                    .userNo(userNo)
                    .build();
    
    BlogDetailDto blog = BlogDetailDto.builder()
                          .title(title)
                          .contents(contents)
                          .user(user)
                          .keywordNo(keywordNo)
                         .build();
    Document document = Jsoup.parse(contents);
    Elements elements = document.getElementsByTag("img");
    if(elements != null) {
      for(Element element : elements) {
        String src = element.attr("src");
        /* src 정보를 DB에 저장하는 코드 등이 이 곳에 있으면 된다. */
        /* editor 상에서 삭제했을 때 upload 폴더에 있는 사진과 비교해서 없는 파일은 upload 폴더에서 삭제하기*/
        System.out.println(src);
      }
    }
    
    // DB에 blog 저장
    return blogDetailMapper.insertBlogDetail(blog);  
    
  }
}