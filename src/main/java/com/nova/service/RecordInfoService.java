package com.nova.service;

import com.nova.entity.RecordInfo;
import java.util.List;

/**
 * 资源管理
 *
 * @author hzhang1
 * @date 2020-01-14
 */
public interface RecordInfoService {

  /**
   * 根据主键id查找资源
   *
   * @param id 主键
   * @param isForUpdate 是否加锁
   * @return 资源对象
   */
  RecordInfo selectById(Integer id,boolean isForUpdate);

  /**
   * 获得资源信息列表
   *
   * @param regionId 区域id
   * @param districtId 街道id
   * @param key 关键字
   * @return 结果
   */
  List<RecordInfo> getRecordInfoList(Integer regionId , Integer districtId , String key);

  /**
   * 导入文件
   *
   * @param recordInfoList 资源列表
   * @return 影响行数
   */
  int importRecordInfoList(List<RecordInfo> recordInfoList);


  /**
   * 新建资源
   *
   * @param recordInfo 资源
   * @return 影响行数
   */
  int insert(RecordInfo recordInfo);

  /**
   * 更新资源
   *
   * @param recordInfo 资源
   * @return 影响行数
   */
  int update(RecordInfo recordInfo);

  /**
   * 删除图片
   *
   * @param photoName 图片名称
   * @return 影响行数
   */
  int deletePhoto(Integer id , String photoName);
}
