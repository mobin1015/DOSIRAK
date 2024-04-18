package com.dosirak.prj.dto;

import java.sql.Date;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;



@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class UserDto {
<<<<<<< HEAD
  private int userNo, signupKind;
  private String email, pw, name, gender, mobile;
  private Date pwModifyDt, signupDt;
=======
	private int userNo, signupKind;
	private String email, pw, name, gender, mobile;
	private Date pwModifyDt, signupDt;
>>>>>>> origin/sindongwoo-branch
}
