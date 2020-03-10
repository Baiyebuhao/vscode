create table tmp_2018_tx_xc
as
select  
count(distinct a.mbl_no) as tx,sum(a.cash_amount) as txe,substring(a1.action_date,1,7) as z_time,a1.data_source,a1.2nd_level,a1.chan_no_desc,a1.child_chan,a.product_name
from warehouse_data_withdrawals_info a
left join 
(select distinct a.mbl_no,
       a.action_date,
       a.data_source, 
       b.2nd_level,
       c.chan_no_desc,
       c.child_chan
from warehouse_atomic_all_process_info a
     
     left join warehouse_atomic_user_info c             
         on a.data_source= c.data_source and a.mbl_no = c.mbl_no
     left join warehouse_atomic_channel_category_info b 
         on a.data_source = b.plat_no and c.chan_no = b.chan_no
where a.action_name = '注册'and a.data_source <> 'jry'
      and a.action_date between '2018-01-01' and '2018-12-31'                  ---------选择注册时间维度
	                                                                           ----------是否选择and b.2nd_level in ('安卓引流','苹果市场','享宇线上组','','Null')
  ) a1
on a.mbl_no = a1.mbl_no
and a.data_source = a1.data_source
where a.mbl_no <> 'null'
    and a.cash_amount > 0
	and a.cash_time between '2018-01-01' and '2018-12-31'                       ---------选择提现时间维度 
    and a1.action_date <> 'null'
group by substring(a1.action_date,1,7),a1.data_source,a1.2nd_level,a1.chan_no_desc,a1.child_chan,a.product_name