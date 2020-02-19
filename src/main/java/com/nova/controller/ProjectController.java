package com.nova.controller;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.nova.dao.ProjectDao.SearchCondition;
import com.nova.entity.Project;
import com.nova.entity.User;
import com.nova.service.ProjectService;
import com.nova.util.CommonReturnPageVO;
import com.nova.util.CommonReturnVO;
import com.nova.util.ExcelUtil;
import java.io.IOException;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

/**
 * 项目管理
 *
 * @author hzhang1
 * @date 2020-01-16
 */
@RestController
@RequestMapping("/project")
public class ProjectController {

  @Resource
  private ProjectService projectService;

  /**
   * 项目信息列表
   *
   * @param id 主键id
   * @param userId 负责人id
   * @param connectName 联系人
   * @param pageNum 当前页
   * @param pageSize 每页显示
   * @return 结果
   */
  @RequestMapping("/list")
  public Object getInfo(@RequestParam(value = "id", required = false) Integer id,
      @RequestParam(value = "userId", required = false) Integer userId,
      @RequestParam(value = "name", required = false) String name,
      @RequestParam(value = "connectPhone", required = false) String connectPhone,
      @RequestParam(value = "pageNum", defaultValue = "1") Integer pageNum,
      @RequestParam(value = "pageSize", defaultValue = "20") Integer pageSize) {

    Page<Project> page = PageHelper.startPage(pageNum,pageSize);
    List<Project> projectList = projectService
        .selectByCondition(new SearchCondition(id ,name,connectPhone,userId));
    return CommonReturnVO.suc(CommonReturnPageVO.get(page,projectList));
  }

  /**
   * 查找负责人
   *
   * @return 结果
   */
  @RequestMapping("/user/list")
  public Object getUserList(){
    return CommonReturnVO.suc(projectService.getUserList());
  }

  /**
   * 新建负责人
   *
   * @param user 用户
   * @return 影响行数
   */
  @RequestMapping("/user/insert")
  public Object insertUser(@RequestBody User user){
    return CommonReturnVO.suc(projectService.insertUser(user));
  }

  /**
   * 新建项目
   *
   * @param project 项目
   * @return 影响行数
   */
  @RequestMapping("/insert")
  public Object insert(@RequestBody Project project){
    return CommonReturnVO.suc(projectService.insert(project));
  }

  /**
   * 更新项目
   *
   * @param project 项目
   * @return 影响行数
   */
  @RequestMapping("/update")
  public Object update(@RequestBody Project project){
    return CommonReturnVO.suc(projectService.update(project));
  }

  /**
   * 删除项目
   *
   * @param id 主键id
   * @return
   */
  @RequestMapping("/delete")
  public Object delete(@RequestParam(value = "id") Integer id){

    Project project = projectService.selectById(id);
    project.setDelete(true);
    return CommonReturnVO.suc(projectService.update(project));
  }

  /**
   * 导入文件
   *
   * @param file 文件
   * @return 影响行数
   * @throws IOException 异常
   */
  @RequestMapping("/upload")
  public Object upload(@RequestParam("file") MultipartFile file) throws IOException {

    List<Project> projectList = ExcelUtil
        .readExcel(file.getInputStream(), Project.class, ExcelUtil.getExcelTypeEnum(file.getOriginalFilename()));
    if(CollectionUtils.isEmpty(projectList)) {
      return CommonReturnVO.fail("导入内容为空");
    }
    return CommonReturnVO.suc(projectService.importProjectList(projectList));
  }
}
