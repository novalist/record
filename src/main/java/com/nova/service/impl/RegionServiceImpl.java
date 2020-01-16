package com.nova.service.impl;

import com.nova.dao.RegionDao;
import com.nova.dao.RegionDao.SearchCondition;
import com.nova.entity.Region;
import com.nova.service.RegionService;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

/**
 * @author hzhang1
 * @date 2020-01-14
 */
@Service
public class RegionServiceImpl implements RegionService {

  @Resource
  private RegionDao regionDao;

  @Override
  public List<Region> getRegionList(Integer regionId,boolean regionType,Integer parentId) {
    return regionDao.selectByCondition(new SearchCondition(regionId,regionType,parentId));
  }

  @Override
  public int insert(Region region) {
    return regionDao.insert(region);
  }

  @Override
  public int update(Region region) {
    return regionDao.update(region);
  }
}
