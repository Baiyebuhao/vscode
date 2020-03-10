新用户效能2（注册存在问题）
select data_source,
       product_name,
	   count(DISTINCT CASE
                          WHEN code = '注册' THEN mbl_no
                      END) AS dnum1,
       count(DISTINCT CASE
                          WHEN code = '推送' THEN mbl_no
                      END) AS dnum2,
	   count(DISTINCT CASE
                          WHEN code = '申请' THEN mbl_no
                      END) AS dnum3,
       count(DISTINCT CASE
                          WHEN code = '授信' THEN mbl_no
                      END) AS dnum4,
       count(DISTINCT CASE
                          WHEN code = '提现' THEN mbl_no
                      END) AS dnum5,
					  
       SUM( CASE WHEN code = '提现' THEN cash_amount
                      END) AS dnum6
from 
(-----1.注册
select '注册' as code,
       a1.data_source,
	   'null' as product_name,
       a1.mbl_no,
	   '0' as cash_amount
from warehouse_atomic_user_info a1
where a1.registe_date between '2019-03-01' and '2019-03-31'

union all
---2.推送
select '推送' as code,
       a1.sys_id as data_source,
	   a1.product_name,
       a1.mbl_no,
	   '0' as cash_amount
from warehouse_data_user_page_action a1
join warehouse_atomic_user_info a2
     on a1.mbl_no = a2.mbl_no
    and a1.sys_id = a2.data_source  
where a1.extractday between '2019-03-01' and '2019-03-31'
  and a2.registe_date between '2019-03-01' and '2019-03-31'
  and a1.button_name in ('申请','立即申请') 
-----------------------and a1.product_name = '随借随还-钱包易贷'

union all
-----3.新用户申请
select '申请' as code,
       a1.data_source,
	   a1.product_name,
       a1.mbl_no,
	   '0' as cash_amount
from warehouse_data_user_review_info a1
join warehouse_atomic_user_info a2  
   on a1.mbl_no = a2.mbl_no
  and a1.data_source = a2.data_source 
where a1.apply_time between '2019-03-01' and '2019-03-31'
  and a2.registe_date between '2019-03-01' and '2019-03-31'
-----------------------and a1.product_name = '随借随还-钱包易贷'

union all
-----4.新用户授信
select '授信' as code,
       a1.data_source,
	   a1.product_name,
       a1.mbl_no,
	   '0' as cash_amount
from warehouse_data_user_review_info a1
join warehouse_atomic_user_info a2  
   on a1.mbl_no = a2.mbl_no
   and a1.data_source = a2.data_source
where a1.apply_time between '2019-03-01' and '2019-03-31'
  and a2.registe_date between '2019-03-01' and '2019-03-31'
  and a1.status = '通过'
-----------------------and a1.product_name = '随借随还-钱包易贷'

union all
-----5.新用户提现
select '提现' as code,
       a1.data_source,
	   a1.product_name,
       a1.mbl_no,
       a1.cash_amount
from warehouse_data_user_withdrawals_info a1
join warehouse_atomic_user_info a2  
   on a1.mbl_no = a2.mbl_no
   and a1.data_source = a2.data_source
where a1.cash_time between '2019-03-01' and '2019-03-31'
  and a2.registe_date between '2019-03-01' and '2019-03-31') c
group by data_source,product_name
