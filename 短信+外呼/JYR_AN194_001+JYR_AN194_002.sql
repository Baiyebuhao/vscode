278	日常取数		田婷、徐超					2019.5.15	李薇薇	金融苑	2019.5.16	
一次性需求	招联好借钱	金融苑+享宇钱包	短信推广		
金融苑（享宇钱包）平台，2018年1月1日-2019年5月15日，
申请马上随借随还审批通过的移动用户，剔除所有申请过招联好借钱、兴业、万达的用户

select distinct a1.mbl_no,a1.data_source 
from warehouse_data_user_review_info a1
left join warehouse_atomic_user_info a2
       on a1.mbl_no = a2.mbl_no
	   and a1.data_source = a2.data_source
left outer join 
	   (select distinct mbl_no,data_source
	    from warehouse_data_user_review_info b
	    where b.data_source in ('jry','xyqb')
	     and b.product_name in ('现金分期-兴业消费','现金分期-招联','现金分期-万达普惠')
	    )a3
on a1.mbl_no = a3.mbl_no
and a1.data_source = a3.data_source
where a1.product_name = '随借随还-马上'
  and a1.status = '通过'
  and a1.data_source in ('jry','xyqb')
  and a1.credit_time between '2018-01-01' and '2019-05-15'
  and a2.isp = '移动'
  and a3.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
  WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
  WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');


279	日常取数		田婷、徐超					2019.5.15	李薇薇	金融苑	2019.5.16	
一次性需求	招联好借钱	金融苑+享宇钱包	短信推广		
金融苑（享宇钱包）平台，2018年7月1日-2019年5月15日，
申请马上随借随还审批不通过的移动用户，剔除所有申请过招联好借钱、兴业、万达的用户
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_review_info a1
left join warehouse_atomic_user_info a2
       on a1.mbl_no = a2.mbl_no
	   and a1.data_source = a2.data_source
left outer join 
       (select * 
	    from warehouse_data_user_review_info b
		where b.product_name = '随借随还-马上'
          and b.status = '通过'
          and b.data_source in ('jry','xyqb')
          and b.credit_time between '2018-07-01' and '2019-05-15') b1
 on a1.mbl_no = b1.mbl_no
and a1.data_source = b1.data_source
left outer join 
	   (select distinct mbl_no,data_source
	    from warehouse_data_user_review_info b
	    where b.data_source in ('jry','xyqb')
	     and b.product_name in ('现金分期-兴业消费','现金分期-招联','现金分期-万达普惠')
	    )a3
 on a1.mbl_no = a3.mbl_no
and a1.data_source = a3.data_source
where a1.product_name = '随借随还-马上'
  and a1.data_source in ('jry','xyqb')
  and a1.credit_time between '2018-07-01' and '2019-05-15'
  and a2.isp = '移动'
  and b1.mbl_no is null
  and a3.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
  WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
  WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');

	
	
	
	
	
	
	
	
	
	
	
select distinct a1.mbl_no,a1.data_source 
from warehouse_data_user_review_info a1
left join warehouse_atomic_user_info a2
       on a1.mbl_no = a2.mbl_no
	   and a1.data_source = a2.data_source
left outer join 
	   (select distinct mbl_no
	    from warehouse_data_user_review_info b
	    where b.data_source in ('jry','xyqb')
	     and b.product_name in ('现金分期-兴业消费','现金分期-招联','现金分期-万达普惠')
	    )a3
on a1.mbl_no = a3.mbl_no
where a1.product_name = '随借随还-马上'
  and a1.status = '通过'
  and a1.data_source in ('jry','xyqb')
  and a1.credit_time between '2018-01-01' and '2019-05-15'
  and a2.isp = '移动'
  and a3.mbl_no is null
