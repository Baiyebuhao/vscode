381	短信需求  徐超    3、重要不紧急 2019.6.17 李薇薇 金融苑 2019.6.18 
一次性需求 招联好借钱 金融苑 金融苑 短信营销 所有用户 
1、2019年6月10日-2019年6月17日注册且至今未申请招联好借钱的用户
2、近3个月在金融苑平台有过活跃，但至今未申请招联好借钱的用户
两个规则的用户取在一个数据包即可 

(--
select distinct a1.mbl_no,a1.data_source
from warehouse_atomic_user_info a1

left outer join(select mbl_no,data_source 
                from warehouse_data_user_review_info a
			    where product_name = '现金分期-招联'
				and data_source = 'jry')a2
		on a1.mbl_no = a2.mbl_no
	   and a1.data_source = a2.data_source

where a1.registe_date between '2019-06-10' and '2019-06-17'
  and a1.data_source = 'jry'
  and a2.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX')

UNION
---
select a3.mbl_no,'jry' as data_source 
         from (select distinct mbl_no
               from warehouse_newtrace_click_record b1
               where extractday between '2019-03-17' and '2019-06-17'
               and platform = 'jry'
               UNION
               select distinct mbl_no
               from warehouse_atomic_user_action b2
               where sys_id = 'jry'
               and extractday between '2019-03-17' and '2019-06-17') a3 

left outer join(select mbl_no,data_source 
                from warehouse_data_user_review_info a
			    where product_name = '现金分期-招联'
				and data_source = 'jry')a4
		on a3.mbl_no = a4.mbl_no
where a4.mbl_no is null
  and a3.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX')
)

(
select distinct a1.mbl_no,a1.data_source
from
(select distinct mbl_no,data_source
from warehouse_atomic_user_info a
where a.registe_date between '2019-06-10' and '2019-06-17'
  and a.data_source = 'jry'
UNION
select distinct mbl_no,'jry' as data_source
from warehouse_newtrace_click_record b
where extractday between '2019-03-17' and '2019-06-17'
  and platform = 'jry'
UNION
select distinct mbl_no,'jry' as data_source
from warehouse_atomic_user_action c
where sys_id = 'jry'
  and extractday between '2019-03-17' and '2019-06-17') a1
left outer join(select mbl_no,data_source 
                from warehouse_data_user_review_info a
			    where product_name = '现金分期-招联'
				and data_source = 'jry')a2
		on a1.mbl_no = a2.mbl_no
	   and a1.data_source = a2.data_source
where a2.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX')
)