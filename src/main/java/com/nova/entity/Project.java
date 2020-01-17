package com.nova.entity;

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

  private String companyName;

  private String connectName;

  private String connectPhone;

  private String area;

  private String content;

  private String detail;

  private Boolean delete;

  private Date createdTime;

  private Date lastUpdatedTime;
}
