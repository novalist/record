package com.nova.util;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

/**
 * 返回前端封装数据公用类
 *
 * @author hzhang1
 * @date 2020-01-14
 */
@Data
public class CommonReturnVO {

    public static final int SUCCESS_CODE = 200;
    public static final int FAILURE_CODE = 400;

    private Integer code;

    private String message;

    private Object data;

    public CommonReturnVO() {}

    public CommonReturnVO(int code, String message, Object data) {
        this.code = code;
        this.message = message;
        this.data = data;
    }

    public static <T> CommonReturnVO suc(T data, String message) {
        return new CommonReturnVO(SUCCESS_CODE, message, data);
    }

    public static CommonReturnVO suc(String message) {
        return suc(null, message);
    }

    public static <T> CommonReturnVO suc(T data) {
        return suc(data, "");
    }

    public static CommonReturnVO suc() {
        return suc("");
    }

    public static <T> CommonReturnVO fail(T data, String message) {
        return new CommonReturnVO(FAILURE_CODE, message, data);
    }

    public static CommonReturnVO fail(String message) {
        return fail(null, message);
    }

    public static <T> CommonReturnVO fail(T data) {
        return fail(data, "");
    }

    public static CommonReturnVO fail() {
        return fail("");
    }
}
