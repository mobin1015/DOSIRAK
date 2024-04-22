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
<<<<<<< HEAD
}
=======
}
>>>>>>> b3f3fdca5d6d3e021026256511da89a41782e6c6
