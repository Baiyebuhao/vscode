339	短信需求  徐超     2019.6.3 刘虹 移动手机贷 2019.6.5 
一次性需求 好借钱 移动手机贷 移动手机贷 短信营销  
--2019年4月1日至今，马上随借随还有提现行为的用户，剔除已申请好借钱的用户，剔除兴业、万达不通过的用户 
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_withdrawals_info a1

left outer join (select distinct mbl_no,data_source
			     from warehouse_data_user_review_info a
			     where product_name = '现金分期-招联'
				   and data_source = 'sjd') a2
			on a1.mbl_no = a2.mbl_no
           and a1.data_source = a2.data_source
		   
left outer join (select distinct mbl_no,data_source
			     from warehouse_data_user_review_info b
			     where product_name in ('现金分期-兴业消费','现金分期-万达普惠')
				   and data_source = 'sjd'
				   and status != '通过') a3
			on a1.mbl_no = a3.mbl_no
           and a1.data_source = a3.data_source
	   
where a1.product_name = '随借随还-马上'
  and a1.data_source = 'sjd'
  and a1.cash_amount > '0'
  and a1.cash_time between '2019-04-01' and '2019-05-31'
  and a2.mbl_no is null
  and a3.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');


