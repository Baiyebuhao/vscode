1、金融苑领取马上免息卷未使用且剩余额度在1500元以上的用户（保留用户姓名、手机号、免息券领取时间和授信额度）
2、金融苑领取马上免息券且未申请过马上产品的用户（保留用户姓名、手机号、免息券领取时间）
3、金融苑领取马上免息券且马上已授信，但未提现的用户，剔除需求1的用户（用户姓名、手机号、免息券领取时间和授信额度）

(-----金融苑领取马上免息卷未使用且马上授信剩余额度在1500元以上的用户
select distinct a1.data_source,
       a1.phone_number as mbl_no,
	   a5.name,
	   substring(a1.tm_smp,1,8),
	   a3.num1
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
  and b.data_source = 'jry') a2
on a1.phone_number = a2.mbl_no
----未提现（未使用）
join 
(select distinct mbl_no,
       acc_lim/100 as num1
from warehouse_atomic_msd_review_result_info a
where appral_res = '通过'
and mbl_no is not null
and data_source = 'jry') a3
on a1.phone_number = a3.mbl_no
----授信用户+授信额
join 
(select mbl_no,num2
from 
(select distinct mbl_no,
       prin_bal/100 as num2,
	   Row_Number() OVER (partition by mbl_no ORDER BY msd_return_time desc) rank     
from warehouse_atomic_msd_withdrawals_result_info a
where msd_return_time > '2019-05-10'
and mbl_no is not null
and data_source = 'jry') b
where b.rank = '1') a4
on a1.phone_number = a4.mbl_no
----提现用户+用信额
where a1.coupon_type='2'
and a1.data_source = 'jry'
and substring(a1.tm_smp,1,8) > '20190510'
and a2.mbl_no is null
and a3.num1-a4.num2 >= '1500'
and a1.phone_number NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe WHERE eff_flg = '1')
)

(---结果2
select distinct a1.data_source,
       a1.phone_number as mbl_no,
	   a5.name,
	   substring(a1.tm_smp,1,8)
from warehouse_atomic_coupon_code a1
left join warehouse_atomic_user_info a5
on a1.phone_number = a5.mbl_no
and a1.data_source = a5.data_source
-----
left outer join
(select distinct mbl_no 
from warehouse_atomic_msd_review_result_info a
where data_source = 'jry') a3
on a1.phone_number = a3.mbl_no

where a1.coupon_type='2'
and a1.data_source = 'jry'
and substring(a1.tm_smp,1,8) > '20190510'
and a3.mbl_no is null
and a5.name is not null
and a1.phone_number NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe WHERE eff_flg = '1')
)

(--结果3
select distinct a1.data_source,
       a1.phone_number as mbl_no,
	   a5.name,
	   substring(a1.tm_smp,1,8),
	   a3.acc_lim/100 as num1
from warehouse_atomic_coupon_code a1
left join warehouse_atomic_user_info a5
on a1.phone_number = a5.mbl_no
and a1.data_source = a5.data_source
-----
join warehouse_atomic_msd_review_result_info a3
on a1.phone_number = a3.mbl_no
and a1.data_source = a3.data_source
left outer join
(select distinct mbl_no from warehouse_atomic_msd_withdrawals_result_info a
where msd_return_time > '2019-05-10'
and data_source = 'jry') a4

left outer join
(SELECT mbl_no FROM warehouse_atomic_smstunsubscribe WHERE eff_flg = '1') a6
on a1.phone_number = a6.mbl_no
where a1.coupon_type='2'
and a1.data_source = 'jry'
and substring(a1.tm_smp,1,8) > '20190510'
and a3.appral_res = '通过'
and a4.mbl_no is null
and a6.mbl_no is null
and a1.phone_number not in ('MTg5NTUxMTA1NzA=')
)