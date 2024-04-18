package com.dosirak.prj.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.dosirak.prj.service.KeywordService;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Controller
public class KeyWordController {

  private KeywordService keyword;
  
  @GetMapping("/blog/keyword.do")
  public String keyword(HttpServletRequest request, Model model) {
    keyword.getKeywordList(request);
    return "/blog/keyword";
  }
  
}
