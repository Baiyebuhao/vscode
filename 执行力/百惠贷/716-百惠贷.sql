716   徐超、李勇、王凤娟     3、重要不紧急 龚月 平台运营 2019.11.12 2019.11.15 
一次性需求 银行代运营 抚宁平台 抚宁平台 定期给银行做代运营报告  
在BI上搭建抚宁百惠贷平台产品页面数据，所有数据当日去重：

1.抚宁平台抚宁产品页面及普惠达产品页面banner点击次数及人数   frontpage  banner
2.抚宁平台抚宁产品页面及普惠达产品页面每一个分区栏的点击次数及人数
3.抚宁平台抚宁产品页面及普惠达产品页面，产品列表单个产品的点击人数及次数  productlist  product_id  
4.抚宁平台抚宁产品页面及普惠达产品页面产品列表，单个产品详情页“立即申请”按钮的点击次数及人数  product_detail  order_promptly

select * 
from warehouse_atomic_newframe_burypoint_pageoperations a1
join warehouse_atomic_newframe_burypoint_baseoperations a2
  on a1.start_id = a2.start_id
join warehouse_atomic_newframe_burypoint_buttonoperations a3
  on a1.start_id = a3.start_id
  
  
select a1.extractday,
       a3.platform as data_source,
       a1.pagename,
	   a1.pagenamecn,
	   a1.click_name,
	   a1.click_namecn,
	   a1.ad_id,
	   a1.ad_location,
	   a1.channel_name,
	   count(a1.extractday) as cs,
	   count(distinct a1.phone_number) as rs
from warehouse_atomic_newframe_burypoint_buttonoperations a1  ---按键
join warehouse_atomic_newframe_burypoint_pageoperations a2    ---页面
  on a1.start_id = a2.start_id
 and a1.page_id = a2.page_id
join warehouse_atomic_newframe_burypoint_baseoperations a3    ---基础属性
  on a1.start_id = a3.start_id
where a1.extractday > '2019-11-10'
group by a1.extractday,
         a3.platform,
         a1.click_name,
         a1.pagename,
	     a1.pagenamecn,
	     a1.click_name,
	     a1.click_namecn,
	     a1.ad_id,
	     a1.ad_location,
	     a1.channel_name
		 
		 
---banner
select a1.* 
from warehouse_atomic_newframe_burypoint_buttonoperations a1
join warehouse_atomic_newframe_burypoint_baseoperations a3    ---基础属性
  on a1.start_id = a3.start_id
where a1.click_name = 'banner'
  and a1.extractday > '2019-11-10'
  and a3.platform = '抚宁百惠贷'

---抚宁平台
---分区栏的点击
select a1.* 
from warehouse_atomic_newframe_burypoint_buttonoperations a1
join warehouse_atomic_newframe_burypoint_baseoperations a3    ---基础属性
  on a1.start_id = a3.start_id
where a1.click_name = 'channel'
  and a1.extractday > '2019-11-10'
  and a3.platform = '抚宁百惠贷'
  
---产品列表单个产品的点击人数及次数
-- product_id
-- product_location
-- source
select a1.* 
from warehouse_atomic_newframe_burypoint_buttonoperations a1
join warehouse_atomic_newframe_burypoint_baseoperations a3    ---基础属性
  on a1.start_id = a3.start_id
where a1.click_name = 'productlist'
  and a1.extractday > '2019-11-10'
  and a3.platform = '抚宁百惠贷'

--单个产品详情页“立即申请”按钮的点击次数及人数
-- product_detail
-- order_promptly
select a1.* 
from warehouse_atomic_newframe_burypoint_buttonoperations a1
join warehouse_atomic_newframe_burypoint_baseoperations a3    ---基础属性
  on a1.start_id = a3.start_id
where a1.click_name = 'order_promptly'
  and a1.extractday > '2019-11-10'
  and a3.platform = '抚宁百惠贷'
