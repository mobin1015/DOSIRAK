package com.dosirak.prj.dto;

import java.sql.Date;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class UserDto {
  private int userNo, signupKind;
  private String email, pw, name, gender, mobile, blogContents, blogImgPath, nickname;
  private Date pwModifyDt, signupDt;
}

