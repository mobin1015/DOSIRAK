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
	private int accessHistoryNo;
	private String email, ip, userAgent, sessionId, signinDt;
}
