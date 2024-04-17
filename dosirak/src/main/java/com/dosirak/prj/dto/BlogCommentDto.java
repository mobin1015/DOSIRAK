package com.dosirak.prj.dto;

import java.sql.Date;

public class BlogCommentDto {
	private int commentNo, blogListNo, state, depth, groupNo;
	private String contents;
	private Date createDt;
	private UserDto user;
}
