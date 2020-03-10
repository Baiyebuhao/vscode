--------新注册用户提现（渠道）
select  
count(distinct a2.mbl_no) as tx,
sum(a2.cash_amount) as txe,
substring(a1.registe_date,1,7) as z_time,
a1.data_source,
a1.the_2nd_level,
a1.the_3rd_level,
a1.chan_no_desc,
a1.child_chan
from warehouse_data_user_withdrawals_info a2
left join 
(select distinct a.mbl_no,
       a.registe_date,
       a.data_source, 
       b.the_2nd_level,
       b.the_3rd_level,
       a.chan_no_desc,
       a.child_chan
from warehouse_atomic_user_info a   
     left join warehouse_data_chan_info b 
         on a.data_source = b.data_source 
         and a.chan_no = b.chan_no 
         and a.child_chan = b.child_chan
where a.registe_date between '2019-04-01' and '2019-04-31'                  ---------选择注册时间维度
	                                                                           ----------是否选择and b.2nd_level in ('安卓引流','苹果市场','享宇线上组','','Null')
  ) a1
on a2.mbl_no = a1.mbl_no
and a2.data_source = a1.data_source
where a2.mbl_no <> 'null'
    and a2.cash_amount > 0
	and a2.cash_time between '2019-04-01' and '2019-04-31'                       ---------选择提现时间维度 
    and a1.registe_date <> 'null'
group by substring(a1.registe_date,1,7),
         a1.data_source,
         a1.the_2nd_level,
         a1.the_3rd_level,
         a1.chan_no_desc,
         a1.child_chan