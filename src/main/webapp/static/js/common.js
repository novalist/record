
	function addEvent(addUrl,sysReloadUrl,data,showTable){
		var parm=JSON.stringify(data);
		$.ajax({
			url:addUrl,
			type:'POST',
			dataType:'json',
			contentType:'application/json',
			data:parm,
			success:function(res){
				if(res.result=="success"){
					alert("添加成功");
					$(".add").removeAttr("disabled");
					window.location.reload();
					/*asyReload(sysReloadUrl,showTable);*/
				}else{
					alert(res.errorMsg);
					$(".add").removeAttr("disabled");
				}
			},
			error:function(err){
				alert(err);
			}
		})
	}

	function asyReload(sysReloadUrl,showTable){
		$.ajax({
			url:sysReloadUrl,
			type:'GET',
			dataType:'json',
			beforeSend:function(){
				$(".mw-loading").fadeIn(300);
			},
			success: function(res){
				$(".mw-loading").fadeOut(300);
				if(res.code=="200"){
					if(res.data.length>0){
						$(".noDataTip").fadeOut(300);
						showTable(res.data);
					}
					else{
						$(".tbody").html("");
						$(".noDataTip").fadeIn(300);
					}
				}
			},
			error: function(err){
				console.log(err);
				$(".mw-loading").fadeOut(300);
			}
		})
	}

	function delEvent(delUrl,data,asyReloadUrl,showTable){

			$.ajax({
				url:delUrl,
				dataType:'json',
				type:'POST',
				contentType:'application/json',
				data: data,
				success:function(res){
					if(res.result=="success"){
						alert("操作成功");
						asyReload(asyReloadUrl,showTable);
					}else{
						alert(res.errorMsg);
					}
				},
				error:function(err){
					alert(err);
				}
			})
	}

	function useEvent(useUrl,data,asyReloadUrl,showTable){
		$.ajax({
			url:useUrl,
			dataType:'json',
			type:'POST',
			contentType:'application/json',
			data: data,
			success:function(res){
				if(res.result=="success"){
					alert("操作成功");
					asyReload(asyReloadUrl,showTable);
				}else{
					alert(res.errorMsg);
				}
			},
			error:function(err){
				alert(err);
			}
		})
	}

	//下拉框
	$("div.select input[type=text]").on("click",function(){
		if($(this).next().next().css("display")=="none"){
			$(this).next().next().slideDown(300);
		}else{
			$(this).next().next().slideUp(300);
		}
	})
	function validate(){
			var applyType=$("#way").attr("data");
			var shippingId=$("#shipping").val();
			var expressType=$("#express_type").val();
			$.ajax({
				url:'./shippingApp/shippingId/'+shippingId+'/applyType/'+applyType+'/expressType/'+expressType+'/check',
				type:'GET',
				dataType:'json',
				success:function(res){
					if(res.result=="fail"){
						$(".alert-danger").fadeIn(300);
						$(".lq-alert-content").text(res.errorMsg);
						return;
					}else{
						$(".alert-danger").fadeOut(300);
					}
				}
			})
		}

	function validate_edit(){
		var applyType=$("#ed_way").attr("data");
		var shippingId=$("#ed_shipping").val();
		var expressType=$("#ed_express_type").val();
		$.ajax({
			url:'./shippingApp/shippingId/'+shippingId+'/applyType/'+applyType+'/expressType/'+expressType+'/check',
			type:'GET',
			dataType:'json',
			success:function(res){
				if(res.result=="fail"){
					$(".ed.alert-danger").fadeIn(300);
					$(".ed.lq-alert-content").text(res.errorMsg);
					return;
				}else{
					$(".ed.alert-danger").fadeOut(300);
				}
			}
		})
	}
	$(document).on("click","div.select .dropdown-menu li",function(e){
		e.stopPropagation();
		var input_val=$(this).parent().prev().prev();
		$(this).siblings().removeClass("selected");
		$(this).addClass("selected");
		input_val.attr('data',$(this).attr("value"));
		input_val.val($(this).text());
		validate();
		$(this).parent().slideUp(300);

	})

	$(document).on("blur","div.select input[type=text]",function(e){
		e.stopPropagation();

		$("div.select ul.dropdown-menu").slideUp(300);
	})

	$(document).on("body","click",function(){
		$('.dropdown-menu', window.parent.document).css({"display":"none"});
	})

	//弹出层定位
	function RestPosition(){
		var offsetLeft=window.parent.document.body.offsetWidth/2;
		var sidebar;
		if(window.parent.document.getElementById("mask")){
			window.parent.document.getElementById("mask").style.display="block";
			var dialog_width=document.getElementById('modify').offsetWidth;
			if(window.parent.document.getElementsByClassName("sidebar")[0]){
				 sidebar=window.parent.document.getElementsByClassName("sidebar")[0].offsetWidth;
			}else{
				sidebar=0;
			}

			var left=offsetLeft-dialog_width/2-sidebar;
			$("#modify").css({'left':left+"px"});
		}else{
			$("#modify").css({'left':"50%","margin-left":(-offsetLeft/2)+"px"});
		}
		FadeIn();
	}
	function FadeOut(){
		$(".modal-backdrop.in").fadeOut(300);
		$("#modify").fadeOut(300);
		if(window.parent.document.getElementById("mask"))
			window.parent.document.getElementById("mask").style.display="none";
	}
	function FadeIn(){
		$("#modify").fadeIn(300)
		$(".modal-backdrop.in").fadeIn(300);
		if(window.parent.document.getElementById("mask"))
			window.parent.document.getElementById("mask").style.display="block";

	}
	$(document).on("click",".cancel",function(){
		FadeOut();
	})
	$(document).on("click",".close",function(){
		FadeOut();
	})