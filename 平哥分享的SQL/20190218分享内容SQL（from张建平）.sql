--初始化数据
INSERT overwrite TABLE warehouse_data_hour_mail_report partition(data_source,elt_date)
SELECT a.is_new_jry,
       a.data_time,
       if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level) AS the_2nd_level,
       if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level) AS the_3rd_level,
       if(b.merger_chan IS NULL,'空白',b.merger_chan) AS merger_chan,
       count(DISTINCT CASE
                          WHEN code='reg' THEN mbl_no
                      END) AS regdnum,
       count(DISTINCT CASE
                          WHEN code='auth' THEN mbl_no
                      END) AS authdnum,
       a.data_source,
       substr(data_time,1,10) AS elt_date
FROM
  (SELECT 'reg' AS code,
          mbl_no,
          if(a.registe_date IS NULL,'1970-01-01 00:00:00',concat(substr(a.registe_date,1,13),':00:00')) AS data_time,
          chan_no,
          a.child_chan,
          data_source,
          CASE
              WHEN data_source ='xyqb'
                   AND (app_version='1.0.0'
                        OR app_version>='8.0.0')
                   AND chan_no='appStore'
                   AND registe_date>='2018-09-20' THEN '是'
              WHEN data_source ='xyqb'
                   AND app_version BETWEEN '1.2.0' AND '7.9.9'
                   AND chan_no!='appStore' THEN '是'
              ELSE '否'
          END is_new_jry
   FROM warehouse_atomic_time_user AS a
   WHERE if(a.registe_date IS NULL,'1970-01-01',substr(a.registe_date,1,7)) = '2018-01'
     AND if(a.registe_date IS NULL,'00',substr(a.registe_date,12,2))!=substr(from_unixtime(unix_timestamp()),12,2)
   UNION ALL SELECT 'auth' AS code,
                    mbl_no,
                    concat(substr(a.authentication_date,1,13),':00:00') AS auth_date,
                    chan_no,
                    a.child_chan,
                    data_source,
                    CASE
                        WHEN data_source ='xyqb'
                             AND (app_version='1.0.0'
                                  OR app_version>='8.0.0')
                             AND chan_no='appStore'
                             AND registe_date>='2018-09-20' THEN '是'
                        WHEN data_source ='xyqb'
                             AND app_version BETWEEN '1.2.0' AND '7.9.9'
                             AND chan_no!='appStore' THEN '是'
                        ELSE '否'
                    END is_new_jry
   FROM warehouse_atomic_time_user AS a
   WHERE substr(a.authentication_date,1,7) ='2018-01'
     AND substr(a.authentication_date,12,2)=substr(from_unixtime(unix_timestamp()),12,2) ) AS a
LEFT JOIN warehouse_data_chan_info AS b ON a.data_source=b.data_source
AND a.chan_no=b.chan_no
AND a.child_chan = b.child_chan
GROUP BY a.data_source,
         a.data_time,
         a.is_new_jry,
         if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level),
         if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level),
         if(b.merger_chan IS NULL,'空白',b.merger_chan);

--手机贷平台 按时更新数据 add 2018-12-11
INSERT overwrite TABLE warehouse_data_hour_mail_report partition(data_source='sjd',elt_date='$onehourago')
SELECT a.is_new_jry,
       a.data_time,
       if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level) AS the_2nd_level,
       if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level) AS the_3rd_level,
       if(b.merger_chan IS NULL,'空白',b.merger_chan) AS merger_chan,
       count(DISTINCT CASE
                          WHEN code='reg' THEN mbl_no
                      END) AS regdnum,
       count(DISTINCT CASE
                          WHEN code='auth' THEN mbl_no
                      END) AS authdnum
FROM
  (SELECT 'reg' AS code,
          mbl_no,
          if(a.registe_date IS NULL,'1970-01-01 00:00:00',concat(substr(a.registe_date,1,13),':00:00')) AS data_time,
          chan_no,
          a.child_chan,
          data_source,
          '否' AS is_new_jry
   FROM warehouse_atomic_time_user AS a
   WHERE data_source ='sjd'
     AND if(a.registe_date IS NULL,'1970-01-01',substr(a.registe_date,1,10))=substr(from_unixtime(unix_timestamp()-3600),1,10)
     AND if(a.registe_date IS NULL,'00',substr(a.registe_date,12,2))!=substr(from_unixtime(unix_timestamp()),12,2)
   UNION ALL SELECT 'auth' AS code,
                    mbl_no,
                    concat(substr(a.authentication_date,1,13),':00:00') AS auth_date,
                    chan_no,
                    a.child_chan,
                    data_source,
                    '否' AS is_new_jry
   FROM warehouse_atomic_time_user AS a
   WHERE data_source ='sjd'
     AND substr(a.authentication_date,1,10)=substr(from_unixtime(unix_timestamp()-3600),1,10)
     AND substr(a.authentication_date,12,2)=substr(from_unixtime(unix_timestamp()),12,2)) AS a
LEFT JOIN warehouse_data_chan_info AS b ON a.data_source=b.data_source
AND a.chan_no=b.chan_no
AND a.child_chan = b.child_chan
GROUP BY a.data_source,
         a.data_time,
         a.is_new_jry,
         if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level),
         if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level),
         if(b.merger_chan IS NULL,'空白',b.merger_chan);

--享宇钱包平台 按时更新数据 add 2018-12-11
INSERT overwrite TABLE warehouse_data_hour_mail_report partition(data_source='xyqb',elt_date='$onehourago')
SELECT a.is_new_jry,
       a.data_time,
       if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level) AS the_2nd_level,
       if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level) AS the_3rd_level,
       if(b.merger_chan IS NULL,'空白',b.merger_chan) AS merger_chan,
       count(DISTINCT CASE
                          WHEN code='reg' THEN mbl_no
                      END) AS regdnum,
       count(DISTINCT CASE
                          WHEN code='auth' THEN mbl_no
                      END) AS authdnum
FROM
  (SELECT 'reg' AS code,
          mbl_no,
          if(a.registe_date IS NULL,'1970-01-01 00:00:00',concat(substr(a.registe_date,1,13),':00:00')) AS data_time,
          chan_no,
          a.child_chan,
          data_source,
          CASE
              WHEN data_source ='xyqb'
                   AND (app_version='1.0.0'
                        OR app_version>='8.0.0')
                   AND chan_no='appStore'
                   AND registe_date>='2018-09-20' THEN '是'
              WHEN data_source ='xyqb'
                   AND app_version BETWEEN '1.2.0' AND '7.9.9'
                   AND chan_no!='appStore' THEN '是'
              ELSE '否'
          END is_new_jry
   FROM warehouse_atomic_time_user AS a
   WHERE data_source ='xyqb'
     AND if(a.registe_date IS NULL,'1970-01-01',substr(a.registe_date,1,10))=substr(from_unixtime(unix_timestamp()-3600),1,10)
     AND if(a.registe_date IS NULL,'00',substr(a.registe_date,12,2))!=substr(from_unixtime(unix_timestamp()),12,2)
   UNION ALL SELECT 'auth' AS code,
                    mbl_no,
                    concat(substr(a.authentication_date,1,13),':00:00') AS auth_date,
                    chan_no,
                    a.child_chan,
                    data_source,
                    CASE
                        WHEN data_source ='xyqb'
                             AND (app_version='1.0.0'
                                  OR app_version>='8.0.0')
                             AND chan_no='appStore'
                             AND registe_date>='2018-09-20' THEN '是'
                        WHEN data_source ='xyqb'
                             AND app_version BETWEEN '1.2.0' AND '7.9.9'
                             AND chan_no!='appStore' THEN '是'
                        ELSE '否'
                    END is_new_jry
   FROM warehouse_atomic_time_user AS a
   WHERE data_source ='xyqb'
     AND substr(a.authentication_date,1,10)=substr(from_unixtime(unix_timestamp()-3600),1,10)
     AND substr(a.authentication_date,12,2)=substr(from_unixtime(unix_timestamp()),12,2)) AS a
LEFT JOIN warehouse_data_chan_info AS b ON a.data_source=b.data_source
AND a.chan_no=b.chan_no
AND a.child_chan = b.child_chan
GROUP BY a.data_source,
         a.data_time,
         a.is_new_jry,
         if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level),
         if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level),
         if(b.merger_chan IS NULL,'空白',b.merger_chan);

--汇智信汇总数据更新 update 2018-12-26
INSERT OVERWRITE TABLE warehouse_data_hzx_bank_view
SELECT BankName,
       pro_type,
       product_id,
       product_name,
       data_date,
       sum(applyOver)AS applyOver,
       sum(applyNotOver) AS applyNotOver,
       sum(waitDistribution) AS waitDistribution,
       sum(distribution) AS distribution,
       sum(researchOver) AS researchOver,
       sum(researchOverHaveAmount) AS researchOverHaveAmount,
       sum(totalAmount) AS totalAmount
FROM
  (SELECT b.name AS BankName,
          CASE
              WHEN p.pro_type =1 THEN '信易贷'
              WHEN p.pro_type =2 THEN '信福时贷'
              WHEN p.pro_type =3 THEN '精细化'
              WHEN p.pro_type =4 THEN '银行产品'
              ELSE '未归类'
          END AS pro_type,
          p.id AS product_id,
          p.name AS product_name,
          substr(t.loan_apply_time,1,10) AS data_date,
          count(DISTINCT CASE
                             WHEN t.m_state = 5 THEN t.id
                         END) AS applyOver,
          count(DISTINCT CASE
                             WHEN t.m_state != 5 THEN t.id
                         END) AS applyNotOver,
          count(DISTINCT CASE
                             WHEN t.m_state = 5
                                  AND distribution = 0 THEN t.id
                         END) AS waitDistribution,
          count(DISTINCT CASE
                             WHEN t.m_state = 5
                                  AND distribution = 1 THEN t.id
                         END) AS distribution,
          0 AS researchOver,
          0 AS researchOverHaveAmount,
          0 AS totalAmount
   FROM warehouse_atomic_hzx_xy_product_info AS st
   JOIN warehouse_atomic_hzx_bank_product_info p ON st.id = p.t_id
   JOIN warehouse_atomic_hzx_research_task AS t ON t.bank_pro_id = p.id
   JOIN warehouse_atomic_hzx_b_bank_base_info AS b ON b.id = t.bank_id
   WHERE p.id IS NOT NULL
     AND p.bank_id NOT IN(1011607210000337,
                          1011609230000007,
                          1011705260000101,
                          1011806250000203,
                          1011808220000244,
                          1011808270000246)
   GROUP BY b.name,
            CASE
                WHEN p.pro_type =1 THEN '信易贷'
                WHEN p.pro_type =2 THEN '信福时贷'
                WHEN p.pro_type =3 THEN '精细化'
                WHEN p.pro_type =4 THEN '银行产品'
                ELSE '未归类'
            END,
            p.id,
            p.name,
            substr(t.loan_apply_time,1,10)
   UNION ALL SELECT b.name AS BankName,
                    CASE
                        WHEN p.pro_type =1 THEN '信易贷'
                        WHEN p.pro_type =2 THEN '信福时贷'
                        WHEN p.pro_type =3 THEN '精细化'
                        WHEN p.pro_type =4 THEN '银行产品'
                        ELSE '未归类'
                    END AS pro_type,
                    p.id AS product_id,
                    p.name AS product_name,
                    substr(t.research_over_time,1,10) AS data_date,
                    0 AS applyOver,
                    0 AS applyNotOver,
                    0 AS waitDistribution,
                    0 AS distribution,
                    count(DISTINCT CASE
                                       WHEN t.m_state = 5
                                            AND t.research_status IN (4, 5) THEN t.id
                                   END) AS researchOver,
                    count(DISTINCT CASE
                                       WHEN t.m_state = 5
                                            AND t.research_status IN (4, 5)
                                            AND t.rec_amount > 0 THEN t.id
                                   END) AS researchOverHaveAmount,
                    sum(CASE
                            WHEN t.m_state = 5
                                 AND t.research_status IN (4, 5)
                                 AND t.rec_amount > 0 THEN rec_amount
                        END)AS totalAmount
   FROM warehouse_atomic_hzx_xy_product_info AS st
   JOIN warehouse_atomic_hzx_bank_product_info p ON st.id = p.t_id
   JOIN warehouse_atomic_hzx_research_task AS t ON t.bank_pro_id = p.id
   JOIN warehouse_atomic_hzx_b_bank_base_info AS b ON b.id = t.bank_id
   WHERE p.id IS NOT NULL
     AND p.bank_id NOT IN(1011607210000337,
                          1011609230000007,
                          1011705260000101,
                          1011806250000203,
                          1011808220000244,
                          1011808270000246)
   GROUP BY b.name,
            CASE
                WHEN p.pro_type =1 THEN '信易贷'
                WHEN p.pro_type =2 THEN '信福时贷'
                WHEN p.pro_type =3 THEN '精细化'
                WHEN p.pro_type =4 THEN '银行产品'
                ELSE '未归类'
            END,
            p.id,
            p.name,
            substr(t.research_over_time,1,10)) AS a
GROUP BY bankName,
         pro_type,
         product_id,
         product_name,
         data_date;         