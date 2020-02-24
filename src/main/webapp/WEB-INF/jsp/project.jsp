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
        .add-form .el-input{
            width: 300px;
        }
    </style>
</head>
<body>
<div id="main">
    <h3>项目管理</h3>
    <div style="margin-bottom: 22px;">
        <el-form :inline="true" :model="formInline">
            <el-form-item label="负责人：" prop="id">
                <el-select v-model="formInline.userId" placeholder="负责人" @change="getUserList">
                    <el-option label="全部" value=""></el-option>
                    <el-option :label="item.name" :value="item.id" v-for="item in userList" :key="item.id"></el-option>
                </el-select>
            </el-form-item>

            <el-form-item>
                <el-input v-model="formInline.connectPhone" placeholder="号码"></el-input>
            </el-form-item>

            <el-button type="primary" @click="search(true)">搜索</el-button>
            <el-button type="primary" @click="newRecord" :disabled="!formInline.userId">新建</el-button>
            <el-upload action="/record/project/upload"
                style="display: inline-block;"
                accept=".xlsx, .xls"
                :show-file-list="false"
                :on-success="handleFileSuccess"
                :on-error="handleFileError">
                <el-button type="primary">导入</el-button>
            </el-upload>
            <el-button @click="getTemplateDownload('项目信息模版.xlsx')">模板下载</el-button>
        </el-form>
    </div>
    <el-table :data="list" border :height="tableHeight">
        <el-table-column type="index" label="序号" width="50" align="center"></el-table-column>
        <el-table-column prop="companyName" label="名称" min-width="120" ></el-table-column>
        <el-table-column prop="connectName" label="联系人" width="100" ></el-table-column>
        <el-table-column prop="connectPhone" label="号码" width="120" ></el-table-column>
        <el-table-column prop="status" label="状态" width="100"></el-table-column>
        <el-table-column prop="name" label="负责人" width="100"></el-table-column>
        <el-table-column prop="area" label="意向区域" width="140"></el-table-column>
        <el-table-column prop="content" label="项目内容" min-width="160"></el-table-column>
        <el-table-column prop="detail" label="跟进" min-width="160"></el-table-column>
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
    <el-dialog
        :visible.sync="isOpenAddModal"
        width="500px"
        :before-close="handleClose">
        <span slot="title">{{addModalTitle}}</span>
        <div>
            <el-form ref="modalForm" :model="modalForm" label-width="80px" :rules="rules" class="add-form">
                <el-form-item label="名称" prop="companyName">
                    <el-input v-model="modalForm.companyName" size="small"></el-input>
                </el-form-item>
                <el-form-item label="联系人" prop="connectName">
                    <el-input v-model="modalForm.connectName" size="small"></el-input>
                </el-form-item>
                <el-form-item label="号码" prop="connectPhone">
                    <el-input v-model="modalForm.connectPhone" size="small"></el-input>
                </el-form-item>
                <el-form-item label="状态" prop="status">
                    <el-select v-model="modalForm.status" size="small">
                        <el-option label="优质" value="WELL"></el-option>
                        <el-option label="一般" value="NORMAL"></el-option>
                        <el-option label="暂缓" value="STOP"></el-option>
                        <el-option label="成功" value="SUCCESS"></el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="负责人" prop="name">
                    <el-select v-model="addForm.id" placeholder="负责人" size="small">
                        <el-option :label="item.name" :value="item.id" v-for="item in userList" :key="item.id"></el-option>
                    </el-select>
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
            <el-button type="primary" @click="addRecord" v-if="addModalTitle == '新建'">保存</el-button>
            <el-button type="primary" @click="update" v-else>更 新</el-button>
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
                    status: '',
                    content: '',
                    area: '',
                    detail: '',
                    name: '',
                    userId: ''
                },
                rules: {
                    companyName: [
                        { required: true, message: '请输入名称', trigger: 'change' },
                    ],
                    connectName: [
                        { required: true, message: '请输入联系人', trigger: 'change' }
                    ],
                    connectPhone: [
                        { required: true, message: '请输入号码', trigger: 'change' }
                    ]
                },
                formInline: {
                    userId: '',
                    pageSize: 15,
                    pageNum: 1
                },
                addForm: {
                    id: '',
                    name: ''
                },
                list: [],
                userList: [],
                regionList: [],
                districtList: [],
                baseUrl: '${pageContext.request.contextPath}/'
            }
        },
        mounted () {
            this.getUserList()
            document.getElementById('main').style.display = 'inherit'
            this.$nextTick(() => this.getTableHeight())
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
            getUserList () {
                this.formInline.id = ''
                axiosGet(this.baseUrl + 'project/user/list', {  })
                .then(res => this.userList = res)
            .catch(err => {
                this.$message({ message: err.message, type: 'error' })
                console.log(err)
                })
            },
            openDelModal (row) {
                this.currRow = row
                this.isOpenDelModal = true
            },
            update () {
                this.$confirm('确定更新？', '提示', {
                    distinguishCancelAndClose: true,
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning',
                }).then(() => {
                    this.postUpdate()
                }).catch(action => {
                    // ...
                })
            },
            async postUpdate () {
                try {
                    await this.$refs.modalForm.validate()
                    this.modalForm.userId = this.addForm.id
                    let res = await axiosPostJSON(this.baseUrl + 'project/update', { ...this.modalForm, id: this.currRow.id })
                    this.closeAddModal()
                    this.$message({ message: '更新成功！', type: 'success' })
                    this.search()
                } catch (err) {
                    console.log(err)
                    err.message && this.$message({ message: err.message, type: 'error' })
                }
            },
            async addRecord () {
                try {
                    await this.$refs.modalForm.validate()
                    this.modalForm.userId = this.addForm.id
                    let res = await axiosPostJSON(this.baseUrl + 'project/insert', this.modalForm)
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
                    status: '',
                    content: '',
                    area: '',
                    detail: '',
                    userId: '',
                    name: ''
                }
                this.$refs.modalForm.resetFields()
                this.isOpenAddModal = false
            },
            handleClose(done) {
                this.modalForm = {
                    companyName: '',
                    connectName: '',
                    connectPhone: '',
                    status: '',
                    content: '',
                    area: '',
                    detail: '',
                    userId: '',
                    name: ''
                }
                this.$refs.modalForm.resetFields()
                done()
            },
            handleFileSuccess (res, file, fileList) {
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
                this.modalForm.status = row.status
                this.modalForm.area = row.area
                this.modalForm.detail = row.detail
                this.modalForm.userId = row.userId
                this.addForm.id = row.userId
                this.addForm.name = row.name
                this.modalForm.name = row.name
                this.modalForm.content = row.content
                this.isOpenAddModal = true
            },
        	getTemplateDownload (params) {
			    window.open('${pageContext.request.contextPath}/common/template/download?fileName=' + params, '_self')
            },
            del () {
                this.isOpenDelModal = false
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
                } catch (err) {
                    console.log(err)
                }
            }
        }
    })
</script>
</html>
