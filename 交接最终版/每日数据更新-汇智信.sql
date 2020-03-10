##���������������������
create table warehouse_data_hzx_user_view
(userid string comment '�û�ID',
 username string comment '�û�����',
 mobile string comment '�ֻ�����',
 account string comment 'ϵͳ�˺�',
 createtime string comment '����ʱ��',
 logintime string comment '��½ʱ��',
 bank_id string comment '����ID',
 bankname string comment '��������',
 dep_id string comment '����ID',
 depname string comment '��������',
 dot_id string comment '����ID',
 dotname string comment '��������',
 status bigint comment '״̬',
 position_id string comment 'ְλID',
 posname string comment 'ְλ����'
)COMMENT '���������л�����Ϣ';

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

##���������������������
create table warehouse_data_hzx_bank_user_view
(extractday string comment '����',
 bankid string comment '����ID',
 bankname string comment '��������',
 dotid string comment '����ID',
 dotname string comment '��������',
 userid string comment '�û�ID',
 prodtype string comment '��Ʒ����',
 productid string comment '��ƷID',
 productname string comment '��Ʒ����',
 qrtype string comment 'Ӫ������',
 applyOver double comment '���������',
 applyNotOver double comment '����������',
 waitDistribution double comment '�����������',
 distribution double comment '�����ѷ�����',
 applyRefuse double comment '���뱻����',
 researchOver double comment '���������',
 researchOverHaveAmount double comment '������ɳ�����',
 totalAmount double comment '����ܶ�'
)COMMENT '���������������������' PARTITIONED BY (months string comment '�·�');

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
              WHEN pd.pro_type =1 THEN '���״�'
              WHEN pd.pro_type =2 THEN '�Ÿ�ʱ��'
              WHEN pd.pro_type =3 THEN '��ϸ��'
              WHEN pd.pro_type =4 THEN '���в�Ʒ'
              ELSE 'δ����'
          END AS prodtype,
          pd.id AS productid,
          pd.name AS productname,
          if(qrcode IS NOT NULL,'��ά��','����') AS qrtype,
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
                WHEN pd.pro_type =1 THEN '���״�'
                WHEN pd.pro_type =2 THEN '�Ÿ�ʱ��'
                WHEN pd.pro_type =3 THEN '��ϸ��'
                WHEN pd.pro_type =4 THEN '���в�Ʒ'
                ELSE 'δ����'
            END,
            pd.id,
            pd.name,
            if(qrcode IS NOT NULL,'��ά��','����'),
            substr(t.loan_apply_time,1,10)
   UNION ALL SELECT bk.id AS bankid,
                    bk.name AS bankname,
                    t.dot_id AS dotid,
                    dot.dot_name AS dotname,
                    if(qrcode IS NOT NULL,qr.user_id,t.user_id) AS userid,
                    CASE
                        WHEN pd.pro_type =1 THEN '���״�'
                        WHEN pd.pro_type =2 THEN '�Ÿ�ʱ��'
                        WHEN pd.pro_type =3 THEN '��ϸ��'
                        WHEN pd.pro_type =4 THEN '���в�Ʒ'
                        ELSE 'δ����'
                    END AS prodtype,
                    pd.id AS productid,
                    pd.name AS productname,
                    if(qrcode IS NOT NULL,'��ά��','����') AS qrtype,
                    substr(t.research_over_time,1,10) AS extractday,
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
                WHEN pd.pro_type =1 THEN '���״�'
                WHEN pd.pro_type =2 THEN '�Ÿ�ʱ��'
                WHEN pd.pro_type =3 THEN '��ϸ��'
                WHEN pd.pro_type =4 THEN '���в�Ʒ'
                ELSE 'δ����'
            END,
            pd.id,
            pd.name,
            if(qrcode IS NOT NULL,'��ά��','����'),
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