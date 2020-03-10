小雨点
warehouse_atomic_xiaoyudian_withdrawals_result_info
mbl_no	string	申请人电话
status	string	状态
contractamount	double	金额
lending_time	string	放款时间
data_source	string	数据业务系统渠道(sjd – 手机贷 xyqb-享宇钱包)

SELECT    a.mbl_no,
          a.data_source,
          min(substring(a.lending_time,1,10)) AS min_date,
          a.status,
          a.amount,
		  b.os_type
   FROM warehouse_atomic_xiaoyudian_withdrawals_result_info a
   left join warehouse_atomic_user_info b
   on a.mbl_no = b.mbl_no
   where substring (lending_time,1,10) BETWEEN '2018-08-22' AND '2018-08-28'
   GROUP BY a.mbl_no,
            a.data_source,
            a.status,
            a.amount,
		    b.os_type
			


