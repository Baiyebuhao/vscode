
新老用户点击量

SELECT extractday,
       data_source,
       product_name,
       count(DISTINCT CASE
                          WHEN (is_credit IN ('','是')
                                OR is_credit IS NULL) THEN mbl_no
                      END) AS dnum,
       count(DISTINCT CASE
                          WHEN is_credit= '否' THEN mbl_no
                      END) AS dnum2,
	   count(DISTINCT mbl_no) AS dnum3	  
FROM warehouse_data_user_action_sum
WHERE extractday = '2018-12-24'
  AND applypv > 0
  and product_name in ('随借随还-马上','现金分期-中邮','现金分期-马上','现金分期-点点','现金分期-万达普惠','现金分期-兴业消费')
GROUP BY extractday,
         product_name,
         data_source
ORDER BY data_source;





(
时间
= '2018-12-24'
between '2018-12-21' and '2018-12-23'
)

(
检查是否有数据
select * from warehouse_data_user_action_sum                 -------------------下午更新，带授信
where extractday = '2018-12-24'
)