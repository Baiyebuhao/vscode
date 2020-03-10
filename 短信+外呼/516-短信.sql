516 短信需求  徐超     3、重要不紧急 纪春艳 平台运营 2019.8.13  2019.8.14上午 
一次性需求 优智借 移动手机贷 移动手机贷 短信营销 按序号分包，且包与包之间去重 
1、手机贷平台，RFM模型中，R值为1,2，M值为1，2,3的用户，剔除已申请优智借产品用户； 
2、手机贷平台，马上随借随还授信已过期用户，且2019年在APP上有点击行为的用户，剔除已申请优智借产品用户； 
3、手机贷平台，马上随借随还已提现用户中剩余额度小于500的用户；剔除已申请优智借产品用户
--1、手机贷平台，RFM模型中，R值为1,2，M值为1，2,3的用户，剔除已申请优智借产品用户
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_channel_info a1
left outer join(select mbl_no 
                from warehouse_data_user_review_info a
			    where product_name = '优智借')a2
		on a1.mbl_no = a2.mbl_no
where a1.rtype in ('1','2')
  and a1.mtype in ('1','2','3')
  and a1.data_source = 'sjd'
  and a2.mbl_no is null
  and a1.mbl_no like 'MT%'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');

--2、手机贷平台，马上随借随还授信已过期用户，且2019年在APP上有点击行为的用户，剔除已申请优智借产品用户
select distinct a1.mbl_no,a1.data_source
from warehouse_atomic_msd_withdrawals_result_info a1
left outer join (select distinct mbl_no
                 from warehouse_data_user_review_info a
                 where product_name = '优智借'
				 and data_source = 'sjd'
				 ) a2
         on a1.mbl_no = a2.mbl_no
join (select distinct mbl_no
      from warehouse_data_user_action_day a
      where extractday >= '2019-01-01'
	    and data_source = 'sjd') a3
		on a1.mbl_no = a3.mbl_no
where a1.data_source = 'sjd'
  and a1.paid_out_time <= '2019-08-14'
  and a1.mbl_no <> 'NULL'
  and a2.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');

--3、手机贷平台，马上随借随还已提现用户中剩余额度小于500的用户；剔除已申请优智借产品用户

select distinct a1.mbl_no,
       a1.data_source
from warehouse_data_user_withdrawals_info a1
join warehouse_atomic_msd_withdrawals_result_info a2
 on a1.mbl_no = a2.mbl_no
and a1.data_source = a2.data_source
---额度在有效期内
join
(select mbl_no,num1
from
(select distinct mbl_no,
       acc_lim/100 as num1,
	   Row_Number() OVER (partition by mbl_no ORDER BY credit_time desc) rank
from warehouse_atomic_msd_review_result_info a
where appral_res = '通过'
and mbl_no is not null
and data_source = 'sjd') b
where b.rank = '1') a3
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
left outer join (select distinct mbl_no
                 from warehouse_data_user_review_info a
                 where product_name = '优智借'
				 and data_source = 'sjd'
				 ) a5
         on a1.mbl_no = a5.mbl_no
where a1.data_source = 'sjd'
  and a1.product_name = '随借随还-马上'
  and a2.paid_out_time > '2019-08-14'
  and a3.num1-a4.num2 <= '500'
  and a5.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');
