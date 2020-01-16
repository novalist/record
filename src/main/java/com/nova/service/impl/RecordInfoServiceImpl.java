package com.nova.service.impl;

import com.nova.dao.RecordInfoDao;
import com.nova.dao.RecordInfoDao.SearchCondition;
import com.nova.dao.RegionDao;
import com.nova.entity.RecordInfo;
import com.nova.entity.Region;
import com.nova.service.RecordInfoService;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;
import org.springframework.util.CollectionUtils;

/**
 * 资源管理
 *
 * @author hzhang1
 * @date 2020-01-14
 */
@Service
public class RecordInfoServiceImpl implements RecordInfoService {

  @Resource
  private RecordInfoDao recordInfoDao;

  @Resource
  private RegionDao regionDao;

  @Override
  public RecordInfo selectById(Integer id) {
    return recordInfoDao.selectById(id);
  }

  @Override
  public List<RecordInfo> getRecordInfoList(Integer regionId , Integer districtId , String key) {
    return recordInfoDao.selectByCondition(new SearchCondition(regionId,districtId,key));
  }

  @Override
  public int importRecordInfoList(List<RecordInfo> recordInfoList) {

    int count = 0;
    for(RecordInfo recordInfo : recordInfoList){
      count += insert(recordInfo);
    }
    return count;
  }

  @Override
  public int insert(RecordInfo recordInfo) {

    Assert.notNull(recordInfo,"资源内容为空");
    Assert.notNull(recordInfo.getRegionName(),"街道为空");
    List<Region> regionList = regionDao.selectByCondition(new RegionDao.SearchCondition(recordInfo.getRegionName(),true));
    Assert.isTrue(!CollectionUtils.isEmpty(regionList),"没有对应街道");

    Region region = regionList.get(0);
    recordInfo.setDistrictId(region.getRegionId());
    recordInfo.setRegionId(region.getParentId());
    return recordInfoDao.insert(recordInfo);
  }

  @Override
  public int update(RecordInfo recordInfo) {
    return recordInfoDao.update(recordInfo);
  }


}
