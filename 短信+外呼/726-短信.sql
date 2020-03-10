726 短信需求  徐超     3、重要不紧急 纪春艳 平台运营 2019.11.13 2019.11.14 
一次性需求 万达普惠 移动手机贷 移动手机贷 短信营销  
1、近3个月针对马上产品有过提现行为的联通用户；
2、本月有点击过马上产品的联通用户；剔除已申请过万达普惠的用户；
---近3个月针对马上产品有过提现行为的联通用户；
select distinct a1.mbl_no,
       a1.data_source
from warehouse_data_user_withdrawals_info a1
left join warehouse_atomic_user_info a2
       on a1.mbl_no = a2.mbl_no
	  and a1.data_source = a2.data_source
where a1.product_name = '随借随还-马上'
  and a1.cash_time between '2019-08-12' and '2019-11-12'
  and a1.cash_amount > 0
  and a1.data_source = 'sjd'
  and a2.isp = '联通'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');
  
----
----本月有点击过马上产品的联通用户；剔除已申请过万达普惠的用户；
select distinct a1.mbl_no,
       a1.data_source
from warehouse_data_user_action_day a1
left join warehouse_atomic_user_info a2
       on a1.mbl_no = a2.mbl_no
	  and a1.data_source = a2.data_source
left outer join (select distinct mbl_no
			     from warehouse_data_user_review_info a
			     where product_name = '现金分期-万达普惠'
				   and data_source = 'sjd') a3
			on a1.mbl_no = a3.mbl_no
where a1.product_name = '随借随还-马上'
  and a1.data_source = 'sjd'
  and a1.extractday between '2019-11-01' and '2019-11-14'
  and a2.isp = '联通'
  and a3.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');

