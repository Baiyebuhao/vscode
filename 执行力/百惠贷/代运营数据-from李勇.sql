SELECT substr(a.registe_date,1,10) AS dt,
       count(DISTINCT a.mbl_no) AS regnum,
       count(DISTINCT CASE
                          WHEN substr(a.authentication_date,1,2) = '20' THEN a.mbl_no
                      END) AS authentication_num,  --实名
       count(DISTINCT CASE
                          WHEN a.registe_date<=b.c_time
                               OR b.c_time IS NULL THEN b.id
                      END) AS hzxregnum,      ---注册
       count(DISTINCT CASE
                          WHEN (a.registe_date<=c.loan_apply_time
                                OR c.loan_apply_time IS NULL) THEN c.customer_id
                      END) AS hzxappnum,     --申请
       count(DISTINCT CASE
                          WHEN (a.registe_date<=c.loan_apply_time
                                OR c.loan_apply_time IS NULL)
                               AND c.m_state=5 THEN c.customer_id
                      END) AS hzxappsccnum,   --申请完成
       count(DISTINCT CASE
                          WHEN (a.registe_date<=c.loan_apply_time
                                OR c.loan_apply_time IS NULL)
                               AND c.m_state=5
                               AND c.research_status IN(4) THEN c.customer_id
                      END) AS hzx_surveysucc,     --调查中
       count(DISTINCT CASE
                          WHEN (a.registe_date<=c.loan_apply_time
                                OR c.loan_apply_time IS NULL)
                               AND c.m_state=5
                               AND c.research_status IN(5) THEN c.customer_id
                      END) AS hzx_surveyfuse,     --调查完成
       count(DISTINCT CASE
                          WHEN (a.registe_date<=c.loan_apply_time
                                OR c.loan_apply_time IS NULL)
                               AND c.m_state=5
                               AND c.research_status IN(-1,1,2,3) THEN c.customer_id
                      END) AS hzx_unfinishedinvestigation,    ---未调查
       avg(CASE
               WHEN (a.registe_date<=c.loan_apply_time
                     OR c.loan_apply_time IS NULL)
                    AND c.m_state=5
                    AND c.research_status IN(4,5) THEN c.score
           END) AS hzxresscore,       ---调查平均额度
       count(DISTINCT CASE
                          WHEN substr(a.registe_date,1,10)<=d.apply_time
                               OR d.apply_time IS NULL THEN d.mbl_no
                      END) AS phdappnum,   --普惠达申请
       count(DISTINCT CASE
                          WHEN (substr(a.registe_date,1,10)<=d.apply_time
                                OR d.apply_time IS NULL)
                               AND substr(a.registe_date,1,10)=substr(d.apply_time,1,10) THEN d.mbl_no
                      END) AS phdappnum_dt,  --普惠达当天申请
       count(DISTINCT CASE
                          WHEN (substr(a.registe_date,1,10)<=d.apply_time
                                OR d.apply_time IS NULL)
                               AND d.status='通过' THEN d.mbl_no
                      END) AS phdsccnum,     --普惠达通过
       count(DISTINCT CASE
                          WHEN (substr(a.registe_date,1,10)<=e.cash_time
                                OR e.cash_time IS NULL) THEN e.mbl_no
                      END) AS phdcashnum,   ---普惠达放款人数
       avg(CASE
               WHEN (substr(a.registe_date,1,10)<=e.cash_time
                     OR e.cash_time IS NULL) THEN e.cash_amount
           END) AS cashamount     ---普惠达平均金额
FROM default.warehouse_atomic_time_user AS a
LEFT JOIN
  (SELECT *
   FROM default.warehouse_atomic_hzx_c_customer
   WHERE bank_id IN ('1011410230000266',
                     '1011810230000266')) AS b ON a.mbl_no=b.mobile
LEFT JOIN
  (SELECT *
   FROM default.warehouse_atomic_hzx_research_task
   WHERE bank_id IN ('1011410230000266',
                     '1011810230000266')) AS c ON b.id=c.customer_id
LEFT JOIN default.warehouse_data_user_review_info AS d ON a.mbl_no=d.mbl_no
AND d.apply_time !='\n'
LEFT JOIN default.warehouse_data_user_withdrawals_info AS e ON a.mbl_no=e.mbl_no
AND e.cash_time !='\n'
WHERE a.data_source IN ('bhh',
                        'bhd')
  AND a.chan_no IN ('10',
                    '11',
                    '12',
                    '13',
                    '14',
                    '16',
                    '17')
  AND substr(a.registe_date,1,10) >= '2019-09-27'
GROUP BY substr(a.registe_date,1,10)
