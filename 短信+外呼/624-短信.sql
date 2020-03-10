624 短信需求  赵小庆 已编码    3、重要不紧急 纪春艳 平台运营 2019.9.29 2019.9.30 
一次性需求 优智借 移动手机贷 移动手机贷 短信营销  

--移动手机贷平台，优智借已授信未提现的移动用户（额度有效期内）SJD_AN365_001

select distinct a1.mbl_no,
                a1.data_source

from warehouse_data_user_review_info a1

left outer join (select  distinct mbl_no
                 from warehouse_atomic_yzj_withdrawals_result_info a
				 where data_source = 'sjd') a2
            on a1.mbl_no = a2.mbl_no

where a1.product_name = '优智借'
   and a1.data_source = 'sjd'
   and a1.status = '通过'
   and a1.credit_time >= '2019-08-30'
   and a2.mbl_no is null
   and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');

