-----移动手机贷领取马上免息卷未使用且马上授信剩余额度在1500元以上的用户
select distinct a1.data_source,
       a1.phone_number as mbl_no,
	   a5.name,
	   substring(a1.tm_smp,1,8),
	   a3.num1
from warehouse_atomic_coupon_code a1
left join warehouse_atomic_user_info a5
on a1.phone_number = a5.mbl_no
and a1.data_source = a5.data_source
-----
left outer join
(select distinct b.phone_number as mbl_no
from warehouse_atomic_coupon_record b
where b.status = '1'
and substring(b.tm_smp,1,8) > '20190510') a2
on a1.phone_number = a2.mbl_no
----
join 
(select distinct mbl_no,
       acc_lim/100 as num1
from warehouse_atomic_msd_review_result_info a
where appral_res = '通过'
and mbl_no is not null) a3
on a1.phone_number = a3.mbl_no
----
join 
(select mbl_no,num2
from 
(select distinct mbl_no,
       prin_bal/100 as num2,
	   Row_Number() OVER (partition by mbl_no ORDER BY msd_return_time desc) rank     
from warehouse_atomic_msd_withdrawals_result_info a
where msd_return_time > '2019-05-10'
and mbl_no is not null) b
where b.rank = '1') a4
on a1.phone_number = a4.mbl_no

where a1.coupon_type='2'
and a1.data_source = 'sjd'
and substring(a1.tm_smp,1,8) > '20190510'
and a2.mbl_no is null
and a3.num1-a4.num2 > '1500'