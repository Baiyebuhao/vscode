CREATE TABLE `product_info` (
  `id` varchar(50) COLLATE utf8mb4_bin NOT NULL COMMENT 'ID',
  `product_code` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '产品编号',
  `product_name` varchar(200) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '产品名称',
  `cate_id` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '分类编码',
  `product_type` varchar(45) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '产品类型 1信贷 2实物分期 3随借随还 11信用卡 21保险 ...',
  `product_desc` varchar(200) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '产品简述',
  `status` varchar(200) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '对接状态',
  `rate` double DEFAULT NULL COMMENT '利息',
  `repay_type` varchar(45) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '还款方式支持  PRINCIPAL 等额本金  INTEREST 等额本息',
  `periods` varchar(200) CHARACTER SET utf8 DEFAULT NULL COMMENT '期数支持',
  `credit_amt_min` double DEFAULT NULL COMMENT '授信金额',
  `credit_amt_max` double DEFAULT NULL COMMENT '授信金额',
  `org_id` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '机构id',
  `create_date` timestamp NULL DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(30) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '创建人',
  `update_date` timestamp NULL DEFAULT NULL COMMENT '修改时间',
  `update_by` varchar(30) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '修改人',
  `state` int(11) DEFAULT '1' COMMENT '状态',
  `comments` varchar(200) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '备注',
  `visit_url` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT '访问第三方页面url',
  `service_name` varchar(80) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '服务名称',
  `max_rate` double DEFAULT NULL COMMENT ' 最大利率',
  `is_fixation_rate` int(1) DEFAULT '1' COMMENT '是否为固定利率',
  `is_modify_status` int(1) DEFAULT '0' COMMENT '是否可以修改订单状态(0-否，1-是)',
  `valid_day` int(255) DEFAULT NULL COMMENT '有效期 天',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='产品接入表';