package com.nova.service.impl;

import com.nova.dao.RecordInfoDao;
import com.nova.dao.RecordInfoDao.SearchCondition;
import com.nova.entity.RecordInfo;
import com.nova.service.RecordInfoService;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

/**
 * @author hzhang1
 * @date 2020-01-14
 */
@Service
public class RecordInfoServiceImpl implements RecordInfoService {

  @Resource
  private RecordInfoDao recordInfoDao;

  @Override
  public List<RecordInfo> getRecordInfoList(Integer regionId , Integer districtId , String key) {
    return recordInfoDao.selectByCondition(new SearchCondition(regionId,districtId,key));
  }

  @Override
  public int insert(RecordInfo recordInfo) {
    return recordInfoDao.insert(recordInfo);
  }

  @Override
  public int update(RecordInfo recordInfo) {
    return recordInfoDao.update(recordInfo);
  }


}
