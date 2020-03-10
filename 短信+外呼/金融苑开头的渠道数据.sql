2019年2月1号-2019年4月12号
金融苑开头的渠道
注册人数、申请人数（对应申请的产品）、授信人数、提现人数
(1.创建注册用户数据 516人
create table tmp_jry_chan_xc
as
select distinct a.mbl_no,
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
where a.registe_date between '2019-02-01' and '2019-04-12'
and b.the_3rd_level like '金融苑%'
and a.data_source = 'jry'
)

(2.取申请-授信-提现，加产品
select * from warehouse_data_user_review_withdrawals_info a
join tmp_jry_chan_xc b
on a.mbl_no = b.mbl_no
and a.data_source = b.data_source
and a.pre <> '0'
and a.extractday > '2019-02-01'
)
