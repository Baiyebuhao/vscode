-------------
-------------2018.1月—2019.4月提现一次以上各产品用户分布

1.每个用户提现多少次
(
select data_source,product_name,mbl_no,count(mbl_no) as cs
from warehouse_data_user_withdrawals_info a 
where cash_time between '2018-01-01' and '2019-04-30'
group by data_source,product_name,mbl_no
)

2.按照提现次数分有多少人

select a1.data_source,a1.product_name,a1.cs,count(distinct a1.mbl_no)
from 
(select data_source,product_name,mbl_no,count(mbl_no) as cs
from warehouse_data_user_withdrawals_info a 
where cash_time between '2018-01-01' and '2019-04-30'
group by data_source,product_name,mbl_no) a1

group by a1.data_source,a1.product_name,a1.cs
------------------
--------2018.1月—2019.4月全平台累计提现金额

select a1.data_source,a1.je,count(distinct a1.mbl_no)
from 
(select data_source,mbl_no,sum(cash_amount) as je
from warehouse_data_user_withdrawals_info a 
where cash_time between '2018-01-01' and '2019-04-30'
group by data_source,mbl_no) a1

group by a1.data_source,a1.je


提现金额	用户数
30000元以上	  ？
25000-30000元	？
20000-25000元	？
15000-20000元	？
10000-15000元	？
10000元以下	？

select a1.data_source,
       count(distinct case when(30000 <= a1.je        )then mbl_no end) as rs_1,
       count(distinct case when(25000 <= a1.je and  a1.je < 30000)then mbl_no end) as rs_2,
       count(distinct case when(20000 <= a1.je and  a1.je < 25000)then mbl_no end) as rs_3,
       count(distinct case when(15000 <= a1.je and  a1.je < 20000)then mbl_no end) as rs_4,
       count(distinct case when(10000 <= a1.je and  a1.je < 15000)then mbl_no end) as rs_5,
       count(distinct case when(         a1.je < 10000)then mbl_no end) as rs_6
from 
(select data_source,mbl_no,sum(cash_amount) as je
from warehouse_data_user_withdrawals_info a 
where cash_time between '2018-01-01' and '2019-04-30'
and data_source = 'sjd'
group by data_source,mbl_no) a1
group by a1.data_source

------------
------------2018.1月—2019.4月成功授信2款产品以上用户
1.每个用户授信成功多少个产品
select mbl_no,
       count(distinct product_name) as cps
from warehouse_data_user_review_info a 
where credit_time between '2018-01-01' and '2019-04-30'
and status = '通过'
and data_source = 'sjd'
group by mbl_no 
2.按产品数分用户数
select a1.cps,
       count(distinct a1.mbl_no)
from
  (select mbl_no,
          count(distinct product_name) as cps
   from warehouse_data_user_review_info a
   where credit_time between '2018-01-01' and '2019-04-30'
     and status = '通过'
     and data_source = 'sjd'
   group by mbl_no) a1
group by a1.cps




