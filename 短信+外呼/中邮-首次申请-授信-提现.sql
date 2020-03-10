中邮授信表warehouse_atomic_zhongyou_review_result_info
approve_status	审批状态  '审批通过'
apply_time	申请时间 2018-04-09	
approve_time  审批时间 2018-04-09
data_source

中邮放款表warehouse_atomic_zhongyou_withdrawals_result_info
loan_amount 放款金额
loan_time	放款时间


用户信息表warehouse_atomic_user_info d    系统d.os_type


中邮8月申请用户
(select a.mbl_no,
       min(a.apply_time) as min_time,
	   a.data_source,
	   b.os_type
from warehouse_atomic_zhongyou_review_result_info a 
     left join warehouse_atomic_user_info b 
     on a.mbl_no = b.mbl_no
where a.apply_time BETWEEN '2018-09-08' AND '2018-09-14'
GROUP BY a.mbl_no,
         a.data_source,
	     b.os_type) a
		 


中邮8月审批通过用户
(select a.mbl_no,
       a.approve_time,
	   a.data_source,
	   a.approve_status,
	   b.os_type
from warehouse_atomic_zhongyou_review_result_info a 
     left join warehouse_atomic_user_info b 
     on a.mbl_no = b.mbl_no
where a.approve_status = '审批通过'
      and a.approve_time BETWEEN '2018-09-08' AND '2018-09-14'
	  and a.apply_time BETWEEN '2018-09-08' AND '2018-09-14'
GROUP BY a.mbl_no,
         a.approve_time,
	     a.data_source,
	     a.approve_status,
	     b.os_type) d

		 
中邮8月提现用户		 
select c.mbl_no,
       c.data_source,
       c.loan_amount,
       c.loan_time,
       b.os_type
from warehouse_atomic_zhongyou_withdrawals_result_info c 
     left join warehouse_atomic_user_info b 
     on c.mbl_no = b.mbl_no
where c.loan_amount > 0 
      and loan_time BETWEEN '2018-08-01' AND '2018-08-31'
group by  c.mbl_no,
       c.data_source,
       c.loan_amount,
       c.loan_time,
       b.os_type

申请用户中的提现人数	
select c.mbl_no,
       c.data_source,
       c.loan_amount,
       c.loan_time,
	   d.min_time,
       d.os_type
from warehouse_atomic_zhongyou_withdrawals_result_info c 
     right join 	   
(select a.mbl_no,
       min(a.apply_time) as min_time,
	   a.data_source,
	   b.os_type
from warehouse_atomic_zhongyou_review_result_info a 
     left join warehouse_atomic_user_info b 
     on a.mbl_no = b.mbl_no
where a.apply_time BETWEEN '2018-09-08' AND '2018-09-14'
GROUP BY a.mbl_no,
         a.data_source,
	     b.os_type) d
	   
where c.loan_amount > 0 
      and loan_time BETWEEN '2018-09-08' AND '2018-09-14'
	  and c.loan_time > d.min_time
group by  c.mbl_no,
       c.data_source,
       c.loan_amount,
       c.loan_time,
	   d.min_time,
       d.os_type
  	   
提现用户
select *

from warehouse_atomic_zhongyou_withdrawals_result_info a
left join warehouse_atomic_user_info b 
     on a.mbl_no = b.mbl_no

where a.loan_time BETWEEN '2018-08-01' AND '2018-08-31' 
      and a.mbl_no in 
    (select distinct mbl_no

     from warehouse_atomic_zhongyou_review_result_info

     where  data_source  = 'sjd' 
	 and apply_time BETWEEN '2018-08-01' AND '2018-08-31')
	   
	   
授信用户中的提现人数	   
	   
select c.mbl_no,
       c.data_source,
       c.loan_amount,
       c.loan_time,
       d.approve_time,
       d.os_type
from warehouse_atomic_zhongyou_withdrawals_result_info c 
     right join 
  (select a.mbl_no,
       a.approve_time,
    a.data_source,
    a.approve_status,
    b.os_type
from warehouse_atomic_zhongyou_review_result_info a 
     left join warehouse_atomic_user_info b 
     on a.mbl_no = b.mbl_no
where approve_status = '审批通过'
      and approve_time BETWEEN '2018-09-08' AND '2018-09-14'
GROUP BY a.mbl_no,
         a.approve_time,
      a.data_source,
      a.approve_status,
      b.os_type) d 
     on c.mbl_no = d.mbl_no
where c.loan_amount > 0 
      and loan_time BETWEEN '2018-09-08' AND '2018-09-14'
group by  c.mbl_no,
       c.data_source,
       c.loan_amount,
       c.loan_time,
       d.approve_time,
       d.os_type
  
	   
	   
	   
	   
	   