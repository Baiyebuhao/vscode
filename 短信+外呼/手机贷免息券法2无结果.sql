-------法2，无结果
select distinct a1.data_source,
       a1.phone_number as mbl_no,
	   a5.name,
	   substring(a1.tm_smp,1,8),
	   a6.num1
from warehouse_atomic_coupon_code a1
left join warehouse_atomic_user_info a5
on a1.phone_number = a5.mbl_no
and a1.data_source = a5.data_source
-----领券
left outer join
(select distinct b.mbl_no
from warehouse_data_user_withdrawals_info b
where b.product_name = '随借随还-马上' 
  and b.cash_time > '2019-05-10'
  and b.data_source = 'sjd') a2
on a1.phone_number = a2.mbl_no
----未提现（未使用）
join 
(select a3.mbl_no,a3.num1,a4.num2
from
----授信用户+授信额
(select distinct mbl_no,
       acc_lim/100 as num1
from warehouse_atomic_msd_review_result_info a
where appral_res = '通过'
and mbl_no is not null
and data_source = 'sjd') a3

left join
----提现用户+用信额
(select mbl_no,num2
from 
(select distinct mbl_no,
       prin_bal/100 as num2,
	   Row_Number() OVER (partition by mbl_no ORDER BY msd_return_time desc) rank     
from warehouse_atomic_msd_withdrawals_result_info a
where msd_return_time > '2019-05-10'
and total_amount > '0'
and mbl_no is not null
and data_source = 'sjd') b
where b.rank = '1') a4
on a3.mbl_no = a4.mbl_no
where a3.num1-a4.num2 >= '1500') a6
on a1.phone_number = a6.mbl_no

where a1.coupon_type='2'
and a1.data_source = 'sjd'
and substring(a1.tm_smp,1,8) > '20190510'
and a2.mbl_no is null
and a1.phone_number NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe WHERE eff_flg = '1')