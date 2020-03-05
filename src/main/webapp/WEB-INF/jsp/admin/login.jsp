<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <title>登陆</title>
    <link href="${pageContext.request.contextPath}/static/images/gyc_icon.ico" rel="shortcut icon" />
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/css/bootstrap.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/global.css">
    <link href="https://at.alicdn.com/t/font_559102_e1m7ym09tore8kt9.css" rel="stylesheet">
    <style type="text/css">
        html,body{
            background-color:#eeeeee;
        }
        .login-body{
            margin:0;
            padding:0;
        }
        a,a:hover{
            text-decoration:none;
        }
        .login-body .content{
            width:100%;
            height:718px;
            background-size:cover;
            background-color:#2589FF;
            background-position:center top;
            background-repeat:no-repeat;
            background-image:url('${pageContext.request.contextPath}/static/images/login-bk.jpg');
            position:relative;
            margin-bottom: 22px;
        }
        .login-body .footer{
            text-align:center;
            font-size: 12px;
            color:#7d8997;
        }
        .content .login-header{
            width:76%;
            height:55px;
            margin: 0 auto;
            padding:8px 20px;
            background-color: transparent;
        }
        .content .login-header img{
            transform:scale(1.3);
            -webkit-transform:scale(1.3);
            -moz-transform:scale(1.3);
            -o-transform:scale(1.3);
        }
        .content  form{
            width: 350px;
            min-height: 424px;
            padding: 42px 25px 54px;
            position:absolute;
            top:50%;
            left: 60%;
            transform:translateY(-50%);
            background-color:#fff;
        }
        .content form .end{
            width:100%;
            font-size: 16px;
            position:relative;
            margin-bottom: 44px;
        }
        .content form .end .title-span{
            color:#2d2f33;
        }
        .content form .end .title-a{
            font-size: 14px;
            position:absolute;
            right: 3px;
            top: 2px;
        }
        .content form .end .check {
            font-size:14px;
        }
        .content form .end .check .icon{
            font-size: 14px;
            margin-right: 5px;
        }
        .content form .end .error{
            color:#f00;
            font-size:12px;
            position:absolute;
            bottom: -28px;
            left:0;
            display:none;
        }
        .content form .form-group {
            position:relative;
            font-size: 14px;
            margin-bottom: 20px;
        }
        .content form .form-group .icon{
            color:#999;
            font-size:24px;
            position: absolute;
            left: 5px;
            top: 2px;
        }
        .content form .form-group .form-control{
            height: 40px;
            font-size: 14px;
            padding-left: 36px;
        }
        .content form #btn-login{
            background-color:#3d99ed;
            color:#fff;
            margin-top: 10px;
            margin-bottom: 18px;
            width:100%;
            height: 40px;
            border-color: #3d99ed;
        }
    </style>
    <style type="text/css">
        @media screen and (max-width:1440px) {
            .login-body .content{
                height: 538px;
            }
        }
    </style>
</head>
<body class="login-body">
<div class="content">
    <div class="login-header">
        <img src="${pageContext.request.contextPath}/static/img/logo.png" alt="Logo" id="logo">
    </div>
    <form action="record/admin/login" method="post" class="form-login">
        <p class="end">
            <span class="title-span">账号登录</span>
            <span class="error login-error">${error}</span>
        </p>
        <div class="form-group">
            <i class="iconfont icon-msnui-tel icon"></i>
            <input type="text" class="form-control required" name="username" errorTitle="用户名" autocomplete="new-password" placeholder="请输入用户名">
        </div>
        <div class="form-group">
            <i class="iconfont icon-mima icon"></i>
            <input type="password" class="form-control required" autocomplete="new-password" errorTitle="密码" name="password" placeholder="请输入密码">
        </div>
        <input type="submit" class="btn btn-primary" id="btn-login" value="登录">
    </form>
</div>
<div class="footer">
    <p>有限公司</p>
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/common.js"></script>
</body>
</html>
