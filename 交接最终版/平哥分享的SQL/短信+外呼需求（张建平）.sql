-- SJD_AN154_01 移动手机贷平台，2018年1月1日-2018年11月30日授信马上随借随还，且至今只提现过一次的联通用户。
SELECT a.mbl_no
FROM warehouse_atomic_user_info AS a
JOIN
  (SELECT mbl_no
   FROM warehouse_atomic_msd_withdrawals_result_info AS a
   WHERE data_source='sjd'
     AND total_amount>0
     AND substr(credit_time,1,10) BETWEEN '2018-01-01' AND '2018-11-30'
   GROUP BY mbl_no
   HAVING count(1)=1) AS b ON a.mbl_no=b.mbl_no
AND a.data_source='sjd'
WHERE a.mbl_no NOT IN
    (SELECT mbl_no
     FROM warehouse_atomic_smstunsubscribe
     WHERE eff_flg = '1'
     UNION SELECT mbl_no_encode
     FROM warehouse_atomic_operation_promotion
     WHERE data_extract_day BETWEEN date_sub('2018-01-09',15) AND '2018-01-09'
       AND marketing_type='DX')
  AND isp LIKE '%联通%';

-- SJD_AN154_02 移动手机贷平台，2018年1月1日-2018年11月30日授信马上随借随还，且至今只提现过一次的移动用户。
SELECT a.mbl_no
FROM warehouse_atomic_user_info AS a
JOIN
  (SELECT mbl_no
   FROM warehouse_atomic_msd_withdrawals_result_info AS a
   WHERE data_source='sjd'
     AND total_amount>0
     AND substr(credit_time,1,10) BETWEEN '2018-01-01' AND '2018-11-30'
   GROUP BY mbl_no
   HAVING count(1)=1) AS b ON a.mbl_no=b.mbl_no
AND a.data_source='sjd'
WHERE a.mbl_no NOT IN
    (SELECT mbl_no
     FROM warehouse_atomic_smstunsubscribe
     WHERE eff_flg = '1'
     UNION SELECT mbl_no_encode
     FROM warehouse_atomic_operation_promotion
     WHERE data_extract_day BETWEEN date_sub('2018-01-09',15) AND '2018-01-09'
       AND marketing_type='DX')
  AND isp LIKE '%移动%';

-- SJD_AN154_03 移动手机贷平台，2018年12月13日-2019年1月5日钱包易贷授信通过且已放款成功用户，保留客户姓名、手机号、申请日期、放款日期、额度
SELECT a.mbl_no,
       name,
       appl_time,
       cash_time,
       total_amount
FROM warehouse_atomic_qianbao_withdrawals_result_info AS a
JOIN warehouse_atomic_user_info AS b ON a.mbl_no=b.mbl_no
AND a.data_source=b.data_source
WHERE credit_time BETWEEN '2018-12-13' AND '2019-01-05'
  AND cash_time IS NOT NULL
  AND a.data_source='sjd'
  AND a.mbl_no NOT IN
    (SELECT mbl_no
     FROM warehouse_atomic_smstunsubscribe
     WHERE eff_flg = '1'
     UNION SELECT mbl_no_encode
     FROM warehouse_atomic_operation_promotion
     WHERE data_extract_day BETWEEN date_sub('2018-01-09',15) AND '2018-01-09'
       AND marketing_type='DX');


-- XYQB_AN154_01 享宇钱包平台，2018年12月13日-2019年1月5日钱包易贷授信通过且已放款成功所有用户，保留客户姓名、手机号、申请日期、放款日期、额度、平台
SELECT a.mbl_no,
       name,
       appl_time,
       cash_time,
       total_amount,
       CASE
           WHEN b.data_source ='xyqb'
                AND (substr(b.app_version,1,5)='1.0.0'
                     OR substr(b.app_version,1,5)>='8.0.0')
                AND b.chan_no='appStore'
                AND b.registe_date>='2018-09-20' THEN 'JRY'
           WHEN b.data_source ='xyqb'
                AND substr(b.app_version,1,5) BETWEEN '1.2.0' AND '7.9.9'
                AND b.chan_no!='appStore' THEN 'JRY'
           ELSE 'XYQB'
       END is_new_jry
FROM warehouse_atomic_qianbao_withdrawals_result_info AS a
JOIN warehouse_atomic_user_info AS b ON a.mbl_no=b.mbl_no
AND a.data_source=b.data_source
WHERE credit_time BETWEEN '2018-12-13' AND '2019-01-05'
  AND cash_time IS NOT NULL
  AND a.data_source='xyqb'
  AND a.mbl_no NOT IN
    (SELECT mbl_no
     FROM warehouse_atomic_smstunsubscribe
     WHERE eff_flg = '1'
     UNION SELECT mbl_no_encode
     FROM warehouse_atomic_operation_promotion
     WHERE data_extract_day BETWEEN date_sub('2018-01-09',15) AND '2018-01-09'
       AND marketing_type='DX');
