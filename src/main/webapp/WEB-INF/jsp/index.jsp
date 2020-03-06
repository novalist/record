<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%><!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <title>资源管理</title>
    <style type="text/css">
        html, body, #app {
            padding: 0;
            margin: 0;
            height: 100%;
        }
        .el-menu-item.is-active {
            font-weight: bold;
        }
        .iframe {
            height: calc(100% - 65px);
        }
        #app {
            display: none;
        }
        .el-menu {
            width: calc(100% - 60px);
            margin-left: 60px;
        }
        .logo {
            position: absolute;
            width: 60px;
            height: 60px;
        }
    </style>
</head>
<body>
<div id="app">
    <div style="background-color: #252b39;height: 60px;">
        <img src="${pageContext.request.contextPath}/static/img/logo.jpg" class="logo">
        <el-menu :default-active="activeIndex" class="el-menu" mode="horizontal" @select="handleSelect" background-color="#252b39" text-color="#ffffff" active-text-color="#409EFF">
            <el-menu-item index="record_info">资源管理</el-menu-item>
            <el-menu-item index="region">区域管理</el-menu-item>
            <el-menu-item index="project">项目管理</el-menu-item>
        </el-menu>
    </div>
    <iframe :src="src" width="100%" frameborder="0" class="iframe"></iframe>
</div>
</body>
<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
<script src="https://unpkg.com/element-ui/lib/index.js"></script>
<script>
    let app = new Vue({
        el: '#app',
        data () {
            return {
                activeIndex: 'record_info',
                src: '${pageContext.request.contextPath}/search/record_info'
            }
        },
        mounted () {
            document.getElementById('app').style.display = 'inherit'
        },
        methods: {
            handleSelect(key) {
                console.log(key)
                this.src = '${pageContext.request.contextPath}/search/' + key
            }
        }
    })
</script>
</html>
