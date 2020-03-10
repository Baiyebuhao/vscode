354	短信需求  徐超3、重要不紧急	2019.6.10	李薇薇	
金融苑	2019.6.11 一次性需求 马上随借随还 短信营销  
--2019年6月1日-2019年6月9日注册的所有用户，剔除其中申请过招联好借钱的用户 
select a1.mbl_no 
from warehouse_atomic_user_info a1
left outer 
join (select mbl_no from warehouse_data_user_review_info
      where product_name = '现金分期-招联') a2
  on a1.mbl_no = a2.mbl_no
where a1.registe_date between '2019-06-01' and '2019-06-09'
  and a1.data_source = 'jry'
  and a2.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');