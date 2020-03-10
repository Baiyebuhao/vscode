485 取数需求  徐超    1、紧急且重要 2019.7.31 龚月 小额现金贷 2019.8.1 
一次性需求 全产品（详见表） 三平台  7月经营分析  
7月1日—7月30日，当月注册用户在当月产生的转化 

---注册
select a.data_source,count(a.mbl_no) from warehouse_atomic_user_info a
where a.registe_date between '2019-07-01' and '2019-07-31'
group by a.data_source


-----新用户推送
select count(distinct a1.mbl_no) as ts,
       a1.sys_id,
	   a1.product_name
from warehouse_data_user_page_action a1
join (select a.data_source,a.mbl_no from warehouse_atomic_user_info a
      where a.registe_date between '2019-07-01' and '2019-07-31') a2
   on a1.mbl_no = a2.mbl_no
   and a1.sys_id = a2.data_source
where a1.extractday between '2019-07-01' and '2019-07-31'
and a1.button_name in ('申请','立即申请') 
group by a1.sys_id,a1.product_name

-----新用户申请
select count(distinct a1.mbl_no) as sq,
       a1.data_source,
	   a1.product_name
from warehouse_data_user_review_info a1
join (select a.data_source,a.mbl_no from warehouse_atomic_user_info a
      where a.registe_date between '2019-07-01' and '2019-07-31') a2
   on a1.mbl_no = a2.mbl_no
   and a1.data_source = a2.data_source
where a1.apply_time between '2019-07-01' and '2019-07-31'
and a1.product_name in ('现金分期-招联','现金分期-钱伴','优智借','趣借钱','信用钱包')
group by a1.data_source,a1.product_name

-----新用户授信
select count(distinct a1.mbl_no) as sx,
       a1.data_source,
	   a1.product_name
from warehouse_data_user_review_info a1
join (select a.data_source,a.mbl_no from warehouse_atomic_user_info a
      where a.registe_date between '2019-07-01' and '2019-07-31') a2
   on a1.mbl_no = a2.mbl_no
   and a1.data_source = a2.data_source
where a1.apply_time between '2019-07-01' and '2019-07-31'
and a1.status = '通过'
and a1.product_name in ('现金分期-招联','现金分期-钱伴','优智借','趣借钱','信用钱包')
group by a1.data_source,
	   a1.product_name

-----新用户提现
select count(distinct a1.mbl_no) as tx,
       sum(a1.cash_amount) as txe,
       a1.data_source,
	   a1.product_name
from warehouse_data_user_withdrawals_info a1
join (select a.data_source,a.mbl_no from warehouse_atomic_user_info a
      where a.registe_date between '2019-07-01' and '2019-07-31') a2
   on a1.mbl_no = a2.mbl_no
   and a1.data_source = a2.data_source
where a1.cash_time between '2019-07-01' and '2019-07-31'
and a1.product_name in ('现金分期-招联','现金分期-钱伴','优智借','趣借钱','信用钱包')
group by a1.data_source,
	   a1.product_name