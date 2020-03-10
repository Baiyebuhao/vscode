select distinct a.mbl_no
from warehouse_atomic_user_info a   
     left join warehouse_data_chan_info b 
         on a.data_source = b.data_source 
         and a.chan_no = b.chan_no 
         and a.child_chan = b.child_chan
where a.registe_date between '2019-01-01' and '2019-04-31'
and a.chan_no = '304'                            -----------------VIVO新注册用户
and a.data_source = 'sjd'                        -----------------手机贷平台
and a.mbl_no not in
(select distinct a2.mbl_no
from warehouse_data_user_review_info a2
where a2.apply_time between '2019-01-01' and '2019-04-31'
and a2.product_name = '现金分期-兴业消费'
and a2.data_source = 'sjd')


9年1月1日至今新注册用户，vivo渠道没有申请过兴业消费的用户  

select distinct a.mbl_no
from warehouse_atomic_user_info a   
left outer join
(select distinct a2.mbl_no
from warehouse_data_user_review_info a2
where a2.apply_time between '2019-01-01' and '2019-04-31'
and a2.product_name = '现金分期-兴业消费'
and a2.data_source = 'sjd') a3
on a.mbl_no = a3.mbl_no
where a.registe_date between '2019-01-01' and '2019-04-31'
and a.chan_no = '304'                            -----------------VIVO新注册用户
and a.data_source = 'sjd'                        -----------------手机贷平台
and a3.mbl_no is null