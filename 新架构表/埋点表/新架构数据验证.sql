--新架构数据验证

--产品ID为60000开头的页面
select distinct a1.pagenamecn,a3.platform
from warehouse_atomic_newframe_burypoint_pageoperations a1
join default.warehouse_atomic_newframe_burypoint_baseoperations a3    ---基础属性
  on a1.start_id = a3.start_id
where a1.extractday > '2019-12-06'
  and product_id like '600000%'
  
--基础表是否重复start_id
SELECT start_id,count(start_id)
from warehouse_atomic_newframe_burypoint_baseoperations a
where extractday = '2019-12-07'
GROUP BY start_id

--