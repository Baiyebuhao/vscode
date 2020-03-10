API产品数据提取

select *
substring(a.check_time,1,10),count(distinct mbl_no),sum(check_amount)
from warehouse_atomic_api_loan_record a

where a.prod_name = '趣借钱'
  and substring(a.check_time,1,10) between '2019-09-20' and '2019-09-25'
  and a.check_status = '1'
group by substring(a.check_time,1,10)



SELECT CASE
           WHEN c.platform_id=1 THEN 'sjd'
           WHEN c.platform_id=2 THEN 'jry'
           WHEN c.platform_id=4 THEN 'xyqb'
       END platform,
       c.mbl_no,
       b.id,
       b.prod_name,
       a.platform_order_no,
       a.create_time AS end_time,
       a.apply_status AS end_status,
       a.credit_time_out,
       a.loan_total_amount AS end_loan_total_amount,
       e.chan_no,
       e.child_chan_no,
       f.mht_apply_no,
       f.create_time,
       f.check_time,
       f.check_amount,
       f.status AS check_status,
       g.mht_payment_no,
       g.payment_time,
       g.status AS payment_status,
       g.payment_amount,
       g.loan_period,
       g.loan_total_amount,
       g.loan_surplus_amount
FROM warehouse_atomic_api_p_user_prod_inf AS a
JOIN warehouse_atomic_api_p_prod_inf AS b ON a.prod_id=b.id
JOIN warehouse_atomic_api_p_user_info AS c ON a.user_id=c.id
LEFT JOIN warehouse_atomic_api_p_order_inf AS e ON a.id=e.user_prod_id
LEFT JOIN warehouse_atomic_api_p_apply_record AS f ON e.id=f.order_id
LEFT JOIN warehouse_atomic_api_p_payment_record AS g ON f.order_id=g.order_id and f.status='1';