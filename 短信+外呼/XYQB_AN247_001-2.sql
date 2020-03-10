移动手机贷平台，2019年5.1-2019.6.24日期间提现3次及以上用户，剔除已申请优智借产品的用户，仅提取联通用户
移动手机贷平台，2019年5.1-2019.6.24日期间提现3次及以上用户，剔除已申请优智借产品的用户，仅提取移动用户


select a1.mbl_no,a1.data_source
from 
(select a2.mbl_no,'sjd' as data_source
 from (select a.mbl_no,count(a.mbl_no) as rum1
     from warehouse_data_user_withdrawals_info a
     where a.data_source = 'sjd'
       and a.cash_amount > '0'
       and a.cash_time between '2019-05-01' and '2019-06-24'
	   and a.mbl_no like 'MT%'
     group by a.mbl_no) a2
 where rum1 >= '3') a1

left join warehouse_atomic_user_info a3
       on a1.mbl_no = a3.mbl_no
      and a1.data_source = a3.data_source
left outer join (select mbl_no,data_source
                 from warehouse_data_user_review_info a
                 where product_name = '优智借'
                   and data_source = 'sjd') a4
       on a1.mbl_no = a4.mbl_no
      and a1.data_source = a4.data_source
where a3.isp = '移动'
  and a4.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');