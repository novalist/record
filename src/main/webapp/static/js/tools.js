;(function($){
	function Filter(el,option){
		this.el=el;
		this.defaults={
			dataUrl:'',
			showTable: function(){}
		}
		this.options=$.extend({},this.defaults,option);
		this.filterKey="";
		this.KeyUp();
	}
	Filter.prototype={
		FilterData: function(){
			var _this=this;
			$.ajax({
				url:_this.options.dataUrl,
				type:'GET',
				dataType:'json',
				success: function(res){
					_this.infoData=res.data;
					if(_this.filterKey){
						if(_this.filterKey.indexOf(',')>-1||_this.filterKey.indexOf('，')>-1){
							var keys=_this.filterKey.replace(/，/g,',').split(',');
							var data=_this.infoData;
							for(var i in keys){
								if(keys[i]){
									_this.filterKey=_this.GetFilterKey(keys[i]);
									data=_this.GetFilter(_this.filterKey, data)
								}
							}
							_this.options.showTable(data)
						}else{
							_this.options.showTable(_this.GetFilter(_this.GetFilterKey(_this.filterKey),_this.infoData))
						}
					}else{
						_this.options.showTable(_this.infoData);
					}
					return ;
				},
				error: function(err){
					console.log("获取数据出错"+err)
				}
			})
		},
		GetFilter:function(filterKey,infoData){
			var data=[];
			data=infoData.filter(function(obj){
				return Object.keys(obj).some(function(key){
					if(obj[key])
					return String(obj[key]).indexOf(filterKey)>-1;
				})
			})
			return data;
		},
		GetFilterKey: function(str){
			var Ch2En=[
				           ['批量获取','BATCH'],
				           ['单个获取','SINGLE'],
				           ['可用','Y'],
				           ['是','Y'],
				           ['否','N'],
				           ['不可用','N'],
				           ['菜鸟代理','CAINIAO'],
				           ['直营','DIRECT_SALE'],
				           ['大华代理','DAHUA'],
				           ['单个快递','ROUTE'],
				           ['所有快递','ROUTEALL'],
				           ['寄方付','1'],
				           ['收方付','2'],
				           ['第三方代付','3']
			          ];
			for(var i in Ch2En){
				if(Ch2En[i][0].indexOf(str)>-1){
					return Ch2En[i][1];
				}
			}
			return str;
		},
		KeyUp:function(){
			var _this=this;
			this.el.on("keyup",function(e){
				var that=$(this);
				var filterKey=$.trim(that.val());
				_this.FilterData();
				_this.filterKey=filterKey;
			})
		}
	}
	$.fn.Filter=function(option){
		return this.each(function(){
			var element=$(this);
			new Filter(element,option);
		})
	}
})(jQuery)