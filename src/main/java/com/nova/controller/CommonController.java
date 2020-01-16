package com.nova.controller;

import com.nova.util.FileUtil;
import java.io.IOException;
import java.util.Objects;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * 公用控制器
 * @author hzhang1
 * @date 2016-3-15
 * @version 1.0.0
 */
@Controller
@RequestMapping(value="common")
public class CommonController {
	
	

	/**
	 * 下载模板excel
	 *
	 * @param request 请求
	 * @param response 响应
	 * @throws IOException IOException
	 */
	@RequestMapping(value = "/template/download", method = RequestMethod.GET)
	public void downloadTemplate(HttpServletRequest request, HttpServletResponse response,
															 @RequestParam String fileName) throws IOException {

		String path = Objects.requireNonNull(Thread.currentThread().getContextClassLoader().getResource(""))
				.getPath() + "static/excel/";
		FileUtil.download(fileName, path, null, response);
	}


}
