<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <title>区域管理</title>
    <style type="text/css">
        .content {
            padding: 10px;
        }
    </style>
</head>
<body>
<div id="app">
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
            <el-button>模板下载</el-button>
        </el-form-item>
    </el-form>
    <el-table :data="list" border>
        <el-table-column type="index" label="序号" width="50" ></el-table-column>
        <el-table-column prop="regionName" label="区域"></el-table-column>
        <el-table-column prop="districtName" label="街道">
        	<template slot-scope="{ row }">
              <div :class="row.districtList.length > 1 ? 'cell-line':''" v-for="(item, index2) in row.districtList" :key="`${row.index}_${index2}`">
              </div>
            </template>
        </el-table-column>
        <el-table-column label="操作" width="120" >
            <template slot-scope="{ row }">
              <a @click.stop="del(row)">删除</a>
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
        el: '#app',
        data () {
            return {
                formInline: {
                    regionId: '',
                    districtId: '',
                    key: ''
                },
                list: [],
                regionList: [],
                districtList: [],
                baseUrl: '${pageContext.request.contextPath}/'
            }
        },
        mounted () {
            this.getSelectData()
        },
        methods: {
            getDistrictList () {
                axiosGet(this.baseUrl + 'region/get/info', { regionType:1,parentId: this.formInline.regionId })
                    .then(res => this.districtList = res)
                    .catch(err => console.log(err))
            },
            getSelectData () {
                axiosGet(this.baseUrl + 'region/get/info')
                    .then(res => {
                        this.regionList = res
                        console.log(this.regionList)
                    })
                    .catch(err => console.log(err))
            },
            uploadImg (row) {

            },
            del (row) {

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
