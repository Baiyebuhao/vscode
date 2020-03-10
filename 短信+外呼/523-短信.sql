523 短信需求  徐超     3、重要不紧急 纪春艳 平台运营 2019.8.15 2019.8.16 
一次性需求 优智借 享宇钱包 享宇钱包 短信营销 按序号分包 
1、享宇钱包平台，8.1-8.15日注册未申请优智借产品用户；
2、享宇钱包平台，RFM模型中，R值为1,2，M值为1,2，3的用户
---1
select a1.mbl_no,
       a1.data_source
from warehouse_atomic_user_info a1
left outer join (select distinct mbl_no
                 from warehouse_data_user_review_info a
                 where product_name = '优智借'
				   and data_source = 'xyqb'
				 ) a2
         on a1.mbl_no = a2.mbl_no
where a1.data_source = 'xyqb'
  and a1.registe_date between '2019-08-01' and '2019-08-15'
  and a2.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');

--2
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_channel_info a1
where a1.rtype in ('1','2')
  and a1.mtype in ('1','2','3')
  and a1.data_source = 'xyqb'
  and a1.mbl_no like 'MT%'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');