-- 切换用户
set role admin;
set io.sort.mb=70;
set hive.jobname.length=20;

set mapred.child.java.opts = -Xmx512m;
set mapreduce.map.memory.mb=1024;
set mapreduce.reduce.memory.mb=1024;

-- 汇智信用户信息 add 20190916
INSERT overwrite TABLE warehouse_data_hzx_user_view
SELECT us.id AS userid,
       us.user_name as username,
       us.mobile,
       us.account,
       us.c_time as createtime,
       us.login_time as logintime,
       us.bank_id,
       bk.name AS bankname,
       us.dep_id,
       dep.name AS depname,
       us.dot_id,
       dot.dot_name AS dotname,
       us.status,
       us.position_id,
       pos.position AS posname
FROM warehouse_atomic_hzx_b_bank_user AS us
JOIN warehouse_atomic_hzx_b_bank_base_info AS bk ON us.bank_id=bk.id
LEFT JOIN warehouse_atomic_hzx_b_bank_dep AS dep ON us.dep_id=dep.id
LEFT JOIN warehouse_atomic_hzx_b_dot AS dot ON us.dot_id=dot.id
LEFT JOIN warehouse_atomic_hzx_b_bank_dot_dep_position AS pos ON us.dot_id=pos.id;

-- 汇智信银行调查数据 add 20190916
INSERT overwrite TABLE warehouse_data_hzx_bank_user_view partition(months)
SELECT extractday,
       bankid,
       bankname,
       dotid,
       dotname,
       userid,
       prodtype,
       productid,
       productname,
       qrtype,
       sum(applyOver)AS applyOver,
       sum(applyNotOver) AS applyNotOver,
       sum(waitDistribution) AS waitDistribution,
       sum(distribution) AS distribution,
       sum(applyRefuse) AS applyRefuse,              
       sum(researchOver) AS researchOver,
       sum(researchOverHaveAmount) AS researchOverHaveAmount,
       sum(totalAmount) AS totalAmount,
       substr(extractday,1,7) as months
FROM
  (SELECT bk.id AS bankid,
          bk.name AS bankname,
          t.dot_id AS dotid,
          dot.dot_name AS dotname,
          if(qrcode IS NOT NULL,qr.user_id,t.user_id) AS userid,
          CASE
              WHEN pd.pro_type =1 THEN '信易贷'
              WHEN pd.pro_type =2 THEN '信福时贷'
              WHEN pd.pro_type =3 THEN '精细化'
              WHEN pd.pro_type =4 THEN '银行产品'
              ELSE '未归类'
          END AS prodtype,
          pd.id AS productid,
          pd.name AS productname,
          if(qrcode IS NOT NULL,'二维码','主动') AS qrtype,
          substr(t.loan_apply_time,1,10) AS extractday,
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
          count(DISTINCT CASE
                             WHEN t.m_state = 5
                                  AND t.research_status = 5 THEN t.id
                         END) AS applyRefuse,
          0 AS researchOver,
          0 AS researchOverHaveAmount,
          0 AS totalAmount
   FROM warehouse_atomic_hzx_xy_product_info AS st
   JOIN warehouse_atomic_hzx_bank_product_info pd ON st.id = pd.t_id
   JOIN warehouse_atomic_hzx_research_task AS t ON t.bank_pro_id = pd.id
   JOIN warehouse_atomic_hzx_b_bank_base_info AS bk ON bk.id = t.bank_id
   LEFT JOIN warehouse_atomic_hzx_b_dot AS dot ON t.dot_id=dot.id
   LEFT JOIN warehouse_atomic_hzx_b_bank_qr_code AS qr ON t.qrcode=qr.id
   WHERE substr(t.loan_apply_time,1,10) between concat(substr(add_months(date(current_date()),-1),1,7),'-01') and  date_sub(date(current_date()),1)
     AND pd.id IS NOT NULL
     AND t.bank_id NOT IN(1011607210000337,
                          1011609230000007,
                          1011705260000101,
                          1011806250000203,
                          1011808220000244,
                          1011808270000246)
   GROUP BY bk.id,
            bk.name,
            t.dot_id,
            dot.dot_name,
            if(qrcode IS NOT NULL,qr.user_id,t.user_id),
            CASE
                WHEN pd.pro_type =1 THEN '信易贷'
                WHEN pd.pro_type =2 THEN '信福时贷'
                WHEN pd.pro_type =3 THEN '精细化'
                WHEN pd.pro_type =4 THEN '银行产品'
                ELSE '未归类'
            END,
            pd.id,
            pd.name,
            if(qrcode IS NOT NULL,'二维码','主动'),
            substr(t.loan_apply_time,1,10)
   UNION ALL SELECT bk.id AS bankid,
                    bk.name AS bankname,
                    t.dot_id AS dotid,
                    dot.dot_name AS dotname,
                    if(qrcode IS NOT NULL,qr.user_id,t.user_id) AS userid,
                    CASE
                        WHEN pd.pro_type =1 THEN '信易贷'
                        WHEN pd.pro_type =2 THEN '信福时贷'
                        WHEN pd.pro_type =3 THEN '精细化'
                        WHEN pd.pro_type =4 THEN '银行产品'
                        ELSE '未归类'
                    END AS prodtype,
                    pd.id AS productid,
                    pd.name AS productname,
                    if(qrcode IS NOT NULL,'二维码','主动') AS qrtype,
                    substr(t.research_over_time,1,10) AS extractday,
                    0 AS applyOver,
                    0 AS applyNotOver,
                    0 AS waitDistribution,
                    0 AS distribution,
                    0 AS applyRefuse,
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
   JOIN warehouse_atomic_hzx_bank_product_info pd ON st.id = pd.t_id
   JOIN warehouse_atomic_hzx_research_task AS t ON t.bank_pro_id = pd.id
   JOIN warehouse_atomic_hzx_b_bank_base_info AS bk ON bk.id = t.bank_id
   LEFT JOIN warehouse_atomic_hzx_b_dot AS dot ON t.dot_id=dot.id
   LEFT JOIN warehouse_atomic_hzx_b_bank_qr_code AS qr ON t.qrcode=qr.id
   WHERE substr(t.research_over_time,1,10) between concat(substr(add_months(date(current_date()),-1),1,7),'-01') and date_sub(date(current_date()),1)
     AND pd.id IS NOT NULL
     AND t.bank_id NOT IN(1011607210000337,
                          1011609230000007,
                          1011705260000101,
                          1011806250000203,
                          1011808220000244,
                          1011808270000246)
   GROUP BY bk.id,
            bk.name,
            t.dot_id,
            dot.dot_name,
            if(qrcode IS NOT NULL,qr.user_id,t.user_id),
            CASE
                WHEN pd.pro_type =1 THEN '信易贷'
                WHEN pd.pro_type =2 THEN '信福时贷'
                WHEN pd.pro_type =3 THEN '精细化'
                WHEN pd.pro_type =4 THEN '银行产品'
                ELSE '未归类'
            END,
            pd.id,
            pd.name,
            if(qrcode IS NOT NULL,'二维码','主动'),
            substr(t.research_over_time,1,10)) AS a
GROUP BY extractday,
         bankid,
         bankname,
         dotid,
         dotname,
         userid,
         prodtype,
         productid,
         productname,
         qrtype,         
         substr(extractday,1,7);
         
INSERT overwrite TABLE warehouse_data_hzx_bank_user_spc
SELECT ur.bankid,
       ur.bankname,
       ur.userid,
       ur.account,
       ur.username,
       ur.rank,
       rs.bank_pro_id,
       rs.prodname,
       rs.prodtype,
       rs.loan_apply_id,
       if(rs.loan_apply_time IS NULL, date_sub(date(current_date()),1), rs.loan_apply_time) AS loan_apply_time,
       rs.applystate,
       rs.distribution,
       rs.research_over_time,
       rs.qrcode,
       rs.qrlabel,
       rs.customer_id,
       rs.researchstatus,
       rs.amount,
       row_number() over(partition BY rs.qrcode
                         ORDER BY rs.loan_apply_time) AS qrnum
FROM
  (SELECT a.id AS bankid,
          a.name AS bankname,
          b.id AS userid,
          b.account,
          b.user_name AS username,
          b.rank
   FROM warehouse_atomic_hzx_b_bank_base_info AS a
   JOIN warehouse_atomic_hzx_b_bank_user AS b ON a.id=b.bank_id
   WHERE a.name LIKE '%村镇银行'
     AND DISABLE=false) AS ur
LEFT JOIN
  (SELECT a.loan_apply_id,
          a.loan_apply_time,
          a.research_over_time,
          a.qrcode,
          CASE
              WHEN b.label=1 THEN '个人'
              WHEN b.label=2 THEN '商家'
              WHEN b.label=3 THEN '银行资源'
              WHEN b.label=4 THEN '渠道'
              WHEN b.label=5 THEN '老客户'
          END qrlabel,
          a.customer_id,
          a.bank_id,
          a.bank_pro_id,
          c.name AS prodname,
          CASE
              WHEN c.pro_type =1 THEN '信易贷'
              WHEN c.pro_type =2 THEN '信福时贷'
              WHEN c.pro_type =3 THEN '精细化'
              WHEN c.pro_type =4 THEN '银行产品'
              ELSE '未归类'
          END AS prodtype,
          if(qrcode IS NOT NULL,b.user_id,a.user_id) AS userid,
          a.m_state AS applystate,
          a.distribution,
          a.research_status AS researchstatus,
          a.rec_amount AS amount,
          row_number() over(partition BY substr(loan_apply_time,1,7),bank_pro_id,customer_id
                            ORDER BY loan_apply_time) AS num
   FROM warehouse_atomic_hzx_research_task AS a
   LEFT JOIN warehouse_atomic_hzx_b_bank_qr_code AS b ON a.qrcode=b.id
   LEFT JOIN warehouse_atomic_hzx_bank_product_info AS c ON a.bank_pro_id=c.id
   WHERE substr(a.loan_apply_time,1,10)>='2019-09-01') AS rs ON ur.userid=rs.userid
AND rs.num=1;         