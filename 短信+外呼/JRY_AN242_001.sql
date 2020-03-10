398 外呼需求  徐超    1、紧急且重要 2019.6.20 何渝宏 客服组 2019.6.21下 
一次性需求  金融苑 金融苑 外呼营销 所有用户 
金融苑平台，2019年6月11日-6月14日马上随借随还授信成功，但未发起过提现的用户（保留用户姓名、手机号、授信时间、授信金额）

select distinct a1.mbl_no,
                a1.data_source,
	            a3.name,
	            a1.credit_time,
	            a1.amount
from warehouse_data_user_review_info a1
left join warehouse_atomic_user_info a3
       on a1.mbl_no = a3.mbl_no
      and a1.data_source = a3.data_source
left outer join (select  distinct mbl_no,data_source
                 from warehouse_data_user_withdrawals_info a
                 where data_source = 'jry'
				   and product_name = '随借随还-马上'
				   and cash_amount > '0') a2
            on a1.mbl_no = a2.mbl_no
           and a1.data_source = a2.data_source
where a1.product_name = '随借随还-马上'
   and a1.data_source = 'jry'
   and a1.status = '通过'
   and a1.credit_time between '2019-06-11' and '2019-06-14'
   and a2.mbl_no is null
   and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe WHERE eff_flg = '1')
   
   
-----
select distinct a1.mbl_no_encode,a3.name,a2.cash_time,a2.cash_amount
from warehouse_atomic_operation_promotion a1
left join warehouse_atomic_user_info a3
       on a1.mbl_no_encode = a3.mbl_no
      and a1.data_source = a3.data_source
join warehouse_data_user_withdrawals_info a2
  on a1.mbl_no_encode = a2.mbl_no
 and a1.data_source = a2.data_source
 
where a1.data_desc = 'JRY_AN231_001'
  and a1.data_source = 'jry'
  and a2.product_name = '现金分期-钱伴'
  and a2.cash_amount > '0'