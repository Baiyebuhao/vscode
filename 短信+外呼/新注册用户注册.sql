--------新注册用户注册
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
where a.registe_date between '2019-03-01' and '2019-03-31'                   ---------选择注册时间维度
	                                                                          ----------是否选择and b.the_2nd_level in ('安卓引流','苹果市场','享宇线上组','','Null')
  ) a1
group by 
     substring(a1.registe_date,1,7),
     a1.data_source,
     a1.the_2nd_level,
     a1.the_3rd_level,
     a1.chan_no_desc,
     a1.child_chan