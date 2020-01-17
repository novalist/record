package com.nova.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

/**
 * @author hzhang1
 * @date 2020-01-17
 */
@Configuration
public class MyWebMvcConfigurerAdapter extends WebMvcConfigurerAdapter {

  @Value("${web.upload-path}")
  private String path;

  @Value("${web.path}")
  private String virtualPath;

  /**
   * 配置静态访问资源
   * @param registry
   */
  @Override
  public void addResourceHandlers(ResourceHandlerRegistry registry) {
    registry.addResourceHandler("/"+ virtualPath +"/**").addResourceLocations("file:" + path +"/");
    super.addResourceHandlers(registry);
  }
}
