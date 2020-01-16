package com.nova.config;

import javax.sql.DataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;

/**
 *
 * @author hzhang1
 * @date 2019/2/15
 */
@ComponentScan
@Configuration
@PropertySource("classpath:application.yml")
public class DataSourceConfig {

  private Logger logger = LoggerFactory.getLogger(DataSourceConfig.class);

  /**
   * 配置Master数据源
   */
  @Bean
  @ConfigurationProperties(prefix = "spring.datasource.master")
  public DataSource getMasterDataSource() {
    logger.info("masterDataSource 数据库连接池创建中......");
    return DataSourceBuilder.create().build();
  }

  /**
   * 配置@Transactional注解事务
   *
   * @return PlatformTransactionManager
   */
  @Bean
  public PlatformTransactionManager transactionManager() {
    return new DataSourceTransactionManager(getMasterDataSource());
  }



}