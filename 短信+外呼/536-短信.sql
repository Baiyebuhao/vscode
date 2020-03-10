536 短信需求  徐超   是  3、重要不紧急 纪春艳 平台运营 2019.8.21 2019.8.22 
一次性需求 优智借 三平台 三平台 短信营销 按平台分包 
马上随借随还授信已过期用户，且2019年在APP上有点击行为的用户，剔除已申请优智借产品用户
select distinct a1.mbl_no,a1.data_source
from warehouse_atomic_msd_withdrawals_result_info a1
left outer join (select distinct mbl_no,data_source
                 from warehouse_data_user_review_info a
                 where product_name = '优智借'
				 ) a2
         on a1.mbl_no = a2.mbl_no
		and a1.data_source = a2.data_source
join (select distinct mbl_no,data_source
      from warehouse_data_user_action_day a
      where extractday >= '2019-01-01') a3
		on a1.mbl_no = a3.mbl_no
	and a1.data_source = a3.data_source
where a1.paid_out_time <= '2019-08-22'
  and a1.mbl_no <> 'NULL'
  and a2.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');



select distinct a1.mbl_no,a1.data_source
from warehouse_atomic_msd_withdrawals_result_info a1
left outer join (select distinct mbl_no
                 from warehouse_data_user_review_info a
                 where product_name = '优智借'
				 and data_source = 'jry'
				 ) a2
         on a1.mbl_no = a2.mbl_no
join (select distinct mbl_no
      from warehouse_data_user_action_day a
      where extractday >= '2019-01-01'
	    and data_source = 'jry') a3
		on a1.mbl_no = a3.mbl_no
where a1.data_source = 'jry'
  and a1.paid_out_time <= '2019-08-22'
  and a1.mbl_no <> 'NULL'
  and a2.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');