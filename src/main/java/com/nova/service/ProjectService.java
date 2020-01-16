package com.nova.service;

import com.nova.dao.ProjectDao.SearchCondition;
import com.nova.entity.Project;
import java.util.List;

/**
 * @author hzhang1
 * @date 2020-01-16
 */
public interface ProjectService {


  Project selectById(Integer id);

  int insert(Project project);

  int update(Project project);

  List<Project> selectByCondition(SearchCondition searchCondition);

  int importProjectList(List<Project> projectList);
}
