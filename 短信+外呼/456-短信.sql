456 短信需求  徐超    3、重要不紧急 2019.7.17 纪春艳 平台运营 2019.7.18 
一次性需求 优智借 享宇钱包 享宇钱包 短信营销  
7.1-7.14实名未申请优智借产品用户


select a1.mbl_no,
       a1.data_source        
from warehouse_atomic_user_info a1
join warehouse_atomic_all_process_info a2
    on a1.mbl_no = a2.mbl_no 
   and a1.data_source = a2.data_source
left outer join
               (select distinct mbl_no
			    from warehouse_data_user_review_info
				where product_name = '优智借'
				  and data_source = 'xyqb') a3
    on a1.mbl_no = a3.mbl_no
 where a1.data_source = 'xyqb'
   and a2.action_name = '实名'
   and a2.action_date between '2019-07-01' and '2019-07-14'
   and a3.mbl_no is null
   and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
       WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
       WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');
