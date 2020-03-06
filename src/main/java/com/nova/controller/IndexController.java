package com.nova.controller;

import javax.servlet.http.HttpServletRequest;
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
  String index(HttpServletRequest request) {
    Object loginUser = request.getSession().getAttribute("loginUser");
    request.setAttribute("user",loginUser);
    return "index";
  }

}
