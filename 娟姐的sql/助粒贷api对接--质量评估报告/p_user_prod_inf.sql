CREATE TABLE `p_user_prod_inf` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户id',
  `prod_id` bigint(20) DEFAULT NULL COMMENT '产品id',
  `platform_order_no` bigint(20) DEFAULT NULL COMMENT '平台订单号',
  `deal_pwd` varchar(6) DEFAULT NULL COMMENT '交易密码',
  `apply_status` int(1) DEFAULT '0' COMMENT '用户产品状态 0新用户，1授信成功，2授信中，3授信失败，4授信已过期，5已提现，6已逾期 ，7一次授信完成，需再次申请',
  `chil_status` int(5) DEFAULT NULL COMMENT '子状态 ：\r\n 0 csi拒绝/会员注册失败/其他异常 1 风控拒绝  2 上传证件失败 3 真人核验失败 4 放款失败 5 放款前置校验失败  6 重新进行活体检测  7  重新进行短信验证',
  `currt_flow` bigint(20) DEFAULT NULL COMMENT '当前流程',
  `credit_time_out` datetime DEFAULT NULL COMMENT '授信过期时间',
  `loan_total_amount` double(11,0) DEFAULT NULL COMMENT '总额度',
  `loan_surplus_amount` double(11,0) DEFAULT NULL COMMENT '剩余额度',
  `support_period` varchar(100) DEFAULT NULL COMMENT '支持期数',
  `interest_rate` varchar(20) DEFAULT NULL COMMENT '产品利率',
  `interests_calculation` int(1) DEFAULT NULL COMMENT '计息方式1 按日计息，2按月计息',
  `repayment_method` int(1) DEFAULT NULL COMMENT '还款方式1等额本金,2等额本息,3等本等息 4 随借随还 5 按月付息，到期还',
  `overdueInterest_rate` varchar(20) DEFAULT NULL COMMENT '逾期利率',
  `early_repayment` int(1) DEFAULT NULL COMMENT '是否支持提前还款0不支持,1支持',
  `payment_status` int(1) DEFAULT '0' COMMENT '提现还款状态，0正常，1提现中，2提现失败，3还款中，4还款失败',
  `fee_desc` varchar(200) DEFAULT NULL COMMENT '手续费描述',
  `annual_rate` varchar(20) DEFAULT NULL COMMENT '年化利率',
  `appoint_repay_date` varchar(20) DEFAULT NULL COMMENT '固定还款日',
  `reapply_date` varchar(20) DEFAULT NULL COMMENT '再次申请授信时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `org_user_id` varchar(40) DEFAULT NULL COMMENT '机构用户id',
  `platform_id` int(10) DEFAULT NULL COMMENT '平台产品id',
  `is_stock` int(2) DEFAULT '0' COMMENT '是否是存量用户  0 不是，1 是',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=217284 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='用户产品表';