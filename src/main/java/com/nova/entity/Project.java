package com.nova.entity;

import com.alibaba.excel.annotation.ExcelProperty;
import com.alibaba.excel.metadata.BaseRowModel;
import java.util.Date;
import lombok.Data;

/**
 * @author hzhang1
 * @date 2020-01-16
 */
@Data
public class Project extends BaseRowModel {

  private Integer id;

  @ExcelProperty(value = "名称")
  private String companyName;

  @ExcelProperty(value = "联系人")
  private String connectName;

  @ExcelProperty(value = "号码")
  private String connectPhone;

  @ExcelProperty(value = "状态")
  private String status;

  @ExcelProperty(value = "意向区域")
  private String area;

  @ExcelProperty(value = "项目内容")
  private String content;

  @ExcelProperty(value = "跟进")
  private String detail;

  private Integer userId;

  @ExcelProperty(value = "负责人")
  private String name;

  private Boolean delete;

  private Date createdTime;

  private Date lastUpdatedTime;

  public enum STATUS{

    WELL("优质"),
    NORMAL("一般"),
    STOP("暂缓"),
    SUCCESS("成功");

    /**
     * 说明
     */
    private String desc;
    STATUS(String desc){
      this.desc = desc;
    }

    public String getDesc() {
      return desc;
    }
  }
}
