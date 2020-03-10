新架构埋点表
(desc warehouse_atomic_newframe_burypoint_baseoperations -- 基础属性

start_id	string	启动编号
browser	string	浏览器
browser_version	string	浏览器版本
brand	string	设备品牌
model	string	设备型号
app_version	string	app版本
device_id	string	设备id
screen_resolution	string	屏幕分辨率
os	string	操作系统
os_version	string	操作系统版本
ip	string	ip地址
mac	string	mac地址
platform	string	平台名称
platform_version	string	平台版本
channel	string	主渠道
childchan	string	子渠道
country	string	国家
province	string	省份
city	string	城市
cerrier	string	运营商
extractday	string	
	NULL	NULL
# Partition Information	NULL	NULL
# col_name            	data_type           	comment             
	NULL	NULL
extractday	string	
)

(desc warehouse_atomic_newframe_burypoint_pageoperations; -- 页面属性 

start_id	string	启动编号
enter_time	string	进入页面时间
from_pagename	string	离开页面名称
from_pagenamecn	string	离开页面中文名称
leave_time	string	离开页面时间
enter_pagename	string	跳转页面名称
enter_pagenamecn	string	跳转页面中文名称
enter_routing	string	跳转页面路由
cus_no	string	用户id
phone_number	string	手机号
longitude	string	经度
latitude	string	纬度
pagename	string	页面名称
pagenamecn	string	页面中文名称
pagerouting	string	页面路由
product_id	string	商品id
page_id	string	页面启动id
extractday	string	
	NULL	NULL
# Partition Information	NULL	NULL
# col_name            	data_type           	comment             
	NULL	NULL
extractday	string	
)

(desc warehouse_atomic_newframe_burypoint_buttonoperations; -- 按键属性

start_id	string	启动编号
networkname	string	网络名称
networktype	string	网络类型
cus_no	string	用户ID
pagename	string	页面名称
pagenamecn	string	页面中文名称
phone_number	string	手机号
latitude	string	纬度
longitude	string	经度
click_name	string	按键名称
click_namecn	string	按键中文名称
click_time	string	时间戳
ad_id	string	广告id
ad_location	string	广告顺序
address_id	string	用户的地址id
agreement_value	string	协议名称
attribute_name	string	属性名称
category	string	分类名称
channel_name	string	频道(分区)名称
close_reason	string	取消原因
code_value	string	
delivery	string	线上邮寄
delivery_shop_value	string	提货门店地址
full_address_value	string	
id_number_value	string	
location_value	string	
name_value	string	
news_id	string	公告id
online	string	在线
order_id	string	订单id
orders_status_value	string	状态值
page_name	string	所属页面
pay_value	string	选项值
phone	string	电话
phone_number_value	string	输入手机号
product_id	string	产品id
product_location	string	产品顺序
resorse	string	来源
search_value	string	搜索内容
self_mention	string	线下提货
shop_id	string	店铺id
sku_value	string	选项值
sort_name	string	选项名称
sort_value	string	选项值
source	string	来源
stages_name	string	分期属性名称
stages_value	string	选项值
store_id	string	门店id
ymsx	string	页面顺序
page_id	string	页面启动id
extractday	string	
	NULL	NULL
# Partition Information	NULL	NULL
# col_name            	data_type           	comment             
	NULL	NULL
extractday	string	
)

产品表
(desc warehouse_mall_goods_product

1	mall_code	string	
2	mall_name	string	平台
3	goods_id	string	
4	goods_name	string	产品名
5	product_id	string	产品id
6	product_name	string
)