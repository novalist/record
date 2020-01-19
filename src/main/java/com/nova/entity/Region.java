package com.nova.entity;

import com.alibaba.excel.annotation.ExcelProperty;
import com.alibaba.excel.metadata.BaseRowModel;
import java.util.List;
import lombok.Data;

/**
 * @author hzhang1
 * @date 2020-01-14
 */
@Data
public class Region extends BaseRowModel {

  /**
   * 主键id
   */
  private Integer regionId;

  /**
   * 父区域ID，如市所属省
   */
  private Integer parentId;

  /**
   * 区域名称
   */
  @ExcelProperty(value = "区域")
  private String regionName;

  /**
   * 区域类别，记录区域的等级
   */
  private Integer regionType;

  /**
   * 是否删除
   */
  private boolean delete;

  @ExcelProperty(value = "街道")
  private String districtName;

  private List<Region> districtList;
}
