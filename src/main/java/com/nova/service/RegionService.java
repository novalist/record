package com.nova.service;

import com.nova.entity.Region;
import java.util.List;
import lombok.Data;

/**
 * 区域
 *
 * @author hzhang1
 * @date 2020-01-14
 */
public interface RegionService {

  List<Region> getRegionList(Integer regionId);

  List<Region> getRegionList(Integer regionId,boolean regionType,Integer parentId);

  int importRegionList(List<Region> regionList);

  int insert(Region region);

  int update(Region region);

}
