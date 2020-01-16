package com.nova.controller;

import com.alibaba.excel.support.ExcelTypeEnum;
import com.nova.entity.RecordInfo;
import com.nova.service.RecordInfoService;
import com.nova.util.CommonReturnVO;
import com.nova.util.ExcelUtil;
import com.nova.util.FileUtil;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Objects;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

/**
 * @author hzhang1
 * @date 2020-01-14
 */
@RestController
@RequestMapping("/record_info")
public class RecordInfoController {

  @Resource
  private RecordInfoService recordInfoService;

  @RequestMapping("/get/info")
  public Object getInfo(@RequestParam(value = "regionId",required = false) Integer regionId,
                        @RequestParam(value = "districtId",required = false) Integer districtId,
                        @RequestParam(value = "key",required = false) String key) {
    return CommonReturnVO.suc(recordInfoService.getRecordInfoList(regionId,districtId,key));
  }

  @RequestMapping("/insert")
  public Object insert(@RequestBody RecordInfo recordInfo){
    return recordInfoService.insert(recordInfo);
  }

  @RequestMapping("/update")
  public Object update(@RequestBody RecordInfo recordInfo){
    return recordInfoService.update(recordInfo);
  }

  @RequestMapping("/delete")
  public Object delete(@RequestBody RecordInfo recordInfo){
    recordInfo.setDelete(true);
    return recordInfoService.update(recordInfo);
  }

  @RequestMapping("/upload")
  public Object upload(@RequestParam("file") MultipartFile file) throws IOException {

    List<RecordInfo> recordInfoList = ExcelUtil.readExcel(file.getInputStream(), RecordInfo.class, ExcelUtil.getExcelTypeEnum(file.getOriginalFilename()));
    recordInfoService.importRecordInfoList(recordInfoList);
    return CommonReturnVO.suc();
  }

  @RequestMapping("/img/upload")
  public Object uploadImg(@RequestParam("uploadFile") CommonsMultipartFile file){
    return null;
  }

  @RequestMapping("/export")
  public void export(@RequestParam(value = "regionId",required = false) Integer regionId,
      @RequestParam(value = "districtId",required = false) Integer districtId,
      @RequestParam(value = "key",required = false) String key,
      HttpServletRequest request, HttpServletResponse response) throws IOException {

    List<RecordInfo> recordInfoList = recordInfoService
        .getRecordInfoList(regionId, districtId, key);

    String path = Objects.requireNonNull(Thread.currentThread().getContextClassLoader().getResource(""))
        .getPath() + "static/upload/";
    String fileName = "test";

    // 全部字段导出
    ExcelUtil.writeExcelWithModel(path + fileName + ExcelTypeEnum.XLSX.getValue(), recordInfoList ,ExcelTypeEnum.XLSX, RecordInfo.class);
    FileUtil.download(fileName + ExcelTypeEnum.XLSX.getValue(), path + fileName + ExcelTypeEnum.XLSX.getValue(), new File(path + fileName + ExcelTypeEnum.XLSX.getValue()), response);

  }


}
