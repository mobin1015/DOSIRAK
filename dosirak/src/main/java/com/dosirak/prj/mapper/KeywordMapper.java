package com.dosirak.prj.mapper;

import java.util.List;
import java.util.Map;

import com.dosirak.prj.dto.BlogDetailDto;

public interface KeywordMapper {
  int getKeywordCount();
  List<BlogDetailDto> getKeywordList(Map<String, Object> map);
}
