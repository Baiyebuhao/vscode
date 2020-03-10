create table warehouse_data_product_info_new
(data_source varchar(10) comment '平台',
 product_id varchar(32) comment '产品ID',
 product_name varchar(32) comment '产品名称',
 product_name_new varchar(32) comment '统一后产品名称'
  );

insert into warehouse_data_product_info_new values
('sjd','2018060600060006','重庆小雨点','现金分期-小雨点'),
('sjd','2017061510060021','中邮','现金分期-中邮'),
('sjd','2015070216330003','移动白条','移动白条-马上'),
('sjd','2018041100000001','业主贷','业主贷-招联'),
('sjd','2018052114350013','现金分期-中邮(WX)','现金分期-中邮'),
('sjd','2017031116330013','现金分期','现金分期-中邮'),
('sjd','2018071600060100','万达小贷','现金分期-万达普惠'),
('sjd','2017061510060016','随借随还','随借随还-马上'),
('sjd','2018013115350000','宁夏小贷','移动白条-钱包易贷'),
('sjd','2018062500060100','拉卡拉','现金分期-拉卡拉'),
('sjd','2017061510060019','好期贷','好期贷-招联'), 
('sjd','2018041100000002','公积金贷','公积金社保贷-招联'), 
('xyqb','40000028','工薪贷','公积金贷-锦城'),
('sjd','2018041100000003','大期待','大期贷-招联'),
('sjd','2017061510060020','白领贷','白领贷-招联');

##授信有效期
drop table warehouse_data_credit_start_to_end;
create table warehouse_data_credit_start_to_end
(data_source varchar(10) comment '平台',
 mbl_no varchar(32) comment '手机号码',
 apply_time varchar(32) comment '申请时间',
 credit_time varchar(32) comment '授信时间',
 product_name varchar(32) comment '产品名称',
 credit_date varchar(32) comment '授信日期',
 credit_end_date varchar(32) comment '授信结束时间'
  );

##truncate table warehouse_data_credit_start_to_end;
INSERT INTO warehouse_data_credit_start_to_end
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
   UNION ALL SELECT data_source,
                    mbl_no,
                    apply_time,
                    creadit_time AS credit_time,
                    '现金分期-点点' AS product_name,
                    cast(date_add(substr(b.creadit_time,1,10),1) AS string) AS credit_date,
                    add_months(substr(b.creadit_time,1,10),3) AS credit_end_date
   FROM default.warehouse_atomic_diandian_review_result_info AS b
   WHERE message = '成功') AS a
WHERE date(credit_time) <= date_sub(date(current_date()),1);


##日期	平台	产品名称	手机号码	所有	产品列表-supermarket	产品详情-product_detail	产品申请-institution_page	产品banner-banner	是否新老用户	是否新注册

drop table warehouse_atomic_user_action_sum;
create table warehouse_atomic_user_action_sum
(extractday varchar(16)  comment '日期',
 data_source varchar(10) comment '平台',
 product_name varchar(32) comment '产品名称',
 mbl_no varchar(32) comment '手机号码',
 is_new varchar(5) comment '新注册用户标识',
 is_credit varchar(5) comment '授信期用户标识',
 allpv int comment '所有pv',
 marketpv int comment '产品列表pv',
 detailpv int comment '产品详情pv',
 applypv int comment '申请按钮pv',
 institupv int comment '产品申请pv',
 bannerpv int comment 'banner-pv'
 );

##truncate table warehouse_atomic_user_action_sum;
insert into warehouse_atomic_user_action_sum
SELECT a.extractday,
       a.data_source,
       a.product_name,
       a.mbl_no,
       is_new,
       b.is_credit,
       allpv,
       marketpv,
       detailpv,
       applypv,
       institupv,
       bannerpv
FROM
  (SELECT extractday,
          a.sys_id AS data_source,
          CASE
              WHEN event_id='bxyk' THEN '信用卡'
              WHEN d.product_name_new IS NOT NULL THEN d.product_name_new
              ELSE a.product_name
          END product_name,
          a.mbl_no,
          CASE
              WHEN a.extractday=b.register_date THEN 'Y'
              ELSE 'N'
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
                END) AS bannerpv
   FROM warehouse_atomic_user_action AS a
   LEFT JOIN
     (SELECT data_source,
             mbl_no,
             min(register_date)register_date
      FROM warehouse_atomic_register_process_info
      GROUP BY data_source,
               mbl_no) AS b ON a.sys_id=b.data_source
   AND a.mbl_no=b.mbl_no
   LEFT JOIN warehouse_data_product_info_new AS d ON a.sys_id=d.data_source
   AND a.product_id=d.product_id
   AND a.product_name IS NOT NULL
   WHERE extractday between date_sub(date(current_date()),450) and date_sub(date(current_date()),401)
   GROUP BY a.extractday,
            a.sys_id,
            CASE
                WHEN event_id='bxyk' THEN '信用卡'
                WHEN d.product_name_new IS NOT NULL THEN d.product_name_new
                ELSE a.product_name
            END,
            a.mbl_no,
            CASE
                WHEN a.extractday=b.register_date THEN 'Y'
                ELSE 'N'
            END) AS a
LEFT JOIN
  (SELECT a.mbl_no,
          a.sys_id AS data_source,
          a.product_name,
          a.extractday,
          max(CASE
                  WHEN c.mbl_no IS NOT NULL
                       AND a.extractday BETWEEN c.credit_date AND c.credit_end_date THEN '1'
                  WHEN c.mbl_no IS NOT NULL THEN '0'
              END) AS is_credit
   FROM warehouse_atomic_user_action AS a
   JOIN warehouse_data_credit_start_to_end AS c ON a.mbl_no=c.mbl_no
   AND a.product_name=c.product_name
   GROUP BY a.mbl_no,
            a.sys_id,
            a.product_name,
            extractday) AS b ON a.mbl_no=b.mbl_no
AND a.product_name=b.product_name
AND a.data_source=b.data_source
AND a.extractday=b.extractday;
