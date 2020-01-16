package com.nova.entity;

import com.alibaba.excel.annotation.ExcelProperty;
import com.alibaba.excel.metadata.BaseRowModel;
import java.util.Date;
import lombok.Data;

/**
 * @author hzhang1
 * @date 2020-01-14
 */
@Data
public class RecordInfo extends BaseRowModel {

  private Integer id;

  @ExcelProperty(value = "企业")
  private String companyName;

  private Short regionId;

  @ExcelProperty(value = "区域")
  private String regionName;

  private Short districtId;

  @ExcelProperty(value = "街道")
  private String districtName;

  @ExcelProperty(value = "联系人")
  private String masterName;

  @ExcelProperty(value = "联系电话1")
  private String masterPhone;

  private String slaveName;

  @ExcelProperty(value = "联系电话2")
  private String slavePhone;

  @ExcelProperty(value = "地址")
  private String address;

  @ExcelProperty(value = "资源信息")
  private String resource;

  @ExcelProperty(value = "备注")
  private String note;

  private String photos;

  private boolean delete;

  private Date createdTime;

  private Date lastUpdatedTime;

}
