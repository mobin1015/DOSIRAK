package com.dosirak.prj.service;

import java.io.File;
import java.io.IOException;

import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

import com.dosirak.prj.dto.UserDto;
import com.dosirak.prj.mapper.UserMapper;
import com.dosirak.prj.utils.MyFileUtils;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

  private final UserMapper userMapper;
  private final MyFileUtils myFileUtils;
  
  
  //★★★ 불러오기
  /*
  @Override
  public UserDto getUserByNo(int userNo) {
    return userMapper.getUserByNo(userNo);

  }
  */
  
  @Override
  public void loadUserByNo(int userNo, Model model) {
    model.addAttribute("user", userMapper.loadUserByNo(userNo));
  }
   
  //★★★ 수정하기
  @Override
  public int modifyProfile(int userNo, String nickname, String blogContents, MultipartFile blogImgPath) {
      // 파일 업로드 처리
      if (blogImgPath != null && !blogImgPath.isEmpty()) {
          String uploadPath = myFileUtils.getUploadPath();
          File dir = new File(uploadPath);
          if (!dir.exists()) {
              dir.mkdirs();
          }
          String filesystemName = myFileUtils.getFilesystemName(blogImgPath.getOriginalFilename());
          File file = new File(dir, filesystemName);
          try {
              blogImgPath.transferTo(file);
          } catch (IOException e) {
              e.printStackTrace();
          }

          // 파일 경로 설정
          String blogImgPathString = uploadPath + "/" + filesystemName;

          // UserDto 객체 생성
          UserDto profile = UserDto.builder()
                  .userNo(userNo)
                  .blogContents(blogContents)
                  .nickname(nickname)
                  .blogImgPath(blogImgPathString)
                  .build();

          // 사용자 정보 업데이트
          int modifyResult = userMapper.updateProfile(profile);
          return modifyResult;
      } else {
          // 파일이 없을 경우에 대한 처리
          return -1; // 예를 들어 에러 코드로 -1을 반환하거나 다른 처리를 할 수 있습니다.
      }
  }
  
}
