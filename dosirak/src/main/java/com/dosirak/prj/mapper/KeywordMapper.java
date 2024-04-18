package com.dosirak.prj.mapper;

import java.util.List;
import java.util.Map;

import com.dosirak.prj.dto.KeywordDto;

public interface KeywordMapper {
  List<KeywordDto> getKeywordList(Map<String, Object> map);
}
