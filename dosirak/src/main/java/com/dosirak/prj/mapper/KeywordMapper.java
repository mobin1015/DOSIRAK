package com.dosirak.prj.mapper;

import java.util.List;
import java.util.Map;

import com.dosirak.prj.dto.KeywordDto;

public interface KeywordMapper {
  int getKeywordCount();
  List<KeywordDto> getKeywordList(Map<String, Object> map);
}
