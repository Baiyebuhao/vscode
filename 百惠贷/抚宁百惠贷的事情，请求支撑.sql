抚宁百惠贷的事情，请求支撑
1、现BI展示内容中新增申请产品情况
2、现BI展示内容中新增推送人数字段数据
3、运营报告的数据提取

(？？推送人数的定义：（推送人数为点击立即申请按钮的人数）
select * 
from warehouse_data_user_action_day a1
where applypv > 0

---
select extractday,
       count(distinct phone_number) as tsrs
from warehouse_atomic_newframe_burypoint_buttonoperations a
where click_name = 'order_promptly'
group by extractday

count(DISTINCT CASE
                          WHEN f.click_name = 'order_promptly' THEN f.phone_number
                      END) AS bhd_click
					  
					  
select a1.extractday,
       a2.registe_date,
       count(distinct a1.phone_number) as tsrs
from warehouse_atomic_newframe_burypoint_buttonoperations a1
join warehouse_atomic_user_info a2
  on a1.phone_number = a2.mbl_no
where a1.click_name = 'order_promptly'
  and a1.phone_number is not null
group by a1.extractday,
         a2.registe_date				  
)


(
银行代运营-BI展示
SELECT substr(a.registe_date,1,10) AS dt,
       count(DISTINCT a.mbl_no) AS regnum,
       count(DISTINCT CASE
                          WHEN a.registe_date<=b.c_time
                               OR b.c_time IS NULL THEN b.id
                      END) AS hzxregnum,       
       count(DISTINCT CASE
                          WHEN a.registe_date<=c.loan_apply_time
                               OR c.loan_apply_time IS NULL THEN c.customer_id
                      END) AS hzxappnum,
       count(DISTINCT CASE
                          WHEN (a.registe_date<=c.loan_apply_time
                                OR c.loan_apply_time IS NULL)
                               AND c.m_state=5 THEN c.customer_id
                      END) AS hzxappsccnum,
       count(DISTINCT CASE
                          WHEN (a.registe_date<=c.loan_apply_time
                                OR c.loan_apply_time IS NULL)
                               AND c.m_state=5
                               AND c.research_status IN(4,5) THEN c.customer_id
                      END) AS hzxressccnum,
       avg(CASE
               WHEN (a.registe_date<=c.loan_apply_time
                     OR c.loan_apply_time IS NULL)
                    AND c.m_state=5
                    AND c.research_status IN(4,5) THEN c.score
           END) AS hzxresscore,
		
	   count(DISTINCT CASE
                          WHEN f.click_name = 'order_promptly' THEN f.phone_number
                      END) AS bhd_click,
					  
       count(DISTINCT CASE
                          WHEN substr(a.registe_date,1,10)<=d.apply_time
                               OR d.apply_time IS NULL THEN d.mbl_no
                      END) AS phdappnum,
       count(DISTINCT CASE
                          WHEN (substr(a.registe_date,1,10)<=d.apply_time
                                OR d.apply_time IS NULL)
                               AND d.status='通过' THEN d.mbl_no
                      END) AS phdsccnum,
       count(DISTINCT CASE
                          WHEN (substr(a.registe_date,1,10)<=e.cash_time
                                OR e.cash_time IS NULL) THEN e.mbl_no
                      END) AS phdcashnum,
       avg(CASE
               WHEN (substr(a.registe_date,1,10)<=e.cash_time
                     OR e.cash_time IS NULL) THEN e.cash_amount
           END) AS cashamount
FROM default.warehouse_atomic_time_user AS a
LEFT JOIN default.warehouse_atomic_hzx_c_customer AS b ON a.mbl_no=b.mobile
LEFT JOIN default.warehouse_atomic_hzx_research_task AS c ON b.id=c.customer_id
LEFT JOIN default.warehouse_data_user_review_info AS d ON a.mbl_no=d.mbl_no
LEFT JOIN default.warehouse_data_user_withdrawals_info AS e ON a.mbl_no=e.mbl_no AND e.cash_time !='\n'
LEFT JOIN default.warehouse_atomic_newframe_burypoint_buttonoperations AS f ON a.mbl_no=f.phone_number

WHERE a.data_source in ('bhh','bhd')
  AND a.chan_no='11'
  AND substr(a.registe_date,1,10) >= '2019-09-27'
GROUP BY substr(a.registe_date,1,10)
)