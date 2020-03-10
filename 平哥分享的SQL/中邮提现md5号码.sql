select a.mbl_no,
       a.order_no,
	   a.loan_amount,
	   a.loan_time,
	   a.loan_period,
       b.mbl_no_md5
from warehouse_atomic_zhongyou_withdrawals_result_info a
     left join warehouse_atomic_user_info b
	 on a.mbl_no = b.mbl_no
where a.loan_time BETWEEN '2018-08-01' AND '2018-08-31' 
and a.mbl_no in 
   (select distinct mbl_no
    from warehouse_atomic_zhongyou_review_result_info
    where  data_source  = 'sjd' and apply_time BETWEEN '2018-08-01' AND '2018-08-31') 
	
	
    warehouse_atomic_user_info