package com.nova;

import javax.servlet.MultipartConfigElement;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.MultipartConfigFactory;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;

/**
 * 启动类
 *
 * @author hzhang1
 */
@SpringBootApplication
@ComponentScan("com.nova.*")
@MapperScan("com.nova.dao")
@ServletComponentScan
public class RecordApplication extends SpringBootServletInitializer {

	public static void main(String[] args) {
		SpringApplication.run(RecordApplication.class, args);
	}

	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
		return application.sources(RecordApplication.class);
	}


	@Bean
	public MultipartConfigElement multipartConfigElement() {
		MultipartConfigFactory factory = new MultipartConfigFactory();
		//  单个数据大小
		factory.setMaxFileSize("4000KB");
		/// 总上传数据大小
		factory.setMaxRequestSize("40000KB");
		return factory.createMultipartConfig();
	}

}
