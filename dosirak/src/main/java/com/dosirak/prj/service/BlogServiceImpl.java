package com.dosirak.prj.service;

import java.io.File;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.dosirak.prj.utils.MyFileUtils;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class BlogServiceImpl implements BlogService {

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
}
