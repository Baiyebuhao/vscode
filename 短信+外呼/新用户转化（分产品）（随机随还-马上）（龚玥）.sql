-----现金分期-兴业消费
-----新用户注册
select a.data_source,count(a.mbl_no) from warehouse_atomic_user_info a
where a.registe_date between '2019-04-21' and '2019-04-27'
group by a.data_source
-----新用户推送
select count(distinct a1.mbl_no) as ts,
       a1.sys_id
from warehouse_data_user_page_action a1
join (select a.data_source,a.mbl_no from warehouse_atomic_user_info a
      where a.registe_date between '2019-04-21' and '2019-04-27') a2
   on a1.mbl_no = a2.mbl_no
   and a1.sys_id = a2.data_source
where a1.extractday between '2019-04-21' and '2019-04-27'
and a1.button_name in ('申请','立即申请') 
and a1.product_name = '现金分期-兴业消费'
group by a1.sys_id

-----新用户申请
select count(distinct a1.mbl_no) as sq,
       a1.data_source
from warehouse_data_user_review_info a1
join (select a.data_source,a.mbl_no from warehouse_atomic_user_info a
      where a.registe_date between '2019-04-21' and '2019-04-27') a2
   on a1.mbl_no = a2.mbl_no
   and a1.data_source = a2.data_source
where a1.apply_time between '2019-04-21' and '2019-04-27'
and a1.product_name = '现金分期-兴业消费'
group by a1.data_source


-----新用户授信
select count(distinct a1.mbl_no) as sx,a1.data_source
from warehouse_data_user_review_info a1
join (select a.data_source,a.mbl_no from warehouse_atomic_user_info a
      where a.registe_date between '2019-04-21' and '2019-04-27') a2
   on a1.mbl_no = a2.mbl_no
   and a1.data_source = a2.data_source
where a1.apply_time between '2019-04-21' and '2019-04-27'
and a1.status = '通过'
and a1.product_name = '现金分期-兴业消费'
group by a1.data_source


-----新用户提现
select count(distinct a1.mbl_no) as tx,
       sum(a1.cash_amount) as txe,
       a1.data_source
from warehouse_data_user_withdrawals_info a1
join (select a.data_source,a.mbl_no from warehouse_atomic_user_info a
      where a.registe_date between '2019-04-21' and '2019-04-27') a2
   on a1.mbl_no = a2.mbl_no
   and a1.data_source = a2.data_source
where a1.cash_time between '2019-04-21' and '2019-04-27'  
and a1.product_name = '现金分期-兴业消费'
group by a1.data_source

