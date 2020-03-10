-- T+1������ɺ󣬿�ʼ����
-- ���뼰�������ݸ��� update 2018-11-08
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
          '����滹-Ǯ���״�' product_name,
                      CASE
                          WHEN appral_res = 'ͨ��' THEN 'ͨ��'
                          WHEN appral_res =''
                               AND status IN('apply_success',
                                             'freeze') THEN 'ͨ��'
                          ELSE 'δͨ��'
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
                      '�ֽ����-����' product_name,
                                CASE
                                    WHEN approve_status='����ͨ��' THEN 'ͨ��'
                                    ELSE 'δͨ��'
                                END status,
                                cast(approve_amount AS decimal(12,2))/100 AS amount
      FROM default.warehouse_atomic_zhongyou_review_result_info
      WHERE not(apply_time BETWEEN '2018-06-28' AND '2018-07-28'
                AND data_source IS NULL)) AS a
   UNION ALL SELECT mbl_no,
                    data_source,
                    lending_time,
                    lending_time AS credit_time,
                    '�ֽ����-С���' product_name,
                               CASE
                                   WHEN status='success' THEN 'ͨ��'
                                   ELSE 'δͨ��'
                               END status,
                               cast(applyamount AS decimal(12,2)) AS amount
   FROM default.warehouse_atomic_xiaoyudian_withdrawals_result_info
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(apply_time,1,10) AS apply_time,
                    substr(loan_time,1,10) AS loan_time,
                    '�ֽ����-������' product_name,
                               CASE
                                   WHEN contract_status='����ɹ�' THEN 'ͨ��'
                                   ELSE 'δͨ��'
                               END status,
                               cast(loan_amount AS decimal(12,2)) AS amount
   FROM default.warehouse_atomic_lkl_withdrawals_result_info
   UNION ALL SELECT if(mbl_no IS NULL,mbl_no_md5,mbl_no) AS mbl_no,
                    data_source,
                    substr(appl_time,1,10) AS apply_time,
                    substr(credit_time,1,10) AS credit_time,
                    '����滹-����' product_name,
                              CASE
                                  WHEN appral_res='ͨ��' THEN 'ͨ��'
                                  ELSE 'δͨ��'
                              END status,
                              cast(acc_lim AS decimal(12,2))/100 AS amount
   FROM default.warehouse_atomic_msd_review_result_info
   UNION ALL SELECT if(mbl_no IS NULL,mbl_no_md5,mbl_no) AS mbl_no,
                    data_source,
                    apply_time,
                    substr(approval_time,1,10) AS approval_time,
                    '�ֽ����-����' product_name,
                              CASE
                                  WHEN approval_status IN('A',
                                                          'N') THEN 'ͨ��'
                                  ELSE 'δͨ��'
                              END status,
                              cast(approval_amount AS decimal(12,2))/100 AS amount
   FROM default.warehouse_atomic_msd_cashord_result_info
   UNION ALL SELECT DISTINCT mbl_no,
                             data_source,
                             apply_time,
                             apply_time AS approval_time,
                             '�ֽ����-���' product_name,
                                       CASE
                                           WHEN status_code='0' THEN 'ͨ��'
                                           ELSE 'δͨ��'
                                       END status,
                                       cast(total_limit AS decimal(12,2))/100 AS amount
   FROM default.warehouse_atomic_diandian_review_result_info
   UNION ALL SELECT mbl_no,
                    data_source,
                    concat(substr(apply_time,1,4),'-',substr(apply_time,5,2),'-',substr(apply_time,7,2)) AS apply_time,
                    concat(substr(apply_time,1,4),'-',substr(apply_time,5,2),'-',substr(apply_time,7,2)) AS creadit_time,
                    CASE
                        WHEN product_code='XJXE001' THEN '���ڴ�-����'
                        WHEN product_code='XJBL001' THEN '�����-����'
                        WHEN product_code='XJDQD01' THEN '���ڴ�-����'
                        WHEN product_code='XJYZ001' THEN 'ҵ����-����'
                        WHEN product_code='XJGJJ01' THEN '�������籣��-����'
                    END product_name,
                    CASE
                        WHEN result_desc='����ɹ�' THEN 'ͨ��'
                        ELSE 'δͨ��'
                    END status,
                    cast(credit_limit AS decimal(12,2)) AS amount
   FROM default.warehouse_atomic_zhaolian_review_result_info
   WHERE apply_status_desc != 'δ�ύ����'
   UNION ALL SELECT b.mbl_no,
                    a.data_source,
                    substr(a.limit_apply_time,1,10) AS apply_time,
                    substr(a.limit_apply_time,1,10) AS creadit_time,
                    '����滹-�ڰ�' product_name,
                              CASE
                                  WHEN limit_apply_status='pass' THEN 'ͨ��'
                                  ELSE 'δͨ��'
                              END status,
                              cast(credit_amount AS decimal(12,2)) AS amount
   FROM default.warehouse_atomic_zhongan_review_result_info AS a
   JOIN default.warehouse_atomic_user_info AS b ON a.data_source=b.data_source
   AND a.apply_mobile=b.mbl_no_md5
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(approvetime,1,10) AS apply_time,
                    substr(approvetime,1,10) AS credit_time,
                    '�ֽ����-��ҵ����' product_name,
                                CASE
                                    WHEN resultcode='SUCCESS' THEN 'ͨ��'
                                    ELSE 'δͨ��'
                                END status,
                                cast(fixedlimit AS decimal(12,2))/100 AS amount
   FROM default.warehouse_atomic_xsyd_review_result_info
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(apply_time,1,10) AS apply_time,
                    substr(finish_time,1,10) AS credit_time,
                    '�ֽ����-����ջ�' product_name,
                                CASE
                                    WHEN substr(finish_time,1,1) >= '1' THEN 'ͨ��'
                                    ELSE 'δͨ��'
                                END AS status,
                                if(loan_amt>0,loan_amt,0) AS amount
   FROM default.warehouse_atomic_wanda_loan_info
   WHERE substr(apply_time,1,1)='2'
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(applytime,1,10) AS apply_time,
                    if(approvalamount>0,substr(applytime,1,10),NULL) credit_time,
                    '����Ǯ��' AS product_name,
                    if(approvalamount>0,'ͨ��','δͨ��') AS status,
                    if(approvalamount>0,approvalamount,0) AS amount
   FROM default.warehouse_atomic_lhp_review_result_info
   UNION ALL SELECT mblno,
                    datasource,
                    substr(applytime,1,10) AS apply_time,
                    if(approvalstatus=1,substr(applytime,1,10),NULL) credit_time,
                    '�ֽ����-Ǯ��' AS product_name,
                    if(approvalstatus=1,'ͨ��','δͨ��') AS status,
                    creditamount AS amount
   FROM default.warehouse_atomic_wacai_loan_info
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(apply_time,1,10) AS apply_time,
                    if(fixed_limit>0,substr(approve_time,1,10),NULL) credit_time,
                    '�ֽ����-����' AS product_name,
                    if(fixed_limit>0,'ͨ��','δͨ��') AS status,
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
                    '���ǽ�' AS product_name,
                    if(credit_status=3,'ͨ��','δͨ��') AS status,
                    if(credit_status=3,cast(credit_amt AS decimal(12,2))/100,0) AS amount
   FROM default.warehouse_atomic_yzj_review_result_info AS a
   WHERE credit_status != 1) AS a;

-- �����������Ż������� update 2018-11-15
INSERT overwrite TABLE warehouse_data_user_review_withdrawals_sum
SELECT '����' AS data_type,
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
SELECT '����' AS data_type,
       credit_time,
       data_source,
       product_name,
       count(1) AS num,
       count(DISTINCT mbl_no) AS dnum,
       sum(amount) AS amount
FROM warehouse_data_user_review_info AS a
WHERE status='ͨ��'
GROUP BY credit_time,
         data_source,
         product_name;

-- �����Ҫ��Ʒ���ż���Ч������ update 2018-11-08
INSERT overwrite TABLE warehouse_data_credit_start_to_end
SELECT DISTINCT *
FROM
  (SELECT data_source,
          mbl_no,
          appl_time,
          substr(b.credit_time,1,10) AS credit_time,
          '����滹-Ǯ���״�' AS product_name,
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
                    '����滹-����' AS product_name,
                    cast(date_add(substr(b.credit_time,1,10),1) AS string) AS credit_date,
                    add_months(substr(b.paid_out_time,1,10),12) AS credit_end_date
   FROM default.warehouse_atomic_msd_withdrawals_result_info AS b
   WHERE paid_out_time is not null
   UNION ALL SELECT data_source,
                    mbl_no,
                    apply_time,
                    approve_time AS credit_time,
                    '�ֽ����-����' AS product_name,
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
   WHERE approve_status='����ͨ��'
   UNION ALL SELECT data_source,
                    if(mbl_no IS NULL,mbl_no_md5,mbl_no) AS mbl_no,
                    apply_time,
                    substr(approval_time,1,10) AS credit_time,
                    '�ֽ����-����' AS product_name,
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
                    '�ֽ����-���' AS product_name,
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
   WHERE a.message = '�ɹ�'
   UNION ALL  SELECT data_source,
            mbl_no,
            substr(apply_time,1,10) AS apply_time,
            substr(finish_time,1,10) AS credit_time,
            '�ֽ����-����ջ�' AS product_name,
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
                    '�ֽ����-��ҵ����' AS product_name,
                    cast(date_add(substr(approvetime,1,10),1) AS string) AS credit_date,
                    substr(expiredate,1,10) AS expiredate
   FROM default.warehouse_atomic_xsyd_review_result_info AS b
   WHERE resultcode='SUCCESS') AS a
WHERE date(credit_time) <= date(current_date());

-- �ӵ����������is_credit�����û���� update 20181114
INSERT overwrite TABLE warehouse_data_user_action_sum PARTITION(extractday)
SELECT a.data_source,
       a.product_name,
       a.mbl_no,
       a.is_new,
       if(b.is_credit=1,'��','��') AS is_credit,
       a.allpv,
       a.marketpv,
       a.detailpv,
       a.applypv,
       a.institupv,
       a.bannerpv,
       if(a.applypv>0,'��','��') AS is_apply,
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

-- �������ݻ��ܽ���� update 2019-02-22 
INSERT overwrite TABLE warehouse_data_user_action_end PARTITION (extractday)
SELECT if(a.data_source='jry','xyqb',a.data_source) as data_source,
       a.product_name,
       sum(applypv) AS num,
       count(DISTINCT mbl_no) AS dnum,
       sum(CASE
               WHEN is_new='��' THEN applypv
           END) AS newnum,
       count(DISTINCT CASE
                          WHEN is_new='��' THEN mbl_no
                      END) AS newdnum,
       sum(CASE
               WHEN is_credit='��' THEN applypv
           END) AS creditnum,
       count(DISTINCT CASE
                          WHEN is_credit='��' THEN mbl_no
                      END) AS creditdnum,
       a.extractday
FROM warehouse_data_user_action_sum AS a
WHERE applypv>0
  AND extractday = date_sub(current_date(),1)
GROUP BY a.extractday,
         if(a.data_source='jry','xyqb',a.data_source),
         a.product_name;
         
-- �������ݻ��ܽ����(��ƽ̨) add 2019-02-21
INSERT overwrite TABLE warehouse_data_user_action_end_new PARTITION (extractday)
SELECT a.data_source,
       a.product_name,
       sum(applypv) AS num,
       count(DISTINCT mbl_no) AS dnum,
       sum(CASE
               WHEN is_new='��' THEN applypv
           END) AS newnum,
       count(DISTINCT CASE
                          WHEN is_new='��' THEN mbl_no
                      END) AS newdnum,
       sum(CASE
               WHEN is_credit='��' THEN applypv
           END) AS creditnum,
       count(DISTINCT CASE
                          WHEN is_credit='��' THEN mbl_no
                      END) AS creditdnum,
       a.extractday
FROM warehouse_data_user_action_sum AS a
WHERE applypv>0
  AND extractday = date_sub(current_date(),1)
GROUP BY a.extractday,
         a.data_source,
         a.product_name;

-- ���������ܻ��ܽ����(��ƽ̨)-�����ֲ�Ʒ add 2019-03-21 update 2019-05-20
INSERT overwrite TABLE warehouse_data_user_action_end_weekly_noproduct PARTITION (YEAR,week)
SELECT a.data_source,
       sum(applypv) AS num,
       count(DISTINCT mbl_no) AS dnum,
       sum(CASE
               WHEN is_new='��' THEN applypv
           END) AS newnum,
       count(DISTINCT CASE
                          WHEN is_new='��' THEN mbl_no
                      END) AS newdnum,
       sum(CASE
               WHEN is_credit='��' THEN applypv
           END) AS creditnum,
       count(DISTINCT CASE
                          WHEN is_credit='��' THEN mbl_no
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
         
-- ���������ܻ��ܽ����(��ƽ̨) add 2019-03-21 update 2019-05-20
INSERT overwrite TABLE warehouse_data_user_action_end_weekly PARTITION (YEAR,week)
SELECT a.data_source,
       a.product_name,
       sum(applypv) AS num,
       count(DISTINCT mbl_no) AS dnum,
       sum(CASE
               WHEN is_new='��' THEN applypv
           END) AS newnum,
       count(DISTINCT CASE
                          WHEN is_new='��' THEN mbl_no
                      END) AS newdnum,
       sum(CASE
               WHEN is_credit='��' THEN applypv
           END) AS creditnum,
       count(DISTINCT CASE
                          WHEN is_credit='��' THEN mbl_no
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

-- �ſ����ݸ���update 2018-11-08
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
          '����滹-Ǯ���״�' AS product_name
   FROM default.warehouse_atomic_qianbao_withdrawals_result_info AS b
   WHERE status IN('overdue',
                   'repaying',
                   'settled')
   UNION ALL SELECT if(mbl_no IS NULL,mbl_no_md5,mbl_no) AS mbl_no,
                    data_source,
                    msd_return_time,
                    cast(total_amount AS decimal(12,2))/100 AS cash_amount,
                    '����滹-����' AS product_name
   FROM default.warehouse_atomic_msd_withdrawals_result_info
   WHERE total_amount>0
     AND msd_return_time IS NOT NULL
   UNION ALL SELECT mbl_no,
                    if(length(data_source)>0,data_source,'sjd') AS data_source,
                    loan_time,
                    cast(loan_amount AS decimal(12,2)) AS cash_amount,
                    '�ֽ����-����' AS product_name
   FROM default.warehouse_atomic_zhongyou_withdrawals_result_info
   WHERE loan_state='MAKELOAN_SUCCESS'
   UNION ALL SELECT if(mbl_no IS NULL,mbl_no_md5,mbl_no) AS mbl_no,
                    data_source,
                    substr(approval_time,1,10) AS lending_time,
                    cast(approval_amount AS decimal(12,2))/100 AS cash_amount,
                    '�ֽ����-����' AS product_name
   FROM default.warehouse_atomic_msd_cashord_result_info
   WHERE approval_status IN('N')
   UNION ALL SELECT mbl_no,
                    data_source,
                    lending_time,
                    cast(applyamount AS decimal(12,2)) AS applyamount,
                    '�ֽ����-С���' AS product_name
   FROM default.warehouse_atomic_xiaoyudian_withdrawals_result_info
   WHERE status='success'
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(loan_time,1,10) AS loan_time,
                    cast(loan_amount AS decimal(12,2)) AS loan_amount,
                    '�ֽ����-������' product_name
   FROM default.warehouse_atomic_lkl_withdrawals_result_info
   WHERE contract_status='����ɹ�'
   UNION ALL SELECT mbl_no,
                    data_source,
                    lending_time,
                    cast(loan_amount AS decimal(12,2))/100 AS loan_amount,
                    '�ֽ����-���' product_name
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
                                           'XJBL001') THEN '�����-����'
                        WHEN product_no IN('P0000222',
                                           'XJYZ001') THEN 'ҵ����-����'
                        WHEN product_no IN('XJDQD01') THEN '���ڴ�-����'
                        WHEN product_no IN('P0048796') THEN '�������籣��-����'
                        WHEN product_no IN('P0000132') THEN '���ڴ�-����'
                        ELSE '���ڴ�-����'
                    END product_name
   FROM default.warehouse_atomic_zhaolian_withdrawals_result_info
   WHERE order_status_desc!='�ѽ���'
   UNION ALL SELECT b.mbl_no,
                    a.data_source,
                    substr(a.loan_out_time,1,10) AS loan_time,
                    cast(loan_amount AS decimal(12,2)) AS loan_amount,
                    '����滹-�ڰ�' AS product_name
   FROM default.warehouse_atomic_zhongan_withdrawals_result_info AS a
   JOIN default.warehouse_atomic_user_info AS b ON a.data_source=b.data_source
   AND a.apply_mobile=b.mbl_no_md5
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(paymentdate,1,10) AS paymentdate,
                    cast(loanamt AS decimal(12,2))/100 AS amount,
                    '�ֽ����-��ҵ����' product_name
   FROM default.warehouse_atomic_xsyd_withdrawals_result_info
   WHERE paymentstatus='SUCCESS'
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(loan_date,1,10) AS loan_date,
                    if(loan_amt>0,loan_amt,0) AS amount,
                    '�ֽ����-����ջ�' product_name
   FROM default.warehouse_atomic_wanda_loan_info AS a
   WHERE loan_amt>0
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(loanstatustime,1,10) AS loan_date,
                    loanamount AS amount,
                    '����Ǯ��'AS product_name
   FROM default.warehouse_atomic_lhp_withdrawals_result_info AS a
   WHERE loanamount>0
   UNION ALL SELECT mblno,
                    datasource,
                    substr(loantime,1,10) AS loan_date,
                    loanamount AS amount,
                    '�ֽ����-Ǯ��'AS product_name
   FROM default.warehouse_atomic_wacai_loan_info AS a
   WHERE loanstatue=1
   UNION ALL SELECT mbl_no,
                    data_source,
                    substr(payment_date,1,10) AS payment_date,
                    loan_amt AS amount,
                    '�ֽ����-����' AS product_name
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
                    '���ǽ�' AS product_name
   FROM default.warehouse_atomic_yzj_withdrawals_result_info AS a
   WHERE credit_status=1) AS a ;

-- �ſ����ݻ��ܸ���
INSERT INTO TABLE warehouse_data_user_review_withdrawals_sum
SELECT '�ſ�' AS data_type,
       cash_time,
       data_source,
       product_name,
       count(1) AS num,
       count(DISTINCT mbl_no) AS dnum,
       sum(cash_amount) AS cash_amount
FROM warehouse_data_user_withdrawals_info AS a
GROUP BY cash_time,
         data_source,
         product_name;
         
-- �������ŷſ�������ϸ add 2019-03-27
INSERT overwrite TABLE warehouse_data_user_review_withdrawals_info
SELECT a.extractday,
       COALESCE(b.data_source,a.data_source) AS data_source,
       a.product_name,
       the_2nd_level,
       the_3rd_level,
       a.mbl_no,
       1 AS pre,
       COUNT(CASE
                 WHEN data_type='����' THEN a.mbl_no
             END) AS applynum,
       COUNT(DISTINCT CASE
                          WHEN data_type='����' THEN a.mbl_no
                      END) AS applydnum,
       COUNT(CASE
                 WHEN data_type='����' THEN a.mbl_no
             END) AS creditnum,
       COUNT(DISTINCT CASE
                          WHEN data_type='����' THEN a.mbl_no
                      END) AS creditdnum,
       sum(CASE
               WHEN data_type='����' THEN amount
               ELSE 0
           END) AS creditamount,
       COUNT(CASE
                 WHEN data_type='�ſ�' THEN a.mbl_no
             END) AS cashnum,
       COUNT(DISTINCT CASE
                          WHEN data_type='�ſ�' THEN a.mbl_no
                      END) AS cashdnum,
       sum(CASE
               WHEN data_type='�ſ�' THEN amount
               ELSE 0
           END) AS cashamount
FROM
  (SELECT '����' AS data_type,
          a.data_source,
          a.apply_time AS extractday,
          a.product_name,
          a.mbl_no,
          0 AS amount
   FROM warehouse_data_user_review_info AS a
   WHERE apply_time<=date_sub(current_date(),1)
   UNION ALL SELECT '����' AS data_type,
                    a.data_source,
                    credit_time AS extractday,
                    a.product_name,
                    a.mbl_no,
                    if(amount IS NULL,0,amount) AS amount
   FROM warehouse_data_user_review_info AS a
   WHERE a.status='ͨ��'
     AND credit_time<=date_sub(current_date(),1)
   UNION ALL SELECT '�ſ�' AS data_type,
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
         a.mbl_no;

-- ƽ̨�ۼ����� add 2018-10-25 update 2019-03-27
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
          count(if(data_type='ע��',mbl_no,NULL)) AS regnum,
          count(if(data_type='ʵ��',mbl_no,NULL)) AS chknum,
          0 AS applynum,
          0 AS applydnum,
          0 AS creditnum,
          0 AS creditdnum,
          0 AS creditamount,
          0 AS cashnum,
          0 AS cashdnum,
          0 AS cashamount
   FROM
     (SELECT 'ע��' AS data_type,
             data_source,
             register_date AS extractday,
             mbl_no
      FROM warehouse_data_user_channel_info AS a
      WHERE register_date<=date_sub(current_date(),1)
      UNION ALL SELECT 'ʵ��' AS data_type,
                       data_source,
                       chk_date AS data_date,
                       mbl_no
      FROM warehouse_data_user_channel_info AS a
      WHERE chk_date<=date_sub(current_date(),1) )AS a
   GROUP BY data_source
   UNION ALL SELECT data_source,
                    0 AS regnum,
                    0 AS chknum,
                    sum(applynum*pre) AS applynum,
                    sum((applydnum/num1)*pre) AS applydnum,
                    sum(creditnum*pre) AS creditnum,
                    sum((creditdnum/num2)*pre) AS creditdnum,
                    sum(creditamount*pre) AS creditamount,
                    sum(cashnum*pre) AS cashnum,
                    sum((cashdnum/num3)*pre) AS cashdnum,
                    sum(cashamount*pre) AS cashamount
   FROM
     (SELECT sum(if(applynum>0,1,0)) over(partition BY data_source,mbl_no) AS num1,
             sum(if(creditnum>0,1,0)) over(partition BY data_source,mbl_no) AS num2,
             sum(if(cashnum>0,1,0)) over(partition BY data_source,mbl_no) AS num3,
             *
      FROM warehouse_data_user_review_withdrawals_info) AS a
   WHERE extractday<=date_sub(current_date(),1)
   GROUP BY data_source) AS a
GROUP BY data_source;

-- ÿ���û����� add 2018-10-25 update 2019-03-27
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
          count(if(data_type='ע��',mbl_no,NULL)) AS regnum,
          count(if(data_type='ʵ��',mbl_no,NULL)) AS chknum,
          0 AS applynum,
          0 AS applydnum,
          0 AS creditnum,
          0 AS creditdnum,
          0 AS creditamount,
          0 AS cashnum,
          0 AS cashdnum,
          0 AS cashamount
   FROM
     (SELECT 'ע��' AS data_type,
             data_source,
             register_date AS extractday,
             mbl_no
      FROM warehouse_data_user_channel_info AS a
      WHERE register_date<=date_sub(current_date(),1)
      UNION ALL SELECT 'ʵ��' AS data_type,
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
                    sum(applynum*pre) AS applynum,
                    sum((cast(applydnum as decimal(12,2))/num1)*pre) AS applydnum,
                    sum(creditnum*pre) AS creditnum,
                    sum((cast(creditdnum as decimal(12,2))/num2)*pre) AS creditdnum,
                    sum(creditamount*pre) AS creditamount,
                    sum(cashnum*pre) AS cashnum,
                    sum((cast(cashdnum as decimal(12,2))/num3)*pre) AS cashdnum,
                    sum(cashamount*pre) AS cashamount
   FROM
     (SELECT sum(if(applynum>0,1,0)) over(partition BY data_source,extractday,mbl_no) AS num1,
             sum(if(creditnum>0,1,0)) over(partition BY data_source,extractday,mbl_no) AS num2,
             sum(if(cashnum>0,1,0)) over(partition BY data_source,extractday,mbl_no) AS num3,
             *
      FROM warehouse_data_user_review_withdrawals_info
      where pre>0) AS a
   WHERE extractday<=date_sub(current_date(),1)
   GROUP BY data_source,
            extractday) AS a
GROUP BY data_source,
         extractday,
         substr(extractday,1,7);

-- ÿ���û����� add 2018-11-07 update 2018-11-29
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
          count(if(data_type='ע��',mbl_no,NULL)) AS regnum,
          count(if(data_type='ʵ��',mbl_no,NULL)) AS chknum,
          0 AS applynum,
          0 AS applydnum,
          0 AS creditnum,
          0 AS creditdnum,
          0 AS creditamount,
          0 AS cashnum,
          0 AS cashdnum,
          0 AS cashamount
   FROM
     (SELECT 'ע��' AS data_type,
             data_source,
             register_date AS extractday,
             mbl_no
      FROM warehouse_data_user_channel_info AS a
      WHERE register_date<=date_sub(current_date(),1)
      UNION ALL SELECT 'ʵ��' AS data_type,
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
                    sum(applynum*pre) AS applynum,
                    sum((cast(applydnum as decimal(12,2))/num1)*pre) AS applydnum,
                    sum(creditnum*pre) AS creditnum,
                    sum((cast(creditdnum as decimal(12,2))/num2)*pre) AS creditdnum,
                    sum(creditamount*pre) AS creditamount,
                    sum(cashnum*pre) AS cashnum,
                    sum((cast(cashdnum as decimal(12,2))/num3)*pre) AS cashdnum,
                    sum(cashamount*pre) AS cashamount
   FROM
     (SELECT sum(if(applynum>0,1,0)) over(partition BY data_source,concat(substr(extractday,1,7),'-01'),mbl_no) AS num1,
             sum(if(creditnum>0,1,0)) over(partition BY data_source,concat(substr(extractday,1,7),'-01'),mbl_no) AS num2,
             sum(if(cashnum>0,1,0)) over(partition BY data_source,concat(substr(extractday,1,7),'-01'),mbl_no) AS num3,
             *
      FROM warehouse_data_user_review_withdrawals_info
      where pre>0) AS a      
   WHERE extractday<=date_sub(current_date(),1)
   GROUP BY data_source,
            concat(substr(extractday,1,7),'-01')) AS a
GROUP BY data_source,
         extractday,
         substr(extractday,1,7);

-- ��Ʒȫ�������ݱ� add 2018-10-23 update 2019-03-27
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
                    sum(applynum*pre) AS applynum,
                    sum(applydnum*pre) AS applydnum,
                    sum(creditnum*pre) AS creditnum,
                    sum(creditdnum*pre) AS creditdnum,
                    sum(creditamount*pre) AS creditamount,
                    sum(cashnum*pre) AS cashnum,
                    sum(cashdnum*pre) AS cashdnum,
                    sum(cashamount*pre) AS cashamount
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


-- ����ȫ��������
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
          count(if(data_type='ע��',mbl_no,NULL)) AS regnum,
          count(if(data_type='ʵ��',mbl_no,NULL)) AS chknum,
          0 AS applynum,
          0 AS applydnum,
          0 AS creditnum,
          0 AS creditdnum,
          0 AS creditamount,
          0 AS cashnum,
          0 AS cashdnum,
          0 AS cashamount
   FROM
     (SELECT 'ע��' AS data_type,
             data_source,
             the_2nd_level,
             the_3rd_level,
             register_date AS extractday,
             mbl_no
      FROM warehouse_data_user_channel_info AS a
      UNION ALL SELECT 'ʵ��' AS data_type,
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
                    sum(applynum*pre) AS applynum,
                    sum(applydnum*pre) AS applydnum,
                    sum(creditnum*pre) AS creditnum,
                    sum(creditdnum*pre) AS creditdnum,
                    sum(creditamount*pre) AS creditamount,
                    sum(cashnum*pre) AS cashnum,
                    sum(cashdnum*pre) AS cashdnum,
                    sum(cashamount*pre) AS cashamount
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

set io.sort.md=50;

-- ÿ����ע���û�����ת������ add 2018-11-21 update 2019-05-20
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
                    sum(cashamount*pre) AS allcash,
                    sum(CASE
                            WHEN product_name = '����滹-����' THEN cashamount*pre
                        END) AS cash01,
                    sum(CASE
                            WHEN product_name = '����滹-�ڰ�' THEN cashamount*pre
                        END) AS cash02,
                    sum(CASE
                            WHEN product_name = '����滹-Ǯ���״�' THEN cashamount*pre
                        END) AS cash03,
                    sum(CASE
                            WHEN product_name = '�ֽ����-����' THEN cashamount*pre
                        END) AS cash04,
                    sum(CASE
                            WHEN product_name = '�ֽ����-����' THEN cashamount*pre
                        END) AS cash05,
                    sum(CASE
                            WHEN product_name = '�ֽ����-����ջ�' THEN cashamount*pre
                        END) AS cash06,
                    sum(CASE
                            WHEN product_name = '�ֽ����-���' THEN cashamount*pre
                        END) AS cash07,
                    sum(CASE
                            WHEN product_name = '�ֽ����-��ҵ����' THEN cashamount*pre
                        END) AS cash08,
                    sum(CASE
                            WHEN product_name = '�ֽ����-С���' THEN cashamount*pre
                        END) AS cash09,
                    sum(CASE
                            WHEN product_name = '�ֽ����-������' THEN cashamount*pre
                        END) AS cash10,
                    sum(CASE
                            WHEN product_name = '���ڴ�-����' THEN cashamount*pre
                        END) AS cash11,
                    sum(CASE
                            WHEN product_name = '�����-����' THEN cashamount*pre
                        END) AS cash12,
                    sum(CASE
                            WHEN product_name = '���ڴ�-����' THEN cashamount*pre
                        END) AS cash13,
                    sum(CASE
                            WHEN product_name = 'ҵ����-����' THEN cashamount*pre
                        END) AS cash14,
                    sum(CASE
                            WHEN product_name = '����Ǯ��' THEN cashamount*pre
                        END) AS cash15,
                    sum(CASE
                            WHEN product_name = '�ֽ����-Ǯ��' THEN cashamount*pre
                        END) AS cash16,
                    sum(CASE
                            WHEN product_name = '�ֽ����-����' THEN cashamount*pre
                        END) AS cash17
   FROM warehouse_data_user_review_withdrawals_info AS d
   JOIN warehouse_atomic_user_info AS a ON a.data_source=d.data_source
   AND a.mbl_no=d.mbl_no
   AND a.registe_date=d.extractday
   WHERE pre>0
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

set io.sort.md=70;

-- ��ע���û���Ʒת��©�� add 2018-12-12 update 2019-05-20
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
   JOIN warehouse_data_daliy_report AS b ON a.data_source=b.data_source
   AND a.extractday=b.extractday
   WHERE a.extractday <= date_sub(current_date(),1)
     AND a.product_name IS NOT NULL
   UNION ALL SELECT a.data_source,
                    a.extractday,
                    a.product_name,
                    0 AS regnum,
                    0 AS chknum,
                    0 AS newdnum,
                    sum(a.applydnum*a.pre) AS applynum,
                    sum(a.creditdnum*a.pre) AS creditnum,
                    sum(a.creditamount*a.pre) AS credit_amount,
                    sum(a.cashdnum*a.pre) AS cashnum,
                    sum(a.cashamount*a.pre) AS cash_amount
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

-- ����ע���û�ת��©��(�޲�Ʒ) add 2019-03-15 update 2019-05-20
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
                    year(action_date) AS YEAR,
                    weekofyear(action_date) AS week,
                    min(action_date) AS extractday,
                    sum(regnum) AS regnum,
                    sum(chknum) AS chknum,
                    0 AS newdnum,
                    0 AS apllynum,
                    0 AS creditnum,
                    0 AS credit_amount,
                    0 AS cashnum,
                    0 AS cash_amount
   FROM warehouse_data_daliy_report
   GROUP BY data_source,
            year(action_date),
            weekofyear(action_date)
   UNION ALL SELECT a.data_source,
                    year(a.extractday),
                    weekofyear(a.extractday),
                    min(a.extractday) AS extractday,
                    0 AS regnum,
                    0 AS chknum,
                    0 AS newdnum,
                    sum(cast(a.applydnum AS decimal(12,2))/a.num1*a.pre) AS applynum,
                    sum(cast(a.creditdnum AS decimal(12,2))/a.num2*a.pre) AS creditnum,
                    sum(a.creditamount*a.pre) AS credit_amount,
                    sum(cast(a.cashdnum AS decimal(12,2))/a.num3*a.pre) AS cashnum,
                    sum(a.cashamount*a.pre) AS cash_amount
   FROM
     (SELECT sum(if(applynum>0,1,0)) over(partition BY data_source,year(extractday),weekofyear(extractday),mbl_no) AS num1,
             sum(if(creditnum>0,1,0)) over(partition BY data_source,year(extractday),weekofyear(extractday),mbl_no) AS num2,
             sum(if(cashnum>0,1,0)) over(partition BY data_source,year(extractday),weekofyear(extractday),mbl_no) AS num3,
             *
      FROM warehouse_data_user_review_withdrawals_info AS a
      WHERE pre>0) AS a
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

-- ����ע���û���Ʒת��©��(�в�Ʒ) add 2019-03-15 update 2019-05-20
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
             year(action_date) AS YEAR,
             weekofyear(action_date) AS week,
             sum(regnum) AS regnum,
             sum(chknum) AS chknum
      FROM warehouse_data_daliy_report
      GROUP BY data_source,
               year(action_date),
               weekofyear(action_date)) AS b ON a.data_source=b.data_source
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
                    sum(cast(a.applydnum AS decimal(12,2))/a.num1*a.pre) AS applynum,
                    sum(cast(a.creditdnum AS decimal(12,2))/a.num2*a.pre) AS creditnum,
                    sum(a.creditamount*a.pre) AS credit_amount,
                    sum(cast(a.cashdnum AS decimal(12,2))/a.num3*a.pre) AS cashnum,
                    sum(a.cashamount*a.pre) AS cash_amount
   FROM
     (SELECT sum(if(applynum>0,1,0)) over(partition BY data_source,year(extractday),weekofyear(extractday),mbl_no,product_name) AS num1,
             sum(if(creditnum>0,1,0)) over(partition BY data_source,year(extractday),weekofyear(extractday),mbl_no,product_name) AS num2,
             sum(if(cashnum>0,1,0)) over(partition BY data_source,year(extractday),weekofyear(extractday),mbl_no,product_name) AS num3,
             *
      FROM warehouse_data_user_review_withdrawals_info AS a
      WHERE pre>0) AS a
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

-- ���������û�������ϸ add 2018-12-28 update 2019-05-20
INSERT overwrite TABLE warehouse_data_product_creadituser_detail
SELECT a.data_source,
       a.extractday,
       a.product_name,
       a.mbl_no,
       pre,
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
                    END)=1 THEN '��'
           ELSE '��'
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
   AND b.status='ͨ��'
   WHERE a.pre>0) AS a
LEFT JOIN warehouse_data_credit_start_to_end AS b ON a.data_source=b.data_source
AND a.mbl_no=b.mbl_no
AND a.product_name=b.product_name
WHERE a.extractday <= date_sub(current_date(),1)
  AND a.product_name IN('����滹-Ǯ���״�',
                        '����滹-����',
                        '�ֽ����-����',
                        '�ֽ����-����',
                        '�ֽ����-���',
                        '�ֽ����-����ջ�',
                        '�ֽ����-��ҵ����')
GROUP BY a.data_source,
         a.extractday,
         a.product_name,
         a.mbl_no,
         pre,
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

--  ���������û�ת��©�� add 2018-12-28 update 2019-05-20
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
   JOIN warehouse_data_daliy_report AS b ON a.data_source=b.data_source
   AND a.extractday=b.extractday
   WHERE a.extractday <= date_sub(current_date(),1)
   UNION ALL SELECT a.data_source,
                    a.extractday,
                    a.product_name,
                    0 AS regnum,
                    0 AS chknum,
                    0 AS creditdnum,
                    applynum*pre AS applynum,
                    creditnum*pre AS creditnum,
                    creditamount*pre AS creditamount,
                    cashnum*pre AS cashnum,
                    cashamount*pre cashamount,
                    newcashnum*pre AS newcashnum,
                    newcashamount*pre AS newcashamount
   FROM warehouse_data_product_creadituser_detail AS a
   WHERE a.extractday <= date_sub(current_date(),1)
     AND is_credit='��') AS a
WHERE a.product_name IN('����滹-Ǯ���״�',
                        '����滹-����',
                        '�ֽ����-����',
                        '�ֽ����-����',
                        '�ֽ����-���',
                        '�ֽ����-����ջ�',
                        '�ֽ����-��ҵ����')
GROUP BY a.data_source,
         a.extractday,
         a.product_name;
                        

-- ��������鿴���������� add 2019-01-16 
INSERT overwrite TABLE warehouse_data_user_action_and_channel_end_special
SELECT data_source,
       data_date,
       is_new_jry,
       the_2nd_level,
       the_3rd_level,
       the_4th_level,
       sum(CASE
               WHEN TYPE='ע��' THEN dnum
           END) AS regdnum,
       sum(CASE
               WHEN TYPE='ʵ��' THEN dnum
           END) AS chkdnum,
       sum(CASE
               WHEN TYPE='����' THEN num
           END) AS applynum,
       sum(CASE
               WHEN TYPE='����' THEN dnum
           END) AS applydnum,
       sum(CASE
               WHEN TYPE='����' THEN num
           END) AS creditnum,
       sum(CASE
               WHEN TYPE='����' THEN dnum
           END) AS creditdnum,
       sum(CASE
               WHEN TYPE='����' THEN amount
           END) AS creditamount,
       sum(CASE
               WHEN TYPE='�ſ�' THEN num
           END) AS cashnum,
       sum(CASE
               WHEN TYPE='�ſ�' THEN dnum
           END) AS cashdnum,
       sum(CASE
               WHEN TYPE='�ſ�' THEN amount
           END) AS cashamount
FROM
  (SELECT 'ע��' AS TYPE,
          data_source,
          register_date AS data_date,
          is_new_jry,
          if(the_2nd_level IS NULL,'�հ�',the_2nd_level) AS the_2nd_level,
          if(the_3rd_level IS NULL,'�հ�',the_3rd_level) AS the_3rd_level,
          if(child_chan IS NULL,'�հ�',child_chan) AS the_4th_level,
          count(DISTINCT mbl_no) AS num,
          count(DISTINCT mbl_no) AS dnum,
          0 AS amount
   FROM warehouse_data_user_channel_info
   WHERE register_date<=date_sub(current_date(),1)
     AND chan_no in('jywh','jywhzj','zcstjtc','gckj','LGJBSH','jbsh','lgjb','lgjbsc','lgmc')
   GROUP BY data_source,
            register_date,
            is_new_jry,
            if(the_2nd_level IS NULL,'�հ�',the_2nd_level),
            if(the_3rd_level IS NULL,'�հ�',the_3rd_level),
            if(child_chan IS NULL,'�հ�',child_chan)
   UNION ALL SELECT 'ʵ��' AS TYPE,
                    data_source,
                    chk_date AS data_date,
                    is_new_jry,
                    if(the_2nd_level IS NULL,'�հ�',the_2nd_level) AS the_2nd_level,
                    if(the_3rd_level IS NULL,'�հ�',the_3rd_level) AS the_3rd_level,
                    if(child_chan IS NULL,'�հ�',child_chan) AS the_4th_level,
                    count(DISTINCT mbl_no) AS num,
                    count(DISTINCT mbl_no) AS dnum,
                    0 AS amount
   FROM warehouse_data_user_channel_info
   WHERE chk_date<=date_sub(current_date(),1)
     AND chan_no in('jywh','jywhzj','zcstjtc','gckj','LGJBSH','jbsh','lgjb','lgjbsc','lgmc')
   GROUP BY data_source,
            chk_date,
            is_new_jry,
            if(the_2nd_level IS NULL,'�հ�',the_2nd_level),
            if(the_3rd_level IS NULL,'�հ�',the_3rd_level),
            if(child_chan IS NULL,'�հ�',child_chan)
   UNION ALL SELECT '����' AS TYPE,
                    a.data_source,
                    a.apply_time,
                    b.is_new_jry,
                    if(b.the_2nd_level IS NULL,'�հ�',b.the_2nd_level) AS the_2nd_level,
                    if(b.the_3rd_level IS NULL,'�հ�',b.the_3rd_level) AS the_3rd_level,
                    if(child_chan IS NULL,'�հ�',child_chan) AS the_4th_level,
                    count(1) AS applyup_num,
                    count(DISTINCT a.mbl_no) AS applyup_dnum,
                    0 AS applyup_amount
   FROM warehouse_data_user_review_info AS a
   JOIN warehouse_data_user_channel_info AS b ON a.data_source=b.data_source
   AND a.mbl_no=b.mbl_no
   WHERE chan_no in('jywh','jywhzj','zcstjtc','gckj','LGJBSH','jbsh','lgjb','lgjbsc','lgmc')
   GROUP BY a.data_source,
            a.apply_time,
            b.is_new_jry,
            if(b.the_2nd_level IS NULL,'�հ�',b.the_2nd_level),
            if(b.the_3rd_level IS NULL,'�հ�',b.the_3rd_level),
            if(child_chan IS NULL,'�հ�',child_chan)
   UNION ALL SELECT '����' AS TYPE,
                    a.data_source,
                    a.credit_time,
                    b.is_new_jry,
                    if(b.the_2nd_level IS NULL,'�հ�',b.the_2nd_level) AS the_2nd_level,
                    if(b.the_3rd_level IS NULL,'�հ�',b.the_3rd_level) AS the_3rd_level,
                    if(child_chan IS NULL,'�հ�',child_chan) AS the_4th_level,
                    count(1) AS applyup_num,
                    count(DISTINCT a.mbl_no) AS applyup_dnum,
                    sum(if(amount IS NULL,0,amount)) AS applyup_amount
   FROM warehouse_data_user_review_info AS a
   JOIN warehouse_data_user_channel_info AS b ON a.data_source=b.data_source
   AND a.mbl_no=b.mbl_no
   WHERE a.status='ͨ��'
     AND a.credit_time IS NOT NULL
     AND chan_no in('jywh','jywhzj','zcstjtc','gckj','LGJBSH','jbsh','lgjb','lgjbsc','lgmc')
   GROUP BY a.data_source,
            a.credit_time,
            b.is_new_jry,
            if(b.the_2nd_level IS NULL,'�հ�',b.the_2nd_level),
            if(b.the_3rd_level IS NULL,'�հ�',b.the_3rd_level),
            if(child_chan IS NULL,'�հ�',child_chan)
   UNION ALL SELECT '�ſ�' AS TYPE,
                    a.data_source,
                    a.cash_time,
                    b.is_new_jry,
                    if(b.the_2nd_level IS NULL,'�հ�',b.the_2nd_level) AS the_2nd_level,
                    if(b.the_3rd_level IS NULL,'�հ�',b.the_3rd_level) AS the_3rd_level,
                    if(child_chan IS NULL,'�հ�',child_chan) AS the_4th_level,
                    count(1) AS applyup_num,
                    count(DISTINCT a.mbl_no) AS applyup_dnum,
                    sum(if(cash_amount IS NULL,0,cash_amount)) AS applyup_amount
   FROM warehouse_data_user_withdrawals_info AS a
   JOIN warehouse_data_user_channel_info AS b ON a.data_source=b.data_source
   AND a.mbl_no=b.mbl_no
   WHERE chan_no in('jywh','jywhzj','zcstjtc','gckj','LGJBSH','jbsh','lgjb','lgjbsc','lgmc')
   GROUP BY a.data_source,
            a.cash_time,
            if(a.product_name IS NULL,'�հ�',a.product_name),
            b.is_new_jry,
            if(b.the_2nd_level IS NULL,'�հ�',b.the_2nd_level),
            if(b.the_3rd_level IS NULL,'�հ�',b.the_3rd_level),
            if(child_chan IS NULL,'�հ�',child_chan)) AS a
WHERE data_date<=date_sub(current_date(),1)
GROUP BY data_source,
         data_date,
         is_new_jry,
         the_2nd_level,
         the_3rd_level,
         the_4th_level;

-- Ǯ��С���䳲���ú˶����� add 2019-03-27 
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
              WHEN province_desc = '����'
                   AND isp LIKE '%�ƶ�%' THEN '�����ƶ�'
              WHEN province_desc = '����'
                   AND isp LIKE '%��ͨ%' THEN '������ͨ'
              WHEN province_desc = '����'
                   AND isp LIKE '%����%' THEN '���յ���'
              WHEN province_desc = '�㶫'
                   AND isp LIKE '%�ƶ�%' THEN '�㶫�ƶ�'
          END AS TYPE,
          COUNT(mbl_no) AS regnum,
          0 AS applynum,
          0 AS regapplynum,
          0 AS warrapplynumm
   FROM default.warehouse_atomic_user_info
   WHERE registe_date >= '2018-12-12'
   GROUP BY registe_date,
            CASE
                WHEN province_desc = '����'
                     AND isp LIKE '%�ƶ�%' THEN '�����ƶ�'
                WHEN province_desc = '����'
                     AND isp LIKE '%��ͨ%' THEN '������ͨ'
                WHEN province_desc = '����'
                     AND isp LIKE '%����%' THEN '���յ���'
                WHEN province_desc = '�㶫'
                     AND isp LIKE '%�ƶ�%' THEN '�㶫�ƶ�'
            END
   UNION ALL SELECT apply_time,
                    CASE
                        WHEN province_desc = '����'
                             AND isp LIKE '%�ƶ�%' THEN '�����ƶ�'
                        WHEN province_desc = '����'
                             AND isp LIKE '%��ͨ%' THEN '������ͨ'
                        WHEN province_desc = '����'
                             AND isp LIKE '%����%' THEN '���յ���'
                        WHEN province_desc = '�㶫'
                             AND isp LIKE '%�ƶ�%' THEN '�㶫�ƶ�'
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
   WHERE product_name = '����滹-Ǯ���״�'
     AND apply_time >= '2018-12-12'
   GROUP BY apply_time,
            CASE
                WHEN province_desc = '����'
                     AND isp LIKE '%�ƶ�%' THEN '�����ƶ�'
                WHEN province_desc = '����'
                     AND isp LIKE '%��ͨ%' THEN '������ͨ'
                WHEN province_desc = '����'
                     AND isp LIKE '%����%' THEN '���յ���'
                WHEN province_desc = '�㶫'
                     AND isp LIKE '%�ƶ�%' THEN '�㶫�ƶ�'
            END) AS a
GROUP BY extractday,
         TYPE;

-- RFMģ�����ݴ��� add 20190528        
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
          sum(b.cashamount*b.pre) AS cash_amount
   FROM warehouse_data_user_channel_info AS a
   JOIN warehouse_data_user_review_withdrawals_info AS b ON a.data_source=b.data_source
   AND a.mbl_no=b.mbl_no
   WHERE b.extractday <= date_sub(current_date(),1)
     AND a.register_date <= date_sub(current_date(),1)
     AND b.cashnum>0
     AND b.pre>0
   GROUP BY a.data_source,
            a.mbl_no,
            a.register_date) AS a;

-- RFMģ�����ݴ��� add 20190528
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

-- ��ƽ̨�û�ת����ϸ����(�ܱ�����) add 2019-06-14
INSERT overwrite TABLE warehouse_data_product_data_detail_analysis PARTITION(years,weeks)
SELECT min(extractday) AS extractday,
       '�ϼ�' AS data_source,
       '�ϼ�' AS product_name,
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
                          WHEN is_new='��' THEN mbl_no
                      END) AS allnewclickdnum,
       count(DISTINCT CASE
                          WHEN is_new='��'
                               AND data_source='sjd' THEN mbl_no
                      END) AS sjdnewclickdnum,
       count(DISTINCT CASE
                          WHEN is_new='��'
                               AND data_source='jry' THEN mbl_no
                      END) AS jrynewclickdnum,
       count(DISTINCT CASE
                          WHEN is_new='��'
                               AND data_source='xyqb' THEN mbl_no
                      END) AS xyqbnewclickdnum,
       0 AS applydnum,
       0 AS creditdnum,
       0 AS cashdnum,
       0 AS cashamount,
       current_date() AS etl_date,
       year(date_add(a.extractday,3)) AS years,
       weekofyear(date_add(a.extractday,3)) AS weeks
FROM warehouse_data_user_action_day AS a
JOIN warehouse_data_analysis_product AS b ON a.product_name=b.product_name
WHERE applypv>0
  AND year(date_add(a.extractday,3))>=2019
GROUP BY year(date_add(a.extractday,3)),
         weekofyear(date_add(a.extractday,3))
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
                          WHEN is_new='��' THEN mbl_no
                      END) AS allnewclickdnum,
       count(DISTINCT CASE
                          WHEN is_new='��'
                               AND data_source='sjd' THEN mbl_no
                      END) AS sjdnewclickdnum,
       count(DISTINCT CASE
                          WHEN is_new='��'
                               AND data_source='jry' THEN mbl_no
                      END) AS jrynewclickdnum,
       count(DISTINCT CASE
                          WHEN is_new='��'
                               AND data_source='xyqb' THEN mbl_no
                      END) AS xyqbnewclickdnum,
       0 AS applydnum,
       0 AS creditdnum,
       0 AS cashdnum,
       0 AS cashamount,
       current_date() AS etl_date,
       year(date_add(a.extractday,3)) AS years,
       weekofyear(date_add(a.extractday,3)) AS weeks
FROM warehouse_data_user_action_day AS a
JOIN warehouse_data_analysis_product AS b ON a.product_name=b.product_name
WHERE applypv>0
  AND year(date_add(a.extractday,3))>=2019
GROUP BY year(date_add(a.extractday,3)),
         weekofyear(date_add(a.extractday,3)),
         a.data_source,
         a.product_name;


INSERT INTO TABLE warehouse_data_product_data_detail_analysis PARTITION(years,weeks)
SELECT min(a.cash_time) AS extractday,
       '�ϼ�' AS data_source,
       '�ϼ�' AS product_name,
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
       year(date_add(a.cash_time,3)) AS years,
       weekofyear(date_add(a.cash_time,3)) AS weeks
FROM warehouse_data_user_withdrawals_info AS a
JOIN warehouse_data_analysis_product AS b ON a.product_name=b.product_name
AND b.product_name='1'
WHERE year(date_add(a.cash_time,3))>=2019
GROUP BY year(date_add(a.cash_time,3)),
         weekofyear(date_add(a.cash_time,3));


INSERT INTO TABLE warehouse_data_product_data_detail_analysis PARTITION(years,weeks)
SELECT min(a.apply_time) AS extractday,
       data_source,
       '�ϼ�' AS product_name,
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
       year(date_add(a.apply_time,3)) AS years,
       weekofyear(date_add(a.apply_time,3)) AS weeks
FROM warehouse_data_user_review_info AS a
JOIN warehouse_data_analysis_product AS b ON a.product_name=b.product_name
AND b.product_name='1'
WHERE year(date_add(a.apply_time,3))>=2019
GROUP BY year(date_add(a.apply_time,3)),
         weekofyear(date_add(a.apply_time,3)),
         data_source
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
       year(date_add(a.apply_time,3)) AS years,
       weekofyear(date_add(a.apply_time,3)) AS weeks
FROM warehouse_data_user_review_info AS a
JOIN warehouse_data_analysis_product AS b ON a.product_name=b.product_name
WHERE year(date_add(a.apply_time,3))>=2019
GROUP BY year(date_add(a.apply_time,3)),
         weekofyear(date_add(a.apply_time,3)),
         a.data_source,
         a.product_name ;


INSERT INTO TABLE warehouse_data_product_data_detail_analysis PARTITION(years,weeks)
SELECT min(a.credit_time) AS extractday,
       data_source,
       '�ϼ�' AS product_name,
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
       year(date_add(a.credit_time,3)) AS years,
       weekofyear(date_add(a.credit_time,3)) AS weeks
FROM warehouse_data_user_review_info AS a
JOIN warehouse_data_analysis_product AS b ON a.product_name=b.product_name
AND b.product_name='1'
WHERE a.status = 'ͨ��'
  AND year(date_add(a.credit_time,3))>=2019
GROUP BY year(date_add(a.credit_time,3)),
         weekofyear(date_add(a.credit_time,3)),
         data_source
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
       year(date_add(a.credit_time,3)) AS years,
       weekofyear(date_add(a.credit_time,3)) AS weeks
FROM warehouse_data_user_review_info AS a
JOIN warehouse_data_analysis_product AS b ON a.product_name=b.product_name
WHERE a.status = 'ͨ��'
  AND year(date_add(a.credit_time,3))>=2019
GROUP BY year(date_add(a.credit_time,3)),
         weekofyear(date_add(a.credit_time,3)),
         a.data_source,
         a.product_name ;

INSERT INTO TABLE warehouse_data_product_data_detail_analysis PARTITION(years,weeks)
SELECT min(a.cash_time) AS extractday,
       data_source,
       '�ϼ�' AS product_name,
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
       sum(cast(cash_amount AS decimal(10,2)))/10000 AS cashamount,
       current_date() AS etl_date,
       year(date_add(a.cash_time,3)) AS years,
       weekofyear(date_add(a.cash_time,3)) AS weeks
FROM warehouse_data_user_withdrawals_info AS a
JOIN warehouse_data_analysis_product AS b ON a.product_name=b.product_name
AND b.product_name='1'
WHERE cash_amount>0
  AND year(date_add(a.cash_time,3))>=2019
GROUP BY year(date_add(a.cash_time,3)),
         weekofyear(date_add(a.cash_time,3)),
         data_source
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
       sum(cast(cash_amount AS decimal(10,2)))/10000 AS cashamount,
       current_date() AS etl_date,
       year(date_add(a.cash_time,3)) AS years,
       weekofyear(date_add(a.cash_time,3)) AS weeks
FROM warehouse_data_user_withdrawals_info AS a
JOIN warehouse_data_analysis_product AS b ON a.product_name=b.product_name
WHERE cash_amount>0
  AND year(date_add(a.cash_time,3))>=2019
GROUP BY year(date_add(a.cash_time,3)),
         weekofyear(date_add(a.cash_time,3)),
         a.data_source,
         a.product_name;

-- ��ƽ̨�û�ת������(�ܱ�����) add 2019-06-14
INSERT overwrite TABLE warehouse_data_product_data_analysis PARTITION(years,weeks)
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
       years,
       weeks
FROM warehouse_data_product_data_detail_analysis AS a
GROUP BY years,
         weeks,
         data_source,
         product_name;

-- ��ƽ̨���������ܻ��ܽ����(�ܱ�����) add 2019-06-14
INSERT overwrite TABLE warehouse_data_user_action_end_weekly_analysis PARTITION (years,weeks)
SELECT a.data_source,
       a.product_name,
       sum(applypv) AS num,
       count(DISTINCT mbl_no) AS dnum,
       sum(CASE
               WHEN is_new='��' THEN applypv
           END) AS newnum,
       count(DISTINCT CASE
                          WHEN is_new='��' THEN mbl_no
                      END) AS newdnum,
       sum(CASE
               WHEN is_credit='��' THEN applypv
           END) AS creditnum,
       count(DISTINCT CASE
                          WHEN is_credit='��' THEN mbl_no
                      END) AS creditdnum,
       min(extractday) AS extractday,
       current_date() AS etl_date,
       year(date_add(a.extractday,3)) AS years,
       weekofyear(date_add(a.extractday,3)) AS weeks
FROM warehouse_data_user_action_sum AS a
WHERE applypv>0
  AND year(extractday) >= 2019
  AND weekofyear(extractday) = weekofyear(date_sub(current_date(),1))
GROUP BY year(date_add(a.extractday,3)),
         weekofyear(date_add(a.extractday,3)),
         a.data_source,
         a.product_name;

-- ��ƽ̨���û�ת������(�ܱ�����) add 2019-06-14       
INSERT overwrite TABLE warehouse_data_product_newuser_weekly_analysis PARTITION (years,weeks)
SELECT a.data_source,
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
       sum(cash_amount*if(b.pre is null,0,b.pre/100)) AS income_amount,
       current_date() AS etl_date,
       a.years,
       a.weeks
FROM
  (SELECT a.data_source,
          a.years,
          a.weeks,
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
   FROM warehouse_data_user_action_end_weekly_analysis AS a
   JOIN
     (SELECT data_source,
             year(date_add(action_date,3)) AS years,
             weekofyear(date_add(action_date,3)) AS weeks,
             sum(regnum) AS regnum,
             sum(chknum) AS chknum
      FROM warehouse_data_daliy_report
      GROUP BY data_source,
               year(date_add(action_date,3)),
               weekofyear(date_add(action_date,3))) AS b ON a.data_source=b.data_source
   AND a.years=b.years
   AND a.years=b.years
   WHERE a.product_name IS NOT NULL
   UNION ALL SELECT a.data_source,
                    year(date_add(a.extractday,3)),
                    weekofyear(date_add(a.extractday,3)),
                    min(a.extractday) AS extractday,
                    a.product_name,                    
                    0 AS regnum,
                    0 AS chknum,
                    0 AS newdnum,
                    sum(cast(a.applydnum AS decimal(12,2))/a.num1*a.pre) AS applynum,
                    sum(cast(a.creditdnum AS decimal(12,2))/a.num2*a.pre) AS creditnum,
                    sum(a.creditamount*a.pre) AS credit_amount,
                    sum(cast(a.cashdnum AS decimal(12,2))/a.num3*a.pre) AS cashnum,
                    sum(a.cashamount*a.pre) AS cash_amount
   FROM
     (SELECT sum(if(applynum>0,1,0)) over(partition BY data_source,year(extractday),weekofyear(extractday),mbl_no,product_name) AS num1,
             sum(if(creditnum>0,1,0)) over(partition BY data_source,year(extractday),weekofyear(extractday),mbl_no,product_name) AS num2,
             sum(if(cashnum>0,1,0)) over(partition BY data_source,year(extractday),weekofyear(extractday),mbl_no,product_name) AS num3,
             *
      FROM warehouse_data_user_review_withdrawals_info AS a
      WHERE pre>0) AS a
   JOIN warehouse_data_user_channel_info AS b ON a.data_source=b.data_source
   AND a.mbl_no=b.mbl_no
   AND year(date_add(a.extractday,3))=year(date_add(b.register_date,3))
   AND weekofyear(date_add(a.extractday,3))=weekofyear(date_add(b.register_date,3))
   WHERE a.extractday <= date_sub(current_date(),1)
     AND a.product_name IS NOT NULL
   GROUP BY a.data_source,
            a.product_name,
            year(date_add(a.extractday,3)),
            weekofyear(date_add(a.extractday,3))) AS a
left join warehouse_data_product_income_pre as b on a.product_name=b.product_name
GROUP BY a.data_source,
         a.years,
         a.weeks,
         a.product_name;