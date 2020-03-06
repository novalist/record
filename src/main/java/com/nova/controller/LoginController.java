package com.nova.controller;

import com.nova.dao.ProjectDao;
import com.nova.entity.User;
import com.nova.util.CommonReturnVO;
import java.util.List;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.util.Assert;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
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
  @RequestMapping(value = "login")
  @ResponseBody
  public Object login(@RequestBody User user1,HttpServletRequest request,HttpSession session){

    Assert.notNull(user1.getName(),"用户名为空");
    List<User> users = projectDao.selectUser(user1.getName());

    if (!CollectionUtils.isEmpty(users)){
      User user = users.get(0);
      if(!user.getPassword().equalsIgnoreCase(user1.getPassword())){
        return CommonReturnVO.fail("密码错误");
      }
      session.setAttribute("loginUser",user);
      session.setMaxInactiveInterval(500);
      return CommonReturnVO.suc();
    }else {
      request.setAttribute("msg","用户名或密码错误");
      return CommonReturnVO.fail("用户名或密码错误");
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
