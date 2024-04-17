package com.dosirak.prj.dto;

<<<<<<< HEAD
=======
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
>>>>>>> b0f40525dbe12758582f07a2dad4706798596aee
public class BlogInfoDto {
	private int blogNo;
	private String blogContents, blogImgPath;
	private UserDto user;
}
