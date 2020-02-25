package com.nova.config;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author hzhang1
 * @date 2020-02-24
 * @description ${description}
 * @Version 1.0
 */
public class LoginHanderInterceptor implements HandlerInterceptor {
  @Override
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object o) throws Exception {
    Object user = request.getSession().getAttribute( "loginUser" );
    if (user == null){
      System.out.println( "拦截" );
      request.setAttribute( "msg","没有权限，请重新登录" );
      request.getRequestDispatcher( "/admin/login" ).forward( request,response );
      return false;
    }else {
      return true;
    }

  }

  @Override
  public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {

  }

  @Override
  public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {

  }
}