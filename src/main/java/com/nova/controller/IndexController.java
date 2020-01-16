package com.nova.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 首页
 *
 * @author hzhang1
 * @date 2020-01-14
 */
@Controller
public class IndexController {

  @RequestMapping("/")
  String index() {
    return "index";
  }

}
