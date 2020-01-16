package com.nova.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import javax.servlet.http.HttpServletResponse;
import org.springframework.util.StringUtils;

/**
 * 文件工具
 * @author lurunze
 * @date 2019/05/5
 */
public class FileUtil {
    /**
     * 下载文件工具
     *
     * @param fileName 目标文件名
     * @param path 目标文件路径
     * @param response 响应
     * @param file 文件
     * @param downloadFileName 用户下载文件使用的文件名
     * @throws IOException io异常
     */
    public static void download(String fileName, String path, File file, String downloadFileName, HttpServletResponse response) throws IOException {
        if (file == null) {
            file = new File(path + fileName);
        }
        if (file.exists()) {
            // 可以指定用户下载文件使用的文件名
            if (!StringUtils.hasText(downloadFileName)) {
                downloadFileName = fileName;
            }
            response.setContentType("application/x-msdownload");
            response.setHeader("Content-disposition", "attachment; filename="
                + new String(downloadFileName.getBytes("utf-8"), "ISO8859-1"));
            InputStream inputStream = new FileInputStream(file);
            OutputStream outputStream = response.getOutputStream();
            byte[] b = new byte[2014];
            int n;
            while ((n = inputStream.read(b)) != -1) {
                outputStream.write(b, 0, n);
            }
            outputStream.close();
            inputStream.close();
        } else {
            throw new RuntimeException("文件" + path + fileName + "不存在");
        }


    }

    /**
     * 下载文件工具
     *
     * @param fileName 目标文件名
     * @param path 目标文件路径
     * @param response 响应
     * @param file 文件
     * @throws IOException io异常
     */
    public static void download(String fileName, String path, File file, HttpServletResponse response) throws IOException {
        download(fileName, path, file, null, response);
    }

    /**
     * 压缩多个文件成一个zip文件
     *
     * @param srcFile 源文件列表
     * @param zipFile 压缩后的文件
     */
    public static void zipFiles(List<File> srcFile, File zipFile) {
        byte[] buf = new byte[1024];
        try {
            //ZipOutputStream类：完成文件或文件夹的压缩
            ZipOutputStream out = new ZipOutputStream(new FileOutputStream(zipFile));
            for (File file : srcFile) {
                FileInputStream in = new FileInputStream(file);
                out.putNextEntry(new ZipEntry(file.getName()));
                int len;
                while ((len = in.read(buf)) > 0) {
                    out.write(buf, 0, len);
                }
                out.closeEntry();
                in.close();
            }
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
