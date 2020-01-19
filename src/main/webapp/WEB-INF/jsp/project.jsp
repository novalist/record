<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/global.css">
    <title>项目管理</title>
    <style type="text/css">
        
    </style>
</head>
<body>
<div id="main" v-if="isShow">
    <h3>项目管理</h3>
    <div style="margin-bottom: 22px;">  
        <label class=".el-form-item__label">负责人：</label>
        <el-input v-model="formInline.connectName" style="width: 217px;" placeholder="负责人"></el-input>
        <el-button type="primary" @click="search">搜索</el-button>
        <el-upload action="/record/project/upload"
            style="display: inline-block;"
            multiple
            :show-file-list="false"
            :on-success="handleFileSuccess"
            :on-error="handleFileError">
            <el-button type="primary">导入</el-button>
        </el-upload>
        <el-button @click="getTemplateDownload('项目信息模版.xlsx')">模板下载</el-button>
    </div>
    <el-table :data="list" border>
        <el-table-column type="index" label="序号" width="50" ></el-table-column>
        <el-table-column prop="companyName" label="企业" width="180" ></el-table-column>
        <el-table-column prop="connectName" label="联系人" width="120" ></el-table-column>
        <el-table-column prop="connectPhone" label="号码" width="120" ></el-table-column>
        <el-table-column prop="area" label="意向区域" width="180"></el-table-column>
        <el-table-column prop="content" label="项目内容"></el-table-column>
        <el-table-column prop="detail" label="跟进"></el-table-column>
        <el-table-column label="操作" width="120" >
            <template slot-scope="{ row }">
            	<div class="action-btn">
                  	<a @click.stop="edit(row)">编辑</a>
                    <a @click.stop="del(row)" class="red">删除</a>
                </div>
            </template>
        </el-table-column>
    </el-table>
</div>
</body>
<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
<script src="https://unpkg.com/element-ui/lib/index.js"></script>
<script src="https://unpkg.com/axios/dist/axios.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/request.js"></script>
<script>
    let app = new Vue({
        el: '#main',
        data () {
            return {
            	 isShow: false,
                formInline: {
                    connectName: ''
                },
                list: [],
                regionList: [],
                districtList: [],
                baseUrl: '${pageContext.request.contextPath}/'
            }
        },
        mounted () {
            this.isShow = true
        },
        methods: {
            handleFileSuccess (res, file, fileList) {
                console.log(res)
                if (res.code == 400) this.$message({ message: res.message, type: 'error' })
                else {
                    this.$message({ message: '导入成功！', type: 'success' })
                    this.search()   
                }
            },
            handleFileError (err, file, fileList) {
                console.log(err)
                this.$message({ message: err, type: 'error' })
            },
            edit (row) {
            },
        	getTemplateDownload (params) {
			    window.open('${pageContext.request.contextPath}/common/template/download?fileName=' + params, '_self')
            },
            del (row) {
                axiosPostJSON(this.baseUrl + 'project/delete', { masterName: row.masterName })
                    .then(res => {
                        this.$message({ message: '删除成功！', type: 'success' })
                        this.search()
                    })
                    .catch(err => {
                        this.$message({ message: err.message, type: 'error' })
                    })
            },
            async search () {
                try {
                    let res = await axiosGet(this.baseUrl + '/project/list', this.formInline)
                    this.list = res.content
                    console.log(this.list)
                } catch (err) {
                    console.log(err)
                }
            }
        }
    })
</script>
</html>
