CREATE TABLE `p_bank_card_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户id',
  `prod_id` bigint(20) DEFAULT NULL COMMENT '产品id',
  `bank_id` bigint(20) DEFAULT NULL COMMENT '银行id',
  `mht_card_id` varchar(64) DEFAULT NULL COMMENT '机构绑卡id',
  `repay_contract_no` varchar(64) DEFAULT NULL COMMENT '代扣签约协议号',
  `card_no` varchar(40) DEFAULT NULL COMMENT '卡号',
  `mbl_no` varchar(11) DEFAULT NULL COMMENT '手机号',
  `bank_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '开户银行',
  `payment_card` int(11) NOT NULL DEFAULT '0' COMMENT '是否是提现卡 0 不是提现卡 1 是提现卡',
  `repayment_card` int(11) NOT NULL DEFAULT '0' COMMENT '是否是还款卡 0 不是还款卡 1 是还款卡',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `bank_code` varchar(20) DEFAULT '0' COMMENT '银行代码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1412 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='银行卡信息表';