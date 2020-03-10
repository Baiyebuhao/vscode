涉及的三张表
warehouse_atomic_all_process_info 
warehouse_atomic_channel_category_info
warehouse_atomic_user_info


select * from warehouse_atomic_all_process_info a

              left join warehouse_atomic_channel_category_info c 
			      on a.chan_no = c.chan_no and a.data_source = plat_no
              left join warehouse_atomic_user_info u             
			      on a.data_source= u.data_source and a.mbl_no = u.mbl_no
where a.action_name = '注册'and a.data_source <> 'jry'and a.action_date = '2018-08-09' 
简单提数
select  a.action_date,
        a.data_source, 
  b.2nd_level,
  c.chan_no_desc,
  c.child_chan,
  count(distinct a.mbl_no)
from warehouse_atomic_all_process_info a
     
     left join warehouse_atomic_user_info c             
         on a.data_source= c.data_source and a.mbl_no = c.mbl_no
     left join warehouse_atomic_channel_category_info b 
         on a.data_source = b.plat_no and c.chan_no = b.chan_no
where a.action_name = '注册'and a.data_source <> 'jry'
      and a.action_date = '2018-08-09' 
group by a.action_date,
        a.data_source, 
  b.2nd_level,
  c.chan_no_desc,
  c.child_chan
  
合并主渠道+子渠道 
(select  a.action_date,
        a.data_source, 
  b.2nd_level,
  c.chan_no_desc,
  c.child_chan,
  concat(c.chan_no_desc,c.child_chan),
  count(distinct a.mbl_no)
from warehouse_atomic_all_process_info a
     
     left join warehouse_atomic_user_info c             
         on a.data_source= c.data_source and a.mbl_no = c.mbl_no
     left join warehouse_atomic_channel_category_info b 
         on a.data_source = b.plat_no and c.chan_no = b.chan_no
where a.action_name = '注册'and a.data_source <> 'jry'
      and a.action_date = '2018-08-09' 
group by a.action_date,
        a.data_source, 
  b.2nd_level,
  c.chan_no_desc,
  c.child_chan ) d 
  
  以上面的数据为新表d，左联结用户统计表（warehouse_data_statistics_chan_info）
 select * 
from 
(select  a.action_date,
        a.data_source, 
  b.2nd_level,
  c.chan_no_desc,
  c.child_chan,
  concat(c.chan_no_desc,c.child_chan) as merger_chan,
  count(distinct a.mbl_no)
from warehouse_atomic_all_process_info a
     
     left join warehouse_atomic_user_info c             
         on a.data_source= c.data_source and a.mbl_no = c.mbl_no
     left join warehouse_atomic_channel_category_info b 
         on a.data_source = b.plat_no and c.chan_no = b.chan_no
where a.action_name = '注册'and a.data_source <> 'jry'
      and a.action_date = '2018-09-09' 
group by a.action_date,
        a.data_source, 
  b.2nd_level,
  c.chan_no_desc,
  c.child_chan ) d 
       left join warehouse_data_statistics_chan_info e 
       on d.merger_chan = e.merger_chan
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
以上面的数据,计入case计算

select  a.action_date,
        a.data_source, 
        b.2nd_level,
  case when c.chan_no_desc is null then '空白'  
       when c.chan_no_desc = '移动手机贷app' then '移动手机贷app'
       when c.chan_no_desc = '享宇钱包app' then '享宇钱包app'
  else concat(c.chan_no_desc,c.child_chan) end  qudao,
         count(distinct a.mbl_no)
from warehouse_atomic_all_process_info a
     
     left join warehouse_atomic_user_info c             
         on a.data_source= c.data_source and a.mbl_no = c.mbl_no
     left join warehouse_atomic_channel_category_info b 
         on a.data_source = b.plat_no and c.chan_no = b.chan_no
where a.action_name = '注册'and a.data_source <> 'jry'
      and a.action_date = '2018-09-09' 
group by a.action_date,
         a.data_source, 
         b.2nd_level,
  case when c.chan_no_desc is null then '空白'  
       when c.chan_no_desc = '移动手机贷app' then '移动手机贷app'
       when c.chan_no_desc = '享宇钱包app' then '享宇钱包app'
  else concat(c.chan_no_desc,c.child_chan) end 

