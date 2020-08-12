CREATE TABLE `p_bank_inf` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bank_logo` varchar(200) DEFAULT NULL COMMENT '银行图标',
  `bank_name` varchar(50) DEFAULT NULL COMMENT '银行名称',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `银行名称` (`bank_name`)
) ENGINE=InnoDB AUTO_INCREMENT=554 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT COMMENT='银行信息';