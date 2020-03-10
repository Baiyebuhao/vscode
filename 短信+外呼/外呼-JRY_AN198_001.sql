291	外呼需求		徐超				3、重要不紧急	2019.5.17	何渝宏	客服组	2019.5.21	一次性需求	
马上随借随还、招联好借钱	

金融苑	外呼营销	所有用户
	
金融苑平台，2019年4月至今，授信马上随借随还或招联好借钱，截止目前还未发起提现的用户。
（保留用户姓名、手机号、授信产品、授信额度、授信时间）	

select a1.mbl_no,
       a1.data_source,
	   a2.name,
	   a1.product_name,
	   a1.amount,
	   a1.credit_time
from warehouse_data_user_review_info a1

left join warehouse_atomic_user_info a2
   on a1.data_source = a2.data_source
  and a1.mbl_no = a2.mbl_no
  
left outer join 
    (select mbl_no from warehouse_data_user_withdrawals_info
     where data_source = 'jry'
     and cash_time between '2019-04-01' and '2019-05-20') a3
 on a1.mbl_no = a3.mbl_no
 
where a1.product_name in ('随借随还-马上','现金分期-招联')
  and a1.data_source = 'jry'
  and a1.credit_time between '2019-04-01' and '2019-05-20'
  and a1.status = '通过'
  and a3.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe WHERE eff_flg = '1')