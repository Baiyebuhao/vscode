移动手机贷
1.2019年4月1日-2019年5月13日实名未申请兴业的用户。 
select distinct a1.mbl_no,a1.data_source
from warehouse_atomic_all_process_info a1
left outer join 
      (select distinct b.mbl_no 
        from warehouse_data_user_review_info b
       where product_name = '现金分期-兴业消费'
         and data_source = 'sjd'
         and apply_time >= '2019-04-01') a2
    on a1.mbl_no = a2.mbl_no
 where a1.action_name = '实名'
   and a1.action_date between '2019-04-01' and '2019-05-13'
   and a1.data_source = 'sjd'
   and a2.mbl_no is null
--------------
2.2018年1月1日至今，马上随借随还授信从未提现过的用户.
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_review_info a1
left outer join 
      (select mbl_no,data_source
         from warehouse_data_user_withdrawals_info a
        where product_name = '随借随还-马上'
          and cash_time >= '2018-01-01'
          and data_source = 'sjd') a2
on a1.mbl_no =a2.mbl_no
and a1.data_source =a2.data_source
where a1.product_name = '随借随还-马上'
and a1.credit_time >= '2018-01-01'
and a1.data_source = 'sjd'
and a1.status = '通过'
and a2.mbl_no is null








select * from warehouse_data_user_withdrawals_info a
where product_name = '随借随还-马上'
and cash_time >= '2018-01-01'
an data_source = 'sjd'