459 短信需求  徐超   3、重要不紧急 2019.7.19 纪春艳 平台运营 2019.7.22下午 
一次性需求 马上随借随还 移动手机贷 移动手机贷 短信营销 按序号分包 
1、额度有效期内，马上随借随还已提现用户，剔除7月提现2次及以上用户；
2、额度有效期内，马上随借随还授信未提现用户；

select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_withdrawals_info a1
left outer join (select mbl_no
                 from (select a.mbl_no,count(mbl_no) as cs
                       from warehouse_data_user_withdrawals_info a
	                   where cash_time >= '2019-07-01'
	                     and product_name = '随借随还-马上'
				         and cash_amount > '0'
				         and data_source = 'sjd'
				       group by a.mbl_no) b
				 where b.cs >= '2') a2
on a1.mbl_no = a2.mbl_no
join warehouse_atomic_msd_withdrawals_result_info a3
 on a1.mbl_no = a3.mbl_no
and a1.data_source = a3.data_source

where a1.data_source = 'sjd'
  and a1.product_name = '随借随还-马上'
  and a2.mbl_no is null
  and a3.paid_out_time > '2019-07-23'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');

----2.法一(数据字段问题）（不使用）
(select distinct a1.mbl_no,
       substr(a1.credit_time,1,10) as credit_date,
       date(substr(a1.credit_time,1,10)) + interval '1' year as credit_end_date
from warehouse_atomic_msd_review_result_info a1
where a1.appral_res = '通过'
  and a1.mbl_no <> 'NULL'
  and a1.data_source = 'sjd') a2

left outer join (select a.mbl_no
                 from warehouse_data_user_withdrawals_info a
	             where product_name = '随借随还-马上'
				   and cash_amount > '0'
				   and data_source = 'sjd') a3
where a2.credit_end_date >'2019-07-23'
  and a3.mbl_no is null
  


---2,法二
select distinct a1.mbl_no
from warehouse_atomic_msd_withdrawals_result_info a1
left outer join (select mbl_no 
                 from warehouse_atomic_msd_withdrawals_result_info a
                 where total_amount > '0'
                   and data_source = 'sjd') a2
           on a1.mbl_no = a2.mbl_no
where a1.data_source = 'sjd'
  and a1.paid_out_time > '2019-07-23'
  and a2.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');



  
  
