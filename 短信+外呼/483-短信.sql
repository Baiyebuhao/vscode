483 短信需求  徐超 已编码    3、重要不紧急 2019.7.31 纪春艳 平台运营 2019.8.1 
一次性需求 马上随借随还 移动手机贷 移动手机贷 短信营销  
马上随借随有提现行为用户，且剩余额度大于1000的用户（额度在有效期内）SJD_AN282_001

1.马上有提现行为用户
select distinct a1.mbl_no
from warehouse_data_user_withdrawals_info a1
where a1.data_source = 'sjd'
  and a1.product_name = '随借随还-马上'
2.额度在有效期内
select distinct a2.mbl_no 
from warehouse_atomic_msd_withdrawals_result_info a2
where a2.paid_out_time > '2019-08-01'

3.马上授信剩余额度>1500（取最近授信）
--3.1马上授信额度'acc_lim'/100
(select distinct mbl_no,
       acc_lim/100 as num1
from warehouse_atomic_msd_review_result_info a
where appral_res = '通过'
and mbl_no is not null) a3

4.马上用信额度'prin_bal'/100,取最近时间的数据
(select mbl_no,num2
from 
(select distinct mbl_no,
       prin_bal/100 as num2,
	   Row_Number() OVER (partition by mbl_no ORDER BY msd_return_time desc) rank     
from warehouse_atomic_msd_withdrawals_result_info a
where mbl_no is not null) b
where b.rank = '1') a4

5.汇总
select distinct a1.mbl_no,
       a1.data_source
from warehouse_data_user_withdrawals_info a1
join warehouse_atomic_msd_withdrawals_result_info a2
 on a1.mbl_no = a2.mbl_no
and a1.data_source = a2.data_source
---额度在有效期内
join
(select distinct mbl_no,
       acc_lim/100 as num1
from warehouse_atomic_msd_review_result_info a
where appral_res = '通过'
and mbl_no is not null
and data_source = 'sjd') a3
on a1.mbl_no = a3.mbl_no
----授信用户+授信额
left join 
(select mbl_no,num2
from 
(select distinct mbl_no,
       prin_bal/100 as num2,
	   Row_Number() OVER (partition by mbl_no ORDER BY msd_return_time desc) rank     
from warehouse_atomic_msd_withdrawals_result_info a
where total_amount > '0'
and mbl_no is not null
and data_source = 'sjd') b
where b.rank = '1') a4
on a1.mbl_no = a4.mbl_no
----提现用户+用信额
where a1.data_source = 'sjd'
  and a1.product_name = '随借随还-马上'
  and a2.paid_out_time > '2019-08-01'
  and a3.num1-a4.num2 >= '1000'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');




































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