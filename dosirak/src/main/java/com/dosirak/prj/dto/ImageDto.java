package com.dosirak.prj.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
public class ImageDto {
	private int imageNo, blogListNo;
	private String filesystemName, uploadPath;
}
