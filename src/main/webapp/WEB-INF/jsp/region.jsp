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
    <title>区域管理</title>
    <style type="text/css">
        .item {
        	margin: 0 10px 10px;
        }
    </style>
</head>
<body>
<div id="main" v-if="isShow">
    <h3>区域/街道管理</h3>
    <el-form :inline="true" :model="searchForm">
        <el-form-item label="区域：" prop="regionId">
            <el-select v-model="searchForm.regionId" placeholder="区域">
                <el-option label="全部" value=""></el-option>
                <el-option :label="item.regionName" :value="item.regionId" v-for="item in regionList" :key="item.regionId"></el-option>
            </el-select>
        </el-form-item>
        <el-form-item>
            <el-button type="primary" @click="search">搜索</el-button>
            <el-upload action="/record/region/upload"
                style="display: inline-block;"
                multiple
                :show-file-list="false"
                :on-success="handleFileSuccess"
                :on-error="handleFileError">
                <el-button type="primary">导入</el-button>
            </el-upload>
            <el-button type="primary" @click="isOpenAddModal = true">新建</el-button>
            <el-button @click="getTemplateDownload('区域街道模版.xlsx')">模板下载</el-button>
        </el-form-item>
    </el-form>
    <el-table :data="list" border v-loading="loading">
        <el-table-column type="index" label="序号" width="50" ></el-table-column>
        <el-table-column prop="regionName" label="区域" width="240" ></el-table-column>
        <el-table-column prop="districtName" label="街道">
        	<template slot-scope="{ row }">
              <div :class="row.districtList.length > 1 ? 'cell-line':''" v-for="(item, index2) in row.districtList" :key="row.regionId+ '_' + index2">
              	{{item.regionName}}
              </div>
            </template>
        </el-table-column>
        <el-table-column label="操作" width="120" >
            <template slot-scope="{ row }">
             	<div v-if="!row.districtList || row.districtList.length == 0" class="action-btn"><a @click.stop="del(row.regionId)" class="red">删除</a></div>
             	<div v-else :class="row.districtList.length > 1 ? 'cell-line':''" class="action-btn" v-for="(item, index2) in row.districtList" :key="row.regionId+ '_' + index2">
              		<a @click.stop="del(item.regionId)" class="red">删除</a>
             	</div>
            </template>
        </el-table-column>
    </el-table>
     <template v-if="isShow">      
        <el-dialog
            :visible.sync="isOpenAddModal"
            width="410px"
            :before-close="handleClose">
            <span slot="title">新建</span>
            <div class="item">
            	<span>区域</span>
            	<el-input v-model="addForm.regionName" size="small" style="width: 120px;margin-left: 5px;"></el-input>
            	<el-button type="primary" 
            		size="small" 
            		@click="newRegion(0)" 
            		:disabled="!addForm.regionName" 
            		:loading="regionAdding">新建</el-button>
            </div>
            <div class="item">
            	<span>街道</span>
            	<el-select v-model="addForm.regionId" placeholder="街道" size="small" style="width: 120px;margin-left: 5px;">
					<el-option :label="item.regionName" :value="item.regionId" v-for="item in regionList" :key="item.regionId"></el-option>
	            </el-select>
            	<el-input v-model="addForm.districtName" size="small" style="width: 120px;"></el-input>
            	<el-button size="small" 
            		type="primary" 
            		@click="newRegion(1)" 
            		:disabled="!addForm.districtName || !addForm.regionId"
            		:loading="districtAdding">新建</el-button>
            </div>
            <span slot="footer" class="dialog-footer">
                <el-button @click="closeAddModal">关 闭</el-button>
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
            	loading: false,
            	regionAdding: false,
            	districtAdding: false,
            	isOpenAddModal: false,
            	isShow: false,
            	searchForm: {
					regionId: ''
            	},
                addForm: {
                    regionId: '',
                    regionName: '',
                    districtName: ''
                },
                list: [],
                regionList: [],
                districtList: [],
                baseUrl: '${pageContext.request.contextPath}/'
            }
        },
        mounted () {
            this.getSelectData()
            this.isShow = true
        },
        methods: {
        	async newRegion (regionType) {
        		if (regionType == 0 && !this.addForm.regionName) {
        			this.$message({ message: '请输入区域名称', type: 'error' })
        			return
        		} else if (regionType == 1) {
        			if (!this.addForm.regionId) {
        				this.$message({ message: '请选择街道区域', type: 'error' })
        				return
        			}
        			else if (!this.addForm.districtName) {
        				this.$message({ message: '请输入街道名称', type: 'error' })
        				return
        			}
        		}
        		try {
        			let params
        			if (regionType == 0) {
        				params = {
        					parentId: 0,
	        				regionName: this.addForm.regionName,
	        				regionType
        				}
        				this.regionAdding = true
        			} else {
        				params = {
        					parentId: this.addForm.regionId,
	        				regionName: this.addForm.districtName,
	        				regionType
        				}
        				this.districtAdding = true
        			}
        			let res = await axiosPostJSON('/record/region/insert', params)
        			this.$message({ message: '新建成功！', type: 'success' })
        			if (regionType == 0) {
        				this.getSelectData()
        				this.regionAdding = false
        				this.addForm.regionName = ''
        			} else {
        				this.districtAdding = false
        				this.addForm.regionId = ''
        				this.addForm.districtName = ''
        			}
 					this.search()
        		} catch (err) {
        			console.log(err)
        			this.$message({ message: err.message, type: 'error' })
        			regionType == 0 ? this.regionAdding = false : this.districtAdding = false
        		}
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
        	handleClose(done) {
                this.addForm = {
                    regionId: '',
                    regionName: '',
                    districtName: ''
                }
                done()
            },
        	closeAddModal () {
                this.addForm = {
                    regionId: '',
                    regionName: '',
                    districtName: ''
                }
                this.isOpenAddModal = false
            },
        	getTemplateDownload (params) {
			    window.open('${pageContext.request.contextPath}/common/template/download?fileName=' + params, '_self')
			},
            getSelectData () {
                axiosGet(this.baseUrl + 'region/get/info')
                    .then(res => {
                        this.regionList = res
                    })
                    .catch(err => console.log(err))
            },
            del (regionId) {
                axiosPostJSON(this.baseUrl + 'region/delete', { regionId })
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
                	this.loading = true
                    let res = await axiosGet(this.baseUrl + 'region/list', this.searchForm)
                    this.list = res.content
                } catch (err) {
                    console.log(err)
                } finally {
                	this.loading = false
                }
            }
        }
    })
</script>
</html>
