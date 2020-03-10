  免息券活动上线至今领券用户的放款金额等相关数据
（具体包含：平台、领券时间、提现时间、本次提现金额、历史提现金额）

select * from 
(select distinct a.data_source,
       a.phone_number as mbl_no,
	   CONCAT_WS('-',substring(a.tm_smp,1,4),substring(a.tm_smp,5,2),substring(a.tm_smp,7,2)) as extractday,
	   '随借随还-马上' as product_name,
	   d.msd_return_time as cash_time,
	   d.total_amount/100 as cash_amount,
	   d.ltd_lend_amt/100 as ltd_cash_amount
from warehouse_atomic_coupon_code a 
   left join warehouse_atomic_user_info b
          on a.phone_number = b.mbl_no
         and a.data_source = b.data_source
   left join warehouse_atomic_msd_withdrawals_result_info d
          on a.phone_number = d.mbl_no
	     and a.data_source = d.data_source
where a.coupon_type='2'
  and substring(a.tm_smp,1,8) between '20190509' and '20190612'
  and d.msd_return_time between '2019-05-09' and '2019-06-12'
  and d.total_amount > '0') a1
where a1.extractday <= a1.cash_time
