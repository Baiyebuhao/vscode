362	取数需求 徐超  2、紧急不重要 2016.6.10 夏玮扬 金融苑 
2019.6.12 一次性需求 随借随还-马上 移动手机贷、金融苑 - 免息券活动数据统计 
2019.5.1-6.12免息券活动上线至今领券用户的放款金额等相关数据

1、具体包含：平台、领券时间、提现时间、本次提现金额、历史累计提现金额
2、通过活动新注册用户的提现人数及金额

----2019.5.1-6.12免息券活动上线至今领券用户的放款金额等相关数据
select distinct a.data_source,
       a.phone_number as mbl_no,
	   CONCAT_WS('-',substring(a.tm_smp,1,4),substring(a.tm_smp,5,2),substring(a.tm_smp,7,2)) as extractday,
	   c.product_name,
	   c.cash_time,
	   c.cash_amount
from warehouse_atomic_coupon_code a 
   left join warehouse_atomic_user_info b
          on a.phone_number = b.mbl_no
         and a.data_source = b.data_source

   left join warehouse_data_user_withdrawals_info c
          on a.phone_number = c.mbl_no
	     and a.data_source = c.data_source
where a.coupon_type='2'
  and substring(a.tm_smp,1,8) between '20190501' and '20190612'
  and c.cash_time between '2019-05-09' and '2019-06-12'
  and c.cash_amount > '0'
  
---通过活动新注册用户的提现人数及金额
select deistinct a1.mbl_no,
       a1.data_source,
       a1.chan_no_desc,
       a1.child_chan,
       a1.registe_date,
       a2.apply_time,
       a2.product_name,
       a2.status,
       a3.cash_time,
       a3.cash_amount
from warehouse_atomic_user_info a1
left join warehouse_data_user_review_info a2
 on a1.mbl_no =a2.mbl_no
and a1.data_source =a2.data_source
left join warehouse_data_user_withdrawals_info a3
 on a1.mbl_no =a3.mbl_no
and a1.data_source =a3.data_source
where a1.chan_no = 'mxqzx'
