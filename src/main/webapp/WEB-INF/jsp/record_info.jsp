<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>资源管理</title>
		<link href="https://cdn.bootcss.com/font-awesome/4.5.0/css/font-awesome.min.css" rel="stylesheet">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap.css">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/global.css">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/xxx-components.css">
		<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/common.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/md5.js"></script>
		<style type="text/css">
			body {
				padding: 15px;
			}

			select,
			input[type=text],
			input[type=password],
			select#way,
			select.shipping {
				display: inline-block;
				width: 60%;
			}

			label {
				font-weight: normal;
			}

			.lq-btn {
				margin: 5px;
			}

			.pop {
				width: 100%;
				height: 100%;
				position: fixed;
				margin: -15px;
				background: rgba(0, 0, 0, 0.5);
				z-index: 998;
				display: none;
			}

			.pop_content {
				width: 420px;
				height: 300px;
				border: 1px solid #ccc;
				box-shadow: 0px 0px 2px rgba(0, 0, 0, 0.7);
				border-radius: 3px;
				background: #fff;
				position: absolute;
				top: 150px;
				left: 50%;
				margin-left: -210px;
				z-index: 999;
				padding: 10px 5%;
			}

			table.lq-table th {
				word-break: keep-all;
			}

			table.lq-table td {
				word-break: break-all;
			}


			#modify .modal-content {
				width: 500px;
				margin: 0 auto;
				margin-top: 200px;
			}

			#modify .row {
				padding: 0 20px;
			}

			.alert-danger {
				display: none;
			}

			.dropdown-menu li {
				margin-top: 5px;
			}

			td.shippingAppSecret {
				max-width: 200px;
				word-break: break-all;
			}
			.file {
				position: relative;
				left: -70px;
				width: 66px;
				height: 30px;
				opacity: 0;
				cursor: pointer;
			}
			.fileName {
				position: relative;
				top: 5px;
				left: -65px;
			}
			.hasDiy {
				position: relative;
			}

			.hasDiy:hover>ul.items {
				display: block;
				 !important;
				animation: fadeIn .5s;
				-webkit-animation: fadeIn .5s;
			}

			.hasDiy .items {
				width: 200px;
				position: absolute;
				background: #fff;
				padding: 15px 8px;
				list-style: none;
				top: 30px;
				left: 0px;
				border: 1px solid rgba(0, 0, 0, .2);
				border-radius: 6px;
				box-shadow: 0 5px 10px rgba(0, 0, 0, .2);
				z-index: 999;
				display: none;
			}

			.hasDiy .items li {
				margin-bottom: 5px;
			}

			.hasDiy .items:before {
				content: '';
				width: 10px;
				height: 10px;
				display: block;
				border-bottom: 10px solid rgba(0, 0, 0, .2);
				border-left: 10px solid transparent;
				border-right: 10px solid transparent;
				position: absolute;
				left: 30px;
				top: -10px;
			}

			.hasDiy .items:after {
				content: '';
				width: 8px;
				height: 8px;
				display: block;
				border-bottom: 8px solid #fff;
				border-left: 8px solid transparent;
				border-right: 8px solid transparent;
				position: absolute;
				left: 32px;
				top: -8px;
			}

			.hasDiy .items p {
				display: inline-block;
				word-break: break-all;
			}

			@keyframes fadeIn {
				0% {
					opacity: 0;
				}

				50% {
					opacity: 0;
				}

				100% {
					opacity: 1;
				}
			}

			@-webkit-keyframes fadeIn {
				0% {
					opacity: 0;
				}

				50% {
					opacity: 0;
				}

				100% {
					opacity: 1;
				}
			}

			@-moz-keyframes fadeIn {
				0% {
					opacity: 0;
				}

				50% {
					opacity: 0;
				}

				100% {
					opacity: 1;
				}
			}

			#available {
				width: 20%;
				margin: 300px auto;
			}

			.filter {
				height: 35px;
				border: 1px solid #ccc;
				paddding: 2px;
				line-height: 35px;
				border-radius: 50px;
				max-width: 200px;
				margin-left: 10px;
				float: right;
			}

			.search_icon {
				display: inline-block;
				height: 35px;
				width: 35px;
				position: absolute;
				right: 0;
				vertical-align: middle;
				color: #dbdbdb;
				transform: scale(0.6);
			}

			.page-header {
				position: relative;
			}

			.xxx-table {
				width: 100%;
			}

			.xxx-table td {
				font-size: 13px;
				padding: 7px 10px;
			}

			.lq-form-group {
				display: flex;
				align-items: center;
			}

			.lq-form-group label {
				width: 6em;
				text-align: right;
				margin: 0;
			}
		</style>
	</head>

	<body>
		<div class="modal-wrap mw-loading">
			<div class="modal-content mc-loading">
				<i class="fa fa-spinner fa-spin" id="loading"></i>
			</div>
		</div>
		<div class="container">
			<div class="page-header">
				<h2>资源查询</h2>
			</div>

			<div class="modal fade" id="modify">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">&times;</button>
						<h4 class="modal-title">更新信息</h4>
					</div>
					<div class="modal-body">
						<div class="row">
							<div class="col-md-4">
								<div class="lq-form-group">
									<label for="ed_regionName">区域:</label>
									<input type="text" class="lq-form-control" id="ed_regionName" param="regionName" readonly>
								</div>
								<div class="lq-form-group">
									<label for="ed_districtName">街道:</label>
									<input type="text" class="lq-form-control" id="ed_districtName" param="districtName" readonly>
								</div>
								<div class="lq-form-group">
									<label for="ed_companyName">企业:</label>
									<input type="text" class="lq-form-control" id="ed_companyName" param="companyName">
								</div>
								<div class="lq-form-group">
									<label for="ed_masterName">联系人:</label>
									<input type="text" class="lq-form-control" id="ed_masterName" param="masterName">
								</div>
								<div class="lq-form-group">
									<label for="ed_masterPhone">联系方式1:</label>
									<input type="text" class="lq-form-control" id="ed_masterPhone" param="masterPhone">
								</div>
								<div class="lq-form-group">
									<label for="ed_slavePhone">联系方式2:</label>
									<input type="text" class="lq-form-control" id="ed_slavePhone" param="slavePhone">
								</div>
								<div class="lq-form-group">
									<label for="ed_address">地址:</label>
									<input type="text" class="lq-form-control" id="ed_address" param="address">
								</div>
								<div class="lq-form-group">
									<label for="ed_resource">资源信息:</label>
									<input type="text" class="lq-form-control" id="ed_resource" param="resource">
								</div>
								<div class="lq-form-group">
									<label for="ed_note">备注:</label>
									<input type="text" class="lq-form-control" id="ed_note" param="note">
								</div>
							</div>
							<div class="ed lq-col-12 alert alert-danger">
								<p><i class="fa fa-warning"></i><span class="lq-alert-content"></span></p>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<button type="buttton" class="btn btn-default" id="cancel">取消</button>
						<input type="hidden" id="ed_id">
						<button type="button" class="btn btn-primary subModify" id="confirm">提交</button>
					</div>
				</div>
			</div>



			<div class="lq-col-3">
				<div class="lq-form-group">
					<label for="region">区域：</label>
					<select class="lq-form-control region" id="region" arical-label="regionId">
						<option value="0">全部</option>
					</select>
				</div>
			</div>
			<div class="lq-col-3">
				<div class="lq-form-group">
					<label for="district">街道：</label>
					<select class="lq-form-control district" id="district" arical-label="districtId">
						<option value="0">全部</option>
					</select>
				</div>
			</div>
			<div class="lq-col-3">
				<div class="lq-form-group">
					<label for="key" style="text-indent:2rem;">关键字：</label>
					<input type="text" class="lq-form-control" id="key" arial-label="key">
				</div>

			</div>
			<div class="lq-col-3">

				<form id="upload" action="../record_info/upload" method="post" enctype="multipart/form-data" style="display:inline">
					<button class="lq-btn lq-btn-sm lq-btn-primary select">选取文件</button>
					<input class="file" type="file" name="file"  style="display:inline-block;"/>
					<span class="fileName">
						<c:if test="${resMap.excel_note != '' and resMap.excel_note != null}">
							<c:out value="${resMap.excel_note}"></c:out>
						</c:if>
					</span>
					<button class="lq-btn lq-btn-sm lq-btn-primary">导入</button>
				</form>
				<a class="download" href="../common//template/download?fileName=test.xlsx">模板下载</a>
			</div>
			<div class="lq-col-3" style="margin-bottom: 10px;float: right;">
				<button class="btn btn-primary btn-sm search" sytle="margin:0">搜索</button>
				<button class="btn btn-primary btn-sm export" sytle="margin:0" id="export">导出</button>
			</div>
			<div class="lq-col-12 alert alert-danger">
				<p><i class="fa fa-warning"></i><span class="lq-alert-content"></span></p>
			</div>
			<table class="lq-table">
				<thead>
					<th>序号</th>
					<th>区域</th>
					<th>街道</th>
					<th>企业</th>
					<th>联系人</th>
					<th>联系方式1</th>
					<th>联系方式2</th>
					<th>地址</th>
					<th>资源信息</th>
					<th>备注</th>
					<th>操作</th>
				</thead>
				<tbody class="tbody"></tbody>
			</table>
			<img src="../record_info/show?fileName=2.jpeg">
		</div>

		<div id="dialog-review-branch" class="xxx-dialog--wrapper" style="display: none;">
			<div class="xxx-dialog">
				<header class="xxx-dialog--header">
					<h1 class="xxx-dialog--title">查看网点信息</h1>
				</header>

				<main class="xxx-dialog--body"></main>

				<div class="xxx-dialog--footer">
					<button class="xxx-button xxx-button--primary btn-confirm">确定</button>
				</div>
			</div>
		</div>
	</body>

	<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/common.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/tools.js"></script>
	<script type="text/javascript">
		$("body").on("click", function () {
			$('.dropdown-menu', window.parent.document).css({
				"display": "none"
			});
		})

		$(document).ready(function () {
			var asyReloadUrl = '${pageContext.request.contextPath}/record_info/get/info?';
			var regionUrl = '${pageContext.request.contextPath}/region/get/info';
			var updateUrl = '${pageContext.request.contextPath}/record_info/update';
			var addUrl = '${pageContext.request.contextPath}/user/shippingApp/add';

			var tableData = [];

			function bindSelectRegion(id) {
				//获取快递下拉框
				$.ajax({
					url: '${pageContext.request.contextPath}/region/get/info?regionType=0',
					type: 'GET',
					dataType: 'json',
					contentType: 'application/json',
					success: function (res) {
						console.log(res);
						var option = '<option value="0">全部</option>';
						if (res.data.length > 0) {
							for (var i in res.data) {
								option += '<option value="' + res.data[i].regionId + '">' + res.data[i].regionName + '</option>';
							}
							$(id).html(option);
						}
					},
					error: function (err) {
						alert(err);
					}
				})
			}

			function bindSelectDistrict(id,regionId) {
				//获取快递下拉框
				$.ajax({
					url: '${pageContext.request.contextPath}/region/get/info?regionType=1&parentId='+regionId,
					type: 'GET',
					dataType: 'json',
					contentType: 'application/json',
					success: function (res) {
						console.log(res);
						var option = '';
						if (res.data.length > 0) {
							for (var i in res.data) {
								option += '<option value="' + res.data[i].regionId + '">' + res.data[i].regionName + '</option>';
							}
							$(id).html(option);
						}else {
							$(id).html('<option value="0">全部</option>');
						}
					},
					error: function (err) {
						alert(err);
					}
				})
			}

			asyReload(asyReloadUrl, showTable);
			bindSelectRegion("#region");

			$(document).on("change", "#region", function () {
				var regionId=$(this).val();
				bindSelectDistrict("#district",regionId);
			})

			$(".add").on("click", function (e) {
				e.preventDefault();
				$(this).attr("disabled", true);
				var data = {
					id: $("#ed_id").val(),
					companyName: $.trim($("#ed_companyName").val()),
					masterName: $.trim($("#ed_masterName").val()),
					masterPhone: $.trim($("#ed_masterPhone").val()),
					slavePhone: $.trim($("#ed_slavePhone").val()),
					address: $("#ed_address").val(),
					resource: $("#ed_resource").val(),
					note: $("#ed_note").val()
				}
				addEvent(addUrl, asyReloadUrl, data, showTable);
			})

			$(".search").on("click", function (e) {
				$(this).attr("disabled",true);

				var url = asyReloadUrl;
				var regionId = $("#regionId").attr('data');
				var districtId = $("#districtId").attr('data');
				var key = $("#key").val();

				if(regionId != undefined){
					url += '&regionId=' + regionId;
				}

				if(districtId != undefined){
					url += '&districtId=' + districtId;
				}

				if(key != undefined && key != ''){
					url += '&key=' + key;
				}

				asyReload(url,showTable);
				$(this).attr("disabled",false);
			})

			$(document).on("click", ".btn-delete", function (e) {

				e.preventDefault();
				var id = $(this).prev().prev().prev().attr("data_id");
				alert(id);

				asyReload(asyReloadUrl,showTable);
			})


			$("#import").on("click",function(e){
				var formdata=new FormData($("#fileUpload")[0])
				$(".filename").text("")
				$(this).attr("disabled",true)
				$.ajax({
					url: '${pageContext.request.contextPath}/record_info/upload',
					type:'POST',
					data:formdata,
					contentType:false,
					processData:false,
					async: false,
					cache: false,
					dataType:'json',
					success:function(res){
						console.log(res);
						if(res.success==true){
							alert("导入成功！");
						}else{
							alert(res.error);
						}
					},
					error:function(err){
						console.log(err)
					}
				})
			})

			$("#export").on("click",function(){
				$(this).attr("disabled",true)
				var parameter=''
				var url='../record_info/export'
				window.location.href=url
			})

			$(document).on("click", ".btn-update", function (e) {
				//更新方法
				e.preventDefault();
				var id = $(this).prev().prev().prev().attr("data_id");
				var datas = {};
				$(this).parent().parent().find("td").each(function (i) {
					if ($(this).attr('data_for')) {
						datas[$(this).attr('data_for')] = $(this).text();
					}
				})
				console.log(datas);

				$("#modify div.lq-form-group").each(function (i) {

					var input = $(this).find("input[type=text]");
					input.val(datas[input.attr("id")]);
				})
				$("#modify").show().css('opacity', 1);
			})

			$("#cancel").on("click", function (e) {
				e.preventDefault();
				$(this).parent().parent().parent().fadeOut(200);
			})

			$("#confirm").on("click", function (e) {
				e.preventDefault();
				var data = {
					id: 1,
					companyName: $.trim($("#ed_companyName").val()),
					masterName: $.trim($("#ed_masterName").val()),
					masterPhone: $.trim($("#ed_masterPhone").val()),
					slavePhone: $.trim($("#ed_slavePhone").val()),
					address: $("#ed_address").val(),
					resource: $("#ed_resource").val(),
					note: $("#ed_note").val()
				}

				$.ajax({
					url: updateUrl,
					dataType: 'json',
					type: 'POST',
					data: JSON.stringify(data),
					contentType: 'application/json',
					success: function (res) {
						console.log(res);
						if (res.result == "success") {
							alert("更新成功！");
							FadeOut();
							asyReload(asyReloadUrl, showTable);
						} else {
							alert(res);
						}
					},
					error: function (err) {
						alert(err);
					}
				})
			})


			function showTable(data) {
				var tdHtml = "";
				tableData = data;
				console.log(data);
				for (var i in data) {
					tdHtml += '<tr>';
					tdHtml += '<td 	data_for="ed_no">' + (Number(i)+1) + '</td>';
					tdHtml += '<td  data_for="ed_regionName">' + data[i].regionName + '</td>';
					tdHtml += '<td  data_for="ed_districtName">' + data[i].districtName + '</td>';
					tdHtml += '<td  data_for="ed_companyName">' + data[i].companyName + '</td>';
					tdHtml += '<td  data_for="ed_masterName">' + data[i].masterName + '</td>';
					tdHtml += '<td  data_for="ed_masterPhone">' + data[i].masterPhone + '</td>';
					tdHtml += '<td  data_for="ed_slavePhone">' + data[i].slavePhone + '</td>';
					tdHtml += '<td  data_for="ed_address">' + data[i].address + '</td>';
					tdHtml += '<td  data_for="ed_resource">' + data[i].resource + '</td>';
					tdHtml += '<td  data_for="ed_note">' + data[i].note + '</td>';

					tdHtml += '<td><input type="hidden" id="id" data_id="' + data[i].id + '">';
					tdHtml += '<button class="lq-btn lq-btn-sm lq-btn-danger img-upload">上传图片</button>';
					tdHtml += '<button class="lq-btn lq-btn-sm lq-btn-primary btn-update" data-target="#modify">编辑</button>';
					tdHtml += '<button class="lq-btn lq-btn-sm lq-btn-success btn-delete">删除</button></td>';
					tdHtml += '</tr>';
				}
				$(".tbody").html(tdHtml);
			}


			$('#dialog-review-branch .btn-confirm').on('click', function () {
				$('#dialog-review-branch').fadeOut();
				$('body').css('overflow', 'auto');
			});

			// 文件上传
			function getFileName(obj){
				var fileName="";
				if (typeof(fileName) != "undefined") {
					fileName = $(obj).val().split("\\").pop();
				}
				return fileName;
			}
			$('.file').change(function () {
				$('.fileName').html(getFileName($(this)));
			});


			function openDialog(data) {
				const arrDataHtml = data.map(item => {
					let temp = '<table class="xxx-table"><tbody><tr>';
					temp += '</tbody></table>';
					return temp;
				});

				$('#dialog-review-branch .xxx-dialog--body').html(arrDataHtml.join('<hr>'));
				$('#dialog-review-branch').fadeIn();
				$('body').css('overflow', 'hidden');
			}

		}

		)
	</script>
</html>