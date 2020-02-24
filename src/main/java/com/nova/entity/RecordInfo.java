package com.nova.entity;

import com.alibaba.excel.annotation.ExcelIgnore;
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

  @ExcelIgnore
  private Integer id;

  @ExcelProperty(value = "企业")
  private String companyName;

  @ExcelIgnore
  private Integer regionId;

  @ExcelIgnore
  private String regionName;

  @ExcelIgnore
  private Integer districtId;

  @ExcelProperty(value = "街道")
  private String districtName;

  @ExcelProperty(value = "联系人")
  private String masterName;

  @ExcelProperty(value = "联系电话1")
  private String masterPhone;

  @ExcelIgnore
  private String slaveName;

  @ExcelProperty(value = "联系电话2")
  private String slavePhone;

  @ExcelProperty(value = "地址")
  private String address;

  @ExcelProperty(value = "资源信息")
  private String resource;

  @ExcelProperty(value = "备注")
  private String note;

  @ExcelIgnore
  private String photos;

  @ExcelIgnore
  private String status;

  @ExcelIgnore
  private boolean delete;


  @ExcelIgnore
  private Date createdTime;

  @ExcelIgnore
  private Date lastUpdatedTime;

}
