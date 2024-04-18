package com.dosirak.prj.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.dosirak.prj.mapper.KeywordMapper;
import com.dosirak.prj.utils.MyPageUtils;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Service
public class KeywordServiceImpl implements KeywordService {
  
  private final KeywordMapper keywordMapper;
  private final MyPageUtils myPageUtils;
  
  @Override
  public ResponseEntity<Map<String, Object>> getKeywordList(HttpServletRequest request) {
    
    int total = keywordMapper.getKeywordCount();
    int display = 10;
    int page = Integer.parseInt(request.getParameter("page"));
    myPageUtils.setPaging(total, display, page);
    
    Map<String, Object> map = Map.of("begin", myPageUtils.getBegin()
                                     ,"end", myPageUtils.getEnd());
    
    return new ResponseEntity<>(Map.of("keywordList", keywordMapper.getKeywordList(map)
                                     , "totalPage", myPageUtils.getTotalPage())
                                     , HttpStatus.OK);
  }
}
