中邮授信表warehouse_atomic_zhongyou_review_result_info
approve_status	审批状态  '审批通过'
apply_time	申请时间 2018-04-09	
approve_time  审批时间 2018-04-09
data_source


中邮放款表warehouse_atomic_zhongyou_withdrawals_result_info
loan_amount 放款金额
loan_time	放款时间
申请
	
SELECT a.mbl_no,
       a.data_source,
       a.min_date,
       d.os_type
       
FROM
  (SELECT mbl_no,
          data_source,
          min(substring(apply_time,1,10)) AS min_date
   FROM warehouse_atomic_zhongyou_review_result_info
 
   GROUP BY mbl_no,data_source) a,
     warehouse_atomic_user_info d
WHERE a.mbl_no = d.mbl_no 
      and substring(min_date,1,10) BETWEEN '2018-09-08' AND '2018-09-14'
GROUP BY a.mbl_no,
         a.data_source,
         a.min_date,
         d.os_type
申请+授信
SELECT a.mbl_no,
       a.data_source,
       a.min_date,
       a.approve_status,
	   a.approve_time,
       d.os_type
       
FROM
  (SELECT mbl_no,
          data_source,
          min(substring(apply_time,1,10)) AS min_date,
          approve_status,
          approve_time
   FROM warehouse_atomic_zhongyou_review_result_info
 
   GROUP BY mbl_no,data_source,approve_status,approve_time) a,
     warehouse_atomic_user_info d
WHERE a.mbl_no = d.mbl_no 
      and substring(min_date,1,10) BETWEEN '2018-09-08' AND '2018-09-14'
GROUP BY a.mbl_no,
         a.data_source,
         a.min_date,
         a.approve_status,
         a.approve_time,
         d.os_type
		 
根据上面内容创建表 ZYSQSX
create table ZYSQSX
as
SELECT a.mbl_no,
       a.data_source,
       a.min_date,
       a.approve_status,
	   a.approve_time,
       d.os_type
       
FROM
  (SELECT mbl_no,
          data_source,
          min(substring(apply_time,1,10)) AS min_date,
          approve_status,
          approve_time
   FROM warehouse_atomic_zhongyou_review_result_info
 
   GROUP BY mbl_no,data_source,approve_status,approve_time) a,
     warehouse_atomic_user_info d
WHERE a.mbl_no = d.mbl_no 
      and substring(min_date,1,10) BETWEEN '2018-09-08' AND '2018-09-14'
GROUP BY a.mbl_no,
         a.data_source,
         a.min_date,
         a.approve_status,
         a.approve_time,
         d.os_type
		 
审批通过
select * from ZYSQSX 
where approve_status = '审批通过'

中邮放款表warehouse_atomic_zhongyou_withdrawals_result_info
loan_amount 放款金额
loan_time	放款时间
放款（未限制提现时间）
select a.mbl_no,
       a.data_source,
       a.loan_amount,
       a.loan_time,
       b.min_date,
       b.os_type
from warehouse_atomic_zhongyou_withdrawals_result_info a,ZYSQSX b
where a.mbl_no = b.mbl_no
  and a.loan_amount > 0
group by  a.mbl_no,
       a.data_source,
       a.loan_amount,
       a.loan_time,
       b.min_date,
       b.os_type





























