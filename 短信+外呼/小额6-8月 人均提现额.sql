随借随还-马上   
近三月提现明细

SELECT a.mbl_no,
       a.data_source,
       a.total_amount,
       a.msd_return_time,
       b.os_type
FROM warehouse_atomic_msd_withdrawals_result_info a,
     warehouse_atomic_user_info b
WHERE a.mbl_no = b.mbl_no
  AND a.msd_return_time BETWEEN '2018-06-01' AND '2018-08-31'
  AND a.total_amount > 0
GROUP BY a.mbl_no,
         a.data_source,
         a.total_amount,
         a.msd_return_time,
         b.os_type
		 
		 
随借随还-马上  
金额/人数	 
SELECT count(distinct a.mbl_no),
       sum(a.total_amount),
	   a.data_source,
       b.os_type
FROM warehouse_atomic_msd_withdrawals_result_info a,
     warehouse_atomic_user_info b
WHERE a.mbl_no = b.mbl_no
  AND a.msd_return_time BETWEEN '2018-06-01' AND '2018-08-31'
  AND a.total_amount > 0
GROUP BY a.data_source,
         b.os_type
		 
		 
中邮
warehouse_atomic_zhongyou_withdrawals_result_info

select count(distinct a.mbl_no),
       sum(a.loan_amount),
	   a.data_source,
	   b.os_type
from warehouse_atomic_zhongyou_withdrawals_result_info a,
     warehouse_atomic_user_info b
where a.mbl_no = b.mbl_no
  and a.loan_time BETWEEN '2018-06-01' AND '2018-08-31'
  and a.loan_amount > 0
group by 
       a.data_source,
       b.os_type
	   
众安点点
warehouse_atomic_diandian_withdrawals_result_info

select count(distinct a.mbl_no),
       sum(a.loan_amount),
       a.data_source,
	   b.os_type
from warehouse_atomic_diandian_withdrawals_result_info a,
     warehouse_atomic_user_info b
where a.mbl_no = b.mbl_no
  and a.lending_time BETWEEN '2018-06-01' AND '2018-08-31'
  and a.loan_amount > 0
group by a.data_source,
	     b.os_type
		 

现金分期-马上
warehouse_atomic_msd_cashord_result_info	   
mbl_no	手机号码
approval_amount	放款金额
msd_return_time	马上返回时间
data_source	数据业务系统渠道	


select count(distinct a.mbl_no),
       sum(a.approval_amount),
       a.data_source,
	   b.os_type
from warehouse_atomic_msd_cashord_result_info a,
     warehouse_atomic_user_info b
where a.mbl_no = b.mbl_no
  and a.msd_return_time BETWEEN '20180601' AND '20180831'
  and a.approval_amount > 0
group by a.data_source,
	     b.os_type  
	   
小雨点
warehouse_atomic_xiaoyudian_withdrawals_result_info a	   

SELECT count(distinct a.mbl_no),
       sum(a.contractamount),
       a.data_source,
	   b.os_type
FROM warehouse_atomic_xiaoyudian_withdrawals_result_info a
     left join warehouse_atomic_user_info b
     on a.mbl_no = b.mbl_no
where substring (lending_time,1,10) BETWEEN '2018-06-01' AND '2018-08-31'
   and a.contractamount > 0
GROUP BY a.data_source,
		 b.os_type



















	   
