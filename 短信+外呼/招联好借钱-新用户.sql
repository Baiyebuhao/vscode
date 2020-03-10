招联好借钱
------申请，授信
SELECT a1.data_source,
       count(DISTINCT a1.mbl_no) AS `申请用户`,
       count(distinct CASE
                 WHEN fixed_limit>0 THEN a1.mbl_no
             END) AS `授信用户`
FROM warehouse_atomic_zlhjq_review_result_info AS a1
join (select a.data_source,a.mbl_no from warehouse_atomic_user_info a
      where a.registe_date between '2019-04-17' and '2019-05-13') a2
   on a1.mbl_no = a2.mbl_no
   and a1.data_source = a2.data_source 
WHERE substr(a1.apply_time,1,10) between '2019-04-17' and '2019-05-13'
GROUP BY a1.data_source

--------提现（有问题）
SELECT a1.data_source,
       count(DISTINCT a1.mbl_no) AS `申请提现`,
       count(DISTINCT CASE
                          WHEN substr(payment_date,1,1)='2' THEN a1.mbl_no
                      END) AS `成功提现`,
       sum(CASE
               WHEN substr(payment_date,1,1)='2' THEN a1.loan_amt
           END) AS `提现金额`
FROM warehouse_atomic_zlhjq_withdrawals_result_info AS a1
join (select a.data_source,a.mbl_no from warehouse_atomic_user_info a
      where a.registe_date between '2019-04-17' and '2019-05-13') a2
   on a1.mbl_no = a2.mbl_no
   and a1.data_source = a2.data_source 
WHERE substr(a1.payment_date,1,10) between '2019-04-17' and '2019-05-13'
GROUP BY a1.data_source



