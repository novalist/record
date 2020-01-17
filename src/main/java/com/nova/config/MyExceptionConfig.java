package com.nova.config;

import com.alibaba.fastjson.JSONObject;
import com.nova.util.CommonReturnVO;
import java.io.PrintWriter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;

/**
 * 自定义统一异常处理器
 * 判断是否是一个独立的前端/客户端（WEB/RF/Android）发送的请求
 * 若是，响应JSON；否则，跳转至相应的视图（JSP页面）
 *
 * @author hzhang1
 * @date 2020/01/19
 */
@Component
public class MyExceptionConfig extends SimpleMappingExceptionResolver {


    private static final String UTF_8 = "UTF-8";
    private static final String APPLICATION_JSON = "application/json";

    public MyExceptionConfig(){}

    /**
     * 根据请求的不同来源做出不同的响应
     * */
    @Override
    protected ModelAndView doResolveException(HttpServletRequest request,
                                              HttpServletResponse response, Object handler, Exception ex) {
        // 针对文件下载，前端有可能是新开页面，为防止在页面上抛出异常堆栈信息，也统一处理成JSON文本返回
        return jsonExceptionHandler(response, ex);
    }

    /**
     * 响应JSON报文的异常处理方法
     *
     * @param response 响应
     * @param ex       异常对象
     * @return 视图
     * */
    private ModelAndView jsonExceptionHandler(HttpServletResponse response, Exception ex) {
        PrintWriter out = null;

        // 响应前端
        try {
            //设置编码
            response.setCharacterEncoding(UTF_8);
            //设置返回类型
            response.setContentType(APPLICATION_JSON);
            out = response.getWriter();
            out.println(JSONObject.toJSON(generateCommonReturnVO(ex)));
        } catch (Exception ignored) {
        } finally {
            if (null != out) {
                out.flush();
                out.close();
            }
        }

        return null;
    }

    /**
     * 对不同类型的异常进行处理转化成CommonReturnVO对象
     *
     * @param ex 异常对象
     * @return   CommonReturnVO对象
     * */
    private CommonReturnVO generateCommonReturnVO(Exception ex) {
        CommonReturnVO commonReturnVO;
        commonReturnVO = CommonReturnVO.fail(ex.getMessage() == null ? "内部异常错误" : ex.getMessage());
        return commonReturnVO;
    }

    /**
     * 判断是否是一个独立的前端/客户端（WEB/RF/Android）发送的请求
     * 根据请求头中是否带platform属性进行判断
     *
     * @param request 请求
     * @return true-是,false-否
     * */
    private boolean isClientRequest(HttpServletRequest request) {
        String header = request.getHeader("platform");
        return StringUtils.hasText(header);
    }
}