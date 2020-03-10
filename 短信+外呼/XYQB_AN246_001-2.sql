2019.4.1-2019.4.30日，在手机贷平台申请任一产品被拒用户，剔除已申请优智借产品用户，仅提取联通用户
2019.4.1-2019.4.30日，在手机贷平台申请任一产品被拒用户，剔除已申请优智借产品用户，仅提取移动用户
select a1.mbl_no,a1.data_source
from warehouse_data_user_review_info a1
left outer join (select mbl_no,data_source
                 from warehouse_data_user_review_info a
                 where status = '通过'
                 and apply_time between '2019-04-01' and '2019-04-30'
                 and data_source = 'sjd') a2
       on a1.mbl_no = a2.mbl_no
      and a1.data_source = a2.data_source
left join warehouse_atomic_user_info a3
       on a1.mbl_no = a3.mbl_no
      and a1.data_source = a3.data_source
left outer join (select mbl_no,data_source
                 from warehouse_data_user_review_info a
                 where product_name = '优智借'
                   and data_source = 'sjd') a4
       on a1.mbl_no = a4.mbl_no
      and a1.data_source = a4.data_source
where a1.apply_time between '2019-04-01' and '2019-04-30'
  and a1.data_source = 'sjd'
  and a2.mbl_no is null
  and a3.isp = '联通'
  and a4.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');