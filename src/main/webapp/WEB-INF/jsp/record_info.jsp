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
    <title>资源管理</title>
    <style type="text/css">
        .add-form .el-form-item {
            margin-bottom: 15px;
        }
        .add-form .el-input {
            width: 200px;
        }
        .img-wrapper {
            text-align: center;
            position: absolute;
            right: 30px;
            top: 90px;
            width: 240px;
            height: 240px;
        }
        .imgs {
            text-align: left;
            width: 260px;
            overflow: auto;
            height: 120px;
            margin-top: 10px;
        }
        .img-item .el-icon-close {
            position: absolute;
            right: 0;
            cursor: pointer;
            padding: 0 0 5px 5px;
            font-size: 16px;
            color: red;
            font-weight: bold;
        }
        .img-item .el-icon-close:hover {
            opacity: 0.7;
        }
        .el-dialog__body {
            padding: 20px;
        }
        .img-item {
            background-repeat: no-repeat;
            width: 60px;
            height: 60px;
            display: inline-block;
            background-size: cover;
            border: 1px solid #DCDEE2;
            cursor: pointer;
            position: relative;
        }
        .img-item.active {
            border-color: #3d99ed;
        }
    </style>
</head>
<body>
<div id="main" v-if="isShow">
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
            <el-upload action="/record/record_info/upload"
                style="display: inline-block;"
                multiple
                :show-file-list="false"
                :on-success="handleFileSuccess"
                :on-error="handleFileError">
                <el-button type="primary">导入</el-button>
            </el-upload>
            <el-button type="primary" @click="newRecord" :disabled="!formInline.regionId || !formInline.districtId">新建</el-button>
            <el-button @click="getTemplateDownload('资源信息模版.xlsx')">模板下载</el-button>
        </el-form-item>
    </el-form>
    <el-table :data="list" border>
        <el-table-column type="index" label="序号" width="50" ></el-table-column>
        <el-table-column prop="regionName" label="区域" width="100" ></el-table-column>
        <el-table-column prop="districtName" label="街道" width="100" ></el-table-column>
        <el-table-column prop="companyName" label="企业" width="180" ></el-table-column>
        <el-table-column prop="masterName" label="联系人" width="120" ></el-table-column>
        <el-table-column prop="masterPhone" label="联系方式1" width="120" ></el-table-column>
        <el-table-column prop="slavePhone" label="联系方式2" width="120" ></el-table-column>
        <el-table-column prop="address" label="地址"></el-table-column>
        <el-table-column prop="resource" label="资源信息" width="180" ></el-table-column>
        <el-table-column prop="note" label="备注" width="180" ></el-table-column>
        <el-table-column label="操作" width="200" >
            <template slot-scope="{ row }">
                <div class="action-btn">
                    <el-upload action="/record/record_info/photo/upload"
                        style="display: inline-block;"
                        multiple
                        :show-file-list="false"
                        :data="{id: row.id}"
                        :on-success="handleSuccess"
                        :on-error="handleError">
                        <a>上传图片</a>
                    </el-upload>
                    <a @click.stop="edit(row)">编辑</a>
                    <a class="red" @click="openDelModal(row)">删除</a>
                </div>
            </template>
        </el-table-column>
    </el-table>
    <template v-if="isShow">      
        <el-dialog
            :visible.sync="isOpenAddModal"
            width="600px"
            :before-close="handleClose">
            <span slot="title">{{addModalTitle}}</span>
            <div>
                <span style="margin: 0 40px;">区域：{{currRow.regionName}}</span>
                <span>街道：{{currRow.districtName}}</span>
                <el-form ref="modalForm" :model="modalForm" label-width="80px" :rules="rules" style="margin-top: 10px;" class="add-form">
                    <el-form-item label="企业" prop="companyName">
                        <el-input v-model="modalForm.companyName" size="small"></el-input>
                    </el-form-item>
                    <el-form-item label="联系人" prop="masterName">
                        <el-input v-model="modalForm.masterName" size="small"></el-input>
                    </el-form-item>
                    <el-form-item label="联系方式1" prop="masterPhone">
                        <el-input v-model="modalForm.masterPhone" size="small"></el-input>
                    </el-form-item>
                    <el-form-item label="联系方式2" prop="slavePhone">
                        <el-input v-model="modalForm.slavePhone" size="small"></el-input>
                    </el-form-item>
                    <el-form-item label="地址" prop="address">
                        <el-input v-model="modalForm.address" size="small"></el-input>
                    </el-form-item>
                    <el-form-item label="备注" prop="note">
                        <el-input v-model="modalForm.note" size="small"></el-input>
                    </el-form-item>
                </el-form>
                <div class="img-wrapper">
                    <img v-if="imgList.length > 0" :src="'/record/photo/'+currImgUrl" width="200" height="200">
                    <div class="imgs">
                        <div v-for="(item, index) in imgList" :key="index" class="img-item" :class="{'active': currImgUrl == item}"
                            :style="{ 'background-image': 'url(/record/photo/' + item + ')' }"
                            @click="showImg(item)">
                            <i class="el-icon-close" @click="delImg(item)"></i>
                        </div>
                    </div>
                </div>
            </div>
            <span slot="footer" class="dialog-footer">
                <el-button @click="closeAddModal">关 闭</el-button>
                <el-button type="primary" @click="update">更 新</el-button>
            </span>
        </el-dialog>
        <el-dialog
          title="提示"
          :visible.sync="isOpenDelModal"
          width="300px">
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
                isOpenDelModal: false,
                isShow: false,
                addModalTitle: '新建',
                currRow: {},
                modalForm: {
                    regionId: '',
                    districtId: '',
                    companyName: '',
                    masterName: '',
                    masterPhone: '',
                    slavePhone: '',
                    address: '',
                    note: ''
                },
                formInline: {
                    regionId: '',
                    districtId: '',
                    key: ''
                },
                currImgUrl: '',
                isOpenAddModal: false,
                list: [],
                imgList: [],
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
            this.$nextTick(() => this.isShow = true)
        },
        methods: {
            openDelModal (row) {
                this.currRow = row
                this.isOpenDelModal = true
            },
            getTemplateDownload (params) {
                window.open('${pageContext.request.contextPath}/common/template/download?fileName=' + params, '_self')
            },
            closeAddModal () {
                this.$refs.modalForm.resetFields()
                this.isOpenAddModal = false
            },
            handleClose(done) {
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
            handleSuccess (response, file, fileList) {
                this.$message({ message: '上传成功！', type: 'success' })
                this.search()
            },
            handleError (err, file, fileList) {
                this.$message({ message: err, type: 'error' })
            },
            getDistrictList () {
                axiosGet(this.baseUrl + 'region/get/info', { regionType:1,parentId: this.formInline.regionId })
                    .then(res => this.districtList = res)
                    .catch(err => {
                        this.$message({ message: err.message, type: 'error' })
                        console.log(err)
                    })
            },
            getRegionData () {
                axiosGet(this.baseUrl + 'region/get/info')
                    .then(res => this.regionList = res)
                    .catch(err => {
                        this.$message({ message: err.message, type: 'error' })
                        console.log(err)
                    })
            },
            delImg (item) {
                axiosPost(this.baseUrl + '/record_info/photo/delete', { id: this.currRow.id, photoName: item })
                    .then(res => {
                        this.$message({ message: '删除成功！', type: 'success' })
                        this.search()
                    })
                    .catch(err => {
                        this.$message({ message: err.message, type: 'error' })
                    })
            },
            showImg (item) {
                 this.currImgUrl = item
            },
            edit (row) {
                this.addModalTitle = '编辑'
                this.currRow = row
                this.modalForm.regionId = row.regionId
                this.modalForm.districtId = row.districtId
                this.modalForm.companyName = row.companyName
                this.modalForm.masterName = row.masterName
                this.modalForm.masterPhone = row.masterPhone
                this.modalForm.slavePhone = row.slavePhone
                this.modalForm.address = row.address
                this.modalForm.note = row.note
                this.imgList = row.photos ? row.photos.split(',') : []
                this.currImgUrl = this.imgList[0]
                this.isOpenAddModal = true
            },
            async update () {
                try {
                    await this.$refs.modalForm.validate()
                    let url = this.addModalTitle == '编辑' ? 'record_info/update' : 'record_info/insert'
                    let res = await axiosPostJSON(this.baseUrl + url, { ...this.modalForm, id: this.modalForm.id })
                    console.log(res)
                    this.closeAddModal()
                    this.$message({ message: '保存成功！', type: 'success' })
                    this.search()
                } catch (err) {
                    console.log(err)
                    err.message && this.$message({ message: err.message, type: 'error' })
                }
            },
            del () {
                console.log('currRow', this.currRow)
                this.isOpenDelModal = true
                axiosPost(this.baseUrl + 'record_info/delete', { id: this.currRow.id })
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
                    let res = await axiosGet(this.baseUrl + 'record_info/get/info', this.formInline)
                    this.list = res.content
                    if (this.currRow.id) {
                        let row = this.list.find(item => item.id == this.currRow.id)
                        this.currRow = row
                    }
                    console.log(this.currRow)
                } catch (err) {
                    console.log(err)
                }
            },
            newRecord () {
                this.addModalTitle = '新建'
                this.modalForm.regionId = this.formInline.regionId
                this.modalForm.districtId = this.formInline.districtId
                let region = this.regionList.find(item => item.regionId == this.formInline.regionId)
                this.currRow.regionName = region.regionName || ''
                let district = this.districtList.find(item => item.regionId == this.formInline.districtId)
                this.currRow.districtName = district.regionName || ''
                this.isOpenAddModal = true
            }
        }
    })
</script>
</html>
