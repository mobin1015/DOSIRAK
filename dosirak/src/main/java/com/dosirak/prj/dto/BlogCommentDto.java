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
public class BlogCommentDto {
	private int commentNo, blogListNo, state, depth, groupNo;
	private String contents;
	private Date createDt;
	private UserDto user;
}
