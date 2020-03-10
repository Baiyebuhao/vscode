新用户效能
1.注册
select '注册' as code,
       a.data_source,
       count(a.mbl_no) 
from warehouse_atomic_user_info a
where a.registe_date between '2019-03-01' and '2019-03-31'
group by a.data_source
2.推送
select '推送' as code,
       count(distinct a1.mbl_no) as ts,
       a1.sys_id,
	   a1.product_name
from warehouse_data_user_page_action a1
join warehouse_atomic_user_info a2
     on a1.mbl_no = a2.mbl_no
    and a1.sys_id = a2.data_source  
where a1.extractday between '2019-03-01' and '2019-03-31'
  and a2.registe_date between '2019-03-01' and '2019-03-31'
  and a1.button_name in ('申请','立即申请') 
-----------------------and a1.product_name = '随借随还-钱包易贷'
group by a1.sys_id,a1.product_name
3.申请
-----新用户申请
select '申请' as code,
       count(distinct a1.mbl_no) as sq,
       a1.data_source,
	   a1.product_name
from warehouse_data_user_review_info a1
join warehouse_atomic_user_info a2  
   on a1.mbl_no = a2.mbl_no
  and a1.data_source = a2.data_source 
where a1.apply_time between '2019-03-01' and '2019-03-31'
  and a2.registe_date between '2019-03-01' and '2019-03-31'
-----------------------and a1.product_name = '随借随还-钱包易贷'
group by a1.data_source,a1.product_name
4.授信
-----新用户授信
select '授信' as code,
       count(distinct a1.mbl_no) as sx,
       a1.data_source,
	   a1.product_name
from warehouse_data_user_review_info a1
join warehouse_atomic_user_info a2  
   on a1.mbl_no = a2.mbl_no
   and a1.data_source = a2.data_source
where a1.apply_time between '2019-03-01' and '2019-03-31'
  and a2.registe_date between '2019-03-01' and '2019-03-31'
  and a1.status = '通过'
-----------------------and a1.product_name = '随借随还-钱包易贷'
group by a1.data_source,a1.product_name
5.提现
-----新用户提现
select '提现' as code,
       count(distinct a1.mbl_no) as tx,
       sum(a1.cash_amount) as txe,
       a1.data_source,
	   a1.product_name
from warehouse_data_user_withdrawals_info a1
join warehouse_atomic_user_info a2  
   on a1.mbl_no = a2.mbl_no
   and a1.data_source = a2.data_source
where a1.cash_time between '2019-03-01' and '2019-03-31'
  and a2.registe_date between '2019-03-01' and '2019-03-31'
-----------------------and a1.product_name = '随借随还-钱包易贷'
group by a1.data_source,a1.product_name