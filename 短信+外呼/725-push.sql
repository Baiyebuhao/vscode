725 push营销 
纪春艳 移动手机贷  

马上老用户中，提现多次的用户，且本月有过产品点击行为的用户；剔除已申请过万达普惠的用户

SELECT distinct a1.mbl_no
from
  (SELECT mbl_no , 
          count(mbl_no) AS cash_tims
   FROM warehouse_data_user_withdrawals_info
   WHERE cash_amount > 0
     AND product_name = '随借随还-马上'
     AND data_source = 'sjd'
     AND mbl_no IS NOT NULL
   GROUP BY mbl_no) AS a1 --马上('随借随还-马上')老用户'历史有过提现记录'

JOIN(SELECT mbl_no
     FROM warehouse_data_user_action_day
     WHERE extractday BETWEEN '2019-11-01' AND '2019-11-14'
       AND data_source = 'sjd'
       AND applypv > 0
       AND product_name = '随借随还-马上' ) AS a2 --本月有过产品点击行为的用户
 ON a1.mbl_no = a2.mbl_no
 
LEFT OUTER JOIN
    (SELECT mbl_no
     FROM warehouse_data_user_review_info
     WHERE apply_time IS NOT NULL
       AND product_name = '现金分期-万达普惠'
	   and data_source = 'sjd') AS a3
 ON a1.mbl_no = a3.mbl_no

WHERE a1.cash_tims >= 2  --提现多次>=2的用户
  and a3.mbl_no IS NULL --剔除已申请过万达普惠('现金分期-万达普惠')的用户