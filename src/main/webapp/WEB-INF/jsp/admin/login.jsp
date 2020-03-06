<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>项目管理</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/global.css">
    <link href="https://cdn.bootcss.com/font-awesome/4.5.0/css/font-awesome.min.css" rel="stylesheet">
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
    <script type="text/javascript">
      var _topWin = window;
      while (_topWin != _topWin.parent.window) {
        _topWin = _topWin.parent.window;
      }
      if (window != _topWin)_topWin.document.location.href = '${pageContext.request.contextPath}/admin/login';
    </script>
    <style type="text/css">
        body{
            background: url(./login-bkg.png) repeat;
            height:100%;
            background: -webkit-linear-gradient(left top,#F2F2F2,#F4F4F4);
            background: -o-linear-gradient(bottom right,#F2F2F2,#F4F4F4);
            background: -moz-linear-gradient(bottom right,#F2F2F2,#F4F4F4);
            background: linear-gradient(to bottom right,#F2F2F2,#F4F4F4);
            font-family: 'Aria','Microsoft YaHei','微软雅黑','黑体';
        }
        .login{
            padding: 0;
            position:relative;
            top:150px;
            margin: 0 auto;
            width: 450px;
        }
        .login-error{
            position: relative;
            width: 290px;
            height: 40px;
            top: -10px;
            display: none;
        }
        .form-login{
            width:430px;
            background: #fff;
            margin: 0 auto;
            box-shadow:0 0 5px #ccc;
            border-radius: 5px;
            padding: 15px 0;
        }
        .form-title{
            text-align: center;
            margin-bottom: 35px;
        }
        .form-login .lq-form-group {
            padding: 0 70px;
        }
        input[type=submit]{
            width: 100%;
            height: 40px;
            font-size: 16px;
        }
        input[type=text],input[type=password]{
            display: inline-block;
            margin-bottom: 20px;
            height: 40px;
            width: 290px;
        }
        .form-title {
            color: #5b5959;
        }
    </style>
</head>
<body >
<div class="navbar navbar-inverse">
</div>
<div class="login">
    <form method="post" class="form-login">
        <h2  class="form-title">项目管理入口</h2>
        <div class="lq-alert lq-alert-danger login-error">
            <p><i class="fa fa-warning"></i><span class="lq-alert-content"></span></p>
        </div>
        <div class="lq-form-group">
            <input type="text" name="username" placeholder="请输入用户名" class="lq-form-control" id="username">
        </div>
        <div class="lq-form-group">
            <input type="password" name="password" placeholder="请输入密码" class="lq-form-control" id="password">
        </div>
        <div class="lq-form-group">
            <input type="submit" value="登录" class="lq-btn lq-btn-sm btn-success btn-login"/>
        </div>
    </form>
</div>

<script type="text/javascript">
  $(document).ready(function(){
    $(".btn-login").on("click",function(e){
      e.preventDefault();
      name=$.trim($("#username").val());
      password=$.trim($("#password").val());
      if(name == ''){
        alert("请输入账号！");
        return;
      }

      if(password == ''){
        alert("请输入密码！");
        return;
      }

      var data={
        name:name,
        password:password
      }
      data=JSON.stringify(data);
      $.ajax({
        url:'${pageContext.request.contextPath}/admin/login',
        type:'POST',
        dataType:'json',
        contentType:'application/json',
        data:data,
        success:function(res){
          console.log(res);
          if(res.code=="200"){
              window.location.href="${pageContext.request.contextPath}/";
          }else{
            alert(res.message);
          }
        },
        error:function(err){
          alert(err);
        }
      })
    })
  })
</script>
</body>
</html>
