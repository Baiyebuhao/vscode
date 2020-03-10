抚宁BI展示3
--产品点击申请
select a1.extractday,
       '抚宁百惠贷' as data_source,
       a1.pagenamecn as page_name,
       a1.click_name,
       a4.goods_name as product_name,
	   count(distinct a1.phone_number) as rs,
	   count(a1.cus_no) as cs
   
from default.warehouse_atomic_newframe_burypoint_buttonoperations a1   ---按钮
left join (select distinct start_id,
             page_id,
			 product_id
      from default.warehouse_atomic_newframe_burypoint_pageoperations) a2  ---页面
  on a1.start_id = a2.start_id
 and a1.page_id = a2.page_id
join (select distinct start_id
      from default.warehouse_atomic_newframe_burypoint_baseoperations     
      where platform = '抚宁百惠贷')a3                                      --基础
  on a1.start_id = a3.start_id
left join (select * 
           from default.warehouse_mall_goods_product a
		   where mall_name = '百惠贷')a4                           --产品
  on a1.goods_id = a4.goods_id
  
where a1.click_name = 'order_promptly'
  and a1.extractday > '2019-12-06'
group by a1.extractday,
         '抚宁百惠贷',
         a1.pagenamecn,
         a1.click_name,
         a4.goods_name