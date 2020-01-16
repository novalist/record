package com.nova.util;

import com.alibaba.excel.context.AnalysisContext;
import com.alibaba.excel.event.AnalysisEventListener;
import com.alibaba.excel.metadata.BaseRowModel;
import java.util.ArrayList;
import java.util.List;

/**
 * 处理Excel，将读取到数据保存为对象并输出
 *
 * @author lurunze
 * @date 2019/07/18
 */
public class ObjectExcelListener<T extends BaseRowModel> extends AnalysisEventListener<T> {
  /**
   * 自定义用于暂时存储data。
   * 可以通过实例获取该值
   */
  private final List<T> data = new ArrayList<>();

  @Override
  public void invoke(T object, AnalysisContext context) {
    //数据存储
    data.add(object);
  }

  @Override
  public void doAfterAllAnalysed(AnalysisContext context) {

  }

  public List<T> getData() {
    return data;
  }

}