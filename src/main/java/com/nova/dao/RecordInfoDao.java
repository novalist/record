package com.nova.dao;

import com.nova.entity.RecordInfo;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

/**
 * @author hzhang1
 * @date 2020-01-14
 */
@Mapper
public interface RecordInfoDao {

  /**
   * 新建
   *
   * @param recordInfo
   * @return
   */
  int insert(RecordInfo recordInfo);

  /**
   * 更新
   *
   * @param recordInfo
   * @return
   */
  int update(RecordInfo recordInfo);

  /**
   * 按id查找
   *
   * @param id
   * @return
   */
  RecordInfo selectById(@Param("id") Integer id);

  /**
   * 查询
   *
   * @param searchCondition 条件
   * @return 列表
   */
  List<RecordInfo> selectByCondition(SearchCondition searchCondition);

  @Data
  @NoArgsConstructor
  @AllArgsConstructor
  class SearchCondition {

    private Integer regionId;

    private Integer districtId;

    private String key;

    private String status;
  }
}
