百惠贷BI展示的按钮数据
SELECT a1.extractday,
       a3.platform AS data_source,
       a1.pagename,
       a1.pagenamecn,
       a1.click_name,
       a1.ad_id,
       a1.ad_location as location,
       count(a1.extractday) AS cs,
       count(DISTINCT a1.phone_number) AS rs
from default.warehouse_atomic_newframe_burypoint_buttonoperations a1  ---按键
join default.warehouse_atomic_newframe_burypoint_pageoperations a2    ---页面
  on a1.start_id = a2.start_id
 and a1.page_id = a2.page_id
join default.warehouse_atomic_newframe_burypoint_baseoperations a3    ---基础属性
  on a1.start_id = a3.start_id
WHERE a1.click_name = 'banner'
  AND a3.platform = '抚宁百惠贷'
GROUP BY a1.extractday,
         a3.platform,
         a1.pagename,
         a1.pagenamecn,
         a1.click_name,
         a1.ad_id,
         a1.ad_location
union all
select a1.extractday,
       a3.platform AS data_source,
       a1.pagename,
       a1.pagenamecn,
       a1.click_name,
	   a1.channel_name,
	   'null' as location,
	   count(a1.extractday) AS cs,
       count(DISTINCT a1.phone_number) AS rs
from default.warehouse_atomic_newframe_burypoint_buttonoperations a1  ---按键
join default.warehouse_atomic_newframe_burypoint_pageoperations a2    ---页面
  on a1.start_id = a2.start_id
 and a1.page_id = a2.page_id
join default.warehouse_atomic_newframe_burypoint_baseoperations a3    ---基础属性
  on a1.start_id = a3.start_id
where a1.click_name = 'channel'
  and a1.extractday > '2019-11-10'
  and a3.platform = '抚宁百惠贷'
GROUP BY a1.extractday,
         a3.platform,
         a1.pagename,
         a1.pagenamecn,
         a1.click_name,
		 a1.channel_name
		 
union all 
select a1.extractday,
       a3.platform AS data_source,
       a1.pagename,
       a1.pagenamecn,
       a1.click_name,
	   a1.product_id,
	   a1.product_location,
	   count(a1.extractday) AS cs,
       count(DISTINCT a1.phone_number) AS rs  
from default.warehouse_atomic_newframe_burypoint_buttonoperations a1  ---按键
join default.warehouse_atomic_newframe_burypoint_pageoperations a2    ---页面
  on a1.start_id = a2.start_id
 and a1.page_id = a2.page_id
join default.warehouse_atomic_newframe_burypoint_baseoperations a3    ---基础属性
  on a1.start_id = a3.start_id
where a1.click_name = 'products'
  and a1.extractday > '2019-11-10'
  and a3.platform = '抚宁百惠贷'
GROUP BY a1.extractday,
         a3.platform,
         a1.pagename,
         a1.pagenamecn,
         a1.click_name,
		 a1.product_id,
		 a1.product_location
