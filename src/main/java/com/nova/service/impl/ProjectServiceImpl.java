package com.nova.service.impl;

import com.nova.dao.ProjectDao;
import com.nova.dao.ProjectDao.SearchCondition;
import com.nova.entity.Project;
import com.nova.service.ProjectService;
import java.util.Date;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

/**
 * @author hzhang1
 * @date 2020-01-16
 */
@Service
public class ProjectServiceImpl implements ProjectService {

  @Resource
  private ProjectDao projectDao;


  @Override
  public Project selectById(Integer id) {

    Project project = projectDao.selectById(id);
    Assert.notNull(project,"未找到对应的项目记录");
    return project;
  }

  @Override
  @Transactional(rollbackFor = Exception.class)
  public int insert(Project project) {

    Assert.notNull(project,"项目内容为空");
    Assert.notNull(project.getCompanyName(),"企业为空");
    Assert.notNull(project.getConnectName(),"联系人为空");
    Assert.notNull(project.getConnectPhone(),"联系号码为空");

    project.setCreatedTime(new Date());
    project.setDelete(false);
    return projectDao.insert(project);
  }

  @Override
  @Transactional(rollbackFor = Exception.class)
  public int update(Project project) {
    return projectDao.update(project);
  }

  @Override
  public List<Project> selectByCondition(SearchCondition searchCondition) {
    return projectDao.selectByCondition(searchCondition);
  }

  @Override
  @Transactional(rollbackFor = Exception.class)
  public int importProjectList(List<Project> projectList) {

    int count = 0 ;
    for(Project project : projectList){
      count += insert(project);
    }
    return count;
  }
}
