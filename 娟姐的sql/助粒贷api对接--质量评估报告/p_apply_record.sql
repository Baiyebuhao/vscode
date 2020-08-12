CREATE TABLE `p_apply_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) DEFAULT NULL COMMENT '订单号',
  `status` int(1) DEFAULT NULL COMMENT '授信状态 0 授信中，1授信成功，2授信失败  3 预授信成功  4 鉴权成功 5 鉴权处理中',
  `mht_apply_no` varchar(64) DEFAULT NULL COMMENT '出资方申请单号',
  `check_time` varchar(32) DEFAULT NULL COMMENT '审核时间',
  `check_memo` varchar(200) DEFAULT NULL COMMENT '\r\n审核处理消息',
  `check_amount` double(20,0) DEFAULT NULL COMMENT '审核额度，成功返回 单位：分',
  `expiry_time` varchar(32) DEFAULT NULL COMMENT '过期时间',
  `result_json` varchar(2000) DEFAULT NULL,
  `callback_json` varchar(2000) DEFAULT NULL COMMENT '回调json信息',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `platform_order_no` bigint(20) DEFAULT NULL COMMENT '平台订单号',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=185116 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='申请授信记录表';