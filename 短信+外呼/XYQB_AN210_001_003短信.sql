333	短信需求  徐超  3、重要不紧急  2019.5.31  纪春艳  享宇钱包  2019.6.3日下午  
一次性需求  钱伴  享宇钱包  短信营销  一个需求一个包  
需求1、享宇钱包平台，历史申请信用钱包授信未提现用户.
需求2、2017年已提现马上现金分期的用户，剔除已申请钱伴产品用户.
需求3、知付圈渠道三平台所有已提现用户，剔除已申请钱伴产品用户.

----需求1、享宇钱包平台，历史申请信用钱包授信未提现用户.
select a1.mbl_no,a1.data_source
from warehouse_data_user_review_info a1
left outer join 
    (select mbl_no,data_source 
     from warehouse_data_user_withdrawals_info a
     where data_source = 'xyqb'
       and product_name = '信用钱包'
       and cash_amount > '0') a2
  on a1.data_source =a2.data_source
 and a1.mbl_no = a2.mbl_no
where a1.data_source = 'xyqb'
  and a1.product_name = '信用钱包'
  and a1.status = '通过' 
  and a2.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');

----需求2、2017年已提现马上现金分期的用户，剔除已申请钱伴产品用户.
select a1.mbl_no,a1.data_source
from warehouse_data_user_withdrawals_info a1
left outer join (select distinct mbl_no,data_source
			     from warehouse_data_user_review_info a
			     where product_name = '现金分期-钱伴'
				   and data_source = 'xyqb') a2
			on a1.mbl_no = a2.mbl_no
           and a1.data_source = a2.data_source
where a1.product_name = '现金分期-马上'
  and a1.data_source = 'xyqb'
  and a1.cash_amount > '0'
  and a1.cash_time between '2017-01-01' and '2017-12-31'
  and a2.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');

----需求3、知付圈渠道三平台所有已提现用户，剔除已申请钱伴产品用户.
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_withdrawals_info a1
join warehouse_atomic_user_info a2
  on a1.mbl_no = a2.mbl_no
 and a1.data_source = a2.data_source
left outer join (select distinct mbl_no,data_source
			     from warehouse_data_user_review_info a
			     where product_name = '现金分期-钱伴'
				   and data_source = 'xyqb') a3
			on a1.mbl_no = a3.mbl_no
           and a1.data_source = a3.data_source 
where a1.cash_amount > '0'
  and a2.chan_no in ('515','xxqd043')
  and a3.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');















