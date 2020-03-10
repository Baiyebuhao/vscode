215	取数需求		徐超			
3、重要不紧急	2019.4.29	叶川	数据部	2019.4.29	不定期需求	全平台	三平台	前置挡板分析	
"提取近1个月（20190401-20190429）全平台用户导流数据。
包含用户手机号、用户导流日期、所导流平台和导流产品、用户申请是否通过等信息。
若有取数疑问，请反馈我。谢谢"	
	
号码 md5号码 平台 产品 推送时间 申请时间 申请状态

(时间：0417-0423 
---------推送用户
select distinct a.mbl_no,
       b.mbl_no_md5,
       a.sys_id as data_source,
	   a.product_name,
	   a.extractday as push_time,
	   0 as apply_time,
	   0 as status
from warehouse_data_user_page_action a
left join warehouse_atomic_user_info b
on a.mbl_no = b.mbl_no
and a.sys_id = b.data_source
where a.extractday between '2019-04-01' and '2019-04-29'
  and a.button_name in ('申请','立即申请')
  and a.mbl_no != 'NULL'
---------
UNION ALL
---------申请用户
select distinct a.mbl_no,
       b.mbl_no_md5,
       a.data_source,
	   a.product_name,
	   0 as push_time,
	   a.apply_time,
	   a.status
from warehouse_data_user_review_info a
left join warehouse_atomic_user_info b
on a.mbl_no = b.mbl_no
and a.data_source = b.data_source
where a.apply_time between '2019-04-01' and '2019-04-29'
)

(----------当天推送当天申请
select distinct a1.mbl_no,
       a1.mbl_no_md5,
       a1.data_source,
	   a1.product_name,
	   a1.push_time,
	   a2.apply_time,
	   a2.status
from
(
select distinct a.mbl_no,
       b.mbl_no_md5,
       a.sys_id as data_source,
	   a.product_name,
	   a.extractday as push_time,
	   0 as apply_time,
	   0 as status
from warehouse_data_user_page_action a
left join warehouse_atomic_user_info b
on a.mbl_no = b.mbl_no
and a.sys_id = b.data_source
where a.extractday between '2019-04-01' and '2019-04-29'
  and a.button_name in ('申请','立即申请')
  and a.mbl_no != 'NULL') a1
left join 
(
select distinct a.mbl_no,
       b.mbl_no_md5,
       a.data_source,
	   a.product_name,
	   0 as push_time,
	   a.apply_time,
	   a.status
from warehouse_data_user_review_info a
left join warehouse_atomic_user_info b
on a.mbl_no = b.mbl_no
and a.data_source = b.data_source
where a.apply_time between '2019-04-01' and '2019-04-29'
  ) a2
on a1.mbl_no = a2.mbl_no
and a1.data_source = a2.data_source
and a1.product_name = a2.product_name
and a1.push_time = a2.apply_time
)
