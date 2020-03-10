-------新用户全流程数据汇总
create table tmp_201902_xc
as
select b1.z_time,b1.data_source,b1.2nd_level,b1.chan_no_desc,b1.child_chan,b1.zc,b2.sm,b3.sq,b4.sx,b5.tx,b5.txe
from 
(select 
     count(distinct a1.mbl_no) as zc,
     substring(a1.action_date,1,7) as z_time,
     a1.data_source,
     a1.2nd_level,
     a1.chan_no_desc,
     a1.child_chan
from 
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
      and a.action_date between '2019-02-01' and '2019-02-28'                  ---------选择注册时间维度
	                                                                          ----------是否选择and b.2nd_level in ('安卓引流','苹果市场','享宇线上组','','Null')
  ) a1
group by 
     substring(a1.action_date,1,7),
     a1.data_source,
     a1.2nd_level,
     a1.chan_no_desc,
     a1.child_chan
	 ) 
	 b1                                                                        ----------注册汇总表
left join (select count(distinct a2.mbl_no) as sm,
       substring(a2.action_date,1,7) as z_time,
	   a2.data_source,
	   a2.2nd_level,
	   a2.chan_no_desc,
	   a2.child_chan
from (
select a1.mbl_no,
       a.action_date,
       a.data_source, 
	   a.action_name,                                                   -------------a.status_desc，报错？？
       a1.2nd_level,
       a1.chan_no_desc,
       a1.child_chan
	   from warehouse_atomic_all_process_info a
right join    
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
      and a.action_date between '2019-02-01' and '2019-02-28'             ---------选择注册时间维度
   )a1                                                                    ---------取出注册用户作为表a1
on a.mbl_no = a1.mbl_no 
and a.data_source = a1.data_source
where a.status_desc in('自认证','认证成功') 
  and a.action_date between '2019-02-01' and '2019-02-28'                ---------选择实名时间维度
)a2                                                                       ---------取出实名用户作为表a2
group by substring(a2.action_date,1,7),
         a2.data_source,
		 a2.2nd_level,
		 a2.chan_no_desc,
		 a2.child_chan
		 )                                                                ---------实名汇总表
		 b2 on b1.data_source = b2.data_source 
                       and b1.2nd_level = b2.2nd_level 
                       and b1.chan_no_desc = b2.chan_no_desc 
					   and b1.child_chan = b2.child_chan 
					   and b1.z_time = b2.z_time 
left join (select     
count(distinct a.mbl_no) as sq,substring(a1.action_date,1,7) as z_time,
a1.data_source,a1.2nd_level,a1.chan_no_desc,a1.child_chan
from warehouse_data_user_review_info a
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
      and a.action_date between '2019-02-01' and '2019-02-28'         ---------选择注册时间维度
   )a1                                                                ---------取出注册用户作为表a1
 on a.mbl_no = a1.mbl_no and a.data_source = a1.data_source
where a.mbl_no <> 'null'
	 and a.apply_time between '2019-02-01' and '2019-02-28'           ---------选择申请时间维度
	 and a1.action_date <> 'null'
group by substring(a1.action_date,1,7),a1.data_source,a1.2nd_level,a1.chan_no_desc,a1.child_chan
)                                                                     ----------申请汇总表
b3 on b1.data_source = b3.data_source 
                       and b1.2nd_level = b3.2nd_level 
                       and b1.chan_no_desc = b3.chan_no_desc 
					   and b1.child_chan = b3.child_chan 
					   and b1.z_time = b3.z_time 
left join (select     
count(distinct a.mbl_no) as sx,substring(a1.action_date,1,7) as z_time,a1.data_source,a1.2nd_level,a1.chan_no_desc,a1.child_chan
from warehouse_data_user_review_info a
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
      and a.action_date between '2019-02-01' and '2019-02-28'         ---------选择注册时间维度
   )a1                                                                ---------取出注册用户作为表a1
on a.mbl_no = a1.mbl_no
and a.data_source = a1.data_source
where a.mbl_no <> 'null'
     and a.status = '通过'
	 and a.credit_time between '2019-02-01' and '2019-02-28'          ---------选择授信时间维度
     and a1.action_date <> 'null'
group by substring(a1.action_date,1,7),a1.data_source,a1.2nd_level,a1.chan_no_desc,a1.child_chan
)                                                                     ----------授信汇总表
b4 on b1.data_source = b4.data_source 
                       and b1.2nd_level = b4.2nd_level 
                       and b1.chan_no_desc = b4.chan_no_desc 
					   and b1.child_chan = b4.child_chan 
					   and b1.z_time = b4.z_time 
left join (select  
count(distinct a.mbl_no) as tx,sum(a.cash_amount) as txe,substring(a1.action_date,1,7) as z_time,a1.data_source,a1.2nd_level,a1.chan_no_desc,a1.child_chan
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
      and a.action_date between '2019-02-01' and '2019-02-28'                  ---------选择注册时间维度
	                                                                           ----------是否选择and b.2nd_level in ('安卓引流','苹果市场','享宇线上组','','Null')
  ) a1
on a.mbl_no = a1.mbl_no
and a.data_source = a1.data_source
where a.mbl_no <> 'null'
    and a.cash_amount > 0
	and a.cash_time between '2019-02-01' and '2019-02-28'                       ---------选择提现时间维度 
    and a1.action_date <> 'null'
group by substring(a1.action_date,1,7),a1.data_source,a1.2nd_level,a1.chan_no_desc,a1.child_chan
)                                                                               ---------提现汇总表 
b5 on b1.data_source = b5.data_source 
                       and b1.2nd_level = b5.2nd_level 
                       and b1.chan_no_desc = b5.chan_no_desc 
					   and b1.child_chan = b5.child_chan 
					   and b1.z_time = b5.z_time 


					   