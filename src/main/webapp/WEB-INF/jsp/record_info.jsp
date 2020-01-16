<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <title>资源管理</title>
    <style type="text/css">
        .content {
            padding: 10px;
        }
        .el-form-item {
            margin-bottom: 10px;
        }
        .el-input {
            line-height: 32px;
            width: 200px;
        }
        .el-input input {
            height: 32px;
        }
        .img-wrapper {
            position: absolute;
            right: 20px;
            top: 100px;
        }
        .action-btn {
            color: #409EFF;
            cursor: pointer;
        }
        .action-btn:hover {
            opacity: 0.8;
        }
        .el-dialog__body {
            padding: 20px;
        }
    </style>
</head>
<body>
<div id="app">
    <h3>资源查询</h3>
    <el-form :inline="true" :model="formInline">
        <el-form-item label="区域：" prop="regionId">
            <el-select v-model="formInline.regionId" placeholder="区域" @change="getDistrictList">
                <el-option label="全部" value=""></el-option>
                <el-option :label="item.regionName" :value="item.regionId" v-for="item in regionList" :key="item.regionId"></el-option>
            </el-select>
        </el-form-item>
        <el-form-item label="街道">
            <el-select v-model="formInline.districtId" placeholder="街道" :disabled="!formInline.regionId">
                <el-option label="全部" value=""></el-option>
                <el-option :label="item.regionName" :value="item.regionId" v-for="item in districtList" :key="item.regionId"></el-option>
            </el-select>
        </el-form-item>
        <el-form-item>
            <el-input v-model="formInline.key" placeholder="关键字"></el-input>
        </el-form-item>
        <el-form-item>
            <el-button type="primary" @click="search">查询</el-button>
            <el-button type="primary" @click="importFile">导入</el-button>
            <el-button type="primary" @click="newRecord">新建</el-button>
            <el-button>模板下载</el-button>
        </el-form-item>
    </el-form>
    <el-table :data="list" border>
        <el-table-column type="index" label="序号" width="50" ></el-table-column>
        <el-table-column prop="regionName" label="区域" width="100" ></el-table-column>
        <el-table-column prop="districtName" label="街道" width="100" ></el-table-column>
        <el-table-column prop="companyName" label="企业" width="180" ></el-table-column>
        <el-table-column prop="masterName" label="联系人" width="120" ></el-table-column>
        <el-table-column prop="asterPhone" label="联系方式1" width="120" ></el-table-column>
        <el-table-column prop="slavePhone" label="联系方式2" width="120" ></el-table-column>
        <el-table-column prop="address" label="地址"></el-table-column>
        <el-table-column prop="resource" label="资源信息" width="180" ></el-table-column>
        <el-table-column prop="note" label="备注" width="180" ></el-table-column>
        <el-table-column label="操作" width="180" >
            <template slot-scope="{ row }">
                <div class="action-btn">
                    <el-upload action="/record_info/photo/upload"
                        multiple
                        :data="{id: row.id}"
                        @on-success="handleSuccess"
                        @on-error="handleError">
                        <a>上传图片</a>
                        <!-- <el-button size="small" type="primary">上传图片</el-button> -->
                    </el-upload>
                    <a @click.stop="edit(row)">编辑</a>
                    <a @click.stop="del(row)">删除</a>
                </div>
            </template>
        </el-table-column>
    </el-table>
    <el-dialog
        title="编辑"
        :visible.sync="dialogVisible"
        width="600px"
        :before-close="handleClose"
        @close="dialogVisible = false">
        <div>
            <span style="margin: 0 20px;">区域：{{currRow.regionName}}</span>
            <span>街道：{{currRow.districtName}}</span>
            <el-form ref="form" :model="modalForm" label-width="80px" :rules="rules" ref="modalForm" style="margin-top: 10px;">
                <el-form-item label="企业" prop="companyName">
                    <el-input v-model="modalForm.companyName"></el-input>
                </el-form-item>
                <el-form-item label="联系人" prop="masterName">
                    <el-input v-model="modalForm.masterName"></el-input>
                </el-form-item>
                <el-form-item label="联系方式1" prop="masterPhone">
                    <el-input v-model="modalForm.masterPhone"></el-input>
                </el-form-item>
                <el-form-item label="联系方式2" prop="slavePhone">
                    <el-input v-model="modalForm.slavePhone"></el-input>
                </el-form-item>
                <el-form-item label="地址" prop="address">
                    <el-input v-model="modalForm.address"></el-input>
                </el-form-item>
                <el-form-item label="备注" prop="note">
                    <el-input v-model="modalForm.note"></el-input>
                </el-form-item>
            </el-form>
            <div class="img-wrapper">
                <i class="el-icon-loading" style="position: absolute;top: 50%; transform: translateY(-50%)"></i>
                <div><img :src="modalForm.photo"></div>
                <div v-for="(item, index) in modalForm.photos" 
                    :key="index" class="img-item" 
                    :style="{ 'background-image': `url(${item})` }"
                    @click="showImg(item)">
                </div>
            </div>
        </div>
        <span slot="footer" class="dialog-footer">
            <el-button @click="dialogVisible = false">关 闭</el-button>
            <el-button type="primary" @click="update">更 新</el-button>
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
        el: '#app',
        data () {
            return {
                currRow: {},
                modalForm: {
                    regionId: '',
                    districtId: '',
                    companyName: '',
                    masterName: '',
                    masterPhone: '',
                    slavePhone: '',
                    address: '',
                    note: '',
                    photos: ''
                },
                formInline: {
                    regionId: '',
                    districtId: '',
                    key: ''
                },
                dialogVisible: false,
                list: [],
                regionList: [],
                districtList: [],
                baseUrl: '${pageContext.request.contextPath}/',
                rules: {
                    companyName: [
                        { required: true, message: '请输入企业名称', trigger: 'change' },
                    ],
                    masterName: [
                        { required: true, message: '请输入联系人', trigger: 'change' }
                    ]
                }
            }
        },
        mounted () {
            this.getRegionData()
        },
        methods: {
            handleSuccess (response, file, fileList) {
                this.$message({ message: '上传成功！', type: 'success' })
            },
            handleError (err, file, fileList) {
                this.$message({ message: err, type: 'error' })
            },
            handleClose () {

            },
            getDistrictList () {
                axiosGet(this.baseUrl + 'region/get/info', { regionType:1,parentId: this.formInline.regionId })
                    .then(res => this.districtList = res)
                    .catch(err => console.log(err))
            },
            getRegionData () {
                axiosGet(this.baseUrl + 'region/get/info')
                    .then(res => {
                        this.regionList = res
                        console.log(this.regionList)
                    })
                    .catch(err => console.log(err))
            },
            uploadImg (row) {

            },
            showImg (item) {

            },
            edit (row) {
                this.currRow = row
                this.modalForm.regionId = row.regionId
                this.modalForm.districtId = row.districtId
                this.modalForm.companyName = row.companyName
                this.modalForm.masterName = row.masterName
                this.modalForm.masterPhone = row.masterPhone
                this.modalForm.slavePhone = row.slavePhone
                this.modalForm.address = row.address
                this.modalForm.note = row.note
                this.modalForm.photos = row.photos.split(',')
                this.dialogVisible = true
            },
            update () {
                axiosPost(this.baseUrl + 'record_info/update', this.modalForm)
                    .then(res => {
                        this.$message({ message: '更新成功！', type: 'success' })
                    })
                    .catch(err => {
                        this.$message({ message: err.message, type: 'error' })
                    })
            },
            del (row) {
                axiosPost(this.baseUrl + 'record_info/delete', row.id)
                    .then(res => {
                        this.$message({ message: '删除成功！', type: 'success' })
                    })
                    .catch(err => {
                        this.$message({ message: err.message, type: 'error' })
                    })
            },
            async search () {
                try {
                    let res = await axiosGet(this.baseUrl + 'record_info/get/info', this.formInline)
                    this.list = res
                } catch (err) {
                    console.log(err)
                }
            },
            importFile () {

            },
            newRecord () {

            }
        }
    })
</script>
</html>
