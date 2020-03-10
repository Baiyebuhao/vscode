590 短信需求  徐超 已编码    重要不紧急 纪春艳 平台运营 2019.9.10 2019.9.11 
一次性需求 钱伴 享宇钱包 享宇钱包 短信营销 按序号分包
1、历史已授信的联通用户，剔除已申请钱伴产品的用户
2、6.1-9.10日已实名未申请钱伴产品的联通用户
--1历史已授信的联通用户，剔除已申请钱伴产品的用户 XYQB_AN347_001
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_review_info a1

left outer join (select distinct mbl_no
                 from warehouse_data_user_review_info a
                 where product_name = '现金分期-钱伴'
				 ) a2
         on a1.mbl_no = a2.mbl_no
join warehouse_atomic_user_info a3
 on a1.mbl_no = a3.mbl_no
and a1.data_source = a3.data_source
where a1.data_source = 'xyqb'
  and a1.status = '通过'
  and a1.mbl_no <> 'NULL'
  and a2.mbl_no is null
  and a3.isp LIKE '%联通%'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');

--6.1-9.10日已实名未申请钱伴产品的联通用户 XYQB_AN347_002
select a1.mbl_no,
       a1.data_source        
from warehouse_atomic_user_info a1
join warehouse_atomic_all_process_info a2
    on a1.mbl_no = a2.mbl_no 
   and a1.data_source = a2.data_source
left outer join
               (select distinct mbl_no
			    from warehouse_data_user_review_info
				where product_name = '现金分期-钱伴'
				) a3
    on a1.mbl_no = a3.mbl_no
 where a1.data_source = 'xyqb'
   and a1.isp LIKE '%联通%'
   and a2.action_name = '实名'
   and a2.action_date between '2019-06-01' and '2019-09-10'
   and a3.mbl_no is null
   and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
       WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
       WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');
