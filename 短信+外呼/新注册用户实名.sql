--------新注册用户实名
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
where a.registe_date between '2019-03-01' and '2019-03-31'             ---------选择注册时间维度
   )a1                                                                 ---------取出注册用户作为表a1
left join  warehouse_atomic_all_process_info c
        on a1.mbl_no = c.mbl_no 
        and a1.data_source = c.data_source
        and a1.registe_date = c.action_date
where c.status_desc in('自认证','认证成功') 
  and c.action_date between '2019-03-01' and '2019-03-31') a2

group by substring(a2.registe_date,1,7),
         a2.data_source,
         a2.the_2nd_level,
         a2.the_3rd_level,
         a2.chan_no_desc,
         a2.child_chan
        