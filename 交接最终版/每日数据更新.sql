--用户表和用户行为表生成完之后，开始处理
--汇智信汇总数据更新 update 2018-11-07
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
          count(CASE
                    WHEN t.m_state = 5 THEN 1
                END) AS applyOver,
          count(CASE
                    WHEN t.m_state != 5 THEN 1
                END) AS applyNotOver,
          count(CASE
                    WHEN t.m_state = 5
                         AND distribution = 0 THEN 1
                END) AS waitDistribution,
          count(CASE
                    WHEN t.m_state = 5
                         AND distribution = 1 THEN 1
                END) AS distribution,
          0 AS researchOver,
          0 AS researchOverHaveAmount,
          0 AS totalAmount
   FROM warehouse_atomic_hzx_xy_product_info AS st
   LEFT JOIN warehouse_atomic_hzx_bank_product_info p ON st.id = p.t_id
   LEFT JOIN warehouse_atomic_hzx_b_bank_base_info AS b ON b.id = p.bank_id
   LEFT JOIN warehouse_atomic_hzx_research_task AS t ON t.pro_id = p.t_id
   AND t.bank_id = p.bank_id
   WHERE p.enable = 1
     AND p.state = 1
     AND p.id IS NOT NULL
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
                    count(CASE
                              WHEN t.m_state = 5
                                   AND t.research_status IN (4, 5) THEN 1
                          END) AS researchOver,
                    count(CASE
                              WHEN t.m_state = 5
                                   AND t.research_status IN (4, 5)
                                   AND t.rec_amount > 0 THEN 1
                          END) AS researchOverHaveAmount,
                    sum(CASE
                            WHEN t.m_state = 5
                                 AND t.research_status IN (4, 5)
                                 AND t.rec_amount > 0 THEN rec_amount
                        END)AS totalAmount
   FROM warehouse_atomic_hzx_xy_product_info AS st
   LEFT JOIN warehouse_atomic_hzx_bank_product_info p ON st.id = p.t_id
   LEFT JOIN warehouse_atomic_hzx_b_bank_base_info AS b ON b.id = p.bank_id
   LEFT JOIN warehouse_atomic_hzx_research_task AS t ON t.pro_id = p.t_id
   AND t.bank_id = p.bank_id
   WHERE p.enable = 1
     AND p.state = 1
     AND p.id IS NOT NULL
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
         
--渠道基础数据合并 add 2018-11-06
INSERT overwrite TABLE warehouse_data_chan_info
SELECT a.plat_no AS data_source,
       if(length(if(the_2nd_level IS NULL,'',the_2nd_level))>0, the_2nd_level, a.2nd_level) AS the_2nd_level,
       if(length(if(the_3rd_level IS NULL,'',the_3rd_level))>0, the_3rd_level, a.3rd_level) AS the_3rd_level,
       a.chan_no,
       if(length(if(b.chan_no_desc IS NULL,'',b.chan_no_desc))>0, b.chan_no_desc, a.3rd_level) AS chan_no_desc,
       a.4th_level AS child_chan,
        concat(if(length(if(the_2nd_level IS NULL,'',the_2nd_level))>0,the_2nd_level,a.2nd_level), a.4th_level) AS merger_chan
FROM warehouse_atomic_channel_category_info AS a
LEFT JOIN warehouse_data_chan_level_info AS b ON a.plat_no=b.data_source
AND a.chan_no=b.chan_no
AND b.child_chan=a.4th_level
WHERE length(if(a.chan_no IS NULL,'',a.chan_no))>0;
         
--渠道发展用户明细 UPDATE 2018-11-26
INSERT overwrite TABLE warehouse_data_user_channel_info
SELECT b.registe_date,
       b.authentication_date,
       b.data_source,
       CASE
           WHEN b.data_source ='xyqb'
                AND (b.app_version='1.0.0'
                     OR b.app_version>='2.0.0')
                AND b.chan_no='appStore'
                AND b.registe_date>='2018-09-20' THEN '是'
           WHEN b.data_source ='xyqb'
                AND b.app_version>='1.2.0'
                AND b.chan_no!='appStore' THEN '是'
           ELSE '否'
       END is_new_jry,
       c.the_2nd_level,
       c.the_3rd_level,
       c.merger_chan,
       b.chan_no,
       b.chan_no_desc,
       b.child_chan,
       b.isp,
       b.province_desc,
       b.city_desc,
       b.mbl_no,
       current_date()
FROM warehouse_atomic_user_info AS b
LEFT JOIN warehouse_data_chan_info AS c ON b.chan_no=c.chan_no
AND b.child_chan = c.child_chan
AND b.data_source= c.data_source;

--渠道发展用户汇总 2018-10-25
INSERT overwrite TABLE warehouse_data_channel_user_sum
SELECT if(register_date is null,'1970-01-01',register_date),
       if(data_source IS NULL,"空白",data_source) AS data_source,
       if(is_new_jry IS NULL,"否",is_new_jry) AS is_new_jry,
       if(the_2nd_level IS NULL,"空白",the_2nd_level) AS the_2nd_level,
       if(the_3rd_level IS NULL,"空白",the_3rd_level) AS the_3rd_level,
       count(mbl_no) AS num
FROM warehouse_data_user_channel_info AS a
WHERE if(register_date is null,'1970-01-01',register_date) <= date_sub(current_date(),1)
GROUP BY if(register_date is null,'1970-01-01',register_date),
         if(data_source IS NULL,"空白",data_source),
         if(is_new_jry IS NULL,"否",is_new_jry),
         if(the_2nd_level IS NULL,"空白",the_2nd_level),
         if(the_3rd_level IS NULL,"空白",the_3rd_level);

--每日点击数据按mbl_no汇总，加新注册用户标示 update 20181114
INSERT INTO table warehouse_data_user_action_day PARTITION(extractday)
SELECT a.sys_id AS data_source,
       CASE
           WHEN event_id='bxyk' THEN '信用卡'
           WHEN d.product_name_new IS NOT NULL THEN d.product_name_new
           ELSE a.product_name
       END product_name,
       a.mbl_no,
       CASE
           WHEN a.extractday=b.register_date THEN '是'
           ELSE '否'
       END AS is_new,
       count(1) AS allpv,
       count(CASE
                 WHEN page_id='supermarket' THEN 1
             END) AS marketpv,
       count(CASE
                 WHEN page_id='product_detail' THEN 1
             END) AS detailpv,
       count(CASE
                 WHEN event_id='apply' THEN 1
             END) AS applypv,
       count(CASE
                 WHEN page_id='institution_page' THEN 1
             END) AS institupv,
       count(CASE
                 WHEN page_id='supermarket'
                      AND event_id='banner' THEN 1
             END) AS bannerpv,
       a.extractday
FROM warehouse_atomic_user_action AS a
LEFT JOIN warehouse_atomic_user_info AS b ON a.sys_id=b.data_source
AND a.mbl_no=b.mbl_no
LEFT JOIN warehouse_data_product_info_new AS d ON a.sys_id=d.data_source
AND a.product_id=d.product_id
AND a.product_id IS NOT NULL
WHERE a.extractday = date_sub(date(current_date()),1)
GROUP BY a.extractday,
         a.sys_id,
         CASE
             WHEN event_id='bxyk' THEN '信用卡'
             WHEN d.product_name_new IS NOT NULL THEN d.product_name_new
             ELSE a.product_name
         END,
         a.mbl_no,
         CASE
             WHEN a.extractday=b.register_date THEN '是'
             ELSE '否'
         END;

--增加新金融苑埋点数据 add 20181113
INSERT INTO table warehouse_data_user_action_day PARTITION(extractday)
SELECT if(a.platform='jry', 'xyqb', a.platform) AS data_source,
       CASE
           WHEN substr(page_enname,1,6) ='credit' THEN '信用卡'
           WHEN substr(page_enname,1,9) ='insurance' THEN '保险'
           WHEN d.product_name_new IS NOT NULL THEN d.product_name_new
           ELSE a.product_name
       END product_name,
       a.mbl_no,
       CASE
           WHEN a.extractday=b.register_date THEN '是'
           ELSE '否'
       END AS is_new,
       count(1) AS allpv,
       count(CASE
                 WHEN page_enname='supermarket' THEN 1
             END) AS marketpv,
       count(CASE
                 WHEN page_enname='product_detail' THEN 1
             END) AS detailpv,
       count(CASE
                 WHEN button_enname='apply' THEN 1
             END) AS applypv,
       count(CASE
                 WHEN page_enname='product_detail' THEN 1
             END) AS institupv,
       count(CASE
                 WHEN button_enname='banner' THEN 1
             END) AS bannerpv,
       a.extractday
FROM warehouse_newtrace_click_record AS a
LEFT JOIN warehouse_atomic_user_info AS b ON if(a.platform='jry', 'xyqb', a.platform)=b.data_source
AND a.mbl_no=b.mbl_no
LEFT JOIN warehouse_data_product_info_new AS d ON if(a.platform='jry', 'xyqb', a.platform)=d.data_source
AND a.product_id=d.product_id
AND a.product_id IS NOT NULL
WHERE a.extractday = date_sub(date(current_date()),1)
GROUP BY a.extractday,
         if(a.platform='jry', 'xyqb', a.platform),
         CASE
             WHEN substr(page_enname,1,6) ='credit' THEN '信用卡'
             WHEN substr(page_enname,1,9) ='insurance' THEN '保险'
             WHEN d.product_name_new IS NOT NULL THEN d.product_name_new
             ELSE a.product_name
         END,
         a.mbl_no,
         CASE
             WHEN a.extractday=b.register_date THEN '是'
             ELSE '否'
         END;       

--每日邮件分日报盘数据Part01 add 2018-11-20 update 2018-11-21
INSERT into warehouse_data_daliy_report
SELECT data_source,
       action_date,
       count(DISTINCT CASE
                          WHEN action_name='注册' THEN mbl_no
                      END) regnum,
       count(DISTINCT CASE
                          WHEN action_name='实名'
                               AND status_code IN('Y','Z') THEN mbl_no
                      END) chknum,
       count(DISTINCT CASE
                          WHEN action_name='用户测评' THEN mbl_no
                      END) testnum,
       count(DISTINCT CASE
                          WHEN action_name='申请' THEN mbl_no
                      END) applynum,
       0 as regallnum,
       0 as chkallnum               
FROM warehouse_atomic_all_process_info AS a
WHERE action_date = date_sub(date(current_date()),1)
GROUP BY data_source,
         action_date;
         
--每日邮件分日报盘数据Part02   add 2018-11-26
INSERT overwrite table warehouse_data_daliy_report
SELECT data_source,
       action_date,
       regnum,
       chknum,
       testnum,
       applynum,
       sum(regnum) over(partition BY data_source
                        ORDER BY action_date DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS regalldnum,
       sum(chknum) over(partition BY data_source
                        ORDER BY action_date DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS chkalldnum
FROM warehouse_data_daliy_report AS a;


--每日邮件分时报盘数据 add 2018-11-21
INSERT into warehouse_data_hour_report
SELECT data_source,
       concat(action_date,' ',substr(action_time,1,2),':00:00') AS action_datetime,
       count(DISTINCT CASE
                          WHEN action_name='注册' THEN mbl_no
                      END) regnum,
       count(DISTINCT CASE
                          WHEN action_name='实名'
                               AND status_code IN('Y','Z') THEN mbl_no
                      END) chknum,
       count(DISTINCT CASE
                          WHEN action_name='用户测评' THEN mbl_no
                      END) testnum,
       count(DISTINCT CASE
                          WHEN action_name='申请' THEN mbl_no
                      END) applynum
FROM warehouse_atomic_all_process_info AS a
WHERE action_date = date_sub(date(current_date()),1)
GROUP BY data_source,
         concat(action_date,' ',substr(action_time,1,2),':00:00');
                

--用户日活跃数据汇总
INSERT overwrite TABLE warehouse_data_user_action_daysum
SELECT a.extractday,
       a.data_source,
       sum(regallnum) AS regallnum,
       sum(regnum) AS regnum,
       sum(allpv) AS allpv,
       sum(dnum) AS dnum,
       sum(applypv) AS applypv,
       sum(applydnum) AS applydnum,
       sum(newnum)AS newnum,
       sum(newdnum)AS newdnum,
       sum(newapplypv) AS newapplypv,
       sum(newapplydnum) AS newapplydnum,
       sum(marketpv) AS marketpv,
       sum(marketuv) AS marketuv
FROM
  (SELECT a.extractday,
          a.data_source,
          0 AS regallnum,
          0 AS regnum,
          sum(allpv) AS allpv,
          count(DISTINCT mbl_no) AS dnum,
          sum(applypv) AS applypv,
          count(DISTINCT CASE
                             WHEN applypv>0 THEN mbl_no
                         END) AS applydnum,
          sum(CASE
                  WHEN is_new='是' THEN allpv
              END) AS newnum,
          count(DISTINCT CASE
                             WHEN is_new='是' THEN mbl_no
                         END) AS newdnum,
          sum(CASE
                  WHEN is_new='是' THEN applypv
              END) AS newapplypv,
          count(DISTINCT CASE
                             WHEN is_new='是'
                                  AND applypv>0 THEN mbl_no
                         END) AS newapplydnum,
          sum(CASE
                  WHEN marketpv>0 THEN marketpv
              END) AS marketpv,
          count(DISTINCT CASE
                             WHEN marketpv>0 THEN mbl_no
                         END) AS marketuv                         
   FROM warehouse_data_user_action_day AS a
   WHERE extractday <= date_sub(current_date(),1)
   GROUP BY a.extractday,
            a.data_source
   UNION ALL SELECT action_date,
                    data_source,
                    regalldnum,
                    regnum,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0
   FROM warehouse_data_daliy_report AS a
   WHERE action_date <= date_sub(current_date(),1)) AS a
GROUP BY a.extractday,
         a.data_source;
         
--用户月浏览活跃数据汇总
INSERT overwrite TABLE warehouse_data_user_action_monthsum
SELECT concat(substr(a.extractday,1,7),'-01') as extractday,
       a.data_source,
       a.allpv,
       a.dnum,
       a.applypv,
       a.applydnum,
       a.newnum,
       a.newdnum,
       a.newapplypv,
       a.newapplydnum,
       b.regalldnum,
       b.regnum,
       a.marketpv,
       a.marketuv
FROM
  (SELECT substr(a.extractday,1,7) AS extractday,
          a.data_source,
          sum(allpv) AS allpv,
          count(DISTINCT mbl_no) AS dnum,
          sum(applypv) AS applypv,
          count(DISTINCT CASE
                             WHEN applypv>0 THEN mbl_no
                         END) AS applydnum,
          sum(CASE
                  WHEN is_new='是' THEN allpv
              END) AS newnum,
          count(DISTINCT CASE
                             WHEN is_new='是' THEN mbl_no
                         END) AS newdnum,
          sum(CASE
                  WHEN is_new='是' THEN applypv
              END) AS newapplypv,
          count(DISTINCT CASE
                             WHEN is_new='是'
                                  AND applypv>0 THEN mbl_no
                         END) AS newapplydnum,
          sum(CASE
                  WHEN marketpv>0 THEN marketpv
              END) AS marketpv,
          count(DISTINCT CASE
                             WHEN marketpv>0 THEN mbl_no
                         END) AS marketuv
   FROM warehouse_data_user_action_day AS a
   GROUP BY substr(a.extractday,1,7),
            a.data_source) AS a
JOIN
  (SELECT substr(action_date,1,7) AS action_date,
          data_source,
          max(regalldnum) AS regalldnum,
          sum(regnum) AS regnum
   FROM warehouse_data_daliy_report AS a
   GROUP BY substr(action_date,1,7),
            data_source) AS b ON a.data_source=b.data_source
AND substr(a.extractday,1,7)=b.action_date;


--每日点击数据按device_id汇总 add 20181127
INSERT INTO TABLE warehouse_data_device_action_day PARTITION(extractday)
SELECT a.sys_id AS data_source,
       a.device_id,
       NULL AS is_new,
       count(1) AS allpv,
       count(CASE
                 WHEN page_id='supermarket' THEN 1
             END) AS marketpv,
       count(CASE
                 WHEN page_id='product_detail' THEN 1
             END) AS detailpv,
       count(CASE
                 WHEN event_id='apply' THEN 1
             END) AS applypv,
       count(CASE
                 WHEN event_id='apply' THEN product_id
             END) AS applyprod,
       count(CASE
                 WHEN page_id='institution_page' THEN 1
             END) AS institupv,
       count(CASE
                 WHEN page_id='supermarket'
                      AND event_id='banner' THEN 1
             END) AS bannerpv,
       a.extractday
FROM warehouse_atomic_user_action AS a
WHERE a.extractday = date_sub(date(current_date()),1)
GROUP BY a.extractday,
         a.sys_id,
         a.device_id;

--每日点击数据按device_id汇总，增加新金融苑埋点 add 20181127
INSERT INTO table warehouse_data_device_action_day PARTITION(extractday)
SELECT if(a.platform='jry', 'xyqb', a.platform) AS data_source,
       a.device_id,
       NULL AS is_new,
       count(1) AS allpv,
       count(CASE
                 WHEN page_enname='supermarket' THEN 1
             END) AS marketpv,
       count(CASE
                 WHEN page_enname='product_detail' THEN 1
             END) AS detailpv,
       count(CASE
                 WHEN button_enname='apply' THEN 1
             END) AS applypv,
       count(CASE
                 WHEN button_enname='apply' THEN product_id
             END) AS applyprod,             
       count(CASE
                 WHEN page_enname='product_detail' THEN 1
             END) AS institupv,
       count(CASE
                 WHEN button_enname='banner' THEN 1
             END) AS bannerpv,
       a.extractday
FROM warehouse_newtrace_click_record AS a
WHERE a.extractday = date_sub(date(current_date()),1)
GROUP BY a.extractday,
         if(a.platform='jry', 'xyqb', a.platform),
         a.device_id;

--设备日活跃数据  add 20181127
INSERT INTO TABLE warehouse_data_device_action_daysum
SELECT a.extractday,
       a.data_source,
       sum(allpv) AS allpv,
       count(DISTINCT device_id) AS dnum,
       sum(applypv) AS applypv,
       count(DISTINCT CASE
                          WHEN applypv>0 THEN device_id
                      END) AS applydnum,
       avg(CASE
               WHEN applypv>0 THEN applyprod
           END) AS avgapplyprod
FROM warehouse_data_device_action_day AS a
WHERE extractday = date_sub(current_date(),1)
GROUP BY a.extractday,
         a.data_source;          

--设备月活跃数据  add 20181127
INSERT overwrite TABLE warehouse_data_device_action_monthsum
SELECT concat(substr(a.extractday,1,7),'-01') AS extractday,
       a.data_source,
       sum(allpv) AS allpv,
       count(DISTINCT device_id) AS dnum,
       sum(applypv) AS applypv,
       count(DISTINCT CASE
                          WHEN applypv>0 THEN device_id
                      END) AS applydnum,
       avg(CASE
               WHEN applypv>0 THEN applyprod
           END) AS avgapplyprod
FROM warehouse_data_device_action_day AS a
WHERE extractday <= date_sub(current_date(),1)
GROUP BY concat(substr(a.extractday,1,7),'-01'),
         a.data_source;  
                 
--***************************************************************************************************************************************************
--T+1数据完成后，开始处理
--申请及授信数据更新 update 2018-11-08
INSERT overwrite TABLE warehouse_data_user_review_info
SELECT mbl_no,
       data_source,
       apply_time,
       credit_time,
       product_name,
       status,
       cast(amount AS decimal(12,2)) AS amount,
       current_date() AS etlday
FROM
  (SELECT mbl_no,
          if(data_source IS NULL,"sjd",data_source) AS data_source,
          concat(substr(appl_time,1,4),'-',substr(appl_time,5,2),'-',substr(appl_time,7,2)) AS apply_time,
          concat(substr(credit_time,1,4),'-',substr(credit_time,5,2),'-',substr(credit_time,7,2)) AS credit_time,
          '随借随还-钱包易贷' product_name,
                      CASE
                          WHEN status IN('apply_success',
                                         'freeze') THEN '通过'
                          ELSE '未通过'
                      END status,
                      cast(acc_lim AS decimal(12,2))/100 AS amount
   FROM default.warehouse_atomic_qianbao_review_result_info
   UNION ALL SELECT mbl_no,
                    data_source,
                    apply_time,
                    approve_time,
                    product_name,
                    status,
                    amount
   FROM
     (SELECT DISTINCT order_no,
                      mbl_no,
                      if(data_source IS NULL,"sjd",data_source) AS data_source,
                      apply_time,
                      approve_time,
                      '现金分期-中邮' product_name,
                                CASE
                                    WHEN approve_status='审批通过' THEN '通过'
                                    ELSE '未通过'
                                END status,
                                cast(approve_amount AS decimal(12,2))/100 AS amount
      FROM default.warehouse_atomic_zhongyou_review_result_info
      WHERE not(apply_time BETWEEN '2018-06-28' AND '2018-07-28'
                AND data_source IS NULL)) AS a
   UNION ALL SELECT mbl_no,
                    data_source,
                    lending_time,
                    lending_time AS credit_time,
                    '现金分期-小雨点' product_name,
                               CASE
                                   WHEN status='success' THEN '通过'
                                   ELSE '未通过'
                               END status,
                               cast(applyamount AS decimal(12,2)) AS amount
   FROM default.warehouse_atomic_xiaoyudian_withdrawals_result_info
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(apply_time,1,10) AS apply_time,
                    substr(loan_time,1,10) AS loan_time,
                    '现金分期-拉卡拉' product_name,
                               CASE
                                   WHEN contract_status='申请成功' THEN '通过'
                                   ELSE '未通过'
                               END status,
                               cast(loan_amount AS decimal(12,2)) AS amount
   FROM default.warehouse_atomic_lkl_withdrawals_result_info
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(appl_time,1,10) AS apply_time,
                    substr(credit_time,1,10) AS credit_time,
                    '随借随还-马上' product_name,
                              CASE
                                  WHEN appral_res='通过' THEN '通过'
                                  ELSE '未通过'
                              END status,
                              cast(acc_lim AS decimal(12,2))/100 AS amount
   FROM default.warehouse_atomic_msd_review_result_info
   UNION ALL SELECT mbl_no,
                    data_source,
                    apply_time,
                    substr(approval_time,1,10) AS approval_time,
                    '现金分期-马上' product_name,
                              CASE
                                  WHEN approval_status IN('A',
                                                          'N') THEN '通过'
                                  ELSE '未通过'
                              END status,
                              cast(approval_amount AS decimal(12,2))/100 AS amount
   FROM default.warehouse_atomic_msd_cashord_result_info
   UNION ALL SELECT DISTINCT mbl_no,
                             data_source,
                             apply_time,
                             apply_time AS approval_time,
                             '现金分期-点点' product_name,
                                       CASE
                                           WHEN status_code='0' THEN '通过'
                                           ELSE '未通过'
                                       END status,
                                       cast(total_limit AS decimal(12,2)) AS amount
   FROM default.warehouse_atomic_diandian_review_result_info
   UNION ALL SELECT mbl_no,
                    data_source,
                    concat(substr(apply_time,1,4),'-',substr(apply_time,5,2),'-',substr(apply_time,7,2)) AS apply_time,
                    concat(substr(apply_time,1,4),'-',substr(apply_time,5,2),'-',substr(apply_time,7,2)) AS creadit_time,
                    CASE
                        WHEN product_code='XJXE001' THEN '好期贷-招联'
                        WHEN product_code='XJBL001' THEN '白领贷-招联'
                        WHEN product_code='XJDQD01' THEN '大期贷-招联'
                        WHEN product_code='XJYZ001' THEN '业主贷-招联'
                        WHEN product_code='XJGJJ01' THEN '公积金社保贷-招联'
                    END product_name,
                    CASE
                        WHEN result_desc='申请成功' THEN '通过'
                        ELSE '未通过'
                    END status,
                    cast(credit_limit AS decimal(12,2)) AS amount
   FROM default.warehouse_atomic_zhaolian_review_result_info
   WHERE apply_status_desc != '未提交申请'
   UNION ALL SELECT b.mbl_no,
                    a.data_source,
                    substr(a.limit_apply_time,1,10) AS apply_time,
                    substr(a.limit_apply_time,1,10) AS creadit_time,
                    '随借随还-众安' product_name,
                              CASE
                                  WHEN limit_apply_status='pass' THEN '通过'
                                  ELSE '未通过'
                              END status,
                              cast(credit_amount AS decimal(12,2)) AS amount
   FROM default.warehouse_atomic_zhongan_review_result_info AS a
   JOIN default.warehouse_atomic_user_info AS b ON a.data_source=b.data_source
   AND a.apply_mobile=b.mbl_no_md5
	 UNION ALL SELECT mbl_no,
		       data_source,
		       substr(approvetime,1,10) AS apply_time,
		       substr(approvetime,1,10) AS credit_time,
		       '现金分期-兴业消费' product_name,
		                 CASE
		                     WHEN resultcode='SUCCESS' THEN '通过'
		                     ELSE '未通过'
		                 END status,
		                 cast(fixedlimit AS decimal(12,2))/100 AS amount
		FROM default.warehouse_atomic_xsyd_review_result_info
		UNION ALL
		SELECT mbl_no,
		       data_source,
		       substr(finish_time,1,10) AS apply_time,
		       substr(finish_time,1,10) AS credit_time,
		       '现金分期-万达普惠' product_name,
		                 '通过' AS status,
		                 if(loan_amt>0,loan_amt,0) AS amount
		FROM default.warehouse_atomic_wanda_loan_info) AS a;

--更新申请授信汇总数据 update 2018-11-15
INSERT overwrite TABLE warehouse_data_user_review_withdrawals_sum
SELECT '申请' AS data_type,
       apply_time,
       data_source,
       product_name,
       count(1) AS num,
       count(DISTINCT mbl_no) AS dnum,
       sum(amount) AS amount
FROM warehouse_data_user_review_info AS a
GROUP BY apply_time,
         data_source,
         product_name
UNION ALL
SELECT '授信' AS data_type,
       credit_time,
       data_source,
       product_name,
       count(1) AS num,
       count(DISTINCT mbl_no) AS dnum,
       sum(amount) AS amount
FROM warehouse_data_user_review_info AS a
WHERE status='通过'
GROUP BY credit_time,
         data_source,
         product_name;
         
--五款重要产品授信及有效期数据 update 2018-11-08
INSERT overwrite TABLE warehouse_data_credit_start_to_end
SELECT DISTINCT *
FROM
  (SELECT data_source,
          mbl_no,
          appl_time,
          concat(substr(b.credit_time,1,4),'-',substr(b.credit_time,5,2),'-',substr(b.credit_time,7,2)) AS credit_time,
          '移动白条-钱包易贷' AS product_name,
          cast(date_add(concat(substr(b.credit_time,1,4),'-',substr(b.credit_time,5,2),'-',substr(b.credit_time,7,2)),1) AS string) AS credit_date,
          add_months(concat(substr(b.credit_time,1,4),'-',substr(b.credit_time,5,2),'-',substr(b.credit_time,7,2)),12) AS credit_end_date
   FROM default.warehouse_atomic_qianbao_review_result_info AS b
   WHERE status IN('apply_success',
                   'freeze')
   UNION ALL SELECT data_source,
                    mbl_no,
                    appl_time,
                    substr(credit_time,1,10) AS credit_time,
                    '随借随还-马上' AS product_name,
                    cast(date_add(substr(b.credit_time,1,10),1) AS string) AS credit_date,
                    add_months(substr(b.credit_time,1,10),12) AS credit_end_date
   FROM default.warehouse_atomic_msd_withdrawals_result_info AS b
   UNION ALL SELECT data_source,
                    mbl_no,
                    apply_time,
                    approve_time AS credit_time,
                    '现金分期-中邮' AS product_name,
                    cast(date_add(b.approve_time,1) AS string) AS credit_date,
                    CASE
                        WHEN loan_period='3' THEN add_months(b.approve_time,3)
                        WHEN loan_period='6' THEN add_months(b.approve_time,6)
                        WHEN loan_period='9' THEN add_months(b.approve_time,9)
                        WHEN loan_period='12' THEN add_months(b.approve_time,12)
                        WHEN loan_period='18' THEN add_months(b.approve_time,18)
                        WHEN loan_period='24' THEN add_months(b.approve_time,24)
                    END AS credit_end_date
   FROM default.warehouse_atomic_zhongyou_review_result_info AS b
   WHERE approve_status='审批通过'
   UNION ALL SELECT data_source,
                    mbl_no,
                    apply_time,
                    substr(approval_time,1,10) AS credit_time,
                    '现金分期-马上' AS product_name,
                    cast(date_add(substr(b.approval_time,1,10),1) AS string) AS credit_date,
                    CASE
                        WHEN approval_period='3' THEN add_months(substr(b.approval_time,1,10),3)
                        WHEN approval_period='6' THEN add_months(substr(b.approval_time,1,10),6)
                        WHEN approval_period='9' THEN add_months(substr(b.approval_time,1,10),9)
                        WHEN approval_period='12' THEN add_months(substr(b.approval_time,1,10),12)
                        WHEN approval_period='18' THEN add_months(substr(b.approval_time,1,10),18)
                        WHEN approval_period='24' THEN add_months(substr(b.approval_time,1,10),24)
                    END AS credit_end_date
   FROM default.warehouse_atomic_msd_cashord_result_info AS b
   WHERE approval_status IN('N',
                            'A')
   UNION ALL SELECT a.data_source,
                    a.mbl_no,
                    a.apply_time,
                    a.creadit_time AS credit_time,
                    '现金分期-点点' AS product_name,
                    cast(date_add(substr(a.creadit_time,1,10),1) AS string) AS credit_date,
                    CASE
                        WHEN b.term='3' THEN add_months(substr(a.creadit_time,1,10),3)
                        WHEN b.term='6' THEN add_months(substr(a.creadit_time,1,10),6)
                        WHEN b.term='9' THEN add_months(substr(a.creadit_time,1,10),9)
                        WHEN b.term='12' THEN add_months(substr(a.creadit_time,1,10),12)
                        WHEN b.term='18' THEN add_months(substr(a.creadit_time,1,10),18)
                        WHEN b.term='24' THEN add_months(substr(a.creadit_time,1,10),24)
                    END AS credit_end_date
   FROM default.warehouse_atomic_diandian_review_result_info AS a
   JOIN warehouse_atomic_diandian_withdrawals_result_info AS b ON a.ssjLoanNo=b.ssjLoanNo
   WHERE a.message = '成功'
   UNION ALL  SELECT data_source,
            mbl_no,
            substr(finish_time,1,10) AS apply_time,
            substr(finish_time,1,10) AS credit_time,
            '现金分期-万达普惠' AS product_name,
            cast(date_add(substr(finish_time,1,10),1) AS string) AS credit_date,
            CASE
                WHEN repay_num='3' THEN add_months(substr(finish_time,1,10),3)
                WHEN repay_num='6' THEN add_months(substr(finish_time,1,10),6)
                WHEN repay_num='9' THEN add_months(substr(finish_time,1,10),9)
                WHEN repay_num='12' THEN add_months(substr(finish_time,1,10),12)
                WHEN repay_num='18' THEN add_months(substr(finish_time,1,10),18)
                WHEN repay_num='24' THEN add_months(substr(finish_time,1,10),24)
                ELSE add_months(substr(finish_time,1,10),1)
            END AS credit_end_date
     FROM default.warehouse_atomic_wanda_loan_info AS b
   UNION ALL SELECT data_source,
                    mbl_no,
                    substr(approvetime,1,10) AS apply_time,
                    substr(approvetime,1,10) AS credit_time,
                    '现金分期-兴业消费' AS product_name,
                    cast(date_add(substr(approvetime,1,10),1) AS string) AS credit_date,
                    substr(expiredate,1,10) AS expiredate
   FROM default.warehouse_atomic_xsyd_review_result_info AS b
   WHERE resultcode='SUCCESS') AS a
WHERE date(credit_time) <= date(current_date());

--接点击数据增加is_credit新老用户标记 update 20181114
INSERT INTO warehouse_data_user_action_sum PARTITION(extractday)
SELECT a.data_source,
       a.product_name,
       a.mbl_no,
       a.is_new,
       if(b.is_credit=1,"是","否") AS is_credit,
       a.allpv,
       a.marketpv,
       a.detailpv,
       a.applypv,
       a.institupv,
       a.bannerpv,
       if(a.applypv>0,"是","否") AS is_apply,
       a.extractday
FROM warehouse_data_user_action_day AS a
LEFT JOIN
  (SELECT a.mbl_no,
          a.data_source,
          a.product_name,
          a.extractday,
          max(CASE
                  WHEN a.extractday BETWEEN c.credit_date AND c.credit_end_date THEN '1'
                  ELSE '0'
              END) AS is_credit
   FROM warehouse_data_user_action_day AS a
   JOIN warehouse_data_credit_start_to_end AS c ON a.mbl_no=c.mbl_no
   AND a.product_name=c.product_name
   GROUP BY a.mbl_no,
            a.data_source,
            a.product_name,
            extractday) AS b ON a.mbl_no=b.mbl_no
AND a.data_source=b.data_source
AND a.product_name=b.product_name
AND a.extractday=b.extractday
WHERE a.extractday = date_sub(date(current_date()),1);

--推送数据汇总结果表
INSERT INTO warehouse_data_user_action_end
SELECT a.extractday,
       a.data_source,
       a.product_name,
       sum(applypv) AS num,
       count(DISTINCT mbl_no) AS dnum,
       sum(CASE
               WHEN is_new='是' THEN applypv
           END) AS newnum,
       count(DISTINCT CASE
                          WHEN is_new='是' THEN mbl_no
                      END) AS newdnum,
       sum(CASE
               WHEN is_credit='否' THEN applypv
           END) AS creditnum,
       count(DISTINCT CASE
                          WHEN is_credit='否' THEN mbl_no
                      END) AS creditdnum
FROM warehouse_data_user_action_sum AS a
WHERE applypv>0
  AND extractday = date_sub(current_date(),1)
GROUP BY a.extractday,
         a.data_source,
         a.product_name;

--放款数据更新update 2018-11-08
INSERT overwrite TABLE warehouse_data_withdrawals_info
SELECT mbl_no,
       data_source,
       cash_time,
       cash_amount,
       product_name,
       current_date() AS etlday
FROM
  (SELECT mbl_no,
          if(length(data_source)>0,data_source,'sjd') AS data_source,
          cash_time,
          cast(cash_amount AS decimal(12,2))/100 AS cash_amount,
          '随借随还-钱包易贷' AS product_name
   FROM default.warehouse_atomic_qianbao_withdrawals_result_info AS b
   WHERE status NOT IN('cancelled',
                       'pay_failed')
   UNION ALL SELECT mbl_no,
                    data_source,
                    msd_return_time,
                    cast(total_amount AS decimal(12,2))/100 AS cash_amount,
                    '随借随还-马上' AS product_name
   FROM default.warehouse_atomic_msd_withdrawals_result_info
   WHERE total_amount>0
     AND msd_return_time IS NOT NULL
   UNION ALL SELECT mbl_no,
                    if(length(data_source)>0,data_source,'sjd') AS data_source,
                    loan_time,
                    cast(loan_amount AS decimal(12,2)) AS cash_amount,
                    '现金分期-中邮' AS product_name
   FROM default.warehouse_atomic_zhongyou_withdrawals_result_info
   WHERE loan_state='MAKELOAN_SUCCESS'
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(approval_time,1,10) AS lending_time,
                    cast(approval_amount AS decimal(12,2))/100 AS cash_amount,
                    '现金分期-马上' as product_name
   FROM default.warehouse_atomic_msd_cashord_result_info
   WHERE approval_status IN('N')
   UNION ALL SELECT mbl_no,
                    data_source,
                    lending_time,
                    cast(applyamount AS decimal(12,2)) AS applyamount,
                    '现金分期-小雨点' AS product_name
   FROM default.warehouse_atomic_xiaoyudian_withdrawals_result_info
   WHERE status='success'
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(loan_time,1,10) AS loan_time,
                    cast(loan_amount AS decimal(12,2)) AS loan_amount,
                    '现金分期-拉卡拉' product_name
   FROM default.warehouse_atomic_lkl_withdrawals_result_info
   WHERE contract_status='申请成功'
   UNION ALL SELECT mbl_no,
                    data_source,
                    lending_time,
                    cast(loan_amount AS decimal(12,2))/100 AS loan_amount,
                    '现金分期-点点' product_name
   FROM default.warehouse_atomic_diandian_withdrawals_result_info
   UNION ALL SELECT mbl_no,
                    data_source,
                    concat(substr(loan_date,1,4),'-',substr(loan_date,5,2),'-',substr(loan_date,7,2)) AS loan_date,
                    cast(install_total_amt AS decimal(12,2))/100 AS loan_amount,
                    CASE
                        WHEN product_no IN('P0000073',
                                           'P0000072',
                                           'P0000067',
                                           'P0000066',
                                           'P0000060',
                                           'P0000069',
                                           'P0000088',
                                           'XJBL001') THEN '白领贷-招联'
                        WHEN product_no IN('P0000222',
                                           'XJYZ001') THEN '业主贷-招联'
                        WHEN product_no IN('XJDQD01') THEN '大期贷-招联'
                        WHEN product_no IN('P0048796') THEN '公积金社保贷-招联'
                        WHEN product_no IN('P0000132') THEN '好期贷-招联'
                        ELSE '好期贷-招联'
                    END product_name
   FROM default.warehouse_atomic_zhaolian_withdrawals_result_info
   WHERE order_status_desc!='已结清'
   UNION ALL SELECT b.mbl_no,
                    a.data_source,
                    substr(a.loan_out_time,1,10) AS loan_time,
                    cast(loan_amount AS decimal(12,2)) AS loan_amount,
                    '随借随还-众安' AS product_name
   FROM default.warehouse_atomic_zhongan_withdrawals_result_info AS a
   JOIN default.warehouse_atomic_user_info AS b ON a.data_source=b.data_source
   AND a.apply_mobile=b.mbl_no_md5
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(paymentdate,1,10) AS paymentdate,
                    cast(loanamt AS decimal(12,2))/100 AS amount,
                    '现金分期-兴业消费' product_name
   FROM default.warehouse_atomic_xsyd_withdrawals_result_info
   WHERE paymentstatus='SUCCESS'
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(loan_date,1,10) AS loan_date,
                    if(loan_amt>0,loan_amt,0) AS amount,
                    '现金分期-万达普惠' product_name
   FROM default.warehouse_atomic_wanda_loan_info AS a
   WHERE loan_amt>0) AS a;

--放款数据汇总更新
INSERT INTO warehouse_data_user_review_withdrawals_sum
SELECT '放款' AS data_type,
       cash_time,
       data_source,
       product_name,
       count(1) AS num,
       count(DISTINCT mbl_no) AS dnum,
       sum(cash_amount) AS cash_amount
FROM warehouse_data_withdrawals_info AS a
GROUP BY cash_time,
         data_source,
         product_name;
         

--申请数据汇总更新
INSERT overwrite TABLE warehouse_data_user_review_sum
SELECT a.data_source,
       a.apply_time,
       if(a.product_name is null,'空白',a.product_name) as product_name,
       b.is_new_jry,
       if(b.the_2nd_level is null,'空白',b.the_2nd_level) as the_2nd_level,
       if(b.the_3rd_level is null,'空白',b.the_3rd_level) as the_3rd_level,
       count(1) AS applyup_num,
       count(DISTINCT a.mbl_no) AS applyup_dnum,
       0 AS applyup_amount
FROM warehouse_data_user_review_info AS a
JOIN warehouse_data_user_channel_info AS b ON a.data_source=b.data_source
AND a.mbl_no=b.mbl_no
GROUP BY a.data_source,
         a.apply_time,
         if(a.product_name is null,'空白',a.product_name),
         b.is_new_jry,
         if(b.the_2nd_level is null,'空白',b.the_2nd_level),
         if(b.the_3rd_level is null,'空白',b.the_3rd_level);

--授信数据汇总更新                           
INSERT overwrite TABLE warehouse_data_user_review_sccsum                                             
SELECT a.data_source,
       a.credit_time,
       if(a.product_name is null,'空白',a.product_name) as product_name,
       b.is_new_jry,
       if(b.the_2nd_level is null,'空白',b.the_2nd_level) as the_2nd_level,
       if(b.the_3rd_level is null,'空白',b.the_3rd_level) as the_3rd_level,
       count(1) AS applyup_num,
       count(DISTINCT a.mbl_no) AS applyup_dnum,
       sum(if(amount is null,0,amount)) AS applyup_amount
FROM warehouse_data_user_review_info AS a
JOIN warehouse_data_user_channel_info AS b ON a.data_source=b.data_source
AND a.mbl_no=b.mbl_no
WHERE a.status='通过'
  AND a.credit_time IS NOT NULL
GROUP BY a.data_source,
         a.credit_time,
         if(a.product_name is null,'空白',a.product_name),
         b.is_new_jry,
         if(b.the_2nd_level is null,'空白',b.the_2nd_level),
         if(b.the_3rd_level is null,'空白',b.the_3rd_level);

--放款数据汇总更新                                              
INSERT overwrite TABLE warehouse_data_user_withdrawals_sccsum
SELECT a.data_source,
       a.cash_time,
       if(a.product_name is null,'空白',a.product_name) as product_name,
       b.is_new_jry,
       if(b.the_2nd_level is null,'空白',b.the_2nd_level) as the_2nd_level,
       if(b.the_3rd_level is null,'空白',b.the_3rd_level) as the_3rd_level,
       count(1) AS applyup_num,
       count(DISTINCT a.mbl_no) AS applyup_dnum,
       sum(if(cash_amount is null,0,cash_amount)) AS applyup_amount
FROM warehouse_data_withdrawals_info AS a
JOIN warehouse_data_user_channel_info AS b ON a.data_source=b.data_source
AND a.mbl_no=b.mbl_no
GROUP BY a.data_source,
         a.cash_time,
         if(a.product_name is null,'空白',a.product_name),
         b.is_new_jry,
         if(b.the_2nd_level is null,'空白',b.the_2nd_level),
         if(b.the_3rd_level is null,'空白',b.the_3rd_level);

--平台累计数据 add 2018-10-25 update 2018-11-07 &&&&
INSERT overwrite TABLE warehouse_data_user_datasum
SELECT data_source,
       sum(CASE
               WHEN TYPE='注册' THEN dnum
           END) AS regdnum,
       sum(CASE
               WHEN TYPE='申请' THEN num
           END) AS applynum,
       sum(CASE
               WHEN TYPE='申请' THEN dnum
           END) AS applydnum,
       sum(CASE
               WHEN TYPE='授信' THEN num
           END) AS creditnum,
       sum(CASE
               WHEN TYPE='授信' THEN dnum
           END) AS creditdnum,
       sum(CASE
               WHEN TYPE='授信' THEN amount
           END) AS creditamount,
       sum(CASE
               WHEN TYPE='放款' THEN num
           END) AS cashnum,
       sum(CASE
               WHEN TYPE='放款' THEN dnum
           END) AS cashdnum,
       sum(CASE
               WHEN TYPE='放款' THEN amount
           END) AS cashamount
FROM
  (SELECT '注册' AS TYPE,
          data_source,
          sum(num) AS num,
          sum(num) AS dnum,
          0 AS amount
   FROM warehouse_data_channel_user_sum
   WHERE register_date<=date_sub(current_date(),1)
   GROUP BY data_source
   UNION ALL SELECT '申请' AS TYPE,
                    a.data_source,
                    count(1) AS applyup_num,
                    count(DISTINCT a.mbl_no) AS applyup_dnum,
                    0 AS applyup_amount
   FROM warehouse_data_user_review_info AS a
   WHERE apply_time<=date_sub(current_date(),1)
   GROUP BY a.data_source
   UNION ALL SELECT '授信' AS TYPE,
                    a.data_source,
                    count(1) AS applyup_num,
                    count(DISTINCT a.mbl_no) AS applyup_dnum,
                    sum(if(amount IS NULL,0,amount)) AS applyup_amount
   FROM warehouse_data_user_review_info AS a
   WHERE a.status='通过'
     AND if(credit_time IS NULL,'1970-01-01',credit_time)<=date_sub(current_date(),1)
   GROUP BY a.data_source
   UNION ALL SELECT '放款' AS TYPE,
                    a.data_source,
                    count(1) AS applyup_num,
                    count(DISTINCT a.mbl_no) AS applyup_dnum,
                    sum(if(cash_amount IS NULL,0,cash_amount)) AS applyup_amount
   FROM warehouse_data_withdrawals_info AS a
   WHERE cash_time<=date_sub(current_date(),1)
   GROUP BY a.data_source) AS a
GROUP BY data_source;


--每日用户数据 add 2018-10-25 update 2018-11-26
INSERT overwrite TABLE warehouse_data_user_daliy
SELECT data_source,
       data_date,
       sum(CASE
               WHEN TYPE='注册' THEN dnum
           END) AS regdnum,
       sum(CASE
               WHEN TYPE='实名' THEN dnum
           END) AS chkdnum,
       sum(CASE
               WHEN TYPE='申请' THEN num
           END) AS applynum,
       sum(CASE
               WHEN TYPE='申请' THEN dnum
           END) AS applydnum,
       sum(CASE
               WHEN TYPE='授信' THEN num
           END) AS creditnum,
       sum(CASE
               WHEN TYPE='授信' THEN dnum
           END) AS creditdnum,
       sum(CASE
               WHEN TYPE='授信' THEN amount
           END) AS creditamount,
       sum(CASE
               WHEN TYPE='放款' THEN num
           END) AS cashnum,
       sum(CASE
               WHEN TYPE='放款' THEN dnum
           END) AS cashdnum,
       sum(CASE
               WHEN TYPE='放款' THEN amount
           END) AS cashamount
FROM
  (SELECT '注册' AS TYPE,
          if(a.data_source ='jry','xyqb',if(data_source is NULL,'sjd',a.data_source)) as data_source,
          register_date AS data_date,
          sum(num) as num,
          sum(num) AS dnum,
          0 AS amount
   FROM warehouse_data_channel_user_sum as a
   GROUP BY if(a.data_source ='jry','xyqb',if(data_source is NULL,'sjd',a.data_source)),
          register_date
   union all SELECT '实名' AS TYPE,
          if(a.data_source ='jry','xyqb',if(data_source is NULL,'sjd',a.data_source)) as data_source,
          chk_date AS data_date,
          count(distinct mbl_no) as num,
          count(distinct mbl_no) AS dnum,
          0 AS amount
   FROM warehouse_data_user_channel_info as a
   GROUP BY if(a.data_source ='jry','xyqb',if(data_source is NULL,'sjd',a.data_source)),
          chk_date
   UNION ALL SELECT '申请' AS TYPE,
                    if(a.data_source ='jry','xyqb',if(data_source is NULL,'sjd',a.data_source)) as data_source,
                    a.apply_time,
                    count(1) AS applyup_num,
                    count(DISTINCT a.mbl_no) AS applyup_dnum,
                    0 AS applyup_amount
   FROM warehouse_data_user_review_info AS a
   GROUP BY if(a.data_source ='jry','xyqb',if(data_source is NULL,'sjd',a.data_source)),
            a.apply_time
   UNION ALL SELECT '授信' AS TYPE,
                    if(a.data_source ='jry','xyqb',if(data_source is NULL,'sjd',a.data_source)) as data_source,
                    a.credit_time,
                    count(1) AS applyup_num,
                    count(DISTINCT a.mbl_no) AS applyup_dnum,
                    sum(if(amount IS NULL,0,amount)) AS applyup_amount
   FROM warehouse_data_user_review_info AS a
   WHERE a.status='通过'
     AND a.credit_time IS NOT NULL
   GROUP BY if(a.data_source ='jry','xyqb',if(data_source is NULL,'sjd',a.data_source)),
            a.credit_time
   UNION ALL SELECT '放款' AS TYPE,
                    if(a.data_source ='jry','xyqb',if(data_source is NULL,'sjd',a.data_source)) as data_source,
                    a.cash_time,
                    count(1) AS applyup_num,
                    count(DISTINCT a.mbl_no) AS applyup_dnum,
                    sum(if(cash_amount IS NULL,0,cash_amount)) AS applyup_amount
   FROM warehouse_data_withdrawals_info AS a
   GROUP BY if(a.data_source ='jry','xyqb',if(data_source is NULL,'sjd',a.data_source)),
            a.cash_time
) AS a
WHERE data_date<=date_sub(current_date(),1)
GROUP BY data_source,
         data_date;         

--每月用户数据 add 2018-11-07
INSERT overwrite TABLE warehouse_data_user_months
SELECT data_source,
       concat(substr(data_date,1,7),'-01') as data_month,
       sum(CASE
               WHEN TYPE='注册' THEN dnum
           END) AS regdnum,
       sum(CASE
               WHEN TYPE='实名' THEN dnum
           END) AS chkdnum,
       sum(CASE
               WHEN TYPE='申请' THEN num
           END) AS applynum,
       sum(CASE
               WHEN TYPE='申请' THEN dnum
           END) AS applydnum,
       sum(CASE
               WHEN TYPE='授信' THEN num
           END) AS creditnum,
       sum(CASE
               WHEN TYPE='授信' THEN dnum
           END) AS creditdnum,
       sum(CASE
               WHEN TYPE='授信' THEN amount
           END) AS creditamount,
       sum(CASE
               WHEN TYPE='放款' THEN num
           END) AS cashnum,
       sum(CASE
               WHEN TYPE='放款' THEN dnum
           END) AS cashdnum,
       sum(CASE
               WHEN TYPE='放款' THEN amount
           END) AS cashamount
FROM
  (SELECT '注册' AS TYPE,
          data_source,
          substr(register_date,1,7) AS data_date,
          sum(num) as num,
          sum(num) AS dnum,
          0 AS amount
   FROM warehouse_data_channel_user_sum
   GROUP BY data_source,
          substr(register_date,1,7)
   union all SELECT '实名' AS TYPE,
          data_source,
          substr(chk_date,1,7) AS data_date,
          count(distinct mbl_no) as num,
          count(distinct mbl_no) AS dnum,
          0 AS amount
   FROM warehouse_data_user_channel_info
   WHERE chk_date<=date_sub(current_date(),1)
   GROUP BY data_source,
          substr(chk_date,1,7)
   UNION ALL SELECT '申请' AS TYPE,
                    a.data_source,
                    substr(a.apply_time,1,7),
                    count(1) AS applyup_num,
                    count(DISTINCT a.mbl_no) AS applyup_dnum,
                    0 AS applyup_amount
   FROM warehouse_data_user_review_info AS a
   GROUP BY a.data_source,
            substr(a.apply_time,1,7)
   UNION ALL SELECT '授信' AS TYPE,
                    a.data_source,
                    substr(a.credit_time,1,7),
                    count(1) AS applyup_num,
                    count(DISTINCT a.mbl_no) AS applyup_dnum,
                    sum(if(amount IS NULL,0,amount)) AS applyup_amount
   FROM warehouse_data_user_review_info AS a
   WHERE a.status='通过'
     AND a.credit_time IS NOT NULL
   GROUP BY a.data_source,
            substr(a.credit_time,1,7)
   UNION ALL SELECT '放款' AS TYPE,
                    a.data_source,
                    substr(a.cash_time,1,7),
                    count(1) AS applyup_num,
                    count(DISTINCT a.mbl_no) AS applyup_dnum,
                    sum(if(cash_amount IS NULL,0,cash_amount)) AS applyup_amount
   FROM warehouse_data_withdrawals_info AS a
   GROUP BY a.data_source,
            substr(a.cash_time,1,7)
) AS a
GROUP BY data_source,
         concat(substr(data_date,1,7),'-01');

--产品全流程数据表    2018-10-23      
INSERT overwrite TABLE warehouse_data_user_action_and_product_end
SELECT a.extractday,
       a.data_source,
       c.mblnum,
       a.product_name,
       a.num,
       a.dnum,
       a.applynum,
       a.applydnum,
       a.creditnum,
       a.creditdnum,
       a.creditamount,
       a.cashnum,
       a.cashdnum,
       a.cashamount
FROM
  (SELECT if(a.extractday IS NULL,b.data_date,a.extractday) AS extractday,
          if(a.data_source IS NULL,b.data_source,a.data_source) AS data_source,
          if(a.product_name IS NULL,b.product_name,a.product_name) AS product_name,
          a.num,
          a.dnum,
          b.applynum,
          b.applydnum,
          b.creditnum,
          b.creditdnum,
          b.creditamount,
          b.cashnum,
          b.cashdnum,
          b.cashamount
   FROM warehouse_data_user_action_end AS a
   FULL OUTER JOIN
     (SELECT if(length(data_date)=10,data_date,'1700-01-01') AS data_date,
             data_source,
             product_name,
             sum(if(data_type='申请',num,0)) AS applynum,
             sum(if(data_type='申请',dnum,0)) AS applydnum,
             sum(if(data_type='授信',num,0)) AS creditnum,
             sum(if(data_type='授信',dnum,0)) AS creditdnum,
             sum(if(data_type='授信',amount,0)) AS creditamount,
             sum(if(data_type='放款',num,0)) AS cashnum,
             sum(if(data_type='放款',dnum,0)) AS cashdnum,
             sum(if(data_type='放款',amount,0)) AS cashamount
      FROM warehouse_data_user_review_withdrawals_sum AS a
      GROUP BY if(length(data_date)=10,data_date,'1700-01-01'),
               data_source,
               product_name) AS b ON a.extractday=b.data_date
   AND a.data_source=b.data_source
   AND a.product_name=b.product_name
   WHERE if(a.data_source IS NULL,b.data_source,a.data_source) != 'h5') AS a
LEFT JOIN
  (SELECT if(length(register_date)=10,register_date,'1700-01-01') AS data_date,
          data_source,
          count(mbl_no) AS mblnum
   FROM warehouse_data_user_channel_info AS a
   GROUP BY if(length(register_date)=10,register_date,'1700-01-01'),
            data_source) AS c ON a.extractday=c.data_date
AND a.data_source=c.data_source;


--渠道全流程数据
INSERT overwrite TABLE warehouse_data_user_action_and_channel_end
SELECT data_source,
       data_date,
       is_new_jry,
       the_2nd_level,
       the_3rd_level,
       sum(CASE
               WHEN TYPE='注册' THEN dnum
           END) AS regdnum,
       sum(CASE
               WHEN TYPE='实名' THEN dnum
           END) AS chkdnum,
       sum(CASE
               WHEN TYPE='申请' THEN num
           END) AS applynum,
       sum(CASE
               WHEN TYPE='申请' THEN dnum
           END) AS applydnum,
       sum(CASE
               WHEN TYPE='授信' THEN num
           END) AS creditnum,
       sum(CASE
               WHEN TYPE='授信' THEN dnum
           END) AS creditdnum,
       sum(CASE
               WHEN TYPE='授信' THEN amount
           END) AS creditamount,
       sum(CASE
               WHEN TYPE='放款' THEN num
           END) AS cashnum,
       sum(CASE
               WHEN TYPE='放款' THEN dnum
           END) AS cashdnum,
       sum(CASE
               WHEN TYPE='放款' THEN amount
           END) AS cashamount
FROM
  (SELECT '注册' AS TYPE,
          data_source,
          register_date AS data_date,
          is_new_jry,
          the_2nd_level,
          the_3rd_level,
          num,
          num AS dnum,
          0 AS amount
   FROM warehouse_data_channel_user_sum
   union all SELECT '实名' AS TYPE,
          data_source,
          chk_date AS data_date,
          is_new_jry,
          if(the_2nd_level IS NULL,'空白',the_2nd_level) AS the_2nd_level,
          if(the_3rd_level IS NULL,'空白',the_3rd_level) AS the_3rd_level,
          count(distinct mbl_no) as num,
          count(distinct mbl_no) AS dnum,
          0 AS amount
   FROM warehouse_data_user_channel_info
   WHERE chk_date<=date_sub(current_date(),1)
   GROUP BY data_source,
          chk_date,
          is_new_jry,
          if(the_2nd_level IS NULL,'空白',the_2nd_level),
          if(the_3rd_level IS NULL,'空白',the_3rd_level)
   UNION ALL SELECT '申请' AS TYPE,
                    a.data_source,
                    a.apply_time,
                    b.is_new_jry,
                    if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level) AS the_2nd_level,
                    if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level) AS the_3rd_level,
                    count(1) AS applyup_num,
                    count(DISTINCT a.mbl_no) AS applyup_dnum,
                    0 AS applyup_amount
   FROM warehouse_data_user_review_info AS a
   JOIN warehouse_data_user_channel_info AS b ON a.data_source=b.data_source
   AND a.mbl_no=b.mbl_no
   GROUP BY a.data_source,
            a.apply_time,
            b.is_new_jry,
            if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level),
            if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level)
   UNION ALL SELECT '授信' AS TYPE,
                    a.data_source,
                    a.credit_time,
                    b.is_new_jry,
                    if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level) AS the_2nd_level,
                    if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level) AS the_3rd_level,
                    count(1) AS applyup_num,
                    count(DISTINCT a.mbl_no) AS applyup_dnum,
                    sum(if(amount IS NULL,0,amount)) AS applyup_amount
   FROM warehouse_data_user_review_info AS a
   JOIN warehouse_data_user_channel_info AS b ON a.data_source=b.data_source
   AND a.mbl_no=b.mbl_no
   WHERE a.status='通过'
     AND a.credit_time IS NOT NULL
   GROUP BY a.data_source,
            a.credit_time,
            b.is_new_jry,
            if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level),
            if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level)
   UNION ALL SELECT '放款' AS TYPE,
                    a.data_source,
                    a.cash_time,
                    b.is_new_jry,
                    if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level) AS the_2nd_level,
                    if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level) AS the_3rd_level,
                    count(1) AS applyup_num,
                    count(DISTINCT a.mbl_no) AS applyup_dnum,
                    sum(if(cash_amount IS NULL,0,cash_amount)) AS applyup_amount
   FROM warehouse_data_withdrawals_info AS a
   JOIN warehouse_data_user_channel_info AS b ON a.data_source=b.data_source
   AND a.mbl_no=b.mbl_no
   GROUP BY a.data_source,
            a.cash_time,
            if(a.product_name IS NULL,'空白',a.product_name),
            b.is_new_jry,
            if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level),
            if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level)) AS a
WHERE data_date<=date_sub(current_date(),1)
GROUP BY data_source,
         data_date,
         is_new_jry,
         the_2nd_level,
         the_3rd_level;

--每日新注册用户转化数据 add 2018-11-21
INSERT INTO warehouse_data_channel_newuser_daily
SELECT data_source,
       extractday,
       if(the_2nd_level is null,'空白',the_2nd_level) as the_2nd_level,
       if(the_3rd_level is null,'空白',the_3rd_level) as the_3rd_level,
       count(DISTINCT CASE
                          WHEN code='注册' THEN mbl_no
                      END) AS regnum,
       count(DISTINCT CASE
                          WHEN code='实名' THEN mbl_no
                      END) AS chknum,
       count(DISTINCT CASE
                          WHEN code='申请' THEN mbl_no
                      END) AS apllynum,
       count(DISTINCT CASE
                          WHEN code='授信' THEN mbl_no
                      END) AS creditnum,
       count(DISTINCT CASE
                          WHEN code='放款' THEN mbl_no
                      END) AS cashnum,
       sum(allcash) AS allcash,
       sum(cash01) AS cash01,
       sum(cash02) AS cash02,
       sum(cash03) AS cash03,
       sum(cash04) AS cash04,
       sum(cash05) AS cash05,
       sum(cash06) AS cash06,
       sum(cash07) AS cash07,
       sum(cash08) AS cash08,
       sum(cash09) AS cash09,
       sum(cash10) AS cash10,
       sum(cash11) AS cash11,
       sum(cash12) AS cash12,
       sum(cash13) AS cash13,
       sum(cash14) AS cash14
FROM
  (SELECT '注册' AS code,
          a.data_source,
          a.register_date AS extractday,
          a.chk_date,
          a.the_2nd_level,
          a.the_3rd_level,
          a.mbl_no,
          0 AS allcash,
          0 AS cash01,
          0 AS cash02,
          0 AS cash03,
          0 AS cash04,
          0 AS cash05,
          0 AS cash06,
          0 AS cash07,
          0 AS cash08,
          0 AS cash09,
          0 AS cash10,
          0 AS cash11,
          0 AS cash12,
          0 AS cash13,
          0 AS cash14
   FROM warehouse_data_user_channel_info AS a
   UNION ALL SELECT '实名' AS code,
                    a.data_source,
                    a.chk_date AS extractday,
                    a.chk_date,
                    a.the_2nd_level,
                    a.the_3rd_level,
                    a.mbl_no,
                    0 AS allcash,
                    0 AS cash01,
                    0 AS cash02,
                    0 AS cash03,
                    0 AS cash04,
                    0 AS cash05,
                    0 AS cash06,
                    0 AS cash07,
                    0 AS cash08,
                    0 AS cash09,
                    0 AS cash10,
                    0 AS cash11,
                    0 AS cash12,
                    0 AS cash13,
                    0 AS cash14
   FROM warehouse_data_user_channel_info AS a
   where chk_date=register_date
   UNION ALL SELECT '申请' AS code,
                    a.data_source,
                    a.register_date AS extractday,
                    a.chk_date,
                    a.the_2nd_level,
                    a.the_3rd_level,
                    b.mbl_no,
                    0 AS cash,
                    0 AS cash01,
                    0 AS cash02,
                    0 AS cash03,
                    0 AS cash04,
                    0 AS cash05,
                    0 AS cash06,
                    0 AS cash07,
                    0 AS cash08,
                    0 AS cash09,
                    0 AS cash10,
                    0 AS cash11,
                    0 AS cash12,
                    0 AS cash13,
                    0 AS cash14
   FROM warehouse_data_user_channel_info AS a
   JOIN warehouse_data_user_review_info AS b ON a.data_source=b.data_source
   AND a.mbl_no=b.mbl_no
   AND a.register_date=b.apply_time
   UNION ALL SELECT '授信' AS code,
                    a.data_source,
                    a.register_date AS extractday,
                    a.chk_date,
                    a.the_2nd_level,
                    a.the_3rd_level,
                    c.mbl_no,
                    0 AS cash,
                    0 AS cash01,
                    0 AS cash02,
                    0 AS cash03,
                    0 AS cash04,
                    0 AS cash05,
                    0 AS cash06,
                    0 AS cash07,
                    0 AS cash08,
                    0 AS cash09,
                    0 AS cash10,
                    0 AS cash11,
                    0 AS cash12,
                    0 AS cash13,
                    0 AS cash14
   FROM warehouse_data_user_channel_info AS a
   JOIN warehouse_data_user_review_info AS c ON a.data_source=c.data_source
   AND a.mbl_no=c.mbl_no
   AND a.register_date=c.credit_time
   AND c.status='通过'
   UNION SELECT '放款' AS code,
                a.data_source,
                a.register_date AS extractday,
                a.chk_date,
                a.the_2nd_level,
                a.the_3rd_level,
                d.mbl_no,
                d.cash_amount,
                CASE
                    WHEN product_name = '随借随还-马上' THEN cash_amount
                END cash01,
                CASE
                    WHEN product_name = '随借随还-众安' THEN cash_amount
                END cash02,
                CASE
                    WHEN product_name = '随借随还-钱包易贷' THEN cash_amount
                END cash03,
                CASE
                    WHEN product_name = '现金分期-马上' THEN cash_amount
                END cash04,
                CASE
                    WHEN product_name = '现金分期-中邮' THEN cash_amount
                END cash05,
                CASE
                    WHEN product_name = '现金分期-万达普惠' THEN cash_amount
                END cash06,
                CASE
                    WHEN product_name = '现金分期-点点' THEN cash_amount
                END cash07,
                CASE
                    WHEN product_name = '现金分期-兴业消费' THEN cash_amount
                END cash08,
                CASE
                    WHEN product_name = '现金分期-小雨点' THEN cash_amount
                END cash09,
                CASE
                    WHEN product_name = '现金分期-拉卡拉' THEN cash_amount
                END cash10,
                CASE
                    WHEN product_name = '大期贷-招联' THEN cash_amount
                END cash11,
                CASE
                    WHEN product_name = '白领贷-招联' THEN cash_amount
                END cash12,
                CASE
                    WHEN product_name = '好期贷-招联' THEN cash_amount
                END cash13,
                CASE
                    WHEN product_name = '业主贷-招联' THEN cash_amount
                END cash14
   FROM warehouse_data_user_channel_info AS a
   JOIN warehouse_data_withdrawals_info AS d ON a.data_source=d.data_source
   AND a.mbl_no=d.mbl_no
   AND a.register_date=d.cash_time) AS a
WHERE substr(extractday,1,10) = date_sub(current_date(),1)
GROUP BY data_source,
         extractday,
         if(the_2nd_level is null,'空白',the_2nd_level),
         if(the_3rd_level is null,'空白',the_3rd_level);v