package com.nova.controller;

import com.nova.service.RegionService;
import com.nova.util.CommonReturnVO;
import javax.annotation.Resource;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

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
  public Object getInfo(@RequestParam(value = "regionId",required = false) Integer regionId){
    return CommonReturnVO.suc(regionService.getRegionList(regionId));
  }

}
