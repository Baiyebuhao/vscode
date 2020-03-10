-- 切换用户
set role admin;
set io.sort.mb=70;
set hive.jobname.length=20;

set mapred.child.java.opts = -Xmx512m;
set mapreduce.map.memory.mb=1024;
set mapreduce.reduce.memory.mb=1024;

-- T+1数据完成后，开始处理
-- 申请及授信数据更新 update 2018-11-08
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
          if(data_source IS NULL,'sjd',data_source) AS data_source,
          substr(appl_time,1,10) AS apply_time,
          substr(credit_time,1,10) AS credit_time,
          '随借随还-钱包易贷' product_name,
                      CASE
                          WHEN appral_res = '通过' THEN '通过'
                          WHEN appral_res =''
                               AND status IN('apply_success',
                                             'freeze') THEN '通过'
                          ELSE '未通过'
                      END status,
                      cast(acc_lim AS decimal(12,2))/100 AS amount
   FROM default.warehouse_atomic_qianbao_review_result_info
   WHERE NOT (substr(credit_time,1,10)='2019-01-29'
              AND substr(appl_time,1,10)!='2019-01-29')
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
                      if(data_source IS NULL,'sjd',data_source) AS data_source,
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
   UNION ALL SELECT if(mbl_no IS NULL,mbl_no_md5,mbl_no) AS mbl_no,
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
   UNION ALL SELECT if(mbl_no IS NULL,mbl_no_md5,mbl_no) AS mbl_no,
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
                                       cast(total_limit AS decimal(12,2))/100 AS amount
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
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(apply_time,1,10) AS apply_time,
                    substr(finish_time,1,10) AS credit_time,
                    '现金分期-万达普惠' product_name,
                                CASE
                                    WHEN substr(finish_time,1,1) >= '1' THEN '通过'
                                    ELSE '未通过'
                                END AS status,
                                if(loan_amt>0,loan_amt,0) AS amount
   FROM default.warehouse_atomic_wanda_loan_info
   WHERE substr(apply_time,1,1)='2'
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(applytime,1,10) AS apply_time,
                    if(approvalamount>0,substr(applytime,1,10),NULL) credit_time,
                    '信用钱包' AS product_name,
                    if(approvalamount>0,'通过','未通过') AS status,
                    if(approvalamount>0,approvalamount,0) AS amount
   FROM default.warehouse_atomic_lhp_review_result_info
   UNION ALL SELECT mblno,
                    datasource,
                    substr(applytime,1,10) AS apply_time,
                    if(approvalstatus=1,substr(applytime,1,10),NULL) credit_time,
                    '现金分期-钱伴' AS product_name,
                    if(approvalstatus=1,'通过','未通过') AS status,
                    creditamount AS amount
   FROM default.warehouse_atomic_wacai_loan_info
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(apply_time,1,10) AS apply_time,
                    if(fixed_limit>0,substr(approve_time,1,10),NULL) credit_time,
                    '现金分期-招联' AS product_name,
                    if(fixed_limit>0,'通过','未通过') AS status,
                    if(fixed_limit>0,cast(fixed_limit AS decimal(12,2))/100,0) AS amount
   FROM
     (SELECT DISTINCT mbl_no,
                      data_source,
                      apply_time,
                      approve_time,
                      fixed_limit
      FROM default.warehouse_atomic_zlhjq_review_result_info) AS a
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(credit_time,1,10) AS apply_time,
                    if(credit_status=3,substr(credit_time,1,10),NULL) credit_time,
                    '优智借' AS product_name,
                    if(credit_status=3,'通过','未通过') AS status,
                    if(credit_status=3,cast(credit_amt AS decimal(12,2))/100,0) AS amount
   FROM default.warehouse_atomic_yzj_review_result_info AS a
   WHERE credit_status != 1
   UNION ALL SELECT mbl_no,
                    platform,
                    substr(apply_time,1,10) AS apply_time,
                    if(check_status=1,substr(check_time,1,10),NULL) credit_time,
                    prod_name AS product_name,
                    if(check_status=1,'通过','未通过') AS status,
                    if(check_status=1,cast(int(check_amount) AS decimal(12,2))/100,0) AS amount
   FROM default.warehouse_atomic_api_loan_record AS a
   WHERE mht_apply_no IS NOT NULL
   UNION ALL SELECT distinct mbl_no,
                    data_source,
                    substr(apply_time,1,10) AS apply_time,
                    if(credit_status in('80','400'),substr(credit_time,1,10),NULL) credit_time,
                    '及贷' AS product_name, 
                    if(credit_status in('80','400'),'通过','未通过') AS status,
                    if(credit_status in('80','400'),cast(credit_line AS decimal(12,2)),0) AS amount
   FROM default.warehouse_atomic_s_jd_callback_credit AS a) AS a;

-- 五款重要产品授信及有效期数据 update 2018-11-08
INSERT overwrite TABLE warehouse_data_credit_start_to_end
SELECT DISTINCT *
FROM
  (SELECT data_source,
          mbl_no,
          appl_time,
          substr(b.credit_time,1,10) AS credit_time,
          '随借随还-钱包易贷' AS product_name,
          cast(date_add(substr(b.credit_time,1,10),1) AS string) AS credit_date,
          add_months(substr(b.credit_time,1,10),12) AS credit_end_date
   FROM default.warehouse_atomic_qianbao_review_result_info AS b
   WHERE status IN('apply_success',
                   'freeze')
      AND NOT (substr(credit_time,1,10)='2019-01-29'
           AND substr(appl_time,1,10)!='2019-01-29')                   
   UNION ALL SELECT data_source,
                    if(mbl_no IS NULL,mbl_no_md5,mbl_no) AS mbl_no,
                    appl_time,
                    substr(credit_time,1,10) AS credit_time,
                    '随借随还-马上' AS product_name,
                    cast(date_add(substr(b.credit_time,1,10),1) AS string) AS credit_date,
                    add_months(substr(b.paid_out_time,1,10),12) AS credit_end_date
   FROM default.warehouse_atomic_msd_withdrawals_result_info AS b
   WHERE paid_out_time is not null
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
                    if(mbl_no IS NULL,mbl_no_md5,mbl_no) AS mbl_no,
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
            substr(apply_time,1,10) AS apply_time,
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

-- 接点击数据增加is_credit新老用户标记 update 20181114
INSERT overwrite TABLE warehouse_data_user_action_sum PARTITION(extractday)
SELECT a.data_source,
       a.product_name,
       a.mbl_no,
       a.is_new,
       if(b.is_credit=1,'是','否') AS is_credit,
       a.allpv,
       a.marketpv,
       a.detailpv,
       a.applypv,
       a.institupv,
       a.bannerpv,
       if(a.applypv>0,'是','否') AS is_apply,
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

-- 推送数据汇总结果表 update 2019-02-22 
INSERT overwrite TABLE warehouse_data_user_action_end PARTITION (extractday)
SELECT if(a.data_source='jry','xyqb',a.data_source) as data_source,
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
                      END) AS creditdnum,
       a.extractday
FROM warehouse_data_user_action_sum AS a
WHERE applypv>0
  AND extractday = date_sub(current_date(),1)
GROUP BY a.extractday,
         if(a.data_source='jry','xyqb',a.data_source),
         a.product_name;
         
-- 推送数据汇总结果表(三平台) add 2019-02-21
INSERT overwrite TABLE warehouse_data_user_action_end_new PARTITION (extractday)
SELECT a.data_source,
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
                      END) AS creditdnum,
       a.extractday
FROM warehouse_data_user_action_sum AS a
WHERE applypv>0
  AND extractday = date_sub(current_date(),1)
GROUP BY a.extractday,
         a.data_source,
         a.product_name;

-- 推送数据周汇总结果表(三平台)-不区分产品 add 2019-03-21 update 2019-05-20
INSERT overwrite TABLE warehouse_data_user_action_end_weekly_noproduct PARTITION (YEAR,week)
SELECT a.data_source,
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
                      END) AS creditdnum,
       min(extractday) AS extractday,
       year(a.extractday) AS YEAR,
       weekofyear(a.extractday) AS week
FROM warehouse_data_user_action_sum AS a
WHERE applypv>0
  AND year(extractday) = year(date_sub(current_date(),1))
  AND weekofyear(extractday) = weekofyear(date_sub(current_date(),1))
GROUP BY year(a.extractday),
         weekofyear(a.extractday),
         a.data_source;       
         
-- 推送数据周汇总结果表(三平台) add 2019-03-21 update 2019-05-20
INSERT overwrite TABLE warehouse_data_user_action_end_weekly PARTITION (YEAR,week)
SELECT a.data_source,
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
                      END) AS creditdnum,
       min(extractday) AS extractday,
       year(a.extractday) AS YEAR,
       weekofyear(a.extractday) AS week
FROM warehouse_data_user_action_sum AS a
WHERE applypv>0
  AND year(extractday) = year(date_sub(current_date(),1))
  AND weekofyear(extractday) = weekofyear(date_sub(current_date(),1))
GROUP BY year(a.extractday),
         weekofyear(a.extractday),
         a.data_source,
         a.product_name;

-- 放款数据更新update 2018-11-08
INSERT overwrite TABLE warehouse_data_user_withdrawals_info
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
   WHERE status IN('overdue',
                   'repaying',
                   'settled')
   UNION ALL SELECT if(mbl_no IS NULL,mbl_no_md5,mbl_no) AS mbl_no,
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
   UNION ALL SELECT if(mbl_no IS NULL,mbl_no_md5,mbl_no) AS mbl_no,
                    data_source,
                    substr(approval_time,1,10) AS lending_time,
                    cast(approval_amount AS decimal(12,2))/100 AS cash_amount,
                    '现金分期-马上' AS product_name
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
   WHERE loan_amt>0
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(loanstatustime,1,10) AS loan_date,
                    loanamount AS amount,
                    '信用钱包'AS product_name
   FROM default.warehouse_atomic_lhp_withdrawals_result_info AS a
   WHERE loanamount>0
   UNION ALL SELECT mblno,
                    datasource,
                    substr(loantime,1,10) AS loan_date,
                    loanamount AS amount,
                    '现金分期-钱伴'AS product_name
   FROM default.warehouse_atomic_wacai_loan_info AS a
   WHERE loanstatue=1
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(payment_date,1,10) AS payment_date,
                    loan_amt AS amount,
                    '现金分期-招联' AS product_name
   FROM
     (SELECT DISTINCT mbl_no,
                      data_source,
                      payment_date,
                      cast(loan_amt AS decimal(12,2))/100 AS loan_amt
      FROM default.warehouse_atomic_zlhjq_withdrawals_result_info) AS a
   WHERE substr(payment_date,1,1)='2'
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(credit_time,1,10) AS loan_date,
                    cast(amt AS decimal(12,2))/100 AS amount,
                    '优智借' AS product_name
   FROM default.warehouse_atomic_yzj_withdrawals_result_info AS a
   WHERE credit_status=1
   UNION ALL SELECT mbl_no,
                    platform,
                    substr(payment_time,1,10) AS apply_time,
                    cast(payment_amount AS decimal(12,2))/100 AS amount,
                    prod_name AS product_name
   FROM default.warehouse_atomic_api_loan_record AS a
   WHERE mht_payment_no IS NOT NULL
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(lending_time,1,10) AS apply_time,
                    cast(real_loan_money AS decimal(12,2)) AS amount,
                    '及贷' AS product_name
   FROM default.warehouse_atomic_s_jd_callback_loan AS a) AS a;
         
-- 申请授信放款数据明细 add 2019-03-27
INSERT overwrite TABLE warehouse_data_user_review_withdrawals_info
SELECT a.extractday,
       COALESCE(b.data_source,a.data_source) AS data_source,
       a.product_name,
       the_2nd_level,
       the_3rd_level,
       a.mbl_no,
       IF(b.register_date IS NULL,'1970-01-01',b.register_date) AS register_date,
       COUNT(CASE
                 WHEN data_type='申请' THEN a.mbl_no
             END) AS applynum,
       COUNT(DISTINCT CASE
                          WHEN data_type='申请' THEN a.mbl_no
                      END) AS applydnum,
       COUNT(CASE
                 WHEN data_type='授信' THEN a.mbl_no
             END) AS creditnum,
       COUNT(DISTINCT CASE
                          WHEN data_type='授信' THEN a.mbl_no
                      END) AS creditdnum,
       sum(CASE
               WHEN data_type='授信' THEN amount
               ELSE 0
           END) AS creditamount,
       COUNT(CASE
                 WHEN data_type='放款' THEN a.mbl_no
             END) AS cashnum,
       COUNT(DISTINCT CASE
                          WHEN data_type='放款' THEN a.mbl_no
                      END) AS cashdnum,
       sum(CASE
               WHEN data_type='放款' THEN amount
               ELSE 0
           END) AS cashamount
FROM
  (SELECT '申请' AS data_type,
          a.data_source,
          a.apply_time AS extractday,
          a.product_name,
          a.mbl_no,
          0 AS amount
   FROM warehouse_data_user_review_info AS a
   WHERE apply_time<=date_sub(current_date(),1)
   UNION ALL SELECT '授信' AS data_type,
                    a.data_source,
                    credit_time AS extractday,
                    a.product_name,
                    a.mbl_no,
                    if(amount IS NULL,0,amount) AS amount
   FROM warehouse_data_user_review_info AS a
   WHERE a.status='通过'
     AND credit_time<=date_sub(current_date(),1)
   UNION ALL SELECT '放款' AS data_type,
                    a.data_source,
                    a.cash_time AS extractday,
                    a.product_name,
                    a.mbl_no,
                    if(cash_amount IS NULL,0,cash_amount) AS amount
   FROM warehouse_data_user_withdrawals_info AS a
   WHERE if(cash_time IS NULL,'1970-01-01',cash_time)<=date_sub(current_date(),1)) AS a
LEFT JOIN warehouse_data_user_channel_info AS b ON a.data_source=b.data_source
AND a.mbl_no=b.mbl_no
GROUP BY a.extractday,
         COALESCE(b.data_source,a.data_source),
         a.product_name,
         the_2nd_level,
         the_3rd_level,
         a.mbl_no,
         IF(b.register_date IS NULL,'1970-01-01',b.register_date);

-- 平台累计数据 add 2018-10-25 update 2019-03-27
INSERT overwrite TABLE warehouse_data_user_datasum
SELECT data_source,
       sum(regnum) AS regnum,
       sum(chknum) AS chknum,
       sum(applynum) AS applynum,
       sum(applydnum) AS applydnum,
       sum(creditnum) AS creditnum,
       sum(creditdnum) AS creditdnum,
       sum(creditamount) AS creditamount,
       sum(cashnum) AS cashnum,
       sum(cashdnum) AS cashdnum,
       sum(cashamount) AS cashamount
FROM
  (SELECT data_source,
          count(if(data_type='注册',mbl_no,NULL)) AS regnum,
          count(if(data_type='实名',mbl_no,NULL)) AS chknum,
          0 AS applynum,
          0 AS applydnum,
          0 AS creditnum,
          0 AS creditdnum,
          0 AS creditamount,
          0 AS cashnum,
          0 AS cashdnum,
          0 AS cashamount
   FROM
     (SELECT '注册' AS data_type,
             data_source,
             register_date AS extractday,
             mbl_no
      FROM warehouse_data_user_channel_info AS a
      WHERE register_date<=date_sub(current_date(),1)
      UNION ALL SELECT '实名' AS data_type,
                       data_source,
                       chk_date AS data_date,
                       mbl_no
      FROM warehouse_data_user_channel_info AS a
      WHERE chk_date<=date_sub(current_date(),1) )AS a
   GROUP BY data_source
   UNION ALL SELECT data_source,
                    0 AS regnum,
                    0 AS chknum,
                    sum(applynum) AS applynum,
                    count(DISTINCT if(applydnum>0,mbl_no,NULL)) AS applydnum,
                    sum(creditnum) AS creditnum,
                    count(DISTINCT if(creditdnum>0,mbl_no,NULL)) AS creditdnum,
                    sum(creditamount) AS creditamount,
                    sum(cashnum) AS cashnum,
                    count(DISTINCT if(cashdnum>0,mbl_no,NULL)) AS cashdnum,
                    sum(cashamount) AS cashamount
   FROM warehouse_data_user_review_withdrawals_info AS a
   GROUP BY data_source) AS a
GROUP BY data_source;

-- 每日用户数据 add 2018-10-25 update 2019-03-27
INSERT overwrite TABLE warehouse_data_user_daliy PARTITION(date_month)
SELECT data_source,
       extractday,
       sum(regnum) AS regnum,
       sum(chknum) AS chknum,
       sum(applynum) AS applynum,
       sum(applydnum) AS applydnum,
       sum(creditnum) AS creditnum,
       sum(creditdnum) AS creditdnum,
       sum(creditamount) AS creditamount,
       sum(cashnum) AS cashnum,
       sum(cashdnum) AS cashdnum,
       sum(cashamount) AS cashamount,
       substr(extractday,1,7) AS date_month
FROM
  (SELECT data_source,
          extractday,
          count(if(data_type='注册',mbl_no,NULL)) AS regnum,
          count(if(data_type='实名',mbl_no,NULL)) AS chknum,
          0 AS applynum,
          0 AS applydnum,
          0 AS creditnum,
          0 AS creditdnum,
          0 AS creditamount,
          0 AS cashnum,
          0 AS cashdnum,
          0 AS cashamount
   FROM
     (SELECT '注册' AS data_type,
             data_source,
             register_date AS extractday,
             mbl_no
      FROM warehouse_data_user_channel_info AS a
      WHERE register_date<=date_sub(current_date(),1)
      UNION ALL SELECT '实名' AS data_type,
                       data_source,
                       chk_date AS data_date,
                       mbl_no
      FROM warehouse_data_user_channel_info AS a
      WHERE chk_date<=date_sub(current_date(),1) )AS a
   GROUP BY data_source,
            extractday
   UNION ALL SELECT data_source,
                    extractday,
                    0 AS regnum,
                    0 AS chknum,
                    sum(applynum) AS applynum,
                    count(DISTINCT if(applydnum>0,mbl_no,NULL)) AS applydnum,
                    sum(creditnum) AS creditnum,
                    count(DISTINCT if(creditdnum>0,mbl_no,NULL)) AS creditdnum,
                    sum(creditamount) AS creditamount,
                    sum(cashnum) AS cashnum,
                    count(DISTINCT if(cashdnum>0,mbl_no,NULL)) AS cashdnum,
                    sum(cashamount) AS cashamount
   FROM warehouse_data_user_review_withdrawals_info AS a
   WHERE extractday<=date_sub(current_date(),1)
   GROUP BY data_source,
            extractday) AS a
GROUP BY data_source,
         extractday,
         substr(extractday,1,7);

-- 每月用户数据 add 2018-11-07 update 2018-11-29
INSERT overwrite TABLE warehouse_data_user_months PARTITION(datemonth)
SELECT data_source,
       extractday,
       sum(regnum) AS regnum,
       sum(chknum) AS chknum,
       sum(applynum) AS applynum,
       sum(applydnum) AS applydnum,
       sum(creditnum) AS creditnum,
       sum(creditdnum) AS creditdnum,
       sum(creditamount) AS creditamount,
       sum(cashnum) AS cashnum,
       sum(cashdnum) AS cashdnum,
       sum(cashamount) AS cashamount,
       substr(extractday,1,7) AS date_month
FROM
  (SELECT data_source,
          concat(substr(extractday,1,7),'-01') AS extractday,
          count(if(data_type='注册',mbl_no,NULL)) AS regnum,
          count(if(data_type='实名',mbl_no,NULL)) AS chknum,
          0 AS applynum,
          0 AS applydnum,
          0 AS creditnum,
          0 AS creditdnum,
          0 AS creditamount,
          0 AS cashnum,
          0 AS cashdnum,
          0 AS cashamount
   FROM
     (SELECT '注册' AS data_type,
             data_source,
             register_date AS extractday,
             mbl_no
      FROM warehouse_data_user_channel_info AS a
      WHERE register_date<=date_sub(current_date(),1)
      UNION ALL SELECT '实名' AS data_type,
                       data_source,
                       chk_date AS data_date,
                       mbl_no
      FROM warehouse_data_user_channel_info AS a
      WHERE chk_date<=date_sub(current_date(),1) )AS a
   GROUP BY data_source,
            concat(substr(extractday,1,7),'-01')
   UNION ALL SELECT data_source,
                    concat(substr(extractday,1,7),'-01') AS extractday,
                    0 AS regnum,
                    0 AS chknum,
                    sum(applynum) AS applynum,
                    count(DISTINCT if(applydnum>0,mbl_no,NULL)) AS applydnum,
                    sum(creditnum) AS creditnum,
                    count(DISTINCT if(creditdnum>0,mbl_no,NULL)) AS creditdnum,
                    sum(creditamount) AS creditamount,
                    sum(cashnum) AS cashnum,
                    count(DISTINCT if(cashdnum>0,mbl_no,NULL)) AS cashdnum,
                    sum(cashamount) AS cashamount
   FROM warehouse_data_user_review_withdrawals_info AS a      
   WHERE extractday<=date_sub(current_date(),1)
   GROUP BY data_source,
            concat(substr(extractday,1,7),'-01')) AS a
GROUP BY data_source,
         extractday,
         substr(extractday,1,7);

-- 产品全流程数据表 add 2018-10-23 update 2019-03-27
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
  (SELECT extractday,
          data_source,
          product_name,
          sum(num) AS num,
          sum(dnum) AS dnum,
          sum(applynum) AS applynum,
          sum(applydnum) AS applydnum,
          sum(creditnum) AS creditnum,
          sum(creditdnum) AS creditdnum,
          sum(creditamount) AS creditamount,
          sum(cashnum) AS cashnum,
          sum(cashdnum) AS cashdnum,
          sum(cashamount) AS cashamount
   FROM
     (SELECT extractday,
             data_source,
             product_name,
             a.num,
             a.dnum,
             0 AS applynum,
             0 AS applydnum,
             0 AS creditnum,
             0 AS creditdnum,
             0 AS creditamount,
             0 AS cashnum,
             0 AS cashdnum,
             0 AS cashamount
      FROM warehouse_data_user_action_end_new AS a
      WHERE a.data_source != 'h5'
      UNION ALL SELECT extractday,
                       data_source,
                       product_name,
                       0 AS num,
                       0 AS dnum,
                    sum(applynum) AS applynum,
                    sum(applydnum) AS applydnum,
                    sum(creditnum) AS creditnum,
                    sum(creditdnum) AS creditdnum,
                    sum(creditamount) AS creditamount,
                    sum(cashnum) AS cashnum,
                    sum(cashdnum) AS cashdnum,
                    sum(cashamount) AS cashamount
      FROM warehouse_data_user_review_withdrawals_info
      GROUP BY extractday,
               data_source,
               product_name) AS b
   GROUP BY extractday,
            data_source,
            product_name) AS a
LEFT JOIN
  (SELECT register_date AS extractday,
          data_source,
          sum(num) AS mblnum
   FROM warehouse_data_channel_user_sum AS a
   GROUP BY register_date,
            data_source) AS c ON a.extractday=c.extractday 
AND a.data_source=c.data_source
WHERE a.extractday<=date_sub(current_date(),1);


-- 渠道全流程数据
INSERT overwrite TABLE warehouse_data_user_action_and_channel_end
SELECT data_source,
       extractday,
       NULL AS is_new_jry,
       the_2nd_level,
       the_3rd_level,
       sum(regnum) AS regnum,
       sum(chknum) AS chknum,
       sum(applynum) AS applynum,
       sum(applydnum) AS applydnum,
       sum(creditnum) AS creditnum,
       sum(creditdnum) AS creditdnum,
       sum(creditamount) AS creditamount,
       sum(cashnum) AS cashnum,
       sum(cashdnum) AS cashdnum,
       sum(cashamount) AS cashamount
FROM
  (SELECT data_source,
          extractday,
          the_2nd_level,
          the_3rd_level,
          count(if(data_type='注册',mbl_no,NULL)) AS regnum,
          count(if(data_type='实名',mbl_no,NULL)) AS chknum,
          0 AS applynum,
          0 AS applydnum,
          0 AS creditnum,
          0 AS creditdnum,
          0 AS creditamount,
          0 AS cashnum,
          0 AS cashdnum,
          0 AS cashamount
   FROM
     (SELECT '注册' AS data_type,
             data_source,
             the_2nd_level,
             the_3rd_level,
             register_date AS extractday,
             mbl_no
      FROM warehouse_data_user_channel_info AS a
      UNION ALL SELECT '实名' AS data_type,
                       data_source,
                       the_2nd_level,
                       the_3rd_level,
                       chk_date AS extractday,
                       mbl_no
      FROM warehouse_data_user_channel_info AS a
      WHERE chk_date<=date_sub(current_date(),1))AS a
   GROUP BY data_source,
            extractday,
            the_2nd_level,
            the_3rd_level
   UNION ALL SELECT data_source,
                    extractday,
                    the_2nd_level,
                    the_3rd_level,
                    0 AS regnum,
                    0 AS chknum,
                    sum(applynum) AS applynum,
                    sum(applydnum) AS applydnum,
                    sum(creditnum) AS creditnum,
                    sum(creditdnum) AS creditdnum,
                    sum(creditamount) AS creditamount,
                    sum(cashnum) AS cashnum,
                    sum(cashdnum) AS cashdnum,
                    sum(cashamount) AS cashamount
   FROM warehouse_data_user_review_withdrawals_info AS a
   GROUP BY data_source,
            extractday,
            the_2nd_level,
            the_3rd_level) AS a
WHERE extractday <= date_sub(current_date(),1)
GROUP BY data_source,
         extractday,
         the_2nd_level,
         the_3rd_level;

set io.sort.mb=50;

-- 每日新注册用户渠道转化数据 add 2018-11-21 update 2019-05-20
INSERT overwrite TABLE warehouse_data_channel_newuser_daily PARTITION(etl_date)
SELECT data_source,
       extractday,
       the_2nd_level,
       the_3rd_level,
       sum(regnum) AS regnum,
       sum(chknum) AS chknum,
       sum(applynum) AS applynum,
       sum(creditnum) AS creditnum,
       sum(cashnum) AS cashnum,
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
       sum(cash14) AS cash14,
       sum(cash15) AS cash15,
       sum(cash16) AS cash16,
       sum(cash17) AS cash17,
       substr(extractday,1,7) AS etl_date
FROM
  (SELECT a.data_source,
          a.register_date AS extractday,
          the_2nd_level,
          the_3rd_level,
          count(DISTINCT a.mbl_no) AS regnum,
          0 AS chknum,
          0 AS applynum,
          0 AS creditnum,
          0 AS cashnum,
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
          0 AS cash14,
          0 AS cash15,
          0 AS cash16,
          0 AS cash17
   FROM warehouse_data_user_channel_info AS a
   GROUP BY a.data_source,
            a.register_date,
            the_2nd_level,
            the_3rd_level
   UNION ALL SELECT a.data_source,
                    a.chk_date,
                    the_2nd_level,
                    the_3rd_level,
                    0 AS regnum,
                    count(DISTINCT a.mbl_no) AS chknum,
                    0 AS applynum,
                    0 AS creditnum,
                    0 AS cashnum,
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
                    0 AS cash14,
                    0 AS cash15,
                    0 AS cash16,
                    0 AS cash17
   FROM warehouse_data_user_channel_info AS a
   WHERE chk_date IS NOT NULL
   GROUP BY a.data_source,
            a.chk_date,
            the_2nd_level,
            the_3rd_level
   UNION ALL SELECT d.data_source,
                    d.extractday,
                    d.the_2nd_level,
                    d.the_3rd_level,
                    0 AS regnum,
                    0 AS chknum,
                    count(DISTINCT CASE
                                       WHEN applynum>0 THEN d.mbl_no
                                   END) AS applynum,
                    count(DISTINCT CASE
                                       WHEN creditnum>0 THEN d.mbl_no
                                   END) AS creditnum,
                    count(DISTINCT CASE
                                       WHEN cashnum>0 THEN d.mbl_no
                                   END) AS cashnum,
                    sum(cashamount) AS allcash,
                    sum(CASE
                            WHEN product_name = '随借随还-马上' THEN cashamount
                        END) AS cash01,
                    sum(CASE
                            WHEN product_name = '随借随还-众安' THEN cashamount
                        END) AS cash02,
                    sum(CASE
                            WHEN product_name = '随借随还-钱包易贷' THEN cashamount
                        END) AS cash03,
                    sum(CASE
                            WHEN product_name = '现金分期-马上' THEN cashamount
                        END) AS cash04,
                    sum(CASE
                            WHEN product_name = '现金分期-中邮' THEN cashamount
                        END) AS cash05,
                    sum(CASE
                            WHEN product_name = '现金分期-万达普惠' THEN cashamount
                        END) AS cash06,
                    sum(CASE
                            WHEN product_name = '现金分期-点点' THEN cashamount
                        END) AS cash07,
                    sum(CASE
                            WHEN product_name = '现金分期-兴业消费' THEN cashamount
                        END) AS cash08,
                    sum(CASE
                            WHEN product_name = '现金分期-小雨点' THEN cashamount
                        END) AS cash09,
                    sum(CASE
                            WHEN product_name = '现金分期-拉卡拉' THEN cashamount
                        END) AS cash10,
                    sum(CASE
                            WHEN product_name = '大期贷-招联' THEN cashamount
                        END) AS cash11,
                    sum(CASE
                            WHEN product_name = '白领贷-招联' THEN cashamount
                        END) AS cash12,
                    sum(CASE
                            WHEN product_name = '好期贷-招联' THEN cashamount
                        END) AS cash13,
                    sum(CASE
                            WHEN product_name = '业主贷-招联' THEN cashamount
                        END) AS cash14,
                    sum(CASE
                            WHEN product_name = '信用钱包' THEN cashamount
                        END) AS cash15,
                    sum(CASE
                            WHEN product_name = '现金分期-钱伴' THEN cashamount
                        END) AS cash16,
                    sum(CASE
                            WHEN product_name = '现金分期-招联' THEN cashamount
                        END) AS cash17
   FROM warehouse_data_user_review_withdrawals_info AS d
   JOIN warehouse_atomic_user_info AS a ON a.data_source=d.data_source
   AND a.mbl_no=d.mbl_no
   AND a.registe_date=d.extractday
   GROUP BY d.data_source,
            d.extractday,
            the_2nd_level,
            the_3rd_level) AS a
WHERE a.extractday BETWEEN concat(substr(date_sub(current_date(),90),1,7),'-01') AND date_sub(current_date(),1)
GROUP BY data_source,
         extractday,
         the_2nd_level,
         the_3rd_level,
         substr(extractday,1,7);

set io.sort.mb=70;

-- 新注册用户产品转化漏斗 add 2018-12-12 update 2019-05-20
INSERT overwrite TABLE warehouse_data_product_newuser_daily
SELECT a.data_source,
       a.extractday,
       a.product_name,
       sum(regnum) AS regnum,
       sum(chknum) AS chknum,
       sum(newdnum) AS newdnum,
       sum(applynum) AS applynum,
       sum(creditnum) AS creditnum,
       sum(credit_amount) AS credit_amount,
       sum(cashnum) AS cashnum,
       sum(cash_amount) AS cash_amount
FROM
  (SELECT a.data_source,
          a.extractday,
          a.product_name,
          regnum,
          chknum,
          newdnum,
          0 AS applynum,
          0 AS creditnum,
          0 AS credit_amount,
          0 AS cashnum,
          0 AS cash_amount
   FROM warehouse_data_user_action_end_new AS a
   JOIN warehouse_data_daliy_report_new AS b ON a.data_source=b.data_source
   AND a.extractday=b.extractday
   WHERE a.extractday <= date_sub(current_date(),1)
     AND a.product_name IS NOT NULL
   UNION ALL SELECT a.data_source,
                    a.extractday,
                    a.product_name,
                    0 AS regnum,
                    0 AS chknum,
                    0 AS newdnum,
                    sum(a.applydnum) AS applynum,
                    sum(a.creditdnum) AS creditnum,
                    sum(a.creditamount) AS credit_amount,
                    sum(a.cashdnum) AS cashnum,
                    sum(a.cashamount) AS cash_amount
   FROM warehouse_data_user_review_withdrawals_info AS a
   JOIN warehouse_data_user_channel_info AS b ON a.data_source=b.data_source
   AND a.mbl_no=b.mbl_no
   AND a.extractday=b.register_date
   WHERE a.extractday <= date_sub(current_date(),1)
   GROUP BY a.data_source,
            a.extractday,
            a.product_name) AS a
GROUP BY a.data_source,
         a.extractday,
         a.product_name;

-- 周新注册用户转化漏斗(无产品) add 2019-03-15 update 2019-05-20
INSERT overwrite TABLE warehouse_data_no_product_newuser_weekly
SELECT a.data_source,
       a.year,
       a.week,
       min(a.extractday) AS extractday,
       sum(regnum) AS regnum,
       sum(chknum) AS chknum,
       sum(newdnum) AS newdnum,
       sum(apllynum) AS apllynum,
       sum(creditnum) AS creditnum,
       sum(credit_amount) AS credit_amount,
       sum(cashnum) AS cashnum,
       sum(cash_amount) AS cash_amount
FROM
  (SELECT a.data_source,
          a.year,
          a.week,
          a.extractday,
          0 AS regnum,
          0 AS chknum,
          newdnum,
          0 AS apllynum,
          0 AS creditnum,
          0 AS credit_amount,
          0 AS cashnum,
          0 AS cash_amount
   FROM warehouse_data_user_action_end_weekly_noproduct AS a
   UNION ALL SELECT data_source,
                    year(extractday) AS YEAR,
                    weekofyear(extractday) AS week,
                    min(extractday) AS extractday,
                    sum(regnum) AS regnum,
                    sum(chknum) AS chknum,
                    0 AS newdnum,
                    0 AS apllynum,
                    0 AS creditnum,
                    0 AS credit_amount,
                    0 AS cashnum,
                    0 AS cash_amount
   FROM warehouse_data_daliy_report_new
   GROUP BY data_source,
            year(extractday),
            weekofyear(extractday)
   UNION ALL SELECT a.data_source,
                    year(a.extractday),
                    weekofyear(a.extractday),
                    min(a.extractday) AS extractday,
                    0 AS regnum,
                    0 AS chknum,
                    0 AS newdnum,
                    count(DISTINCT if(applydnum>0,a.mbl_no,NULL)) AS applydnum,
                    count(DISTINCT if(creditdnum>0,a.mbl_no,NULL)) AS creditdnum,
                    sum(a.creditamount) AS credit_amount,
                    count(DISTINCT if(cashdnum>0,a.mbl_no,NULL)) AS cashdnum,
                    sum(a.cashamount) AS cash_amount
   FROM warehouse_data_user_review_withdrawals_info AS a
   JOIN warehouse_data_user_channel_info AS b ON a.data_source=b.data_source
   AND a.mbl_no=b.mbl_no
   AND year(a.extractday)=year(b.register_date)
   AND weekofyear(a.extractday)=weekofyear(b.register_date)
   WHERE a.extractday <= date_sub(current_date(),1)
   GROUP BY a.data_source,
            year(a.extractday),
            weekofyear(a.extractday)) AS a
GROUP BY a.data_source,
         a.year,
         a.week;

-- 周新注册用户产品转化漏斗(有产品) add 2019-03-15 update 2019-05-20
INSERT overwrite TABLE warehouse_data_product_newuser_weekly
SELECT a.data_source,
       a.year,
       a.week,
       min(a.extractday) AS extractday,
       a.product_name,
       sum(regnum) AS regnum,
       sum(chknum) AS chknum,
       sum(newdnum) AS newdnum,
       sum(applynum) AS applynum,
       sum(creditnum) AS creditnum,
       sum(credit_amount) AS credit_amount,
       sum(cashnum) AS cashnum,
       sum(cash_amount) AS cash_amount,
       sum(cash_amount*if(b.pre is null,0,b.pre/100)) AS income_amount
FROM
  (SELECT a.data_source,
          a.year,
          a.week,
          a.extractday,
          a.product_name,
          regnum,
          chknum,
          newdnum,
          0 AS applynum,
          0 AS creditnum,
          0 AS credit_amount,
          0 AS cashnum,
          0 AS cash_amount
   FROM warehouse_data_user_action_end_weekly AS a
   JOIN
     (SELECT data_source,
             year(extractday) AS YEAR,
             weekofyear(extractday) AS week,
             sum(regnum) AS regnum,
             sum(chknum) AS chknum
      FROM warehouse_data_daliy_report_new
      GROUP BY data_source,
               year(extractday),
               weekofyear(extractday)) AS b ON a.data_source=b.data_source
   AND a.YEAR=b.YEAR
   AND a.week=b.week
   WHERE a.product_name IS NOT NULL
   UNION ALL SELECT a.data_source,
                    year(a.extractday),
                    weekofyear(a.extractday),
                    min(a.extractday) AS extractday,
                    a.product_name,                    
                    0 AS regnum,
                    0 AS chknum,
                    0 AS newdnum,
                    count(DISTINCT if(applydnum>0,a.mbl_no,NULL)) AS applydnum,
                    count(DISTINCT if(creditdnum>0,a.mbl_no,NULL)) AS creditdnum,
                    sum(a.creditamount) AS credit_amount,
                    count(DISTINCT if(cashdnum>0,a.mbl_no,NULL)) AS cashdnum,
                    sum(a.cashamount) AS cash_amount
   FROM warehouse_data_user_review_withdrawals_info AS a
   JOIN warehouse_data_user_channel_info AS b ON a.data_source=b.data_source
   AND a.mbl_no=b.mbl_no
   AND year(a.extractday)=year(b.register_date)
   AND weekofyear(a.extractday)=weekofyear(b.register_date)
   WHERE a.extractday <= date_sub(current_date(),1)
     AND a.product_name IS NOT NULL
   GROUP BY a.data_source,
            a.product_name,
            year(a.extractday),
            weekofyear(a.extractday)) AS a
left join warehouse_data_product_income_pre as b on a.product_name=b.product_name
GROUP BY a.data_source,
         a.year,
         a.week,
         a.product_name;

-- 非授信期用户数据明细 add 2018-12-28 update 2019-05-20
INSERT overwrite TABLE warehouse_data_product_creadituser_detail
SELECT a.data_source,
       a.extractday,
       a.product_name,
       a.mbl_no,
       1 as pre,
       applynum,
       applydnum,
       creditnum,
       creditdnum,
       creditamount,
       cashnum,
       cashdnum,
       cashamount,
       newcashnum,
       newcashdnum,
       newcashamount,
       CASE
           WHEN max(CASE
                        WHEN a.extractday BETWEEN b.credit_date AND b.credit_end_date THEN '1'
                        ELSE '0'
                    END)=1 THEN '是'
           ELSE '否'
       END AS is_credit
FROM
  (SELECT a.*,
          CASE
              WHEN b.mbl_no IS NOT NULL THEN cashnum
          END newcashnum,
          CASE
              WHEN b.mbl_no IS NOT NULL THEN cashdnum
          END newcashdnum,
          CASE
              WHEN b.mbl_no IS NOT NULL THEN cashamount
          END newcashamount
   FROM warehouse_data_user_review_withdrawals_info AS a
   LEFT JOIN warehouse_data_user_review_info AS b ON a.data_source=b.data_source
   AND a.mbl_no=b.mbl_no
   AND a.product_name=b.product_name
   AND a.extractday=b.credit_time
   AND b.status='通过') AS a
LEFT JOIN warehouse_data_credit_start_to_end AS b ON a.data_source=b.data_source
AND a.mbl_no=b.mbl_no
AND a.product_name=b.product_name
WHERE a.extractday <= date_sub(current_date(),1)
  AND a.product_name IN('随借随还-钱包易贷',
                        '随借随还-马上',
                        '现金分期-中邮',
                        '现金分期-马上',
                        '现金分期-点点',
                        '现金分期-万达普惠',
                        '现金分期-兴业消费')
GROUP BY a.data_source,
         a.extractday,
         a.product_name,
         a.mbl_no,
         applynum,
         applydnum,
         creditnum,
         creditdnum,
         creditamount,
         cashnum,
         cashdnum,
         cashamount,
         newcashnum,
         newcashdnum,
         newcashamount;

--  非授信期用户转化漏斗 add 2018-12-28 update 2019-05-20
INSERT overwrite TABLE warehouse_data_product_creadituser_daily
SELECT a.data_source,
       a.extractday,
       a.product_name,
       sum(regnum) AS regnum,
       sum(chknum) AS chknum,
       sum(creditdnum) AS creditdnum,
       sum(applynum) AS applynum,
       sum(creditnum) AS creditnum,
       sum(creditamount) AS creditamount,
       sum(cashnum) AS cashnum,
       sum(cashamount) AS cashamount,
       sum(newcashnum) AS newcashnum,
       sum(newcashamount) AS newcashamount
FROM
  (SELECT a.data_source,
          a.extractday,
          a.product_name,
          regnum,
          chknum,
          creditdnum,
          0 AS applynum,
          0 AS creditnum,
          0 AS creditamount,
          0 AS cashnum,
          0 AS cashamount,
          0 AS newcashnum,
          0 AS newcashamount
   FROM warehouse_data_user_action_end AS a
   JOIN warehouse_data_daliy_report_new AS b ON a.data_source=b.data_source
   AND a.extractday=b.extractday
   WHERE a.extractday <= date_sub(current_date(),1)
   UNION ALL SELECT a.data_source,
                    a.extractday,
                    a.product_name,
                    0 AS regnum,
                    0 AS chknum,
                    0 AS creditdnum,
                    applynum AS applynum,
                    creditnum AS creditnum,
                    creditamount AS creditamount,
                    cashnum AS cashnum,
                    cashamount cashamount,
                    newcashnum AS newcashnum,
                    newcashamount AS newcashamount
   FROM warehouse_data_product_creadituser_detail AS a
   WHERE a.extractday <= date_sub(current_date(),1)
     AND is_credit='否') AS a
WHERE a.product_name IN('随借随还-钱包易贷',
                        '随借随还-马上',
                        '现金分期-中邮',
                        '现金分期-马上',
                        '现金分期-点点',
                        '现金分期-万达普惠',
                        '现金分期-兴业消费')
GROUP BY a.data_source,
         a.extractday,
         a.product_name;

-- 新注册30天内提现用户 add 2019-07-10
INSERT overwrite TABLE warehouse_data_user_30day_translation PARTITION(register_date)
SELECT a.data_source,
       a.the_2nd_level,
       a.the_3rd_level,
       NULL AS TYPE,
       -1 AS days,
       a.num,
       0 AS usernum,
       a.register_date
FROM warehouse_data_channel_user_sum AS a
WHERE a.register_date BETWEEN date_sub(current_date(),60) AND date_sub(current_date(),1)
UNION ALL
SELECT a.data_source,
       a.the_2nd_level,
       a.the_3rd_level,
       a.TYPE,
       a.days,
       0 AS dnum,
       count(DISTINCT mbl_no) AS usersccnum,
       a.register_date AS extracatday
FROM
  (SELECT a.data_source,
          a.the_2nd_level,
          a.the_3rd_level,
          a.mbl_no,
          a.register_date,
          '申请' AS TYPE,
          datediff(apply_time,register_date) AS days
   FROM
     (SELECT a.data_source,
             a.the_2nd_level,
             a.the_3rd_level,
             a.mbl_no,
             a.register_date,
             b.apply_time
      FROM warehouse_data_user_channel_info AS a
      JOIN warehouse_data_user_review_info AS b ON a.data_source=b.data_source
      AND a.mbl_no=b.mbl_no
      WHERE register_date BETWEEN date_sub(current_date(),60) AND date_sub(current_date(),1)) AS a
   WHERE (apply_time IS NULL
          OR datediff(apply_time,register_date)<=30)
   UNION ALL SELECT a.data_source,
                    a.the_2nd_level,
                    a.the_3rd_level,
                    a.mbl_no,
                    a.register_date,
                    '授信' AS TYPE,
                    datediff(credit_time,register_date) AS days
   FROM
     (SELECT a.data_source,
             a.mbl_no,
             a.the_2nd_level,
             a.the_3rd_level,
             a.register_date,
             if(status='通过',credit_time,NULL) AS credit_time
      FROM warehouse_data_user_channel_info AS a
      JOIN warehouse_data_user_review_info AS b ON a.data_source=b.data_source
      AND a.mbl_no=b.mbl_no
      WHERE register_date BETWEEN date_sub(current_date(),60) AND date_sub(current_date(),1)
        AND status='通过') AS a
   WHERE (credit_time IS NULL
          OR datediff(credit_time,register_date)<=30)
   UNION ALL SELECT a.data_source,
                    a.the_2nd_level,
                    a.the_3rd_level,
                    a.mbl_no,
                    a.register_date,
                    '放款' AS TYPE,
                    datediff(cash_time,register_date) AS days
   FROM
     (SELECT a.data_source,
             a.the_2nd_level,
             a.the_3rd_level,
             a.mbl_no,
             a.register_date,
             b.cash_time
      FROM warehouse_data_user_channel_info AS a
      JOIN warehouse_data_user_withdrawals_info AS b ON a.data_source=b.data_source
      AND a.mbl_no=b.mbl_no
      WHERE register_date BETWEEN date_sub(current_date(),60) AND date_sub(current_date(),1)) AS a
   WHERE datediff(cash_time,register_date)<=30) AS a
GROUP BY a.data_source,
         a.the_2nd_level,
         a.the_3rd_level,
         a.register_date,
         a.TYPE,
         a.days;

-- 钱包小贷蜂巢调用核对数据 add 2019-03-27 
INSERT overwrite TABLE warehouse_data_qbxd_apply_flow_data
SELECT extractday,
       TYPE,
       sum(regnum) AS regnum,
       sum(applynum) AS applynum,
       sum(regapplynum) AS regapplynum,
       sum(warrapplynumm) AS warrapplynumm
FROM
  (SELECT registe_date AS extractday,
          CASE
              WHEN province_desc = '江苏'
                   AND isp LIKE '%移动%' THEN '江苏移动'
              WHEN province_desc = '江苏'
                   AND isp LIKE '%联通%' THEN '江苏联通'
              WHEN province_desc = '江苏'
                   AND isp LIKE '%电信%' THEN '江苏电信'
              WHEN province_desc = '广东'
                   AND isp LIKE '%移动%' THEN '广东移动'
          END AS TYPE,
          COUNT(mbl_no) AS regnum,
          0 AS applynum,
          0 AS regapplynum,
          0 AS warrapplynumm
   FROM default.warehouse_atomic_user_info
   WHERE registe_date >= '2018-12-12'
   GROUP BY registe_date,
            CASE
                WHEN province_desc = '江苏'
                     AND isp LIKE '%移动%' THEN '江苏移动'
                WHEN province_desc = '江苏'
                     AND isp LIKE '%联通%' THEN '江苏联通'
                WHEN province_desc = '江苏'
                     AND isp LIKE '%电信%' THEN '江苏电信'
                WHEN province_desc = '广东'
                     AND isp LIKE '%移动%' THEN '广东移动'
            END
   UNION ALL SELECT apply_time,
                    CASE
                        WHEN province_desc = '江苏'
                             AND isp LIKE '%移动%' THEN '江苏移动'
                        WHEN province_desc = '江苏'
                             AND isp LIKE '%联通%' THEN '江苏联通'
                        WHEN province_desc = '江苏'
                             AND isp LIKE '%电信%' THEN '江苏电信'
                        WHEN province_desc = '广东'
                             AND isp LIKE '%移动%' THEN '广东移动'
                    END AS TYPE,
                    0 AS regnum,
                    COUNT(DISTINCT a.mbl_no) AS applynum,
                    COUNT(DISTINCT CASE
                                       WHEN a.apply_time = b.registe_date THEN a.mbl_no
                                   END) AS regapplynum,
                    COUNT(DISTINCT CASE
                                       WHEN b.registe_date >= '2019-01-01' THEN a.mbl_no
                                   END) AS warrapplynumm
   FROM default.warehouse_data_user_review_info a
   LEFT JOIN default.warehouse_atomic_user_info b ON a.data_source = b.data_source
   AND a.mbl_no = b.mbl_no
   WHERE product_name = '随借随还-钱包易贷'
     AND apply_time >= '2018-12-12'
   GROUP BY apply_time,
            CASE
                WHEN province_desc = '江苏'
                     AND isp LIKE '%移动%' THEN '江苏移动'
                WHEN province_desc = '江苏'
                     AND isp LIKE '%联通%' THEN '江苏联通'
                WHEN province_desc = '江苏'
                     AND isp LIKE '%电信%' THEN '江苏电信'
                WHEN province_desc = '广东'
                     AND isp LIKE '%移动%' THEN '广东移动'
            END) AS a
GROUP BY extractday,
         TYPE;

-- RFM模型数据处理 add 20190528        
INSERT overwrite TABLE warehouse_data_user_info_rfm
SELECT a.data_source,
       a.mbl_no,
       CASE
           WHEN datediff(current_date(), a.register_date) <=39 THEN 1
           WHEN datediff(current_date(), a.register_date) BETWEEN 40 AND 129 THEN 2
           WHEN datediff(current_date(), a.register_date) BETWEEN 130 AND 359 THEN 3
           ELSE 4
       END Rtype,
       CASE
           WHEN bround(cast(num/ceiling(months_between(current_date(), register_date)) AS decimal(12,3)),1) >=1 THEN 1
           WHEN bround(cast(num/ceiling(months_between(current_date(), register_date)) AS decimal(12,3)),1) >= 0.5
                AND bround(cast(num/ceiling(months_between(current_date(), register_date)) AS decimal(12,3)),1) < 1 THEN 2
           WHEN bround(cast(num/ceiling(months_between(current_date(), register_date)) AS decimal(12,3)),1) <0.5 THEN 3
       END Ftype,
       CASE
           WHEN cash_amount >9000 THEN 1
           WHEN cash_amount BETWEEN 4000 AND 9000 THEN 2
           ELSE 3
       END Mtype,
       current_date() AS etlday
FROM
  (SELECT a.data_source,
          a.mbl_no,
          a.register_date,
          count(1) AS num,
          max(b.extractday) AS last_cash_time,
          sum(b.cashamount) AS cash_amount
   FROM warehouse_data_user_channel_info AS a
   JOIN warehouse_data_user_review_withdrawals_info AS b ON a.data_source=b.data_source
   AND a.mbl_no=b.mbl_no
   WHERE b.extractday <= date_sub(current_date(),1)
     AND a.register_date <= date_sub(current_date(),1)
     AND b.cashnum>0
   GROUP BY a.data_source,
            a.mbl_no,
            a.register_date) AS a;

-- RFM模型数据处理 add 20190528
INSERT overwrite TABLE warehouse_data_user_channel_info
SELECT register_date,
       chk_date,
       a.data_source,
       is_new_jry,
       the_2nd_level,
       the_3rd_level,
       merger_chan,
       chan_no,
       chan_no_desc,
       child_chan,
       isp,
       province_desc,
       city_desc,
       a.mbl_no,
       pre,
       b.rtype,
       b.ftype,
       b.mtype,
       concat(b.rtype,b.ftype,b.mtype) AS rfmvalue,
       current_date() AS etlday
FROM warehouse_data_user_channel_info AS a
LEFT JOIN warehouse_data_user_info_rfm AS b ON a.data_source= b.data_source
AND a.mbl_no=b.mbl_no;

--运营周报产品分析明细数据 add 2019-06-14
INSERT overwrite TABLE warehouse_data_product_data_detail_analysis PARTITION(yearweeks,datatype)
SELECT min(extractday) AS extractday,
       '合计' AS data_source,
       '合计' AS product_name,
       count(DISTINCT mbl_no) AS allclickdnum,
       count(DISTINCT CASE
                          WHEN data_source='sjd' THEN mbl_no
                      END) AS sjdclickdnum,
       count(DISTINCT CASE
                          WHEN data_source='jry' THEN mbl_no
                      END) AS jryclickdnum,
       count(DISTINCT CASE
                          WHEN data_source='xyqb' THEN mbl_no
                      END) AS xyqbclickdnum,
       count(DISTINCT CASE
                          WHEN is_new='是' THEN mbl_no
                      END) AS allnewclickdnum,
       count(DISTINCT CASE
                          WHEN is_new='是'
                               AND data_source='sjd' THEN mbl_no
                      END) AS sjdnewclickdnum,
       count(DISTINCT CASE
                          WHEN is_new='是'
                               AND data_source='jry' THEN mbl_no
                      END) AS jrynewclickdnum,
       count(DISTINCT CASE
                          WHEN is_new='是'
                               AND data_source='xyqb' THEN mbl_no
                      END) AS xyqbnewclickdnum,
       0 AS applydnum,
       0 AS creditdnum,
       0 AS cashdnum,
       0 AS cashamount,
       current_date() AS etl_date,
       concat(year(a.extractday),'-',weekofyear(a.extractday)) AS yearweeks,
       'MD' AS datatype
FROM warehouse_data_user_action_day AS a
JOIN warehouse_data_analysis_product AS b ON a.product_name=b.product_name
WHERE applypv>0
  AND year(a.extractday)=year(current_date())
  AND weekofyear(a.extractday)>=weekofyear(current_date())-1
GROUP BY concat(year(a.extractday),'-',weekofyear(a.extractday))
UNION ALL
SELECT min(extractday) AS extractday,
       '合计' AS data_source,
       a.product_name,
       count(DISTINCT mbl_no) AS allclickdnum,
       count(DISTINCT CASE
                          WHEN data_source='sjd' THEN mbl_no
                      END) AS sjdclickdnum,
       count(DISTINCT CASE
                          WHEN data_source='jry' THEN mbl_no
                      END) AS jryclickdnum,
       count(DISTINCT CASE
                          WHEN data_source='xyqb' THEN mbl_no
                      END) AS xyqbclickdnum,
       count(DISTINCT CASE
                          WHEN is_new='是' THEN mbl_no
                      END) AS allnewclickdnum,
       count(DISTINCT CASE
                          WHEN is_new='是'
                               AND data_source='sjd' THEN mbl_no
                      END) AS sjdnewclickdnum,
       count(DISTINCT CASE
                          WHEN is_new='是'
                               AND data_source='jry' THEN mbl_no
                      END) AS jrynewclickdnum,
       count(DISTINCT CASE
                          WHEN is_new='是'
                               AND data_source='xyqb' THEN mbl_no
                      END) AS xyqbnewclickdnum,
       0 AS applydnum,
       0 AS creditdnum,
       0 AS cashdnum,
       0 AS cashamount,
       current_date() AS etl_date,
       concat(year(a.extractday),'-',weekofyear(a.extractday)) AS yearweeks,
       'MD' AS datatype
FROM warehouse_data_user_action_day AS a
JOIN warehouse_data_analysis_product AS b ON a.product_name=b.product_name
WHERE applypv>0
  AND year(a.extractday)=year(current_date())
  AND weekofyear(a.extractday)>=weekofyear(current_date())-1
GROUP BY concat(year(a.extractday),'-',weekofyear(a.extractday)),
         a.product_name
UNION ALL
SELECT min(extractday) AS extractday,
       a.data_source,
       a.product_name,
       count(DISTINCT mbl_no) AS allclickdnum,
       count(DISTINCT CASE
                          WHEN data_source='sjd' THEN mbl_no
                      END) AS sjdclickdnum,
       count(DISTINCT CASE
                          WHEN data_source='jry' THEN mbl_no
                      END) AS jryclickdnum,
       count(DISTINCT CASE
                          WHEN data_source='xyqb' THEN mbl_no
                      END) AS xyqbclickdnum,
       count(DISTINCT CASE
                          WHEN is_new='是' THEN mbl_no
                      END) AS allnewclickdnum,
       count(DISTINCT CASE
                          WHEN is_new='是'
                               AND data_source='sjd' THEN mbl_no
                      END) AS sjdnewclickdnum,
       count(DISTINCT CASE
                          WHEN is_new='是'
                               AND data_source='jry' THEN mbl_no
                      END) AS jrynewclickdnum,
       count(DISTINCT CASE
                          WHEN is_new='是'
                               AND data_source='xyqb' THEN mbl_no
                      END) AS xyqbnewclickdnum,
       0 AS applydnum,
       0 AS creditdnum,
       0 AS cashdnum,
       0 AS cashamount,
       current_date() AS etl_date,
       concat(year(a.extractday),'-',weekofyear(a.extractday)) AS yearweeks,
       'MD' AS datatype
FROM warehouse_data_user_action_day AS a
JOIN warehouse_data_analysis_product AS b ON a.product_name=b.product_name
WHERE applypv>0
  AND year(a.extractday)=year(current_date())
  AND weekofyear(a.extractday)>=weekofyear(current_date())-1
GROUP BY concat(year(a.extractday),'-',weekofyear(a.extractday)),
         a.data_source,
         a.product_name;


INSERT overwrite TABLE warehouse_data_product_data_detail_analysis PARTITION(yearweeks,datatype)
SELECT min(a.cash_time) AS extractday,
       '合计' AS data_source,
       '合计' AS product_name,
       0 AS allclickdnum,
       0 AS sjdclickdnum,
       0 AS jryclickdnum,
       0 AS xyqbclickdnum,
       0 AS allnewclickdnum,
       0 AS sjdnewclickdnum,
       0 AS jrynewclickdnum,
       0 AS xyqbnewclickdnum,
       0 AS applydnum,
       0 AS creditdnum,
       count(DISTINCT mbl_no) AS cashdnum,
       sum(cash_amount) AS cashamount,
       current_date() AS etl_date,
       concat(year(a.cash_time),'-',weekofyear(a.cash_time)) AS yearweeks,
       'YW' AS datatype
FROM warehouse_data_user_withdrawals_info AS a
JOIN warehouse_data_analysis_product AS b ON a.product_name=b.product_name
AND b.type='1'
WHERE year(a.cash_time)>=2019
GROUP BY concat(year(a.cash_time),'-',weekofyear(a.cash_time));


INSERT INTO TABLE warehouse_data_product_data_detail_analysis PARTITION(yearweeks,datatype)
SELECT min(a.apply_time) AS extractday,
       '合计' AS data_source,
       a.product_name,
       0 AS allclickdnum,
       0 AS sjdclickdnum,
       0 AS jryclickdnum,
       0 AS xyqbclickdnum,
       0 AS allnewclickdnum,
       0 AS sjdnewclickdnum,
       0 AS jrynewclickdnum,
       0 AS xyqbnewclickdnum,
       count(DISTINCT mbl_no) AS applydnum,
       0 AS creditdnum,
       0 AS cashdnum,
       0 AS cashamount,
       current_date() AS etl_date,
       concat(year(a.apply_time),'-',weekofyear(a.apply_time)) AS yearweeks,
       'YW' AS datatype
FROM warehouse_data_user_review_info AS a
JOIN warehouse_data_analysis_product AS b ON a.product_name=b.product_name
AND b.type='1'
WHERE year(a.apply_time)>=2019
GROUP BY concat(year(a.apply_time),'-',weekofyear(a.apply_time)),
         a.product_name
UNION ALL
SELECT min(a.apply_time) AS extractday,
       a.data_source,
       a.product_name,
       0 AS allclickdnum,
       0 AS sjdclickdnum,
       0 AS jryclickdnum,
       0 AS xyqbclickdnum,
       0 AS allnewclickdnum,
       0 AS sjdnewclickdnum,
       0 AS jrynewclickdnum,
       0 AS xyqbnewclickdnum,
       count(DISTINCT mbl_no) AS applydnum,
       0 AS creditdnum,
       0 AS cashdnum,
       0 AS cashamount,
       current_date() AS etl_date,
       concat(year(a.apply_time),'-',weekofyear(a.apply_time)) AS yearweeks,
       'YW' AS datatype
FROM warehouse_data_user_review_info AS a
JOIN warehouse_data_analysis_product AS b ON a.product_name=b.product_name
WHERE year(a.apply_time)>=2019
GROUP BY concat(year(a.apply_time),'-',weekofyear(a.apply_time)),
         a.data_source,
         a.product_name ;


INSERT INTO TABLE warehouse_data_product_data_detail_analysis PARTITION(yearweeks,datatype)
SELECT min(a.credit_time) AS extractday,
       '合计' AS data_source,
       a.product_name,
       0 AS allclickdnum,
       0 AS sjdclickdnum,
       0 AS jryclickdnum,
       0 AS xyqbclickdnum,
       0 AS allnewclickdnum,
       0 AS sjdnewclickdnum,
       0 AS jrynewclickdnum,
       0 AS xyqbnewclickdnum,
       0 AS applydnum,
       count(DISTINCT mbl_no) AS creditdnum,
       0 AS cashdnum,
       0 AS cashamount,
       current_date() AS etl_date,
       concat(year(a.credit_time),'-',weekofyear(a.credit_time)) AS yearweeks,
       'YW' AS datatype
FROM warehouse_data_user_review_info AS a
JOIN warehouse_data_analysis_product AS b ON a.product_name=b.product_name
AND b.type='1'
WHERE a.status = '通过'
  AND year(a.credit_time)>=2019
GROUP BY concat(year(a.credit_time),'-',weekofyear(a.credit_time)),
         a.product_name
UNION ALL
SELECT min(a.credit_time) AS extractday,
       a.data_source,
       a.product_name,
       0 AS allclickdnum,
       0 AS sjdclickdnum,
       0 AS jryclickdnum,
       0 AS xyqbclickdnum,
       0 AS allnewclickdnum,
       0 AS sjdnewclickdnum,
       0 AS jrynewclickdnum,
       0 AS xyqbnewclickdnum,
       0 AS applydnum,
       count(DISTINCT mbl_no) AS creditdnum,
       0 AS cashdnum,
       0 AS cashamount,
       current_date() AS etl_date,
       concat(year(a.credit_time),'-',weekofyear(a.credit_time)) AS yearweeks,
       'YW' AS datatype
FROM warehouse_data_user_review_info AS a
JOIN warehouse_data_analysis_product AS b ON a.product_name=b.product_name
WHERE a.status = '通过'
  AND year(a.credit_time)>=2019
GROUP BY concat(year(a.credit_time),'-',weekofyear(a.credit_time)),
         a.data_source,
         a.product_name;

INSERT INTO TABLE warehouse_data_product_data_detail_analysis PARTITION(yearweeks,datatype)
SELECT min(a.cash_time) AS extractday,
       '合计' AS data_source,
       a.product_name,
       0 AS allclickdnum,
       0 AS sjdclickdnum,
       0 AS jryclickdnum,
       0 AS xyqbclickdnum,
       0 AS allnewclickdnum,
       0 AS sjdnewclickdnum,
       0 AS jrynewclickdnum,
       0 AS xyqbnewclickdnum,
       0 AS applydnum,
       0 AS creditdnum,
       count(DISTINCT mbl_no) AS cashdnum,
       sum(cast(cash_amount AS decimal(10,2))) AS cashamount,
       current_date() AS etl_date,
       concat(year(a.cash_time),'-',weekofyear(a.cash_time)) AS yearweeks,
       'YW' AS datatype
FROM warehouse_data_user_withdrawals_info AS a
JOIN warehouse_data_analysis_product AS b ON a.product_name=b.product_name
AND b.type='1'
WHERE cash_amount>0
  AND year(a.cash_time)>=2019
GROUP BY concat(year(a.cash_time),'-',weekofyear(a.cash_time)),
         a.product_name
UNION ALL
SELECT min(a.cash_time) AS extractday,
       a.data_source,
       a.product_name,
       0 AS allclickdnum,
       0 AS sjdclickdnum,
       0 AS jryclickdnum,
       0 AS xyqbclickdnum,
       0 AS allnewclickdnum,
       0 AS sjdnewclickdnum,
       0 AS jrynewclickdnum,
       0 AS xyqbnewclickdnum,
       0 AS applydnum,
       0 AS creditdnum,
       count(DISTINCT mbl_no) AS cashdnum,
       sum(cast(cash_amount AS decimal(10,2))) AS cashamount,
       current_date() AS etl_date,
       concat(year(a.cash_time),'-',weekofyear(a.cash_time)) AS yearweeks,
       'YW' AS datatype
FROM warehouse_data_user_withdrawals_info AS a
JOIN warehouse_data_analysis_product AS b ON a.product_name=b.product_name
WHERE cash_amount>0
  AND year(a.cash_time)>=2019
GROUP BY concat(year(a.cash_time),'-',weekofyear(a.cash_time)),
         a.data_source,
         a.product_name;

-- 三平台用户转化数据(周报分析) add 2019-06-14
INSERT overwrite TABLE warehouse_data_product_data_analysis PARTITION(yearweeks)
SELECT data_source,
       product_name,
       min(extractday) AS extractday,       
       sum(allclickdnum) AS allclickdnum,
       sum(sjdclickdnum) AS sjdclickdnum,
       sum(jryclickdnum) AS jryclickdnum,
       sum(xyqbclickdnum) AS xyqbclickdnum,
       sum(allnewclickdnum) AS allnewclickdnum,
       sum(sjdnewclickdnum) AS sjdnewclickdnum,
       sum(jrynewclickdnum) AS jrynewclickdnum,
       sum(xyqbnewclickdnum) AS xyqbnewclickdnum,
       sum(applydnum) AS applydnum,
       sum(creditdnum) AS creditdnum,
       sum(cashdnum) AS cashdnum,
       sum(cashamount) AS cashamount,
       current_date() AS etl_date,
       yearweeks
FROM warehouse_data_product_data_detail_analysis AS a
GROUP BY yearweeks,
         data_source,
         product_name;

-- 三平台推送数据周汇总结果表(周报分析) add 2019-06-14
INSERT overwrite TABLE warehouse_data_user_action_end_weekly_analysis PARTITION (years,weeks)
SELECT a.data_source,
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
                      END) AS creditdnum,
       min(extractday) AS extractday,
       current_date() AS etl_date,
       year(a.extractday) AS years,
       weekofyear(a.extractday) AS weeks
FROM warehouse_data_user_action_sum AS a
WHERE applypv>0
  AND year(extractday) >= 2019
  AND weekofyear(extractday) = weekofyear(date_sub(current_date(),1))
GROUP BY year(a.extractday),
         weekofyear(a.extractday),
         a.data_source,
         a.product_name;

-- 三平台新用户转化数据(周报分析) add 2019-06-14       
INSERT overwrite TABLE warehouse_data_product_newuser_weekly_analysis PARTITION (years,weeks)
SELECT a.data_source,
       min(a.extractday) AS extractday,
       a.product_name,
       sum(regnum) AS regnum,
       sum(chknum) AS chknum,
       sum(newdnum) AS newdnum,
       sum(applynum) AS applynum,
       sum(creditnum) AS creditnum,
       sum(creditamount) AS creditamount,
       sum(cashnum) AS cashnum,
       sum(cashamount) AS cashamount,
       sum(incomeamount) AS income_amount,
       current_date() as etl_date,
       a.years,
       a.weeks
FROM
  (SELECT a.data_source,
          a.extractday,
          a.product_name,
          0 AS regnum,
          0 AS chknum,
          newdnum,
          0 AS applynum,
          0 AS creditnum,
          0 AS creditamount,
          0 AS cashnum,
          0 AS cashamount,
          0 AS incomeamount,
          a.years,
          a.weeks
   FROM warehouse_data_user_action_end_weekly_analysis AS a
   WHERE a.product_name IS NOT NULL
   UNION ALL SELECT data_source,
                    min(extractday) AS extractday,
                    '注册实名' AS product_name,
                    sum(regnum) AS regnum,
                    sum(chknum) AS chknum,
                    0 AS newdnum,
                    0 AS applynum,
                    0 AS creditnum,
                    0 AS credit_amount,
                    0 AS cashnum,
                    0 AS cash_amount,
                    0 AS income_amount,
                    year(extractday) AS years,
                    weekofyear(extractday) AS weeks
   FROM warehouse_data_daliy_report_new AS a
   WHERE a.extractday BETWEEN '2019-01-01' AND date_sub(current_date(),1)
   GROUP BY data_source,
            year(extractday),
            weekofyear(extractday)
   UNION ALL SELECT a.data_source,
                    min(a.extractday) AS extractday,
                    a.product_name,
                    0 AS regnum,
                    0 AS chknum,
                    0 AS newdnum,
                    sum(cast(a.applydnum AS decimal(12,2))) AS applynum,
                    sum(cast(a.creditdnum AS decimal(12,2))) AS creditnum,
                    sum(a.creditamount) AS credit_amount,
                    sum(cast(a.cashdnum AS decimal(12,2))) AS cashnum,
                    sum(a.cashamount) AS cash_amount,
                    sum(a.cashamount*if(c.pre IS NULL,0,c.pre/100)) AS income_amount,
                    year(a.extractday),
                    weekofyear(a.extractday)
   FROM warehouse_data_user_review_withdrawals_info AS a
   JOIN warehouse_data_user_channel_info AS b ON a.data_source=b.data_source
   AND a.mbl_no=b.mbl_no
   AND year(a.extractday)=year(b.register_date)
   AND weekofyear(a.extractday)=weekofyear(b.register_date)
   LEFT JOIN warehouse_data_product_income_pre AS c ON a.product_name=c.product_name
   WHERE a.extractday BETWEEN '2019-01-01' AND date_sub(current_date(),1)
     AND a.product_name IS NOT NULL
   GROUP BY a.data_source,
            a.product_name,
            year(a.extractday),
            weekofyear(a.extractday)) AS a
GROUP BY a.data_source,
         a.product_name,
         years,
         weeks;
