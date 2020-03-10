--------新注册用户申请（渠道）
select     
count(distinct a1.mbl_no) as sq,
substring(a1.registe_date,1,7) as z_time,
a1.data_source,
a1.the_2nd_level,
a1.the_3rd_level,
a1.chan_no_desc,
a1.child_chan,
c.product_name
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
   
     join warehouse_data_user_review_info c
     on a1.mbl_no = c.mbl_no 
     and a1.data_source = c.data_source
	 
where c.apply_time between '2019-03-01' and '2019-03-31'           ---------选择申请时间维度

group by substring(a1.registe_date,1,7),
a1.data_source,
a1.the_2nd_level,
a1.the_3rd_level,
a1.chan_no_desc,
a1.child_chan,
c.product_name
    