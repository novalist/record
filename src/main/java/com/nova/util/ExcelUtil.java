package com.nova.util;

import com.alibaba.excel.ExcelReader;
import com.alibaba.excel.ExcelWriter;
import com.alibaba.excel.annotation.ExcelProperty;
import com.alibaba.excel.event.AnalysisEventListener;
import com.alibaba.excel.metadata.BaseRowModel;
import com.alibaba.excel.metadata.Sheet;
import com.alibaba.excel.support.ExcelTypeEnum;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletResponse;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.apache.poi.hssf.usermodel.DVConstraint;
import org.apache.poi.hssf.usermodel.HSSFDataValidation;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Name;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddressList;
import org.springframework.util.Assert;
import org.springframework.util.StringUtils;

/**
 * Excel工具
 *
 * @author lurunze
 * @date 2019/07/17
 */
public class ExcelUtil {

    /**
     * 从Excel中读取文件，读取的文件是一个DTO类，该类必须继承BaseRowModel 具体实例参考 ： MemberMarketDto.java
     * 参考：https://github.com/alibaba/easyexcel 字符流必须支持标记，FileInputStream 不支持标记，可以使用BufferedInputStream
     * 代替 BufferedInputStream bis = new BufferedInputStream(new FileInputStream(...));
     *
     * @param inputStream 文件输入流
     * @param clazz       继承该类必须继承BaseRowModel的类
     * @param excelTypeEnum 文件类型
     * @return 读取完成的list
     */
    public static <T extends BaseRowModel> List<T> readExcel(final InputStream inputStream,
                                                             final Class<? extends BaseRowModel> clazz, ExcelTypeEnum excelTypeEnum) {
        if (null == inputStream) {
            throw new NullPointerException("the inputStream is null!");
        }
        AnalysisEventListener listener = new ObjectExcelListener();
        ExcelReader reader = new ExcelReader(inputStream, excelTypeEnum, null, listener);
        reader.read(new com.alibaba.excel.metadata.Sheet(1, 1, clazz));

        return ((ObjectExcelListener) listener).getData();
    }

    /**
     * 需要写入的Excel，有模型映射关系
     *
     * @param file 需要写入的Excel
     * @param list 写入Excel中的所有数据，继承于BaseRowModel
     * @param excelTypeEnum Excel格式
     */
    public static void writeExcel(final File file, List<? extends BaseRowModel> list, ExcelTypeEnum excelTypeEnum)
            throws FileNotFoundException {
        OutputStream out = new FileOutputStream(file);
        try {
            ExcelWriter writer = new ExcelWriter(out, excelTypeEnum);
            //写第一个sheet,  有模型映射关系
            Class t = list.get(0).getClass();
            com.alibaba.excel.metadata.Sheet sheet = new com.alibaba.excel.metadata.Sheet(1, 0, t);
            writer.write(list, sheet);
            writer.finish();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                out.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 获取Excel文件类型
     *
     * @param originalFilename 文件名
     * @return ExcelTypeEnum
     */
    public static ExcelTypeEnum getExcelTypeEnum(String originalFilename) {
        String fileType;
        Assert.isTrue(originalFilename.lastIndexOf(".") != -1, "文件格式错误");
        fileType = originalFilename.substring(originalFilename.lastIndexOf("."));
        if (ExcelTypeEnum.XLS.getValue().equals(fileType)) {
            return ExcelTypeEnum.XLS;
        } else if (ExcelTypeEnum.XLSX.getValue().equals(fileType)) {
            return ExcelTypeEnum.XLSX;
        } else {
            throw new RuntimeException("文件格式不正确，请选择.xlsx或.xls格式文件！");
        }
    }

    /**
     * 写Excel文件
     *
     * @param excelTypeEnum excel版本
     * @param fileName      包含文件路径的文件名
     * @param sheetName     sheet名
     * @param datas         文件数据（包含表头）
     */
    public static void writeExcel(ExcelTypeEnum excelTypeEnum, String fileName, String sheetName,
                                  List<List<String>> datas) throws FileNotFoundException {
        OutputStream out = new FileOutputStream(fileName);
        try {
            ExcelWriter writer = new ExcelWriter(out, excelTypeEnum, false);
            //写第一个sheet, sheet1  数据全是List<String> 无模型映射关系
            Sheet sheet1 = new Sheet(1, 0);
            sheet1.setSheetName(sheetName);
            writer.write0(datas, sheet1);
            writer.finish();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                out.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public static List<List<String>> objectListToStringList(List objectList, List<String> fieldList)
            throws IllegalAccessException {
        Class c = objectList.get(0).getClass();
        List<List<String>> list = new ArrayList<>();
        for (Object o : objectList) {
            List<String> subList = new ArrayList<>();
            Field[] fields = c.getDeclaredFields();
            for (Field f : fields) {
                f.setAccessible(true);
            }
            Map<String, String> map = new HashMap<>(16);
            for (Field f : fields) {
                String field = f.toString().substring(f.toString().lastIndexOf(".") + 1);
                if (f.get(o) != null) {
                    map.put(field, f.get(o).toString());
                } else {
                    map.put(field, "");
                }
            }
            for (String str : fieldList) {
                subList.add(map.get(str));
            }
            list.add(subList);
        }
        return list;
    }

    /**
     * 校验excel表头是否正确
     *
     * @param excelTitle excel表头
     * @param templateTitle 模板表头
     * @return 校验结果
     */
    public static Boolean checkTitle(List<String> excelTitle, List<String> templateTitle) {
        if (excelTitle.size() != templateTitle.size()) {
            return false;
        }
        for (int i = 0; i < templateTitle.size(); i++) {
            if (!excelTitle.get(i).equals(templateTitle.get(i))) {
                return false;
            }
        }
        return true;
    }

    @Getter
    @Setter
    static class ExcelExportGrid {
        private String key;
        private String desc;

        ExcelExportGrid(String key, String desc) {
            this.key = key;
            this.desc = desc;
        }

    }

    /**
     * 获取Excel导出模板网格
     *
     * @param clz 类
     * @return
     */
    public static Map<String, Object> get(Class<? extends BaseRowModel> clz) {

        if (clz == null) {
            throw new RuntimeException("invalid method input");
        }

        Map<String, Object> map = new HashMap<>(1);

        Field[] fields = clz.getDeclaredFields();
        List<ExcelExportGrid> list = new ArrayList<>(fields.length);
        for (Field field : fields) {

            boolean annotationPresent = field.isAnnotationPresent(ExcelProperty.class);
            if (annotationPresent) {
                ExcelProperty excelProperty = field.getAnnotation(ExcelProperty.class);
                String[] value = excelProperty.value();
                list.add(new ExcelExportGrid(field.getName(), value[0]));
            }

        }
        map.put(toLowerFirst(clz.getSimpleName()), list);

        return map;
    }

    /**
     * 首字母小写
     *
     * @param oldStr 原字符串
     * @return 目标字符串
     */
    public static String toLowerFirst(String oldStr) {
        char[] chars = oldStr.toCharArray();
        chars[0] += 32;
        return String.valueOf(chars);
    }



    /**
     * 使用模型(全部字段) 来写入Excel
     *
     * @param path          文件路径
     * @param dataList      源数据
     * @param sheetNameList sheet名
     * @param clazzList     源类
     * @param excelTypeEnum xlsx/xls
     */
    public static void writeExcelWithModel(String path,
                                           List<List<? extends BaseRowModel>> dataList,
                                           List<String> sheetNameList,
                                           List<Class<? extends BaseRowModel>> clazzList,
                                           ExcelTypeEnum excelTypeEnum) throws FileNotFoundException {
        OutputStream outputStream = new FileOutputStream(path);

        //这里指定需要表头，因为model通常包含表头信息
        ExcelWriter writer = new ExcelWriter(outputStream, excelTypeEnum, true);
        for(int index = 0; index < dataList.size(); index++){
            Sheet sheet = new Sheet(index + 1, 0, clazzList.get(index));
            sheet.setSheetName(sheetNameList.get(index));
            writer.write(dataList.get(index), sheet);
        }
        writer.finish();
    }
    /**
     * 使用模型（部分字段） 来写入Excel
     *
     * @param path          文件路径
     * @param fieldList     导出字段
     * @param data          源数据
     * @param clazz         源类
     */
    public static void writeExcelWithModel(String path,
        List<String> fieldList,
        List<? extends BaseRowModel> data,
        Class<? extends BaseRowModel> clazz) throws FileNotFoundException {
        OutputStream outputStream = new FileOutputStream(path);
        //这里指定需要表头，因为model通常包含表头信息
        ExcelWriter writer = new ExcelWriter(outputStream, ExcelTypeEnum.XLSX, false);
        //写第一个sheet, sheet1  数据全是List<String> 无模型映射关系
        Sheet sheet1 = new Sheet(1, 0);
        sheet1.setSheetName("sheet1");
        writer.write0(getWriteDate(fieldList, clazz, data), sheet1);
        writer.finish();
    }
    /**
     * 使用模型(全部字段) 来写入Excel
     *
     * @param path          文件路径
     * @param data          源数据
     * @param clazz         源类
     */
    public static void writeExcelWithModel(String path,
                                           List<? extends BaseRowModel> data,
                                            ExcelTypeEnum excelTypeEnum,
                                           Class<? extends BaseRowModel> clazz) throws FileNotFoundException {
        OutputStream outputStream = new FileOutputStream(path);

        //这里指定需要表头，因为model通常包含表头信息
        ExcelWriter writer = new ExcelWriter(outputStream, excelTypeEnum, true);
        //写第一个sheet, sheet1  数据全是List<String> 无模型映射关系
        Sheet sheet1 = new Sheet(1, 0, clazz);
        writer.write(data, sheet1);
        writer.finish();
    }

    /**
     * 使用模型（部分字段） 来写入Excel 多sheet写入
     *
     * @param path          文件路径
     * @param sheetDateList sheet列表
     */
    public static void writeExcelWithMultipleSheetModel(String path, List<SheetDateModel> sheetDateList) throws FileNotFoundException {
        OutputStream outputStream = new FileOutputStream(path);
        ExcelWriter writer = new ExcelWriter(outputStream, ExcelTypeEnum.XLSX, false);
        int i = 1;
        for (SheetDateModel sheetDateModel : sheetDateList) {
            List<String> fieldList = sheetDateModel.getFieldList();
            Class<? extends BaseRowModel> clazz = sheetDateModel.getClazz();
            List<? extends BaseRowModel> data = sheetDateModel.getData();
            List<List<String>> writeData = getWriteDate(fieldList, clazz, data);
            //这里指定需要表头，因为model通常包含表头信息
            //写第一个sheet, sheet1  数据全是List<String> 无模型映射关系
            Sheet sheet = new Sheet(i++, 0);
            sheet.setSheetName(sheetDateModel.getSheetName());
            writer.write0(writeData, sheet);
        }
        writer.finish();
    }

    private static List<List<String>> getWriteDate(List<String> fieldList, Class<? extends BaseRowModel> clazz, List<? extends BaseRowModel> data) {
        List<List<String>> writeData = new ArrayList<>();

        List<String> titleList = new ArrayList<>();
        Field[] declaredFields = clazz.getDeclaredFields();
        Map<String, String> titleMap = new HashMap<>(16);
        for (Field field : declaredFields) {
            boolean annotationPresent = field.isAnnotationPresent(ExcelProperty.class);
            if (annotationPresent) {
                ExcelProperty excelProperty = field.getAnnotation(ExcelProperty.class);
                String[] value = excelProperty.value();
                if (fieldList.contains(field.getName())) {
                    titleMap.put(field.getName(), value[0]);
                }
            }
        }
        for (String field : fieldList) {
            titleList.add(titleMap.get(field));
        }
        writeData.add(titleList);

        try {
            Iterator<? extends BaseRowModel> iterator = data.iterator();
            while (iterator.hasNext()) {

                BaseRowModel next = iterator.next();
                List<String> contentList = new ArrayList<>();
                Class<? extends BaseRowModel> aClass = next.getClass();

                for (String field : fieldList) {

                    Field declaredField = aClass.getDeclaredField(field);
                    declaredField.setAccessible(true);
                    Object object = declaredField.get(next);
                    contentList.add(object != null ? String.valueOf(object) : "");
                }

                writeData.add(contentList);
            }
        } catch (Exception e) {
            throw new RuntimeException("解析数据失败");
        }
        return writeData;
    }

    @Getter
    @Setter
    @ToString
    @NoArgsConstructor
    @AllArgsConstructor
    public static class SheetDateModel{
        private String sheetName;
        private List<String> fieldList;
        private List<? extends BaseRowModel> data;
        private Class<? extends BaseRowModel> clazz;
    }

    /**
     * 创建excel工作簿
     *
     * @param clz 需要导出的class
     * @return 工作簿
     */
    public static Workbook createExcelWorkBook(Class<? extends BaseRowModel> clz, String firstSheetName){

        if (clz == null) {
            throw new RuntimeException("invalid method input");
        }

        Field[] fields = clz.getDeclaredFields();
        Workbook workbook = new HSSFWorkbook();
        org.apache.poi.ss.usermodel.Sheet sheet = workbook.createSheet(!StringUtils.isEmpty(firstSheetName) ? firstSheetName : "template");
        Row row = sheet.createRow((short) 0);

        int colNum = 0;
        for (Field field : fields) {
            boolean annotationPresent = field.isAnnotationPresent(ExcelProperty.class);
            if (annotationPresent) {
                ExcelProperty excelProperty = field.getAnnotation(ExcelProperty.class);
                String[] value = excelProperty.value();
                Cell cell = row.createCell(colNum++);
                cell.setCellValue(value[0]);
            }
        }
        return workbook;
    }

    /**
     * 单元格前景色设置
     *
     * @param workbook excel工作簿
     * @param colNum 列（从0开始）
     * @param indexedColor 颜色
     */
    public static void fillSheetColorList(Workbook workbook, int colNum, IndexedColors indexedColor){
        org.apache.poi.ss.usermodel.Sheet sheet = workbook.getSheetAt(0);
        Row row = sheet.getRow((short) 0);

        Cell cell = row.getCell(colNum);
        Assert.notNull(cell,"不存在的列");

        CellStyle cellStyle=workbook.createCellStyle();
        cellStyle.setFillForegroundColor(indexedColor.getIndex());
        cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

        cell.setCellStyle(cellStyle);
    }


    /**
     * 单元格自定义列内容设置
     *
     * @param workbook excel工作簿
     * @param firstCol 列（从0开始）
     * @param lastCol 截止列
     * @param fontColor 字体颜色
     * @param value 内容
     */
    public static void fillSheetCellStyle(Workbook workbook, int firstCol, int lastCol ,short fontColor , String value){
        org.apache.poi.ss.usermodel.Sheet sheet = workbook.getSheetAt(0);
        Row row = sheet.getRow((short) 1);
        if(row == null){
            row = sheet.createRow((short) 1);
        }

        for(int i = firstCol ; i <= lastCol ; i++ ) {
            Cell cell = row.createCell(i);

            Font font = workbook.createFont();
            font.setColor(fontColor);

            CellStyle cellStyle = workbook.createCellStyle();
            cellStyle.setFont(font);
            cell.setCellStyle(cellStyle);

            cell.setCellValue(value);
        }
    }

    /**
     * 填充表格列下拉框，多次对同一列填充会覆盖
     *
     * @param workbook excel工作簿
     * @param firstCol 开始行号（从0开始）
     * @param lastCol 结束行号
     * @param list 填充列表
     */
    public static void fillSheetSelectList(Workbook workbook, int firstCol, int lastCol, List<String> list){
        fillSheetSelectList(workbook,"",firstCol,lastCol,list);
    }

    /**
     * 创建带有隐藏格的excel（用于处理下拉框中数据较多 超出字符串限制的情况），多次对同一列填充会覆盖
     *
     * @param workbook 入参
     * @param hiddenName 隐藏域名称
     * @param firstCol 开始行号（从0开始）
     * @param lastCol 终止行号
     * @param list 填充列表
     */
    public static void fillSheetSelectList(Workbook workbook, String hiddenName, int firstCol, int lastCol, List<String> list){

        String[] strings = new String[list.size()];
        list.toArray(strings);
        org.apache.poi.ss.usermodel.Sheet sheet = workbook.getSheetAt(0);
        CellRangeAddressList cellRangeAddressList = new CellRangeAddressList(1, 65535, firstCol, lastCol);
        DVConstraint dvConstraint;
        if(!StringUtils.isEmpty(hiddenName)){
            org.apache.poi.ss.usermodel.Sheet hidden = workbook.createSheet(hiddenName + "Hidden");

            for (int i = 0, length = list.size(); i < length; i++) {
                hidden.createRow(i).createCell(0).setCellValue(list.get(i));
            }
            Name categoryName = workbook.createName();
            categoryName.setNameName(hiddenName);
            // A1:A代表隐藏域创建第?列createCell(?)时。以A1列开始A行数据获取下拉数组
            categoryName.setRefersToFormula(hiddenName + "Hidden" + "!$A$1:$A$" + list.size());
            dvConstraint = DVConstraint.createFormulaListConstraint(hiddenName);
        }else{
            dvConstraint = DVConstraint.createExplicitListConstraint(strings);
        }

        HSSFDataValidation dataValidation = new HSSFDataValidation(cellRangeAddressList, dvConstraint);
        sheet.addValidationData(dataValidation);

    }

    /**
     * 模板导出
     *
     * @param workbook excel工作簿
     * @param fileName 文件名
     * @param response 返回
     * @throws IOException 异常
     */
    public static void exportExcelTemplate(Workbook workbook ,String fileName,
                                           HttpServletResponse response) throws IOException {

        OutputStream output = null;
        BufferedOutputStream bufferedOutPut = null;
        try {
            response.reset();
            response.setContentType("application/vnd.ms-excel;charset=UTF-8");
            response.setHeader("Content-Disposition",
                    "attachment;filename=" + new String((fileName + ".xls").getBytes(), "iso-8859-1"));
            response.setCharacterEncoding("UTF-8");
            output = response.getOutputStream();
            bufferedOutPut = new BufferedOutputStream(output);

            workbook.write(bufferedOutPut);
            bufferedOutPut.flush();
        } catch (Exception e) {

        } finally {
            if (bufferedOutPut != null) {
                bufferedOutPut.close();
            }
            if (output != null) {
                output.close();
            }
        }
    }

}
