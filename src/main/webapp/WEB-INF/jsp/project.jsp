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
        .add-form .el-form-item {
            margin-bottom: 15px;
        }
        .add-form {
            margin: 0 50px 0 20px;
        }
    </style>
</head>
<body>
<div id="main" v-if="isShow">
    <h3>项目管理</h3>
    <div style="margin-bottom: 22px;">  
        <label class="el-form-item__label">负责人：</label>
        <el-input v-model="formInline.connectName" style="width: 217px;" placeholder="负责人"></el-input>
        <el-button type="primary" @click="search(true)">搜索</el-button>
        <el-button type="primary" @click="newRecord">新建</el-button>
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
    <el-table :data="list" border :height="tableHeight">
        <el-table-column type="index" label="序号" width="50" ></el-table-column>
        <el-table-column prop="companyName" label="企业" width="160" ></el-table-column>
        <el-table-column prop="connectName" label="联系人" width="120" ></el-table-column>
        <el-table-column prop="connectPhone" label="号码" width="120" ></el-table-column>
        <el-table-column prop="area" label="意向区域" width="180"></el-table-column>
        <el-table-column prop="content" label="项目内容"></el-table-column>
        <el-table-column prop="detail" label="跟进"></el-table-column>
        <el-table-column label="操作" width="120" >
            <template slot-scope="{ row }">
            	<div class="action-btn">
                  	<a @click.stop="edit(row)">编辑</a>
                    <a class="red" @click="openDelModal(row)">删除</a>
                </div>
            </template>
        </el-table-column>
    </el-table>
    <el-pagination background
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        :current-page="formInline.pageNum"
        :page-sizes="[15, 30, 45, 60]"
        :page-size="formInline.pageSize"
        layout="total, sizes, prev, pager, next, jumper"
        :total="total">
    </el-pagination>
    <template v-if="isShow">      
        <el-dialog
            :visible.sync="isOpenAddModal"
            width="500px"
            :before-close="handleClose">
            <span slot="title">{{addModalTitle}}</span>
            <div>
                <el-form ref="modalForm" :model="modalForm" label-width="80px" :rules="rules" class="add-form">
                    <el-form-item label="企业" prop="companyName">
                        <el-input v-model="modalForm.companyName" size="small"></el-input>
                    </el-form-item>
                    <el-form-item label="联系人" prop="connectName">
                        <el-input v-model="modalForm.connectName" size="small"></el-input>
                    </el-form-item>
                    <el-form-item label="号码" prop="connectPhone">
                        <el-input v-model="modalForm.connectPhone" size="small"></el-input>
                    </el-form-item>
                    <el-form-item label="意向区域" prop="area">
                        <el-input v-model="modalForm.area" size="small"></el-input>
                    </el-form-item>
                    <el-form-item label="项目内容" prop="content">
                        <el-input v-model="modalForm.content" size="small"></el-input>
                    </el-form-item>
                    <el-form-item label="跟进" prop="detail">
                        <el-input v-model="modalForm.detail" size="small"></el-input>
                    </el-form-item>
                </el-form>
            </div>
            <span slot="footer" class="dialog-footer">
                <el-button @click="closeAddModal">关 闭</el-button>
                <el-button type="primary" @click="update">更 新</el-button>
            </span>
        </el-dialog>
        <el-dialog
          title="提示"
          :visible.sync="isOpenDelModal"
          width="350px">
          <i class="el-icon-warning-outline" style="color: rgb(255, 153, 0);font-weight: bold;font-size: 18px;"></i>
          <span style="font-size: 16px;">确定删除吗</span>
          <span slot="footer" class="dialog-footer">
            <el-button @click="isOpenDelModal = false">取 消</el-button>
            <el-button type="primary" @click="del">确 定</el-button>
          </span>
        </el-dialog>
    </template>
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
                total: 0,
                tableHeight: 0,
                addModalTitle: '',
                isOpenDelModal: false,
                isOpenAddModal: false,
                currRow: {},
                modalForm: {
                    companyName: '',
                    connectName: '',
                    connectPhone: '',
                    content: '',
                    area: '',
                    detail: ''
                },
                rules: {
                    companyName: [
                        { required: true, message: '请输入企业名称', trigger: 'change' },
                    ],
                    connectName: [
                        { required: true, message: '请输入联系人', trigger: 'change' }
                    ],
                    connectPhone: [
                        { required: true, message: '请输入号码', trigger: 'change' }
                    ]
                },
            	isShow: false,
                formInline: {
                    connectName: '',
                    pageSize: 15,
                    pageNum: 1
                },
                list: [],
                regionList: [],
                districtList: [],
                baseUrl: '${pageContext.request.contextPath}/'
            }
        },
        mounted () {
            setTimeout(() => this.isShow = true, 100)
            this.$nextTick(() => {
                // this.isShow = true
                this.getTableHeight()
            })
        },
        methods: {
            getTableHeight () {
              this.tableHeight = document.body.clientHeight - 216
            },
            handleSizeChange (val) {
                this.formInline.pageSize = val
                this.search()
            },
            handleCurrentChange (val) {
                this.formInline.pageNum = val
                this.search()
            },
            newRecord () {
                this.addModalTitle = '新建'
                this.isOpenAddModal = true
            },
            openDelModal (row) {
                this.currRow = row
                this.isOpenDelModal = true
            },
            async update () {
                try {
                    await this.$refs.modalForm.validate()
                    let url 
                    let params = { ...this.modalForm }
                    if (this.addModalTitle == '编辑') {
                        params.id = this.currRow.id
                        url = 'project/update'
                    } else url = 'project/insert'
                    let res = await axiosPostJSON(this.baseUrl + url, params)
                    console.log(res)
                    this.closeAddModal()
                    this.$message({ message: '保存成功！', type: 'success' })
                    this.search()
                } catch (err) {
                    console.log(err)
                    err.message && this.$message({ message: err.message, type: 'error' })
                }
            },
            closeAddModal () {
                this.modalForm = {
                    companyName: '',
                    connectName: '',
                    connectPhone: '',
                    content: '',
                    area: '',
                    detail: ''
                }
                this.$refs.modalForm.resetFields()
                this.isOpenAddModal = false
            },
            handleClose(done) {
                this.modalForm = {
                    companyName: '',
                    connectName: '',
                    connectPhone: '',
                    content: '',
                    area: '',
                    detail: ''
                }
                this.$refs.modalForm.resetFields()
                done()
            },
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
                this.addModalTitle = '编辑'
                this.currRow = row
                this.modalForm.companyName = row.companyName
                this.modalForm.connectName = row.connectName
                this.modalForm.connectPhone = row.connectPhone
                this.modalForm.area = row.area
                this.modalForm.detail = row.detail
                this.modalForm.content = row.content
                this.isOpenAddModal = true
            },
        	getTemplateDownload (params) {
			    window.open('${pageContext.request.contextPath}/common/template/download?fileName=' + params, '_self')
            },
            del () {
                axiosPost(this.baseUrl + 'project/delete', { id: this.currRow.id })
                    .then(res => {
                        this.$message({ message: '删除成功！', type: 'success' })
                        this.search()
                    })
                    .catch(err => {
                        this.$message({ message: err.message, type: 'error' })
                    })
            },
            async search (flag) {
                try {
                    if (flag) this.formInline.pageNum = 1
                    let res = await axiosGet(this.baseUrl + 'project/list', this.formInline)
                    this.list = res.content
                    this.total = res.totalCount
                    console.log(this.list)
                } catch (err) {
                    console.log(err)
                }
            }
        }
    })
</script>
</html>
