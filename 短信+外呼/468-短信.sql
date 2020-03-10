468 短信需求  徐超    3、重要不紧急 2019.7.23 纪春艳 平台运营 2019.7.24 
一次性需求 优智借 享宇钱包 享宇钱包 短信营销 按序号分包 

1、享宇钱包平台，7.14-7.21申请好借钱/兴业/信用钱包未授信用户；剔除已申请优智借产品用户
2、7.14-7.21点击钱伴未提现用户，剔除已申请优智借产品用户
3、享宇钱包平台6.1-7.21日注册未申请优智借产品用户

---468.1
select distinct a1.mbl_no
from warehouse_data_user_review_info a1
left outer join (select distinct mbl_no
                 from warehouse_data_user_review_info a
                 where product_name in ('现金分期-招联','现金分期-兴业消费','信用钱包')
                   and status = '通过'
				   and data_source = 'xyqb'
				 ) a2
		 on a1.mbl_no = a2.mbl_no
left outer join (select distinct mbl_no
                 from warehouse_data_user_review_info a
                 where product_name = '优智借'
				 and data_source = 'xyqb'
				 ) a3 
         on a1.mbl_no = a3.mbl_no

where a1.product_name in ('现金分期-招联','现金分期-兴业消费','信用钱包')
  and a1.data_source = 'xyqb'
  and a1.apply_time between '2019-07-14' and '2019-07-21'
  and a2.mbl_no is null
  and a3.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');
---2
select a1.mbl_no
from 
(select distinct mbl_no
from warehouse_newtrace_click_record b1
where extractday between '2019-07-14' and '2019-07-21'
and platform = 'xyqb'
and product_name = '钱伴'
UNION
select distinct mbl_no
from warehouse_atomic_user_action b2
where sys_id = 'xyqb'
and extractday between '2019-07-14' and '2019-07-21'
and product_name = '钱伴') a1
left outer join 
                (select distinct mbl_no
                from warehouse_data_user_withdrawals_info a
                where data_source = 'xyqb'
                  and product_name = '钱伴'
                  and cash_amount > '0'
                ) a2
         on a1.mbl_no = a2.mbl_no
left outer join (select distinct mbl_no
                 from warehouse_data_user_review_info a
                 where product_name = '优智借'
				 and data_source = 'xyqb'
				 ) a3 
         on a1.mbl_no = a3.mbl_no
where a2.mbl_no is null
  and a3.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');
---3
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
  and a1.registe_date between '2019-06-01' and '2019-07-21'
  and a2.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');








