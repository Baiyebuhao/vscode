王佼	大额现金贷	2019.4.22	
一次性需求	好人贷	移动手机贷	push推广	
1、2019.1.1至今，移动手机贷平台点击好人贷页面，未点击申请按钮的用户
desc warehouse_newtrace_click_record


select *
from warehouse_newtrace_click_record a
where button_enname = 'banner'
and extractday >= '2019-01-01'
and ad_name = '好人贷'
and platform = 'sjd'

UNION ALL

select *
from warehouse_newtrace_click_record a
where extractday >= '2019-01-01'
and product_name = '好人贷'
and platform = 'sjd'
and page_enname = 'supermarket'

2、2019.1.1至今，移动手机贷平台点击好人贷申请按钮，未提交申请的用户	

