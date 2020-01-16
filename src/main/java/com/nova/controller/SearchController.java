package com.nova.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 搜索控制层
 *
 * @author hzhang1
 * @date 2020-01-14
 */
@Controller
@RequestMapping("/search")
public class SearchController {

  @RequestMapping("/record_info")
  String info() {
    return "record_info";
  }

  @RequestMapping("/region")
  String region() {
    return "region";
  }

  @RequestMapping("/project")
  String project() {
    return "project";
  }

  @RequestMapping("/get/region")
  String getRegion() {
    return "Hello Spring Boot";
  }


}
