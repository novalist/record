package com.nova.service;

import com.nova.entity.RecordInfo;
import java.util.List;

/**
 * 记录
 *
 * @author hzhang1
 * @date 2020-01-14
 */
public interface RecordInfoService {

  /**
   * 获得记录信息列表
   *
   * @param regionId
   * @param districtId
   * @param key
   * @return
   */
  List<RecordInfo> getRecordInfoList(Integer regionId , Integer districtId , String key);

  /**
   *
   * @param recordInfo
   * @return
   */
  int insert(RecordInfo recordInfo);

  /**
   *
   * @param recordInfo
   * @return
   */
  int update(RecordInfo recordInfo);
}
