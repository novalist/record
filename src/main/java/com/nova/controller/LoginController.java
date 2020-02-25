package com.nova.controller;

import com.nova.dao.ProjectDao;
import com.nova.entity.User;
import java.util.List;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

/**
 * @author hzhang1
 * @date 2020-02-24
 * @description 登陆
 * @Version 1.0
 */
@Controller
@RequestMapping("/admin")
public class LoginController{

  @Resource
  ProjectDao projectDao;

  @GetMapping("login")
  public ModelAndView loginView() {
    return new ModelAndView("admin/login");
  }

  //登陆
  @PostMapping(value = "login")
  public String login(@RequestParam("username") String username,
      @RequestParam("password") String password, HttpServletRequest request,HttpSession session){

    Assert.notNull(username,"用户名为空");
    List<User> users = projectDao.selectUser(username);

    if (!CollectionUtils.isEmpty(users)){
      User user = users.get(0);
      session.setAttribute("loginUser",user);
      session.setMaxInactiveInterval(10);
      return "record_info";
    }else {
      request.setAttribute("msg","用户名或密码错误");
      return "admin/login";
    }

  }

  //退出
  @RequestMapping("/logout")
  public String  logout(HttpServletRequest request){
    //移除session
    request.getSession().invalidate();
    return "redirect:/admin/login";
  }
}
