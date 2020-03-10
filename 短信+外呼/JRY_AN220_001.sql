353	外呼需求  徐超    3、重要不紧急 2019.6.10 李薇薇 金融苑 2019.6.11 
一次性需求 招联好借钱 金融苑 金融苑 外呼营销  
2017年1月1日-2018年12月31日，授信马上随借随还，
且2019年4月1日-6月10日在金融苑平台点击过的用户，剔除其中申请过好借钱的所有用户
（保留用户姓名，手机号，授信时间，授信额度，最近一次登录时间） 

select a1.mbl_no,
       a1.data_source,
       a4.name,
	   a1.credit_time,
	   a1.amount,
	   max(a2.extractday)
from warehouse_data_user_review_info a1
left join warehouse_atomic_user_info a4
  on a1.mbl_no = a4.mbl_no
------ and a1.data_source = a4.data_source
join warehouse_newtrace_click_record a2
  on a1.mbl_no = a2.mbl_no
left outer 
join (select mbl_no from warehouse_data_user_review_info
      where product_name = '现金分期-招联') a3
  on a1.mbl_no = a3.mbl_no
where a1.credit_time between '2017-01-01' and '2018-12-31'
  and a1.product_name = '随借随还-马上'
  and a1.status = '通过'
  and a1.data_source <> 'sjd'
  and a2.platform = 'jry'
  and a2.extractday between '2019-04-01' and '2019-06-10'
  and a3.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe WHERE eff_flg = '1')
group by a1.mbl_no,
         a1.data_source,
         a4.name,
	     a1.credit_time,
	     a1.amount
  
  
  