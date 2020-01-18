package com.nova.controller;

import com.alibaba.excel.support.ExcelTypeEnum;
import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.nova.entity.RecordInfo;
import com.nova.service.RecordInfoService;
import com.nova.util.CommonReturnPageVO;
import com.nova.util.CommonReturnVO;
import com.nova.util.ExcelUtil;
import com.nova.util.FileUtil;
import com.nova.util.ImageUtil;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

/**
 * 资源管理
 *
 * @author hzhang1
 * @date 2020-01-14
 */
@RestController
@RequestMapping("/record_info")
public class RecordInfoController {

  @Resource
  private RecordInfoService recordInfoService;

  @Resource
  private ResourceLoader resourceLoader;

  @Value("${web.upload-path}")
  private String path;

  /**
   * 资源管理查询
   *
   * @param regionId 区域id
   * @param districtId 街道id
   * @param key 关键字
   * @return 列表
   */
  @RequestMapping("/get/info")
  public Object getInfo(@RequestParam(value = "regionId", required = false) Integer regionId,
      @RequestParam(value = "districtId", required = false) Integer districtId,
      @RequestParam(value = "key", required = false) String key,
      @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
      @RequestParam(value = "pageSize", defaultValue = "20") Integer pageSize) {

    Page<RecordInfo> page = PageHelper.startPage(pageNum,pageSize);
    List<RecordInfo> recordInfoList = recordInfoService
        .getRecordInfoList(regionId, districtId, key);
    return CommonReturnVO.suc(CommonReturnPageVO.get(page,recordInfoList));
  }

  /**
   * 新建资源
   *
   * @param recordInfo 资源对象
   * @return 影响行数
   */
  @RequestMapping("/insert")
  public Object insert(@RequestBody RecordInfo recordInfo){
    return CommonReturnVO.suc(recordInfoService.insert(recordInfo));
  }

  /**
   * 更新资源
   *
   * @param recordInfo 资源对象
   * @return 影响行数
   */
  @RequestMapping("/update")
  public Object update(@RequestBody RecordInfo recordInfo){
    return CommonReturnVO.suc(recordInfoService.update(recordInfo));
  }

  /**
   * 删除资源
   *
   * @param id 资源主键id
   * @return 影响行数
   */
  @RequestMapping("/delete")
  public Object delete(@RequestParam(value = "id") Integer id){

    RecordInfo recordInfo = recordInfoService.selectById(id);
    recordInfo.setDelete(true);
    return recordInfoService.update(recordInfo);
  }

  /**
   * 导入文件
   *
   * @param file 文件
   * @return 影响行数
   * @throws IOException
   */
  @RequestMapping("/upload")
  public Object upload(@RequestParam("file") MultipartFile file) throws IOException {

    List<RecordInfo> recordInfoList = ExcelUtil.readAllSheetExcel(file.getInputStream(),RecordInfo.class);
    //List<RecordInfo> recordInfoList = ExcelUtil.readExcel(file.getInputStream(), RecordInfo.class, ExcelUtil.getExcelTypeEnum(file.getOriginalFilename()));
    return CommonReturnVO.suc(recordInfoService.importRecordInfoList(recordInfoList));
  }

  /**
   * 照片上传
   *
   * @param file 文件
   * @return 文件名
   * @throws IOException
   */
  @RequestMapping("/photo/upload")
  public Object uploadPhoto(@RequestParam("file") MultipartFile file,
      @RequestParam(value = "id") Integer id) throws IOException {

    String localPath = path;
    String msg = "";

    String fileName = id + "_" +file.getOriginalFilename();
    if (ImageUtil.upload(file, localPath, fileName)){
      msg = "上传成功！";

      RecordInfo recordInfo = recordInfoService.selectById(id);
      recordInfo.setPhotos(StringUtils.hasText(recordInfo.getPhotos()) ? recordInfo.getPhotos() + "," +fileName : fileName );
      recordInfoService.update(recordInfo);
    }else {
      msg = "上传失败！";
    }

    return CommonReturnVO.suc(fileName , msg);
  }

  /**
   * 删除照片
   *
   * @param id 主键id
   * @param photoName 照片名称
   * @return 影响行数
   */
  @RequestMapping("/photo/delete")
  public Object deletePhoto(@RequestParam(value = "id") Integer id,
      @RequestParam(value = "photoName") String photoName){

    return CommonReturnVO.suc(recordInfoService.deletePhoto(id,photoName));
  }

  /**
   * 照片展示
   *
   * @param fileName
   * @return
   */
  @RequestMapping("show")
  public ResponseEntity showPhotos(String fileName){

    try {
      // 由于是读取本机的文件，file是一定要加上的， path是在application配置文件中的路径
      return ResponseEntity.ok(resourceLoader.getResource("file:" + path + fileName));
    } catch (Exception e) {
      return ResponseEntity.notFound().build();
    }
  }

  /**
   * 照片路径
   *
   * @return
   */
  @RequestMapping("photo/path/get")
  public Object showPhotos(){
    return CommonReturnVO.suc(path,"success");
  }

  /**
   * 导出
   *
   * @param regionId
   * @param districtId
   * @param key
   * @param response
   * @throws IOException
   */
  @RequestMapping("/export")
  public void export(@RequestParam(value = "regionId",required = false) Integer regionId,
      @RequestParam(value = "districtId",required = false) Integer districtId,
      @RequestParam(value = "key",required = false) String key,
      HttpServletResponse response) throws IOException {

    List<RecordInfo> recordInfoList = recordInfoService
        .getRecordInfoList(regionId, districtId, key);

    String fileName = "资源管理";

    List<List<RecordInfo>> list = new ArrayList<>();
    List<String> sheetNameList = new ArrayList<>();
    List classList = new ArrayList<>();
    Map<Integer,List<RecordInfo>> recordInfoMap = new HashMap<>(8);
    for(RecordInfo recordInfo : recordInfoList){

      List<RecordInfo> recordInfos = null;
      if(recordInfoMap.containsKey(recordInfo.getRegionId())){
        recordInfos = recordInfoMap.get(recordInfo.getRegionId());
      }else {
        recordInfos = new ArrayList<>();
      }
      recordInfos.add(recordInfo);
      recordInfoMap.put(recordInfo.getRegionId(),recordInfos);
    }

    for(Integer recordId : recordInfoMap.keySet()){
      list.add(recordInfoMap.get(recordId));
      sheetNameList.add(recordInfoMap.get(recordId).get(0).getRegionName());
      classList.add(RecordInfo.class);
    }

    String path = ExcelUtil
        .writeExcelWithSheet(fileName, list, sheetNameList,
            classList, ExcelTypeEnum.XLSX);
    FileUtil.download(fileName + ExcelTypeEnum.XLSX.getValue(), path, new File(path), response);

  }


}
