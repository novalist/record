package com.nova.entity;

import lombok.Data;

/**
 * @author hzhang1
 * @date 2020-02-18
 * @description 负责人
 * @Version 1.0
 */
@Data
public class User {

  private Integer id;

  private String name;

  private String password;

  private boolean is_delete;

}
