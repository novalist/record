package com.nova.util;


import com.github.pagehelper.Page;
import java.util.List;
import lombok.Getter;
import lombok.Setter;

/**
 * 分页封装
 *
 * @author Jarvis Lee
 * @date 2018/12/22
 * */
@Getter
@Setter
public class CommonReturnPageVO<T> {
    private List<T> content;
    private Long totalCount;

    public CommonReturnPageVO(){}

    public CommonReturnPageVO(List<T> content, Long totalCount) {
        this.content = content;
        this.totalCount = totalCount;
    }

    public static <T> CommonReturnPageVO<T> get(Page page, List<T> content) {
        return new CommonReturnPageVO<>(content, page.getTotal());
    }

    /**
     * 用于在server进行数据分页时使用
     * @param total 数据总数
     * @param content 数据内容
     * @param <T> 数据类型
     * @return 数据体
     */
    public static <T> CommonReturnPageVO<T> get(Long total, List<T> content) {
        return new CommonReturnPageVO<>(content, total);
    }
}
