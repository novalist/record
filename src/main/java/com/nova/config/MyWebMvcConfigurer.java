package com.nova.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * @author hzhang1
 * @date 2020-02-24
 * @description ${description}
 * @Version 1.0
 */
//@Configuration
public class MyWebMvcConfigurer implements WebMvcConfigurer {

  /**
   * 注册拦截器
   */
  @Override
  public void addInterceptors(InterceptorRegistry registry) {
    registry.addInterceptor(new LoginHanderInterceptor())
        .addPathPatterns("/**")
        .excludePathPatterns("/", "/index.jsp", "/admin/login", "/static/**");
  }
}