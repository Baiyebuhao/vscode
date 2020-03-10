386	短信需求  徐超     2019.6.17 刘虹 移动手机贷 2019.6.18 
一次性需求 马上随借随还 移动手机贷 移动手机贷 短信营销  
2018年6月1日-2019年3月15日马上随借随还有过提现行为
且近三个月（2019年3月16日-2019年6月14日）无提现行为的用户 请相互剔重 

select distinct a1.mbl_no,a1.data_source
  from warehouse_data_user_withdrawals_info a1
left outer join(select mbl_no,data_source
                from warehouse_data_user_withdrawals_info a
                where data_source = 'sjd'
                  and product_name = '随借随还-马上'
				  and cash_time between '2019-03-16' and '2019-06-14'
                  and cash_amount > '0') a2
 on a1.mbl_no = a2.mbl_no
and a1.data_source = a2.data_source

 where a1.data_source = 'sjd'
   and a1.product_name = '随借随还-马上'
   and a1.cash_time between '2018-06-01' and '2019-03-15'
   and a1.cash_amount > '0'
   and a1.mbl_no like 'MT%'
   and a2.mbl_no is null
   and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX')

