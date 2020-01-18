package com.nova.service.impl;

import com.nova.dao.RecordInfoDao;
import com.nova.dao.RecordInfoDao.SearchCondition;
import com.nova.dao.RegionDao;
import com.nova.entity.RecordInfo;
import com.nova.entity.Region;
import com.nova.service.RecordInfoService;
import java.util.Date;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
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

  private final String SPLIT_SEPARATE = ",";

  @Resource
  private RecordInfoDao recordInfoDao;

  @Resource
  private RegionDao regionDao;

  @Override
  public RecordInfo selectById(Integer id) {
    RecordInfo recordInfo = recordInfoDao.selectById(id);
    Assert.notNull(recordInfo,"找不到对应资源记录");
    return recordInfo;
  }

  @Override
  public List<RecordInfo> getRecordInfoList(Integer regionId , Integer districtId , String key) {
    return recordInfoDao.selectByCondition(new SearchCondition(regionId,districtId,key));
  }

  @Override
  @Transactional(rollbackFor = Exception.class)
  public int importRecordInfoList(List<RecordInfo> recordInfoList) {

    int count = 0;
    for(RecordInfo recordInfo : recordInfoList){
      count += insert(recordInfo);
    }
    return count;
  }

  @Override
  @Transactional(rollbackFor = Exception.class)
  public int insert(RecordInfo recordInfo) {

    Assert.notNull(recordInfo,"资源内容为空");
    if(recordInfo.getDistrictId() == null) {
      Assert.notNull(recordInfo.getDistrictName(), "街道为空");

      RegionDao.SearchCondition searchCondition = new RegionDao.SearchCondition();
      searchCondition.setRegionName(recordInfo.getDistrictName());
      searchCondition.setRegionType(true);
      List<Region> regionList = regionDao
          .selectByCondition(searchCondition);
      Assert.isTrue(!CollectionUtils.isEmpty(regionList), "没有对应街道");

      Region region = regionList.get(0);
      recordInfo.setDistrictId(region.getRegionId());
      recordInfo.setRegionId(region.getParentId());
    }else {
      Region region = regionDao.selectById(recordInfo.getDistrictId());
      Assert.notNull(region,"街道内容为空");
      recordInfo.setRegionId(region.getParentId());
    }

    recordInfo.setCreatedTime(new Date());
    return recordInfoDao.insert(recordInfo);
  }

  @Override
  @Transactional(rollbackFor = Exception.class)
  public int update(RecordInfo recordInfo) {
    return recordInfoDao.update(recordInfo);
  }

  @Override
  public int deletePhoto(Integer id, String photoName) {
    RecordInfo recordInfo = selectById(id);

    String photos = recordInfo.getPhotos();
    photos.replace(photoName,"").replace(photoName + SPLIT_SEPARATE , "");
    recordInfo.setPhotos(photos);
    return recordInfoDao.update(recordInfo);
  }

}
