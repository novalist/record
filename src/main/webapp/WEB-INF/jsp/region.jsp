<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>仓库添加页面</title>
		<link href="https://cdn.bootcss.com/font-awesome/4.5.0/css/font-awesome.min.css" rel="stylesheet">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap.css">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/global.css">
		<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/bootstrap.min.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/common.js"></script>			
		<style type="text/css">
			body{
				padding: 15px;
			}
			input[type=text]{
				width: 60%;
				display:inline-block;
			}
			.lq-btn {
				margin: 0 5px;
			}
			.mc-loading {
				font-size: 30px;
				color: #fff;
			}
			#modify{
				width: 50%;
				top: 200px;
				margin: 0 auto;
			}
			#modify .row{
				padding: 0 20px;
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
				<h2>仓库管理<input type="text" class="form-control filter" placeholder="输入关键字，快速查找"><span class=" glyphicon glyphicon-search search_icon"></span></h2>
			</div>
			<div class="modal fade" id="modify" tabindex="-1" role="dialog" aria-labelledby="update" aria-hidden="true">
				 <div class="modal-content">
				 	<div class="modal-header">
				 		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				 		<h4 class="modal-title">更新仓库信息</h4>
				 	</div>
					<div class="modal-body">
						<div class="row">
							<div class="lq-col-4">
								<div class="lq-form-group">
									<label for="code" style="text-indent: 1rem;">代号:</label>
									<input type="text" class="lq-form-control" id="ed_code" param="warehouseCode">
								</div>
								<div class="lq-form-group">
									<label for="warehouseName">仓库名:</label>
									<input type="text" class="lq-form-control" id="ed_warehouseName" param="warehouseName">
								</div>														
							</div>
							<div class="lq-col-4">
								<div class="lq-form-group">
									<label for="province">省/直辖市:</label>
									<input type="text" class="lq-form-control" id="ed_province" param="provinceName">
								</div>
								<div class="lq-form-group">
									<label for="city" style="text-indent: 3.5rem;">市:</label>
									<input type="text" class="lq-form-control" id="ed_city" param="cityName">
								</div>								
							</div>
							<div class="lq-col-4">
								<div class="lq-form-group">
									<label for="district">行政区:</label>
									<input type="text" class="lq-form-control" id="ed_district" param="districtName">
								</div>
								<div class="lq-form-group">
									<label for="address" style="text-indent:1rem;">地址:</label>
									<input type="text" class="lq-form-control" id="ed_address" param="address">
								</div>					
							</div>												
						</div>
					</div>
				 	<div class="modal-footer">
				 		<button type="buttton" class="btn btn-default" data-dismiss="modal">取消</button>
				 		<input type="hidden" id="ed_warehouseId">
				 		<button type="button" class="btn btn-primary subModify">提交更改</button>
				 	</div>
				 </div>
			</div>
			<div class="lq-col-3">
				<div class="lq-form-group">
					<label for="warehouseName">仓库名:</label>
					<input type="text" class="lq-form-control" id="warehouseName">
				</div>
				<div class="lq-form-group">
					<label for="code" style="text-indent: 1rem;">代号:</label>
					<input type="text" class="lq-form-control" id="code">
				</div>				
			</div>
			<div class="lq-col-3">
				<div class="lq-form-group">
					<label for="province">省/直辖市:</label>
					<input type="text" class="lq-form-control" id="province">
				</div>
				<div class="lq-form-group">
					<label for="city" style="text-indent: 3.5rem;">市:</label>
					<input type="text" class="lq-form-control" id="city">
				</div>								
			</div>
			<div class="lq-col-4">
				<div class="lq-form-group">
					<label for="district">行政区:</label>
					<input type="text" class="lq-form-control" id="district">
				</div>
				<div class="lq-form-group">
					<label for="address" style="text-indent:1rem;">地址:</label>
					<input type="text" class="lq-form-control" id="address">
					<button class="lq-btn lq-btn-sm lq-btn-primary add">添加</button>					
				</div>					
			</div>
			
			<table class="lq-table">
				<thead>
					<th>仓库代号</th>
					<th>仓库名称</th>
					<th>级联省/市</th>
					<th>城市名称</th>
					<th>行政区</th>
					<th>地址</th>
					<th>是否可用</th>
					<th>创建人</th>
					<th>操作</th>
				</thead>
				<tbody class="tbody">
				</tbody>
			</table>
			<div class="noDataTip">未查到符合条件的数据!</div>
		</div>
	</body>
	<script type="text/javascript"  src="${pageContext.request.contextPath}/static/js/tools.js"></script>
	<script type="text/javascript">
		$(document).ready(function(){
			var asyReloadUrl='${pageContext.request.contextPath}/user/warehouse/list';
			var addUrl='${pageContext.request.contextPath}/user/warehouse/add';
			var delUrl='${pageContext.request.contextPath}/user/warehouse/disable';
			var useUrl='${pageContext.request.contextPath}/user/warehouse/enable';
			
			$(document).on("click",".btn-del",function(){
				var warehouseId=$.trim($(this).prev().val());
				var data={warehouseId:warehouseId};
				delEvent(delUrl,JSON.stringify(data),asyReloadUrl,showTable);
			})
			
			$(document).on("click",".btn-use",function(){
				var warehouseId=$.trim($(this).prev().prev().val());
				var data={warehouseId:warehouseId};
				useEvent(useUrl,JSON.stringify(data),asyReloadUrl,showTable);
			})
			
			$(".add").on("click",function(e){
				e.preventDefault();
				$(this).attr("disabled",true);
				var warehouseCode=$("#code").val();
				var warehouseName=$("#warehouseName").val();
				var cityName=$("#city").val();
				var provinceName=$("#province").val();
				var districtName=$("#district").val();
				var address=$("#address").val();
				var data={
						warehouseCode:$.trim(warehouseCode),
						warehouseName:$.trim(warehouseName),
						provinceName:$.trim(provinceName),
						cityName:$.trim(cityName),
						districtName:$.trim(districtName),
						address:$.trim(address)
					};
				addEvent(addUrl,asyReloadUrl,data,showTable);
			})
			
			$(document).on('click','.btn-update',function(e){
				e.preventDefault();
				var dataRow=$(this).parent().parent().find('td');
				var editData=[];
				dataRow.each(function(){
					editData.push($(this).text());
				})
				$("#ed_warehouseId").val($(this).parent().find("input").val());
				$("#modify input[type=text]").each(function(i){
					$(this).val(editData[i]);
				})
				
				
			})
			
			$(document).on('click','.subModify',function(e){
				e.preventDefault();
				var dataRes={warehouseId:$("#ed_warehouseId").val()};
				$("#modify input[type=text]").each(function(){
					dataRes[$(this).attr("param")]=$.trim($(this).val());
				})
				console.log(dataRes);
				$.ajax({
					url:'${pageContext.request.contextPath}/user/warehouse/modify',
					type:'POST',
					dataType:'json',
					contentType:'application/json',
					data:JSON.stringify(dataRes),
					success:function(res){
						if(res.result=="success"){
							alert("修改成功!");
							window.location.reload();
						}else{
							alert(res.note);
						}
					},
					error:function(err){
						alert("服务器响应失败...");
					}
				})
			})
						
			asyReload(asyReloadUrl,showTable);
			
			function showTable(data){
				var tdHtml="";
				for(var i in data){
					tdHtml+='<tr class="dataLine">';
					tdHtml+='<td>'+data[i].warehouseCode+'</td>';
					tdHtml+='<td>'+data[i].warehouseName+'</td>';
					tdHtml+='<td>'+data[i].provinceName+'</td>';
					tdHtml+='<td>'+data[i].cityName+'</td>';
					tdHtml+='<td>'+data[i].districtName+'</td>';
					tdHtml+='<td>'+data[i].address+'</td>';
					tdHtml+=data[i].available=="Y"?"<td>可用</td>":"<td>不可用</td>";
					tdHtml+='<td>'+data[i].createdUser+'</td>';
					tdHtml+='<td><input type="hidden" id="warehosue_id" value="'+data[i].warehouseId+'">';
					if(data[i].available=="Y"){
						tdHtml+='<button class="lq-btn lq-btn-sm lq-btn-danger btn-del">弃用</button>';
						tdHtml+='<button class="lq-btn lq-btn-sm lq-btn-primary btn-use" style="display:none">启用</button>';
						tdHtml+='<button class="lq-btn lq-btn-sm lq-btn-success btn-update" data-toggle="modal" data-target="#modify">更新</button></td>';
					}else{
						tdHtml+='<button class="lq-btn lq-btn-sm lq-btn-danger btn-del" style="display:none">弃用</button>';
						tdHtml+='<button class="lq-btn lq-btn-sm lq-btn-primary btn-use">启用</button>';	
						tdHtml+='<button class="lq-btn lq-btn-sm lq-btn-success btn-update" data-toggle="modal" data-target="#modify">更新</button></td>';
					}
					tdHtml+='</tr>';
				}
				$("tbody.tbody").html(tdHtml);
				
			}
			
			$("body").on("click",function(){
				$('.dropdown-menu', window.parent.document).css({"display":"none"});
			})
			
			$(".filter").Filter({
				dataUrl: asyReloadUrl,
				showTable: showTable
			})
		})
	</script>
</html>