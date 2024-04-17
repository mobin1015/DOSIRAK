package com.dosirak.prj.dto;

import java.sql.Date;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

<<<<<<< HEAD
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


=======
@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
>>>>>>> b0f40525dbe12758582f07a2dad4706798596aee
public class UserDto {
	private int userNo, signupKind;
	private String email, pw, name, gender, mobile;
	private Date pwModifyDt, signupDt;
}
