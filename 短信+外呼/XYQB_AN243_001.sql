400 短信需求  徐超    3、重要不紧急 2019.6.21 纪春艳 享宇钱包 2019.6.24日下班前 
一次性需求  享宇钱包 享宇钱包 短信营销 所有用户 
享宇钱包平台，历史申请兴业和好借钱未授信用户；剔除已申请优智借产品用户

select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_review_info a1
left outer join(select distinct mbl_no,data_source 
                from warehouse_data_user_review_info a
                where product_name in ('现金分期-兴业消费','现金分期-招联')
				  and data_source = 'xyqb'
				  and status = '通过'
				)a2
		on a1.mbl_no = a2.mbl_no
	   and a1.data_source = a2.data_source
			   
left outer join(select mbl_no,data_source 
                from warehouse_data_user_review_info a
			    where product_name = '优智借'
				and data_source = 'xyqb'
				)a3
		on a1.mbl_no = a3.mbl_no
	   and a1.data_source = a3.data_source
where a1.product_name in ('现金分期-兴业消费','现金分期-招联')
  and a1.data_source = 'xyqb'
  and a2.mbl_no is null
  and a3.mbl_no is null
  and a1.mbl_no like 'MT%'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');