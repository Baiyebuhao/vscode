--抚宁BI展示1（修改抚宁百惠贷为助立贷）
SELECT a1.extractday,
       '助立贷' AS data_source,
       a1.pagename,
       a1.pagenamecn,
       a1.click_name,
       a1.ad_id,
       a1.ad_location as location,
       count(a1.extractday) AS cs,
       count(DISTINCT a1.phone_number) AS rs
	   
from default.warehouse_atomic_newframe_burypoint_buttonoperations a1   ---按钮
left join (select distinct start_id,
             page_id,
			 goods_id
      from default.warehouse_atomic_newframe_burypoint_pageoperations) a2  ---页面
  on a1.start_id = a2.start_id
 and a1.page_id = a2.page_id
join (select distinct start_id
      from default.warehouse_atomic_newframe_burypoint_baseoperations     
      where platform in( '抚宁百惠贷','助立贷'))a3                                      --基础
  on a1.start_id = a3.start_id
  
WHERE a1.click_name = 'banner'
  and a1.extractday > '2019-11-10'

GROUP BY a1.extractday,
         '助立贷',
         a1.pagename,
         a1.pagenamecn,
         a1.click_name,
         a1.ad_id,
         a1.ad_location
union all
select a1.extractday,
       '助立贷' AS data_source,
       a1.pagename,
       a1.pagenamecn,
       a1.click_name,
	   a1.channel_name,
	   'null' as location,
	   count(a1.extractday) AS cs,
       count(DISTINCT a1.phone_number) AS rs
	   
from default.warehouse_atomic_newframe_burypoint_buttonoperations a1   ---按钮
left join (select distinct start_id,
             page_id,
			 goods_id
      from default.warehouse_atomic_newframe_burypoint_pageoperations) a2  ---页面
  on a1.start_id = a2.start_id
 and a1.page_id = a2.page_id
join (select distinct start_id
      from default.warehouse_atomic_newframe_burypoint_baseoperations     
      where platform  in( '抚宁百惠贷','助立贷'))a3                                      --基础
  on a1.start_id = a3.start_id
  
where a1.click_name = 'channel'
  and a1.extractday > '2019-11-10'
GROUP BY a1.extractday,
         '助立贷',
         a1.pagename,
         a1.pagenamecn,
         a1.click_name,
		 a1.channel_name
		 
union all 
select a1.extractday,
       '助立贷' AS data_source,
       a1.pagename,
       a1.pagenamecn,
       a1.click_name,
	   a4.goods_name,
	   a1.product_location,
	   count(a1.extractday) AS cs,
       count(DISTINCT a1.phone_number) AS rs  
	   
from default.warehouse_atomic_newframe_burypoint_buttonoperations a1   ---按钮
left join (select distinct start_id,
             page_id,
			 goods_id
      from default.warehouse_atomic_newframe_burypoint_pageoperations) a2  ---页面
  on a1.start_id = a2.start_id
 and a1.page_id = a2.page_id
join (select distinct start_id
      from default.warehouse_atomic_newframe_burypoint_baseoperations     
      where platform  in( '抚宁百惠贷','助立贷'))a3                                      --基础
  on a1.start_id = a3.start_id
left join default.warehouse_mall_goods_product a4                           --产品
  on a1.goods_id = a4.goods_id
  
where a1.click_name = 'products'
  and a1.extractday > '2019-11-10'

GROUP BY a1.extractday,
         '助立贷',
         a1.pagename,
         a1.pagenamecn,
         a1.click_name,
		 a4.goods_name,
		 a1.product_location
