package com.nova.dao;

import com.nova.entity.Project;
import com.nova.entity.User;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

/**
 * @author hzhang1
 * @date 2020-01-16
 */
@Mapper
public interface ProjectDao {

  /**
   * 新建
   *
   * @param project
   * @return
   */
  int insert(Project project);

  /**
   * 新建负责人
   *
   * @param user
   * @return
   */
  int insertUser(User user);

  /**
   * 更新
   *
   * @param project
   * @return
   */
  int update(Project project);

  /**
   * 按id查找
   *
   * @param id
   * @return
   */
  Project selectById(@Param("id") Integer id);

  /**
   * 查询
   *
   * @param searchCondition 条件
   * @return 列表
   */
  List<Project> selectByCondition(SearchCondition searchCondition);

  /**
   * 查询负责人
   * @param name 名字
   *
   * @return 列表
   */
  List<User> selectUser(@Param("name") String name);

  @Data
  @NoArgsConstructor
  @AllArgsConstructor
  class SearchCondition {

    private Integer id;

    private String connectName;

    private String connectPhone;

    private Integer userId;

    private String status;

  }
}
