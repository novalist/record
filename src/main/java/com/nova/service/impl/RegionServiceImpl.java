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
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;
import org.springframework.util.CollectionUtils;

/**
 * 区域管理 Impl
 *
 * @author hzhang1
 * @date 2020-01-14
 */
@Service
public class RegionServiceImpl implements RegionService {

  @Resource
  private RegionDao regionDao;

  @Override
  public List<Region> getRegionList(Integer regionId) {

    List<Region> regionList = regionDao.selectByCondition(new SearchCondition(null, null, regionId,null));
    List<Region> regionBOList = new ArrayList<>(regionList.size());
    List<Region> regions = regionList.stream().filter(region -> region.getRegionType().equals(0))
        .collect(Collectors.toList());

    Map<Integer,List<Region>> regionMap = new HashMap<>(regions.size());
    for(Region region : regionList){

      if(region.getRegionType() == 0) continue;

      List<Region> tempRegionList = null;
      if(regionMap.containsKey(region.getParentId())){
        tempRegionList = regionMap.get(region.getParentId());
        tempRegionList.add(region);
      }else {
        tempRegionList = new ArrayList<>();
        tempRegionList.add(region);
      }
      regionMap.put(region.getParentId(), tempRegionList);
    }

    regions.forEach(
        region -> {
          Region regionBO = new Region();
          BeanUtils.copyProperties(region,regionBO);
          regionBO.setDistrictList(regionMap.get(region.getRegionId()));
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
  @Transactional(rollbackFor = Exception.class)
  public int importRegionList(List<Region> regionList) {

    int count = 0;
    for(Region region : regionList){

      Assert.notNull(region.getRegionName(),"区域为空");
      if(region.getRegionName().equalsIgnoreCase(region.getDistrictName())){
        region.setRegionType(0);
      }else {

        Assert.notNull(region.getDistrictName(),"街道为空");

        SearchCondition searchCondition = new SearchCondition();
        searchCondition.setRegionName(region.getRegionName());
        searchCondition.setRegionType(false);
        List<Region> regionList1 = regionDao
            .selectByCondition(searchCondition);

        Integer regionId = null;
        if(CollectionUtils.isEmpty(regionList1)) {
          region.setRegionName(region.getRegionName());
          region.setRegionType(0);
          regionId = insert(region);
        }else {
          regionId = regionList1.get(0).getRegionId();
        }

        region.setRegionId(null);
        region.setRegionName(region.getDistrictName());
        region.setRegionType(1);
        region.setParentId(regionId);
      }

      insert(region);
      count += 1;
    }
    return count;
  }

  @Override
  @Transactional(rollbackFor = Exception.class)
  public int insert(Region region) {

    Assert.notNull(region,"内容为空");
    Assert.notNull(region.getRegionName(),"名称为空");
    if(region.getParentId() == null) {
      region.setParentId(0);
    }
    region.setDelete(false);

    int regionId = regionDao.insert(region);
    if(region.getRegionType() == 0) {
      region.setParentId(regionId);
      update(region);
    }
    return region.getRegionId() == null ? 0 : region.getRegionId();
  }

  @Override
  @Transactional(rollbackFor = Exception.class)
  public int update(Region region) {
    return regionDao.update(region);
  }
}
