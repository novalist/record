package com.nova.controller;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.nova.dao.ProjectDao.SearchCondition;
import com.nova.entity.Project;
import com.nova.service.ProjectService;
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
 * @date 2020-01-16
 */
@RestController
@RequestMapping("/project")
public class ProjectController {

  @Resource
  private ProjectService projectService;

  @RequestMapping("/get/info")
  public Object getInfo(@RequestParam(value = "id", required = false) Integer id,
      @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
      @RequestParam(value = "pageSize", defaultValue = "20") Integer pageSize) {

    Page<Project> page = PageHelper.startPage(pageNum,pageSize);
    List<Project> projectList = projectService
        .selectByCondition(new SearchCondition(id));
    return CommonReturnVO.suc(CommonReturnPageVO.get(page,projectList));
  }


  /**
   * 新建
   *
   * @param project
   * @return
   */
  @RequestMapping("/insert")
  public Object insert(@RequestBody Project project){
    return CommonReturnVO.suc(projectService.insert(project));
  }

  /**
   * 更新
   *
   * @param project
   * @return
   */
  @RequestMapping("/update")
  public Object update(@RequestBody Project project){
    return projectService.update(project);
  }

  /**
   * 删除
   *
   * @param project
   * @return
   */
  @RequestMapping("/delete")
  public Object delete(@RequestBody Project project){
    project.setDelete(true);
    return projectService.update(project);
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

    List<Project> recordInfoList = ExcelUtil
        .readExcel(file.getInputStream(), Project.class, ExcelUtil.getExcelTypeEnum(file.getOriginalFilename()));
    return CommonReturnVO.suc(projectService.importProjectList(recordInfoList));
  }
}
