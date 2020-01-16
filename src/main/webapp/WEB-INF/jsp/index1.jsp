<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>Record Search</title>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap.css">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/global.css">
		<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/bootstrap.min.js"></script>
	</head>
	<style type="text/css">
		body{
			overflow-y:hidden;
			height:100%;
		}
		.clearFloat{
			zoom:1;
		}
		.clearFloat:after{
			content: '';
			clear: both;
			height:0;
			visibility:hidden;
			display: block;
		}
		.main-container{
			width: 100%;
			height: 100%;
			padding: 0;
			padding-top: 52px;
			font-size: 14px;
			font-family:"黑体";
		}

		.navbar {
			position: absolute;
			top: 0;
			left: 0;
			margin: 0;
			width: 100vw;
			height: 52px;
			border-radius: 0;
		}
		
		.main-container .content {
			height: 100%;
			width: 100%;
		}
	</style>
	<body>
		<div class="navbar navbar-inverse">
			<div class="container">
				<div class="navbar-header">
					<buttton class="navbar-toggle collapsed" type="button" data-toggle="collapse" data-target=".navbar-collapse">
						<span class="sr-only">Toggle navigation</span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</buttton><a class="navbar-brand hidden-sm">Record Search</a>
				</div>
				<div class="navbar-collapse collapse" roll="navigation" aria-expanded="false">
					<ul class="nav navbar-nav">
					 	<li class="relationConf">
							<a href="${pageContext.request.contextPath}/search/record_info" target="content-frame">资源管理</a>
						</li>
					 	<li class="relationConf">
							<a href="${pageContext.request.contextPath}/search/region" target="content-frame">区域管理</a>
						</li>
						<li class="relationConf">
							<a href="${pageContext.request.contextPath}/search/project" target="content-frame">项目管理</a>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<div class="main-container">
			<div class="content">
				<iframe src="${pageContext.request.contextPath}/search/record_info" width="100%" height="100%" frameborder="0" id="content_frame" name="content-frame"></iframe>
			</div>
		</div>

	<script type="text/javascript">
		$(".nav li").on("click",function(){
			$(this).addClass("active").siblings().removeClass("active")
		})
		
		$.ajax({
			url:'${pageContext.request.contextPath}/region/get/info',
			type:'GET',
			dataType:'json',
			success:function(res){
				console.log(res)
			},
			error:function(err){
				console.log(err);
			}
		})
		
		$(".dropdown").click(function(){
			if($(".dropdown-menu").css('display')!="none"){
				$(".dropdown-menu").slideUp(300)
			}else{
				$(".dropdown-menu").slideDown(300)
			}
			
		})
	</script>
	</body>
</html>
