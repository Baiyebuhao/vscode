471 短信需求  徐超    3、重要不紧急 2019.7.23 纪春艳 平台运营 2019.7.25 
一次性需求 优智借 移动手机贷、享宇钱包  短信营销 按平台分包 
历史钱包易贷授信通过所有用户

1.手机贷
select distinct mbl_no,data_source
from warehouse_data_user_review_info a
where product_name = '随借随还-钱包易贷'
  and status = '通过'
  and data_source = 'sjd'
  and a.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');


2.享宇钱包
select distinct mbl_no,data_source
from warehouse_data_user_review_info a
where product_name = '随借随还-钱包易贷'
  and status = '通过'
  and data_source = 'xyqb'
  and a.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');






