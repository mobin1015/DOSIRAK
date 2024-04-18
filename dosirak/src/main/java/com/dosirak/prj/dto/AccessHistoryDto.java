package com.dosirak.prj.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class AccessHistoryDto {
<<<<<<< HEAD
	private int accessHistoryNo;
	private String email, ip, userAgent, sessionId, signinDt;
=======
  private int accessHistoryNo;
  private String email, ip, userAgent, sessionId, signinDt;
>>>>>>> f7224d81fcaa7dddfd8d5015f5f22f2dc1feacf2
}
