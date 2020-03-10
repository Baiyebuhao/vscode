568 统计需求  徐超     1、紧急且重要 纪春艳 平台运营 2019.9.2 2019.9.2
一次性需求 全产品 三平台  统计三平台授信提现率
3平台，8月新注册用户授信提现率（已授信用户取数需剔除优智借产品放款失败的用户），分平台取值+三平台平均值

1.优智借授信成功人数
select count(distinct a1.mbl_no),
       a1.data_source
from warehouse_atomic_yzj_review_result_info a1
join warehouse_atomic_user_info a2
  on a1.mbl_no = a2.mbl_no 
 and a1.data_source = a2.data_source
where a1.credit_status = '3'
  and substring(a1.credit_time,1,10) between '2019-08-01' and '2019-08-31'
  and a2.registe_date between '2019-08-01' and '2019-08-31'
group by a1.data_source

2.优智借放款成功人数

select count(distinct a1.mbl_no),a1.data_source
from warehouse_atomic_yzj_withdrawals_result_info a1
join warehouse_atomic_yzj_review_result_info a2
  on a1.mbl_no = a2.mbl_no 
 and a1.data_source = a2.data_source
join warehouse_atomic_user_info a3
  on a1.mbl_no = a3.mbl_no 
 and a1.data_source = a3.data_source
where a1.credit_status = '1'
  and a2.credit_status = '3'
  and substring(a2.credit_time,1,10) between '2019-08-01' and '2019-08-31'
  and a3.registe_date between '2019-08-01' and '2019-08-31'
group by a1.data_source

3.
--------新注册用户授信
 select a.data_source,
	   c.product_name,
       count(distinct a.mbl_no)
from warehouse_atomic_user_info a   
     left join warehouse_data_chan_info b 
         on a.data_source = b.data_source 
        and a.chan_no = b.chan_no 
        and a.child_chan = b.child_chan
     left join warehouse_data_user_review_info c
         on a.mbl_no = c.mbl_no 
        and a.data_source = c.data_source
where a.registe_date between '2019-08-01' and '2019-08-31'              ---------选择注册时间维度
  and c.credit_time between '2019-08-01' and '2019-08-31'                ---------选择授信时间维度
  and c.status = '通过'
group by a.data_source,
	   c.product_name
	   
4.
----------新注册用户提现
select a.data_source,
	   c.product_name,
       count(distinct a.mbl_no)

from warehouse_atomic_user_info a   
     left join warehouse_data_chan_info b 
         on a.data_source = b.data_source 
        and a.chan_no = b.chan_no 
        and a.child_chan = b.child_chan        
     left join warehouse_data_user_withdrawals_info c
         on a.mbl_no = c.mbl_no 
        and a.data_source = c.data_source
where a.registe_date between '2019-08-01' and '2019-08-31'              ---------选择注册时间维度
  and c.cash_time between '2019-08-01' and '2019-08-31'                ---------选择提现时间维度
  and c.cash_amount > 0
group by a.data_source,
	   c.product_name