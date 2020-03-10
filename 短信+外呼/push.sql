--push
--2、万达普惠已授信用户中，仅提现一次的用户,含用户授信额度、提现金额、提现时间；  SJD_AN466_002

select a1.mbl_no,
       a1.credit_time,
       a1.amount,
       a3.cash_amount,
	   a3.cash_time
from(select distinct mbl_no,
            data_source,
			credit_time,
	        amount
     from warehouse_data_user_review_info
	 where data_source = 'sjd' 
	   and product_name = '现金分期-万达普惠' 
	   and status = '通过') a1
join
---仅提现一次的用户
         (select mbl_no
          from warehouse_data_user_withdrawals_info
          where data_source = 'sjd' 
		    and product_name = '现金分期-万达普惠' 
			and cash_amount > 0
          group by mbl_no
          having count(mbl_no) = 1
		  )as a2
on a1.mbl_no = a2.mbl_no
join
---万达普惠已提现用户
         (select mbl_no,
                 cash_amount, 
                 cash_time
          from warehouse_data_user_withdrawals_info a
          where data_source = 'sjd' 
		    and product_name = '现金分期-万达普惠' 
			and cash_amount > 0
		  ) as a3
on a1.mbl_no = a3.mbl_no
