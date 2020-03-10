447 外呼需求  徐超    3、重要不紧急 2019.7.12 何渝宏 客服组 2019.7.15 
一次性需求 马上随借随还 移动手机贷 移动手机贷 外呼营销 按授信金额从高到低抽取500人 
移动手机贷平台，2019年4月16日-2019年5月31日在马上随借随还首次提现后，从2019年4月17日至今无二次提现行为的用户，
剔除授信额度低于5000的用户（保留用户姓名、手机号、授信时间、授信金额） 

1.提现过一次的用户
2.排除之前有过提现的用户
3.排除之后无提现的用户
4.取用户数据（姓名，号码，最近一次授信时间，授信金额，且金额大于等于5000）

select b1.mbl_no,'sjd' as data_source,b3.name,b2.credit_time,b2.amount
from
(select a1.mbl_no,
       count(a1.mbl_no) as cs
from warehouse_data_user_withdrawals_info a1
left outer join (select distinct mbl_no
                 from warehouse_data_user_withdrawals_info a
				 where cash_time < '2019-04-16'
				   and data_source = 'sjd'
				   and product_name = '随借随还-马上') a2
			on a1.mbl_no = a2.mbl_no
left outer join (select distinct mbl_no
                 from warehouse_data_user_withdrawals_info a
				 where cash_time > '2019-05-31'
				   and data_source = 'sjd'
				   and product_name = '随借随还-马上') a3
			on a1.mbl_no = a3.mbl_no
where a1.cash_time between '2019-04-16' and '2019-05-31'
  and a1.product_name = '随借随还-马上'
  and a1.data_source = 'sjd'
  and a2.mbl_no is null
  and a3.mbl_no is null
group by a1.mbl_no) b1
left join warehouse_data_user_review_info b2
on b1.mbl_no = b2.mbl_no
left join warehouse_atomic_user_info b3
on b1.mbl_no = b3.mbl_no
where b1.cs = '1'
  and b2.data_source = 'sjd'
  and b2.product_name = '随借随还-马上'
  and b2.status = '通过'
  and b2.amount >= '5000'
  and b3.data_source = 'sjd'
  and b1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe WHERE eff_flg = '1')
order by b2.amount desc
limit 500
