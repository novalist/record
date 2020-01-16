package com.nova.service.impl;

import com.nova.dao.RegionDao;
import com.nova.dao.RegionDao.SearchCondition;
import com.nova.entity.Region;
import com.nova.service.RegionService;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

/**
 * @author hzhang1
 * @date 2020-01-14
 */
@Service
public class RegionServiceImpl implements RegionService {

  @Resource
  private RegionDao regionDao;

  @Override
  public List<RegionBO> getRegionList(Integer regionId) {

    List<Region> regionList = regionDao.selectByCondition(new SearchCondition(regionId, null, null,null));
    List<RegionBO> regionBOList = new ArrayList<>(regionList.size());
    List<Region> regions = regionList.stream().filter(region -> region.getRegionType().equals(0))
        .collect(Collectors.toList());

    Map<Integer,List<Region>> regionMap = new HashMap<>(regions.size());
    for(Region region : regionList){

      if(region.getRegionType() == 0) continue;

      List<Region> tempRegionList = null;
      if(regionMap.containsKey(region.getRegionId())){
        tempRegionList = regionMap.get(region.getRegionId());
        tempRegionList.add(region);
      }else {
        tempRegionList = new ArrayList<>();
        tempRegionList.add(region);
      }
      regionMap.put(region.getRegionId(), tempRegionList);
    }

    regions.forEach(
        region -> {
          RegionBO regionBO = new RegionBO();

          regionBO.setRegion(region);
          regionBO.setRegionList(regionMap.get(region.getRegionId()));
          regionBOList.add(regionBO);
        }
    );

    return regionBOList;
  }

  @Override
  public List<Region> getRegionList(Integer regionId,boolean regionType,Integer parentId) {
    return regionDao.selectByCondition(new SearchCondition(regionId,regionType,parentId,null));
  }

  @Override
  public int importRegionList(List<Region> regionList) {

    int count = 0;
    for(Region region : regionList){
      count += insert(region);
    }
    return count;
  }

  @Override
  public int insert(Region region) {

    Assert.notNull(region,"内容为空");
    Assert.notNull(region.getRegionName(),"名称为空");
    return regionDao.insert(region);
  }

  @Override
  public int update(Region region) {
    return regionDao.update(region);
  }
}
