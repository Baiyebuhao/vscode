1.产品列表点击
select product_name,
count(distinct mbl_no) as dj
from warehouse_newtrace_click_record a         
where page_enname = 'list'
and button_enname = 'productlist'
and platform = 'jry'
and extractday = '2019-03-15'


2.产品详情（申请）（金融苑-首页进入）
select product_name,
count(distinct mbl_no) as sq
from warehouse_newtrace_click_record a         
where page_enname = 'product_detail'
and button_enname = 'apply'
and platform = 'jry'
and source = 'fl'
and extractday = '2019-03-15'

3.汇总（漏斗）
select a1.product_name,a1.dj,a2.sq from 
(select product_name,
count(distinct mbl_no) as dj
from warehouse_newtrace_click_record a         
where page_enname = 'list'
and button_enname = 'productlist'
and platform = 'jry'
and extractday = '2019-03-15'
group by product_name) a1
left join 
(select product_name,
count(distinct mbl_no) as sq
from warehouse_newtrace_click_record a         
where page_enname = 'product_detail'
and button_enname = 'apply'
and platform = 'jry'
and source = 'fl'
and extractday = '2019-03-15'
group by product_name) a2
on a1.product_name = a2.product_name




