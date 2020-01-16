package com.nova.controller;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.nova.entity.Region;
import com.nova.service.RegionService;
import com.nova.service.RegionService.RegionBO;
import com.nova.util.CommonReturnPageVO;
import com.nova.util.CommonReturnVO;
import com.nova.util.ExcelUtil;
import java.io.IOException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

/**
 * @author hzhang1
 * @date 2020-01-14
 */
@RestController
@RequestMapping("/region")
public class RegionController {

  @Resource
  private RegionService regionService;

  @RequestMapping("/get/info")
  public Object getInfo(@RequestParam(value = "regionId",required = false) Integer regionId,
      @RequestParam(value = "regionType",required = false) boolean regionType,
      @RequestParam(value = "parentId",required = false) Integer parentId){
    return CommonReturnVO.suc(regionService.getRegionList(regionId,regionType,parentId));
  }

  @RequestMapping("/get/list")
  public Object getInfo(@RequestParam(value = "regionId",required = false) Integer regionId,
      @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
      @RequestParam(value = "pageSize", defaultValue = "20") Integer pageSize){

    Page<RegionBO> page = PageHelper.startPage(pageNum,pageSize);
    List<RegionBO> regionList = regionService.getRegionList(regionId);
    return CommonReturnVO.suc(CommonReturnPageVO.get(page,regionList));
  }

  @RequestMapping("/insert")
  public Object insert(@RequestBody Region region){
    return CommonReturnVO.suc(regionService.insert(region));
  }

  @RequestMapping("/update")
  public Object update(@RequestBody Region region){
    return CommonReturnVO.suc(regionService.update(region));
  }

  @RequestMapping("/delete")
  public Object delete(@RequestBody Region region){
    region.setDelete(true);
    return CommonReturnVO.suc(regionService.update(region));
  }


  @RequestMapping("/upload")
  public Object upload(@RequestParam("file") MultipartFile file) throws IOException {

    List<Region> regionList = ExcelUtil.readExcel(file.getInputStream(), Region.class, ExcelUtil.getExcelTypeEnum(file.getOriginalFilename()));
    return CommonReturnVO.suc(regionService.importRegionList(regionList));
  }
}
