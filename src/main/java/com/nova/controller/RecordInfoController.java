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
import java.util.List;
import java.util.Objects;
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
   *
   * @param regionId
   * @param districtId
   * @param key
   * @return
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
   * 新建
   *
   * @param recordInfo
   * @return
   */
  @RequestMapping("/insert")
  public Object insert(@RequestBody RecordInfo recordInfo){
    return CommonReturnVO.suc(recordInfoService.insert(recordInfo));
  }

  /**
   * 更新
   *
   * @param recordInfo
   * @return
   */
  @RequestMapping("/update")
  public Object update(@RequestBody RecordInfo recordInfo){
    return recordInfoService.update(recordInfo);
  }

  /**
   * 删除
   *
   * @param recordInfo
   * @return
   */
  @RequestMapping("/delete")
  public Object delete(@RequestBody RecordInfo recordInfo){
    recordInfo.setDelete(true);
    return recordInfoService.update(recordInfo);
  }

  /**
   * 导入文件
   *
   * @param file
   * @return
   * @throws IOException
   */
  @RequestMapping("/upload")
  public Object upload(@RequestParam("file") MultipartFile file) throws IOException {

    List<RecordInfo> recordInfoList = ExcelUtil.readExcel(file.getInputStream(), RecordInfo.class, ExcelUtil.getExcelTypeEnum(file.getOriginalFilename()));
    return CommonReturnVO.suc(recordInfoService.importRecordInfoList(recordInfoList));
  }

  /**
   * 照片上传
   *
   * @param file
   * @return
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
   * @param request
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

    String path = Objects.requireNonNull(Thread.currentThread().getContextClassLoader().getResource(""))
        .getPath() + "static/upload/";
    String fileName = "资源管理";

    // 全部字段导出
    ExcelUtil.writeExcelWithModel(path + fileName + ExcelTypeEnum.XLSX.getValue(), recordInfoList ,ExcelTypeEnum.XLSX, RecordInfo.class);
    FileUtil.download(fileName + ExcelTypeEnum.XLSX.getValue(), path + fileName + ExcelTypeEnum.XLSX.getValue(), new File(path + fileName + ExcelTypeEnum.XLSX.getValue()), response);

  }


}
