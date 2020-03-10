渠道一组7月新注册用户  
注册-申请-授信-提现
	  
创建表：渠道一组新注册用户
create table tmp_07 
as
select distinct a.mbl_no,
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
      and a.action_date between '2018-07-01' and '2018-07-31'
	  and b.2nd_level in ('安卓引流','苹果市场','享宇线上组','','Null')
	  
	  
SELECT * from warehouse_data_user_review_info
desc warehouse_data_user_review_info
desc warehouse_data_withdrawals_info

 申请授信表
 warehouse_data_user_review_info
 放款表
 warehouse_data_withdrawals_info
 
注册人数
create table tmp_0701 
as
select count(distinct mbl_no),substring(action_date,1,7),data_source,2nd_level,chan_no_desc,child_chan
from tmp_07
group by substring(action_date,1,7),data_source,2nd_level,chan_no_desc,child_chan
 
申请人数
create table tmp_0702
as
select     
count(distinct a.mbl_no),substring(b.action_date,1,7),b.data_source,b.2nd_level,b.chan_no_desc,b.child_chan
from warehouse_data_user_review_info a
left join tmp_07 b 
on a.mbl_no = b.mbl_no
and a.data_source = b.data_source
where a.mbl_no <> 'null'
      and action_date <> 'null'
group by substring(b.action_date,1,7),b.data_source,b.2nd_level,b.chan_no_desc,b.child_chan
	  
	  
授信人数
create table tmp_0703
as
select     
count(distinct a.mbl_no),substring(b.action_date,1,7),b.data_source,b.2nd_level,b.chan_no_desc,b.child_chan
from warehouse_data_user_review_info a
left join tmp_07 b 
on a.mbl_no = b.mbl_no
and a.data_source = b.data_source
where a.mbl_no <> 'null'
      and action_date <> 'null'
	  and a.status = '通过'
group by substring(b.action_date,1,7),b.data_source,b.2nd_level,b.chan_no_desc,b.child_chan	  
	  	  	 

			 
提现人数+金额（分产品）
create table tmp_0704
as
select  
count(distinct a.mbl_no),
sum(cash_amount),
a.product_name,
substring(b.action_date,1,7),
b.data_source,b.2nd_level,b.chan_no_desc,b.child_chan
from warehouse_data_withdrawals_info a
left join tmp_07 b 
on a.mbl_no = b.mbl_no
and a.data_source = b.data_source
where a.mbl_no <> 'null'
      and action_date <> 'null'
	  and cash_amount > 0
	  and substr (a.cash_time,1,7) = '2018-07' 
group by a.product_name,substring(b.action_date,1,7),b.data_source,b.2nd_level,b.chan_no_desc,b.child_chan	 

提现人数+金额（不分产品）
create table tmp_0705
as
select  
count(distinct a.mbl_no),sum(cash_amount),substring(b.action_date,1,7),b.data_source,b.2nd_level,b.chan_no_desc,b.child_chan
from warehouse_data_withdrawals_info a
left join tmp_07 b 
on a.mbl_no = b.mbl_no
and a.data_source = b.data_source
where a.mbl_no <> 'null'
      and action_date <> 'null'
	  and cash_amount > 0
group by substring(b.action_date,1,7),b.data_source,b.2nd_level,b.chan_no_desc,b.child_chan


注册tmp_0701
申请tmp_0702
授信tmp_0703
提现tmp_0704

分产品
select a.data_source,a.2nd_level,a.chan_no_desc,a.child_chan,a.c1,a.c0,b.c0,c.c0,d.c0,d.c1,d.product_name
from tmp_0701 a
left join tmp_0702 b on a.data_source = b.data_source 
                       and a.2nd_level = b.2nd_level 
                       and a.chan_no_desc = b.chan_no_desc 
					   and a.child_chan = b.child_chan 
					   and a.c1 = b.c1 
left join tmp_0703 c on a.data_source = c.data_source 
                       and a.2nd_level = c.2nd_level 
                       and a.chan_no_desc = c.chan_no_desc 
				       and a.child_chan = c.child_chan 
					   and a.c1 = c.c1  
left join tmp_0704 d on a.data_source = d.data_source 
                       and a.2nd_level = d.2nd_level 
                       and a.chan_no_desc = d.chan_no_desc 
					   and a.child_chan = d.child_chan 
					   and a.c1 = d.c3  
					   
					   
不分产品					   
select a.data_source,a.2nd_level,a.chan_no_desc,a.child_chan,a.c1,a.c0,b.c0,c.c0,d.c0,d.c1
from tmp_0701 a
left join tmp_0702 b on a.data_source = b.data_source 
                       and a.2nd_level = b.2nd_level 
                       and a.chan_no_desc = b.chan_no_desc 
					   and a.child_chan = b.child_chan 
					   and a.c1 = b.c1 
left join tmp_0703 c on a.data_source = c.data_source 
                       and a.2nd_level = c.2nd_level 
                       and a.chan_no_desc = c.chan_no_desc 
				       and a.child_chan = c.child_chan 
					   and a.c1 = c.c1  
left join tmp_0705 d on a.data_source = d.data_source 
                       and a.2nd_level = d.2nd_level 
                       and a.chan_no_desc = d.chan_no_desc 
					   and a.child_chan = d.child_chan 
					   and a.c1 = d.c2  					   