337	短信需求  徐超     2019.6.3 刘虹 移动手机贷 2019.6.5 一次性需求 
马上随借随还（端午免息券） 移动手机贷 短信营销 
由近及远取5000人
--2019年4月1日至今注册且实名的移动用户，未申请马上随借随还，剔除申请兴业消费不通过的用户
select a1.mbl_no,
       a1.data_source,
	   a1.registe_date
from warehouse_atomic_user_info a1
  join warehouse_atomic_all_process_info a2
    on a1.mbl_no = a2.mbl_no 
   and a1.data_source = a2.data_source
  left outer join (select distinct mbl_no,data_source
			       from warehouse_data_user_review_info a
			       where product_name = '随借随还-马上'
				     and data_source = 'sjd') a3
			on a1.mbl_no = a3.mbl_no
           and a1.data_source = a3.data_source
  left outer join (select distinct mbl_no,data_source
			       from warehouse_data_user_review_info a
			       where product_name = '现金分期-兴业消费'
				     and data_source = 'sjd'
				     and status != '通过') a4
			on a1.mbl_no = a4.mbl_no
           and a1.data_source = a4.data_source  
 where a1.registe_date between '2019-04-01' and '2019-05-31'                 ---选择注册时间维度
   and a1.data_source = 'sjd'
   and a1.isp = '移动'
   and a2.action_name = '实名'
   and a2.action_date between '2019-04-01' and '2019-05-31'
   and a3.mbl_no is null
   and a4.mbl_no is null 
   and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX')
order by a1.registe_date desc
limit 5000;