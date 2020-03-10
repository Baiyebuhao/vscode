774 短信需求  徐超     3、重要不紧急 纪春艳 平台运营 2019.12.3 2019.12.4上午 
一次性需求 全产品 移动手机贷 移动手机贷 短信营销 按序号分包 
1、11月已实名未申请任一产品的用户；
2、申请优智借、钱伴、信用钱包已获得授信的用户；
3、R值为3且M值为1、2、3的用户

---SJD_AN451_001
select a1.mbl_no as mbl_no,
       a1.data_source as data_source       
from warehouse_atomic_user_info a1
join warehouse_atomic_all_process_info a2
    on a1.mbl_no = a2.mbl_no 
   and a1.data_source = a2.data_source
left outer join
               (select distinct mbl_no
			    from warehouse_data_user_review_info) a3
    on a1.mbl_no = a3.mbl_no
 where a1.data_source = 'sjd'
   and a2.action_name = '实名'
   and a2.action_date between '2019-11-01' and '2019-11-30'
   and a3.mbl_no is null
   and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
       WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
       WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');
	   
---SJD_AN451_002
select distinct mbl_no as mbl_no,
       data_source as data_source
from warehouse_data_user_review_info a
where product_name in ('现金分期-钱伴','优智借','信用钱包')
  and data_source = 'sjd'
  and status = '通过'
  and amount > 0
  and mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
       WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
       WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');

---SJD_AN451_003
select distinct a1.mbl_no as mbl_no,
       a1.data_source as data_source
from warehouse_data_user_channel_info a1
where a1.rtype in ('3')
  and a1.mtype in ('1','2','3')
  and a1.data_source = 'sjd'
  and a1.mbl_no like 'MT%'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');