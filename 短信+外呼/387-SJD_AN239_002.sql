387	短信需求  徐超     2019.6.17 刘虹 移动手机贷 2019.6.18 
一次性需求 好借钱 移动手机贷 移动手机贷 短信营销  
2019年3月16日至6月16日马上随借随还有提现行为，剔除申请过好借钱同时申请兴业或万达的用户 请相互剔重 

(--同时申请好借钱和兴业
select distinct a.mbl_no 
from warehouse_data_user_review_info a
join warehouse_data_user_review_info b
on a.mbl_no = b.mbl_no
and a.data_source = b.data_source
where a.product_name = '现金分期-招联'
  and b.product_name = '现金分期-兴业消费'
  and a.data_source = 'sjd'

UNION
--同时申请好借钱和万达
select distinct a.mbl_no 
from warehouse_data_user_review_info a
join warehouse_data_user_review_info b
on a.mbl_no = b.mbl_no
and a.data_source = b.data_source
where a.product_name = '现金分期-招联'
  and b.product_name = '现金分期-万达普惠'
  and a.data_source = 'sjd')

-----
select distinct a1.mbl_no,a1.data_source
  from warehouse_data_user_withdrawals_info a1
left outer join(--同时申请好借钱和兴业
                select distinct a.mbl_no,a.data_source
                from warehouse_data_user_review_info a
                join warehouse_data_user_review_info b
                on a.mbl_no = b.mbl_no
                and a.data_source = b.data_source
                where a.product_name = '现金分期-招联'
                  and b.product_name = '现金分期-兴业消费'
                  and a.data_source = 'sjd'
                UNION
                --同时申请好借钱和万达
                select distinct a.mbl_no,a.data_source
                from warehouse_data_user_review_info a
                join warehouse_data_user_review_info b
                on a.mbl_no = b.mbl_no
                and a.data_source = b.data_source
                where a.product_name = '现金分期-招联'
                  and b.product_name = '现金分期-万达普惠'
                  and a.data_source = 'sjd') a2
 on a1.mbl_no = a2.mbl_no
and a1.data_source = a2.data_source

 where a1.data_source = 'sjd'
   and a1.product_name = '随借随还-马上'
   and a1.cash_time between '2019-03-16' and '2019-06-16'
   and a1.cash_amount > '0'
   and a1.mbl_no like 'MT%'
   and a2.mbl_no is null
   and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX')