package com.dosirak.prj.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class BlogInfoDto {
  private int blogNo;
  private String blogContents, blogImgPath;
  private UserDto user;
}
