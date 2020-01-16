package com.nova.dao;

import com.nova.entity.Region;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * @author hzhang1
 * @date 2020-01-14
 */
public interface RegionDao {

  /**
   * 插入
   *
   * @param region
   * @return
   */
  int insert(Region region);

  /**
   * 更新
   *
   * @param region
   * @return
   */
  int update(Region region);

  /**
   * 查询
   *
   * @param searchCondition
   * @return
   */
  List<Region> selectByCondition(SearchCondition searchCondition);

  @Data
  @NoArgsConstructor
  @AllArgsConstructor
  class SearchCondition {
    private Integer regionId;
    private Boolean regionType;
    private Integer parentId;
    private String regionName;

    public SearchCondition(String regionName,Boolean regionType) {
      this.regionName = regionName;
      this.regionType = regionType;
    }
  }
}
