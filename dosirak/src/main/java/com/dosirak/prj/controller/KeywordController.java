package com.dosirak.prj.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.dosirak.prj.service.KeywordService;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Controller
public class KeywordController {

  private KeywordService keyword;
  
  @GetMapping("/blog/keyword.page")
  public String keywordPage() {
    return "blog/keyword";
  }
  
  @GetMapping(value="/blog/keyword.do", produces="application/json")
  public ResponseEntity<Map<String, Object>> getKeywordList(HttpServletRequest request) {
    return keyword.getKeywordList(request);
  }
  
  
}
