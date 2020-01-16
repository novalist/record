function ShowPage(totalPage,currentPage,maxPage,endPage,data,url,ShowTable){
	var totalPage=totalPage;
	var currentPage=currentPage;
	var maxPage=maxPage;
	var endPage=endPage;
	var mid=Math.ceil(maxPage/2);
	var END_PAGE;
	var startPage;
	if(totalPage>maxPage)
		END_PAGE=maxPage;
	else
		END_PAGE=totalPage;
	
	PageConstructor();
	function PageConstructor(){
		var pageHtml='';
		if(totalPage>0){
			$(".page-wrap").fadeIn(300);
			pageHtml+='<li class="prev"><a href="#" alt="返回首页" aria-label="Previous"><span aria-hidden="true">&laquo首页</span></a></li>';
			if(currentPage>=maxPage)
				startPage=currentPage-mid;
			else
				startPage=1;
			for(var i=startPage;i<startPage+END_PAGE;i++){
				if(i==currentPage)
					pageHtml+='<li class="active"><a href="#">'+i+'</a></li>';
				else if(i<=totalPage)
					pageHtml+='<li><a href="#">'+i+'</a></li>';
			}
			pageHtml+='<li class="next"><a href="#" alt="跳至尾页" aria-label="Next"><span aria-hidden="true">尾页&raquo;</span></a></li>';	
			$(".pagination").html(pageHtml);
		}
		
		
	}
	$(document).on("click",".pagination li",function(e){
		e.preventDefault();
		var _this=$(this);
		var lastPage=_this.parent().find("li.next").prev().find("a").text();
		currentPage=parseInt(_this.find("a").text());
		if(_this.hasClass("prev")){
			currentPage=1;
			PageConstructor();
		}else if(_this.hasClass("next")){
			currentPage=totalPage;
			startPage=totalPage-maxPage;
			PageConstructor();
		}else{
			if(currentPage+maxPage-mid>totalPage&&parseInt(lastPage)==totalPage){
				_this.addClass("active").siblings().removeClass("active");
			}else{
				PageConstructor();
			}
		}
		
		$.ajax({
			url:url+'?pageNum='+currentPage+'&pageSize='+maxPage,
			type: 'POST',
			dataType:'json',
			contentType:'application/json',
			data:data,
			beforeSend : function(){
				_this.addClass("active").siblings().removeClass("active");
				$(".mw-loading").fadeIn(300);
			},						
			success: function(res){
				console.log(res);
				$(".mw-loading").fadeOut(300);
				if(res.result=="success"){
					ShowTable(res.data.list)
				}else{
					alert(res.errorMsg);
				}
			},
			error:function(err){
				$(".mw-loading").fadeOut(300);
				alert(err);
			}
		})
			
	})		

}