338	短信需求  徐超     2019.6.3 刘虹 移动手机贷 2019.6.5 
一次性需求 马上随借随还 移动手机贷  短信营销 
--2018年1月-2019年1月马上随借随还有过提现动作，且2019年2月至今未提现的移动用户。
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_withdrawals_info a1

left outer join (select distinct mbl_no,data_source
			     from warehouse_data_user_withdrawals_info a
			     where product_name = '随借随还-马上'
				   and data_source = 'sjd'
				   and cash_time between '2019-02-01' and '2019-05-31') a2
			on a1.mbl_no = a2.mbl_no
           and a1.data_source = a2.data_source	   
where a1.product_name = '随借随还-马上'
  and a1.data_source = 'sjd'
  and a1.cash_amount > '0'
  and a1.cash_time between '2018-01-01' and '2019-01-31'
  and a2.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');