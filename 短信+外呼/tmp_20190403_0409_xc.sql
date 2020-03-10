create table tmp_20190403_0409_xc
as
select b1.z_time,b1.data_source,b1.the_2nd_level,b1.the_3rd_level,b1.chan_no_desc,b1.child_chan,b1.zc,b2.sm,b3.sq,b4.sx,b5.tx,b5.txe
from
(--------新注册用户注册b1
select 
     count(distinct a1.mbl_no) as zc,
     substring(a1.registe_date,1,7) as z_time,
     a1.data_source,
     a1.the_2nd_level,
	 a1.the_3rd_level,
     a1.chan_no_desc,
     a1.child_chan
from 
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
where a.registe_date between '2019-04-03' and '2019-04-09'                   ---------选择注册时间维度
	                                                                          ----------是否选择and b.the_2nd_level in ('安卓引流','苹果市场','享宇线上组','','Null')
  ) a1
group by 
     substring(a1.registe_date,1,7),
     a1.data_source,
     a1.the_2nd_level,
     a1.the_3rd_level,
     a1.chan_no_desc,
     a1.child_chan
)b1                                                                        ----------注册汇总表
left join 
(--------新注册用户实名b2
select count(distinct a2.mbl_no) as sm,
       substring(a2.registe_date,1,7) as z_time,
	   a2.data_source,
	   a2.the_2nd_level,
	   a2.the_3rd_level,
	   a2.chan_no_desc,
	   a2.child_chan
from 
(select a1.mbl_no,
       a1.registe_date,
       a1.data_source, 
	   c.action_name, 
       a1.the_2nd_level,
	   a1.the_3rd_level,
       a1.chan_no_desc,
       a1.child_chan
from 
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
where a.registe_date between '2019-04-03' and '2019-04-09'             ---------选择注册时间维度
   )a1                                                                 ---------取出注册用户作为表a1
left join  warehouse_atomic_all_process_info c
        on a1.mbl_no = c.mbl_no 
        and a1.data_source = c.data_source
        and a1.registe_date = c.action_date
where c.status_desc in('自认证','认证成功') 
  and c.action_date between '2019-04-03' and '2019-04-09') a2

group by substring(a2.registe_date,1,7),
         a2.data_source,
         a2.the_2nd_level,
         a2.the_3rd_level,
         a2.chan_no_desc,
         a2.child_chan
        
)b2 on b1.data_source = b2.data_source 
    and b1.the_2nd_level = b2.the_2nd_level
	and b1.the_3rd_level = b2.the_3rd_level
    and b1.chan_no_desc = b2.chan_no_desc 
	and b1.child_chan = b2.child_chan 
	and b1.z_time = b2.z_time 
left join
(--------新注册用户申请b3
select     
count(distinct a1.mbl_no) as sq,
substring(a1.registe_date,1,7) as z_time,
a1.data_source,
a1.the_2nd_level,
a1.the_3rd_level,
a1.chan_no_desc,
a1.child_chan
from 
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
where a.registe_date between '2019-04-03' and '2019-04-09'             ---------选择注册时间维度
   )a1                                                                 ---------取出注册用户作为表a1
   
     join warehouse_data_user_review_info c
     on a1.mbl_no = c.mbl_no 
     and a1.data_source = c.data_source
	 
where c.apply_time between '2019-04-03' and '2019-04-09'           ---------选择申请时间维度

group by substring(a1.registe_date,1,7),a1.data_source,a1.the_2nd_level,a1.the_3rd_level,a1.chan_no_desc,a1.child_chan
    
)b3 on b1.data_source = b3.data_source 
                       and b1.the_2nd_level = b3.the_2nd_level
					   and b1.the_3rd_level = b3.the_3rd_level
                       and b1.chan_no_desc = b3.chan_no_desc 
					   and b1.child_chan = b3.child_chan 
					   and b1.z_time = b3.z_time 
left join
(--------新注册用户授信b4
select     
count(distinct a1.mbl_no) as sx,
substring(a1.registe_date,1,7) as z_time,
a1.data_source,
a1.the_2nd_level,
a1.the_3rd_level,
a1.chan_no_desc,
a1.child_chan
from 
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
where a.registe_date between '2019-04-03' and '2019-04-09'             ---------选择注册时间维度
   )a1                                                                 ---------取出注册用户作为表a1
     join warehouse_data_user_review_info c
     on a1.mbl_no = c.mbl_no 
     and a1.data_source = c.data_source
	 
where c.apply_time between '2019-04-03' and '2019-04-09'           ---------选择申请时间维度
      and c.status = '通过'                                        ---------选择申请通过用户
group by substring(a1.registe_date,1,7),a1.data_source,a1.the_2nd_level,a1.the_3rd_level,a1.chan_no_desc,a1.child_chan
)b4 on b1.data_source = b4.data_source 
                       and b1.the_2nd_level = b4.the_2nd_level 
					   and b1.the_3rd_level = b4.the_3rd_level
                       and b1.chan_no_desc = b4.chan_no_desc 
					   and b1.child_chan = b4.child_chan 
					   and b1.z_time = b4.z_time
left join
(--------新注册用户提现b5
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
where a.registe_date between '2019-04-03' and '2019-04-09'                  ---------选择注册时间维度
  ) a1                                                                      ---------取出注册用户作为表a1
on a2.mbl_no = a1.mbl_no
and a2.data_source = a1.data_source
where a2.mbl_no <> 'null'
    and a2.cash_amount > 0
	and a2.cash_time between '2019-04-03' and '2019-04-09'                       ---------选择提现时间维度 
    and a1.registe_date <> 'null'
group by substring(a1.registe_date,1,7),
         a1.data_source,
         a1.the_2nd_level,
         a1.the_3rd_level,
         a1.chan_no_desc,
         a1.child_chan
)b5 on b1.data_source = b5.data_source 
                       and b1.the_2nd_level = b5.the_2nd_level
					   and b1.the_3rd_level = b5.the_3rd_level
                       and b1.chan_no_desc = b5.chan_no_desc 
					   and b1.child_chan = b5.child_chan 
					   and b1.z_time = b5.z_time  					   