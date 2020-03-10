CREATE TABLE warehouse_data_channel_newuser_daily
(data_source string comment '数据平台',
       extractday  string comment '数据日期',
       the_2nd_level  string comment '二级渠道',
       the_3rd_level  string comment '三级渠道',
       regnum  int comment '注册量',
       chknum int comment '实名量',
       apllynum int comment '申请量',
       creditnum int comment '授信量',
       cashnum int comment '提现量',
       allcash double comment '提现金额',
       cash01 double comment '随借随还-马上_放款金额',
       cash02 double comment '随借随还-众安_放款金额',
       cash03 double comment '随借随还-钱包易贷_放款金额',
       cash04 double comment '现金分期-马上_放款金额',
       cash05 double comment '现金分期-中邮_放款金额',
       cash06 double comment '现金分期-万达普惠_放款金额',
       cash07 double comment '现金分期-点点_放款金额',
       cash08 double comment '现金分期-兴业消费_放款金额',
       cash09 double comment '现金分期-小雨点_放款金额',
       cash10 double comment '现金分期-拉卡拉_放款金额',
       cash11 double comment '大期贷-招联_放款金额',
       cash12 double comment '白领贷-招联_放款金额',
       cash13 double comment '好期贷-招联_放款金额',
       cash14 double comment '业主贷-招联_放款金额'
  );


INSERT INTO warehouse_data_channel_newuser_daily
SELECT data_source,
       extractday,
       the_2nd_level,
       the_3rd_level,
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
WHERE extractday <= date_sub(date(current_date()),1)
GROUP BY data_source,
         extractday,
         the_2nd_level,
         the_3rd_level