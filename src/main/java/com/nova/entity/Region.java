package com.nova.entity;

import lombok.Data;

/**
 * @author hzhang1
 * @date 2020-01-14
 */
@Data
public class Region {

  /**
   * 主键id
   */
  private Short regionId;

  /**
   * 父区域ID，如市所属省
   */
  private Short parentId;

  /**
   * 区域名称
   */
  private String regionName;

  /**
   * 区域类别，记录区域的等级
   */
  private Byte regionType;

  /**
   * 是否删除
   */
  private boolean delete;
}
