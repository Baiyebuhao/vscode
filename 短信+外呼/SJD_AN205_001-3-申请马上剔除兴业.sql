313	徐超 3、重要不紧急	2019.5.28	刘虹	移动手机贷	2019.5.29	
一次性需求	好借钱	移动手机贷	移动手机贷	
短信营销
2018年8月1日-2019年5月27日，申请马上随借随还审批通过的移动用户，剔除所有申请过招联好借钱、兴业的用户

1.2018年8月1日-2019年5月27日，申请马上随借随还审批通过的移动用户，剔除所有申请过招联好借钱、兴业、万达的用户

select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_review_info a1

left join warehouse_atomic_user_info a4
          on a1.mbl_no = a4.mbl_no
		  and a1.data_source = a4.data_source
  
left outer join(select * from warehouse_data_user_review_info a2
			    where a2.product_name in ('现金分期-招联','现金分期-兴业消费','现金分期-万达普惠'))a3
				on a1.mbl_no = a3.mbl_no
				
where a1.product_name = '随借随还-马上'
  and a1.data_source = 'sjd'
  and a1.status = '通过'
  and a1.apply_time between '2018-08-01' and '2019-05-27'
  and a4.isp = '移动'
  and a3.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
                        WHERE eff_flg = '1' 
						UNION 
						SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
                        WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date()
						AND marketing_type = 'DX')

2.2019年5月15日至今已领取免息券，且历史以来从未申请马上随借随还的用户

select distinct a1.phone_number as mbl_no,
       a1.data_source
from warehouse_atomic_coupon_code a1
  left join warehouse_atomic_user_info a2
         on a1.phone_number = a2.mbl_no
  left outer join (select distinct mbl_no
                   from warehouse_data_user_review_info b
                   where product_name = '随借随还-马上'
				   and data_source = 'sjd') a3
	            on a1.phone_number = a3.mbl_no
where a1.coupon_type='2'
  and a1.data_source = 'sjd'
  and substring(a1.tm_smp,1,8) between '20190515' and '20190527'
  and a3.mbl_no is null
  and a1.phone_number NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
                              WHERE eff_flg = '1' 
						      UNION 
						      SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
                              WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date()
						      AND marketing_type = 'DX')

  

3.2019年5月15日至今已领取免息券，且申请马上随借随还授信还未提现用户
select distinct a1.phone_number as mbl_no,
       a1.data_source
from warehouse_atomic_coupon_code a1
  join warehouse_atomic_user_info a2
    on a1.phone_number = a2.mbl_no
   and a1.data_source = a2.data_source
  join warehouse_data_user_review_info a3
    on a1.phone_number = a3.mbl_no
   and a1.data_source = a3.data_source
  left outer join (select mbl_no,data_source
                   from warehouse_data_user_withdrawals_info
                   where product_name = '随借随还-马上'
				     and data_source = 'sjd') a4
              on a1.phone_number = a4.mbl_no
             and a1.data_source = a4.data_source 
where a1.coupon_type='2'
  and a1.data_source = 'sjd'
  and substring(a1.tm_smp,1,8) between '20190515' and '20190527'
  and a3.product_name = '随借随还-马上'
  and a3.status = '通过'
  and a4.mbl_no is null
  and a1.phone_number NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
                              WHERE eff_flg = '1' 
						      UNION 
						      SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
                              WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date()
						      AND marketing_type = 'DX')
3.法2

select distinct b.phone_number as mbl_no,
       b.data_source
from warehouse_atomic_coupon_code b
join    
(select distinct a1.mbl_no,a1.data_source
 from warehouse_data_user_review_info a1
 left outer join (select mbl_no,data_source
                   from warehouse_data_user_withdrawals_info
                   where product_name = '随借随还-马上'
				     and data_source = 'sjd') a2
			 on a1.mbl_no = a2.mbl_no
			and a1.data_source = a2.data_source
where a1.data_source = 'sjd'
  and a1.product_name = '随借随还-马上'
  and a1.status = '通过'
  and a2.mbl_no is null) a3
 on b.phone_number = a3.mbl_no
and b.data_source = a3.data_source
where b.coupon_type='2'
  and b.data_source = 'sjd'
  and substring(b.tm_smp,1,8) between '20190515' and '20190527'
  and b.phone_number NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
                              WHERE eff_flg = '1' 
						      UNION 
						      SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
                              WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date()
						      AND marketing_type = 'DX')











