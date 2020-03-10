320  短信需求  徐超  2019.5.28	刘虹  移动手机贷  2019.5.29
一次性需求  马上随借随还  移动手机贷  短信营销	
2019年4月1日至今，马上随借随还授信未提现用户且授信额度在1500元以上。

select distinct a1.mbl_no,a1.data_source,a1.amount
 from warehouse_data_user_review_info a1
 left outer join (select mbl_no,data_source
                   from warehouse_data_user_withdrawals_info
                   where product_name = '随借随还-马上'
				     and data_source = 'sjd'
                     and cash_time >= '2019-04-01') a2
			 on a1.mbl_no = a2.mbl_no
			and a1.data_source = a2.data_source
where a1.data_source = 'sjd'
  and a1.product_name = '随借随还-马上'
  and a1.status = '通过'
  and a1.amount >= '1500'
  and a1.credit_time >= '2019-04-01'
  and a2.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
                              WHERE eff_flg = '1' 
						      UNION 
						      SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
                              WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date()
						      AND marketing_type = 'DX')