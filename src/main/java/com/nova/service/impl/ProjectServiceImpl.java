package com.nova.service.impl;

import com.nova.dao.ProjectDao;
import com.nova.dao.ProjectDao.SearchCondition;
import com.nova.entity.Project;
import com.nova.service.ProjectService;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

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
    return projectDao.selectById(id);
  }

  @Override
  public int insert(Project project) {
    return projectDao.insert(project);
  }

  @Override
  public int update(Project project) {
    return projectDao.update(project);
  }

  @Override
  public List<Project> selectByCondition(SearchCondition searchCondition) {
    return projectDao.selectByCondition(searchCondition);
  }

  @Override
  public int importProjectList(List<Project> projectList) {

    for(Project project : projectList){
      projectDao.insert(project);
    }
    return 0;
  }
}
