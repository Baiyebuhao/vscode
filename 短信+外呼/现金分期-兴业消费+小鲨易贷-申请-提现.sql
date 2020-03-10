现金分期-兴业消费+小鲨易贷-申请-提现
现金分期-兴业消费

#小鲨易贷申请授信，统用授信时间
SELECT  approvetime, data_source, 
COUNT(DISTINCT mbl_no) AS apply_cus,
count(case when resultcode = 'SUCCESS' then mbl_no end) as criet_cus
FROM warehouse_atomic_xsyd_review_result_info 
where approvetime between '2018-11-12' and '2018-11-29'
group by approvetime, data_source
order by data_source

#小鲨易贷提现放款
SELECT data_source,
       paymentdate,
       count(DISTINCT mbl_no) AS dnum, --提现人数
       sum(loanamt)AS loanamt          --提现金额
FROM warehouse_atomic_xsyd_withdrawals_result_info AS a
WHERE paymentstatus='SUCCESS'
and paymentdate between '2018-10-30' and '2018-11-08'
GROUP BY data_source,paymentdate
order by data_source



#万达授信、提现放款（机构没返申请数据）
SELECT data_source,
       count(CASE
                 WHEN substr(finish_time, 1,10) = date_sub(current_date(),1) THEN  
             END) AS credit_cus,
       count(CASE
                 WHEN substr(loan_date, 1,10) = date_sub(current_date(),1) THEN mbl_no
             END)AS withdraw,
       sum(CASE
               WHEN substr(loan_date, 1,10) = date_sub(current_date(),1) THEN loan_amt
           END) AS amount
FROM warehouse_atomic_wanda_loan_info
GROUP BY data_source