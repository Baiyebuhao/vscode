众安点点
申请授信表warehouse_atomic_diandian_review_result_info
mbl_no		    申请人电话
status_desc		授信结果状态描述   '正常出额'
message		    授信描述           '授信成功'   '成功'
creadit_time	授信时间  2018-07-17	
apply_time		申请时间  2018-06-06
data_source	    平台

点点提现表warehouse_atomic_diandian_withdrawals_result_info
loan_amount	    放款金额
lending_time	放款时间





创建首次申请授信表（众安点点申请授信）
create table ZADDSQSX
as
SELECT a.mbl_no,
       a.data_source,
       a.min_date,
       a.status_desc,
	   a.creadit_time,
       d.os_type
       
FROM
  (SELECT mbl_no,
          data_source,
          min(substring(apply_time,1,10)) AS min_date,
          status_desc,
          creadit_time
   FROM warehouse_atomic_diandian_review_result_info
 
   GROUP BY mbl_no,data_source,status_desc,creadit_time) a,
     warehouse_atomic_user_info d
WHERE a.mbl_no = d.mbl_no 
      and substring(min_date,1,10) BETWEEN '2018-08-22' AND '2018-08-28'
GROUP BY a.mbl_no,
         a.data_source,
         a.min_date,
         a.status_desc,
	     a.creadit_time,
         d.os_type
		 
审批通过
select * from ZADDSQSX
where status_desc = '正常出额' 
   and creadit_time BETWEEN '2018-08-22' AND '2018-08-28'


点点提现表warehouse_atomic_diandian_withdrawals_result_info
loan_amount	    放款金额
lending_time	放款时间
放款
select a.mbl_no,
       a.data_source,
       a.loan_amount,
	   a.lending_time,
	   b.min_date,
	   b.os_type
from warehouse_atomic_diandian_withdrawals_result_info a,ZADDSQSX b
where a.mbl_no = b.mbl_no
  and a.loan_amount > 0
group by  a.mbl_no,
       a.data_source,
       a.loan_amount,
	   a.lending_time,
	   b.min_date,
	   b.os_type
		  
		  
		  
		  
		  
		  
		  
		  
		  