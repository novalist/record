package com.nova.service.impl;

import com.nova.dao.ProjectDao;
import com.nova.dao.ProjectDao.SearchCondition;
import com.nova.entity.Project;
import com.nova.entity.Project.STATUS;
import com.nova.entity.User;
import com.nova.service.ProjectService;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

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
    Assert.notNull(project.getCompanyName(),"企业名称为空");
    Assert.notNull(project.getConnectName(),"联系人为空");
    Assert.notNull(project.getConnectPhone(),"联系号码为空");
    Assert.notNull(project.getUserId(),"负责人为空");

    if(StringUtils.isEmpty(project.getStatus())){
      project.setStatus("WELL");
    }

    project.setCreatedTime(new Date());
    project.setDelete(false);
    return projectDao.insert(project);
  }

  @Override
  @Transactional(rollbackFor = Exception.class)
  public int insertUser(User user) {

    Assert.notNull(user,"负责人为空");
    Assert.notNull(user.getName(),"负责人姓名为空");
    return projectDao.insertUser(user);
  }

  @Override
  @Transactional(rollbackFor = Exception.class)
  public int update(Project project) {

    if(project.getUserId() == null && StringUtils.hasText(project.getName())){
      List<User> userList = projectDao.selectUser(project.getName());
      Assert.isTrue(!CollectionUtils.isEmpty(userList),"负责人不存在");

      project.setUserId(userList.get(0).getId());
    }

    if("优质".equalsIgnoreCase(project.getStatus())){
      project.setStatus(STATUS.WELL.name());
    }else if("一般".equalsIgnoreCase(project.getStatus())){
      project.setStatus(STATUS.NORMAL.name());
    }else if("暂缓".equalsIgnoreCase(project.getStatus())){
      project.setStatus(STATUS.STOP.name());
    }else if("成功".equalsIgnoreCase(project.getStatus())){
      project.setStatus(STATUS.SUCCESS.name());
    }

    return projectDao.update(project);
  }

  @Override
  public List<Project> selectByCondition(SearchCondition searchCondition) {
    return projectDao.selectByCondition(searchCondition);
  }

  @Override
  @Transactional(rollbackFor = Exception.class)
  public int importProjectList(List<Project> projectList) {

    Map<String,Integer> userMap = new HashMap<>(6);
    List<User> users = projectDao.selectUser(null);
    for(User user : users){
      userMap.put(user.getName(),user.getId());
    }
    int count = 0 ;
    for(Project project : projectList){
      project.setUserId(userMap.get(project.getName()));
      count += insert(project);
    }
    return count;
  }

  @Override
  public List<User> getUserList() {
    return projectDao.selectUser(null);
  }
}
