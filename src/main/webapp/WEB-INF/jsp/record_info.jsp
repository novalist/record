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
        .line2 {
            text-overflow: -o-ellipsis-lastline;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }
    </style>
</head>
<body>
<div id="main">
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
        <el-form-item label="状态" prop="status">
            <el-select v-model="formInline.status" placeholder="状态" @change="search(true)">
                <el-option label="全部" value=""></el-option>
                <el-option label="交易" value="START"></el-option>
                <el-option label="非交易" value="CLOSE"></el-option>
            </el-select>
        </el-form-item>
        <el-form-item>
            <el-input v-model="formInline.key" placeholder="关键字"></el-input>
        </el-form-item>
        <el-form-item>
            <el-button type="primary" @click="search(true)">查询</el-button>
            <el-upload action="/record/record_info/upload"
                style="display: inline-block;"
                accept=".xlsx, .xls"
                :show-file-list="false"
                :on-success="handleFileSuccess"
                :on-error="handleFileError">
                <el-button type="primary">导入</el-button>
            </el-upload>
            <el-button type="primary" @click="newRecord" :disabled="!formInline.regionId || !formInline.districtId">新建</el-button>
            <el-button @click="getTemplateDownload('资源信息模版.xlsx')">模板下载</el-button>
        </el-form-item>
    </el-form>
    <el-table :data="list" border :height="tableHeight">
        <el-table-column type="index" label="序号" width="50" align="center"></el-table-column>
        <!-- <el-table-column prop="regionName" label="区域" width="100" ></el-table-column>
        <el-table-column prop="districtName" label="街道" width="100" ></el-table-column> -->
        <el-table-column prop="companyName" label="企业" width="160" ></el-table-column>
        <el-table-column prop="masterName" label="联系人" width="80" ></el-table-column>
        <el-table-column prop="masterPhone" label="联系方式1" width="120" ></el-table-column>
        <el-table-column prop="slavePhone" label="联系方式2" width="90" ></el-table-column>
        <el-table-column prop="address" label="地址" min-width="90"></el-table-column>
        <el-table-column prop="status" label="状态" width="50">
            <template scope="scope">
                <p v-if="scope.row.status=='START'">交易</p>
                <p v-if="scope.row.status=='CLOSE'">非交易</p>
            </template>
        </el-table-column>
        <el-table-column prop="resource" label="资源信息" min-width="120" ></el-table-column>
        <el-table-column prop="note" label="备注" width="120">
            <template slot-scope="{ row }">
                <el-tooltip class="item" effect="dark" :content="row.note" placement="bottom-end">
                    <div class="line2">{{row.note}}</div>
                </el-tooltip>
            </template>
        </el-table-column>
        <el-table-column label="操作" width="150" >
            <template slot-scope="{ row }">
                <div class="action-btn">
                    <el-upload action="/record/record_info/photo/upload"
                        style="display: inline-block;"
                        multiple
                        accept="image/png, image/jpeg"
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
                <el-form-item label="资源信息" prop="resource">
                    <el-input v-model="modalForm.resource" size="small"></el-input>
                </el-form-item>
                <el-form-item label="状态" prop="status">
                    <el-select v-model="modalForm.status" placeholder="状态">
                        <el-option label="交易" value="START"></el-option>
                        <el-option label="非交易" value="CLOSE"></el-option>
                    </el-select>
                </el-form-item>
                <el-form-item label="备注" prop="note">
                    <el-input v-model="modalForm.note" style="width: 200px;" size="small" type="textarea" rows="2" resize="none"></el-input>
                </el-form-item>
            </el-form>
            <div class="img-wrapper">
                <el-popover v-if="imgList.length > 0" 
                    placement="right"
                    width="420"
                    trigger="hover">
                    <img width="400" height="400" :src="'/record/photo/'+currImgUrl" />
                    <img slot="reference" :src="'/record/photo/'+currImgUrl" width="200" height="200">
                </el-popover>
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
                isOpenDelModal: false,
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
                    resource: '',
                    status: '',
                    note: ''
                },
                formInline: {
                    regionId: '',
                    districtId: '',
                    status: '',
                    key: '',
                    pageSize: 15,
                    pageNum: 1
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
                },
                tableHeight: 0
            }
        },
        mounted () {
            this.getRegionData()
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
            openDelModal (row) {
                this.currRow = row
                this.isOpenDelModal = true
            },
            getTemplateDownload (params) {
                window.open('${pageContext.request.contextPath}/common/template/download?fileName=' + params, '_self')
            },
            closeAddModal () {
                this.modalForm = {
                    regionId: '',
                    districtId: '',
                    companyName: '',
                    masterName: '',
                    masterPhone: '',
                    slavePhone: '',
                    address: '',
                    resource: '',
                    status: '',
                    note: ''
                }
                this.$refs.modalForm.resetFields()
                this.isOpenAddModal = false
            },
            handleClose(done) {
                this.modalForm = {
                    regionId: '',
                    districtId: '',
                    companyName: '',
                    masterName: '',
                    masterPhone: '',
                    slavePhone: '',
                    resource: '',
                    address: '',
                    status: '',
                    note: ''
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
            handleSuccess (response, file, fileList) {
                this.$message({ message: '上传成功！', type: 'success' })
                this.search()
            },
            handleError (err, file, fileList) {
                this.$message({ message: err, type: 'error' })
            },
            getDistrictList () {
                axiosGet(this.baseUrl + 'region/get/info', { regionType:1, parentId: this.formInline.regionId })
                    .then(res => this.districtList = res)
                    .catch(err => {
                        this.$message({ message: err.message, type: 'error' })
                        console.log(err)
                    })
            },
            getRegionData () {
                axiosGet(this.baseUrl + 'region/get/info', { regionType: 0 })
                    .then(res => this.regionList = res)
                    .catch(err => {
                        this.$message({ message: err.message, type: 'error' })
                        console.log(err)
                    })
            },
            postDelImg (item) {
                axiosPost(this.baseUrl + 'record_info/photo/delete', { id: this.currRow.id, photoName: item })
                    .then(res => {
                    this.$message({ message: '删除成功！', type: 'success' })
                    let index = this.imgList.findIndex(item1 => item == item1)
                    this.imgList.splice(index, 1)
                    if (this.currImgUrl == item) {
                        if (this.imgList[index]) this.currImgUrl = this.imgList[index]
                        else this.currImgUrl = this.imgList[0]
                    }
                    this.search()
                    })
                    .catch(err => {
                        this.$message({ message: err.message, type: 'error' })
                    })
            },
            delImg (item) {
                this.$confirm('确定删除？', '提示', {
                    distinguishCancelAndClose: true,
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning',
                }).then(() => {
                   this.postDelImg(item)
                }).catch(action => {
                    // ...
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
                this.modalForm.status = row.status
                this.modalForm.note = row.note
                this.modalForm.resource = row.resource
                this.imgList = row.photos ? row.photos.split(',') : []
                this.currImgUrl = this.imgList[0]
                this.isOpenAddModal = true
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
                    let res = await axiosPostJSON(this.baseUrl + 'record_info/update', { ...this.modalForm, id: this.currRow.id })
                    this.closeAddModal()
                    this.$message({ message: '保存成功！', type: 'success' })
                    this.search()
                } catch (err) {
                    console.log(err)
                    err.message && this.$message({ message: err.message, type: 'error' })
                }
            },
            async addRecord () {
                try {
                    await this.$refs.modalForm.validate()
                    let res = await axiosPostJSON(this.baseUrl + 'record_info/insert', this.modalForm)
                    this.closeAddModal()
                    this.$message({ message: '新建成功！', type: 'success' })
                    this.search()
                } catch (err) {
                    console.log(err)
                    err.message && this.$message({ message: err.message, type: 'error' })
                }
            },
            del () {
                this.isOpenDelModal = false
                axiosPost(this.baseUrl + 'record_info/delete', { id: this.currRow.id })
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
                    let res = await axiosGet(this.baseUrl + 'record_info/get/info', this.formInline)
                    this.list = res.content
                    this.total = res.totalCount
                    if (this.currRow.id) {
                        let row = this.list.find(item => item.id == this.currRow.id)
                        if (row && this.isOpenAddModal) {
                            this.currRow = row
                            this.imgList = row.photos ? row.photos.split(',') : []
                        }
                    }
                } catch (err) {
                    console.log(err)
                }
            },
            newRecord () {
                this.addModalTitle = '新建'
                this.imgList = []
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
