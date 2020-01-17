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
        
    </style>
</head>
<body>
<div id="main" v-if="isShow">
    <h3>区域/街道管理</h3>
    <el-form :inline="true" :model="formInline">
        <el-form-item label="区域：" prop="regionId">
            <el-select v-model="formInline.regionId" placeholder="区域">
                <el-option label="全部" value=""></el-option>
                <el-option :label="item.regionName" :value="item.regionId" v-for="item in regionList" :key="item.regionId"></el-option>
            </el-select>
        </el-form-item>
        <el-form-item>
            <el-button type="primary" @click="search">搜索</el-button>
            <el-button type="primary" @click="importFile">导入</el-button>
            <el-button type="primary" @click="newRecord">新建</el-button>
            <el-button @click="getTemplateDownload('region')">模板下载</el-button>
        </el-form-item>
    </el-form>
    <el-table :data="list" border>
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
            	<div :class="row.districtList.length > 1 ? 'cell-line':''" class="action-btn" v-for="(item, index2) in row.districtList" :key="row.regionId+ '_' + index2">
              	<a @click.stop="del(row, item)" class="red">删除</a>
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
                    regionId: ''
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
            del (row) {
                axiosPostJSON(this.baseUrl + 'region/delete', { regionId: row.regionId })
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
                    let res = await axiosGet(this.baseUrl + '/region/list', this.formInline)
                    this.list = res.content
                    console.log(this.list)
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
