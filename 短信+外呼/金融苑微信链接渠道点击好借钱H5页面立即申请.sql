318  统计需求 徐超  3、重要不紧急  2019.5.28  夏玮扬  金融苑  2019.5.31  
定期需求   （月末最后一天取）  好借钱  金融苑   数据统计  
2019.5.1-5.31来自金融苑微信链接渠道点击好借钱H5页面立即申请按钮的人数

select count(distinct a.mbl_no)
from warehouse_newtrace_click_record a
where platform = 'jry'
  and page_enname = 'H5productdetail'
  and button_enname = 'apply'
  and channel = 'jrywxlj'
  and childchan = '001'
  and product_name = '好借钱极速贷'
  and product_id = '40000045'
  and extractday between '2019-05-01' and '2019-05-31'
  
-------
count(extractday),count(distinct a.mbl_no)

select *
from warehouse_newtrace_click_record a
where platform = 'jry'
  and page_enname like 'H5%'
  and channel = 'jrydx'
  and childchan = '001'
  and product_name = '移动白条-马上'
  and product_id = '40000001'
  
----------
select *
from warehouse_newtrace_click_record a
where platform = 'jry'
  and page_enname like 'H5%'
  and channel = 'jrydx'
  and childchan = '001'
  and product_name = '好借钱极速贷'
  and product_id = '40000045'
  
  