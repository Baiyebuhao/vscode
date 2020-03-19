CREATE TABLE warehouse_atomic_api_loan_record(
 platform	STRING COMMENT '平台',
 mbl_no	STRING COMMENT '手机号码',
 prod_id	BIGINT COMMENT '产品ID',
 prod_name	STRING COMMENT '产品名称',
 platform_order_no	BIGINT COMMENT '平台订单号',
 end_time	STRING COMMENT '目前状态时间',
 end_status	INT COMMENT '目前状态',
 credit_time_out	STRING COMMENT '授信有效期',
 end_loan_total_amount	DOUBLE COMMENT '目前累计提现金额',
 chan_no	STRING COMMENT '主渠道',
 child_chan_no	STRING COMMENT '子渠道',
 mht_apply_no	STRING COMMENT '机构申请订单号',
 apply_time	STRING COMMENT '申请时间',
 check_time	STRING COMMENT '授信时间',
 check_amount	STRING COMMENT '授信金额',
 check_status	INT COMMENT '授信状态',
 mht_payment_no	STRING COMMENT '机构提现订单',
 payment_time	STRING COMMENT '提现时间',
 payment_status	INT COMMENT '提现状态',
 payment_amount	DOUBLE COMMENT '提现金额',
 loan_period	INT COMMENT '提现期数',
 loan_total_amount	DOUBLE COMMENT '累计提现金额',
 loan_surplus_amount	DOUBLE COMMENT '剩余提现额',
)COMMENT 'API产品授信放款数据表'

INSERT OVERWRITE TABLE warehouse_atomic_api_loan_record
SELECT CASE
           WHEN c.platform_id=1 THEN 'sjd'
           WHEN c.platform_id=2 THEN 'jry'
           WHEN c.platform_id=4 THEN 'xyqb'
       END platform,
       c.mbl_no,
       b.id,
       b.prod_name,
       a.platform_order_no,
       a.create_time AS end_time,
       a.apply_status AS end_status,
       a.credit_time_out,
       a.loan_total_amount AS end_loan_total_amount,
       e.chan_no,
       e.child_chan_no,
       f.mht_apply_no,
       f.create_time,
       f.check_time,
       f.check_amount,
       f.status AS check_status,
       g.mht_payment_no,
       g.payment_time,
       g.status AS payment_status,
       g.payment_amount,
       g.loan_period,
       g.loan_total_amount,
       g.loan_surplus_amount
FROM warehouse_atomic_api_p_user_prod_inf AS a
JOIN warehouse_atomic_api_p_prod_inf AS b ON a.prod_id=b.id
JOIN warehouse_atomic_api_p_user_info AS c ON a.user_id=c.id
LEFT JOIN warehouse_atomic_api_p_order_inf AS e ON a.id=e.user_prod_id
LEFT JOIN warehouse_atomic_api_p_apply_record AS f ON e.id=f.order_id
LEFT JOIN warehouse_atomic_api_p_payment_record AS g ON f.order_id=g.order_id and f.status='1';