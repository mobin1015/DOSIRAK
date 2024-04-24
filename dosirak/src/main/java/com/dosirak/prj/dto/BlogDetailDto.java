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
public class BlogDetailDto {
  private int blogListNo, keywordNo, hasThumbnail,commentCount;
  private String title, contents, keywordName;
  private Date createDt, modifyDt;
  private UserDto user;
}
