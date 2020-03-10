768 短信需求  徐超 已编码    3、重要不紧急 纪春艳 平台运营 2019.11.27 2019.11.28 
一次性需求 万达普惠 移动手机贷 移动手机贷 短信营销 按序号分包 
1、2019年针对钱包易贷、招联现金分期放款成功的联通用户；剔除已申请万达普惠的用户
2、本月申请任一产品未获得授信的联通用户，剔除已申请万达普惠的用户
--SJD_AN447_001
select a1.mbl_no,
       'sjd' as data_source
from (select distinct mbl_no
      from warehouse_data_user_withdrawals_info a
      where product_name in('随借随还-钱包易贷','现金分期-招联')
	    and cash_amount > 0
		and data_source = 'sjd') a1
join (select distinct mbl_no
      from warehouse_atomic_user_info a
      where isp = '联通'
	    and data_source = 'sjd') a2
      on a1.mbl_no = a2.mbl_no
LEFT OUTER JOIN 
     (SELECT distinct mbl_no
      FROM warehouse_data_user_review_info a
      WHERE product_name = '现金分期-万达普惠') a3 
      ON a1.mbl_no = a3.mbl_no
where a3.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');


---SJD_AN447_002
SELECT distinct a1.mbl_no,
       a1.data_source
FROM warehouse_data_user_review_info a1
join (select distinct mbl_no
      from warehouse_atomic_user_info a
      where isp = '联通'
	    and data_source = 'sjd') a4
      on a1.mbl_no = a4.mbl_no
left outer join
     (SELECT distinct mbl_no
      FROM warehouse_data_user_review_info a
	  where status = '通过'
	    and credit_time between '2019-11-01' and '2019-11-18') a2
	   on a1.mbl_no = a2.mbl_no
LEFT OUTER JOIN 
     (SELECT distinct mbl_no
      FROM warehouse_data_user_review_info a
      WHERE product_name = '现金分期-万达普惠') a3 
      ON a1.mbl_no = a3.mbl_no	   
where a1.apply_time between '2019-11-01' and '2019-11-18'
  and a1.data_source = 'sjd'
  and a2.mbl_no is null
  and a3.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');
