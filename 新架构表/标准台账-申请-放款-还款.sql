--标准台账1-申请：
CREATE TABLE `l_application_inf` (
	`id` varchar(128)NOT NULL COMMENT 'ID',
	`data_source` varchar(45) DEFAULT NULL COMMENT '业务平台'，
	`org_no` varchar(45) DEFAULT NULL COMMENT '机构编号',
	`product_no` varchar(45) DEFAULT NULL COMMENT '产品编号',
	`xy_order_no` varchar(45) DEFAULT NULL COMMENT  '享宇订单号',
	`org_order_no` varchar(45) DEFAULT NULL COMMENT '机构订单号',
	`mbl_no` varchar(45) DEFAULT NULL COMMENT '申请人电话',
	`apply_time` datetime DEFAULT NULL COMMENT '申请时间',
	`status` varchar(45) DEFAULT NULL COMMENT '授信状态',
	`credit_time` varchar(45) DEFAULT NULL COMMENT '授信时间',
	`credit_amount` double(11,2) DEFAULT NULL COMMENT '授信金额（可用金额）',
	`loan_term` varchar(45) DEFAULT NULL COMMENT '授信额度有效期',
	`refuse_desc` varchar(100) DEFAULT NULL COMMENT '授信未通过原因',
	`bind_card_time` varchar(100) DEFAULT NULL COMMENT '成功绑卡时间',
	`bind_card_res` varchar(100) DEFAULT NULL COMMENT '绑卡成功结果',
	`inst_rate` varchar(30) DEFAULT NULL COMMENT '产品利率',
	`fee_amt` varchar(11) DEFAULT NULL COMMENT '提现手续费费率',
	`acc_manage_fee` double(11,2) DEFAULT NULL COMMENT '账户管理费',
	`prepay_rate` varchar(11) DEFAULT NULL COMMENT '提前还款手续费费率',
	`record_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '入库时间',
	`hash` varchar(128) NOT NULL COMMENT '全列的hash值',
	PRIMARY KEY (`id`),
	KEY `mbl_no_nl` (`mbl_no`) USING BTREE,
	KEY `xy_order_no_nl` (`xy_order_no`) USING BTREE,
)   ENGINE = InnoDB DEFAULT CHARSET=utf8;

--标准台账2-放款：
CREATE TABLE `l_payment_inf` (
	`id` varchar(128)NOT NULL COMMENT 'ID',
	`data_source` varchar(45) DEFAULT NULL COMMENT '业务平台'，
	`org_no` varchar(45) DEFAULT NULL COMMENT '机构编号',
	`product_no` varchar(45) DEFAULT NULL COMMENT '产品编号',
	`xy_order_no` varchar(45) DEFAULT NULL COMMENT  '享宇订单号',
	`org_order_no` varchar(45) DEFAULT NULL COMMENT '机构订单号',
	`mbl_no` varchar(45) DEFAULT NULL COMMENT '申请人电话',
	`apply_time` datetime DEFAULT NULL COMMENT '申请提现时间',
	`apply_amount` varchar(45) DEFAULT NULL COMMENT '申请提现金额',
	`ltd_lend_amt` double(11,2) DEFAULT NULL COMMENT '累计提现额（随借随还）',
	`total_amount` double(11,2) DEFAULT NULL COMMENT, 
	`total_num` int(11) DEFAULT NULL COMMENT '当天提现次数（随借随还）',
	`approval_status` varchar(11) DEFAULT NULL COMMENT '提现审批状态',
	`approval_time` datetime DEFAULT NULL COMMENT '提现审批时间',
	`loan_status` varchar(40) DEFAULT NULL COMMENT '放款状态',
	`loan_amount` double(11,2) DEFAULT NULL,
	`loan_time` varchar(45) DEFAULT NULL COMMENT '放款时间',
	`loan_period` varchar(45) DEFAULT NULL COMMENT '放款期数',
	`prin_bal` double(11,2) DEFAULT NULL COMMENT '剩余可用额度',
	`record_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '入库时间',
	`hash` varchar(128) NOT NULL COMMENT '全列的hash值',
	PRIMARY KEY (`id`),
)   ENGINE = InnoDB DEFAULT CHARSET=utf8;

--标准台账3-还款：
CREATE TABLE `l_repayment_inf` (
	`id` varchar(70)NOT NULL 'ID',
	`data_source` varchar(45) DEFAULT NULL COMMENT '业务平台'，
	`org_no` varchar(45) DEFAULT NULL COMMENT '机构编号',
	`product_no` varchar(45) DEFAULT NULL COMMENT '产品编号',
	`xy_order_no` varchar(45) DEFAULT NULL COMMENT  '享宇订单号',
	`org_order_no` varchar(45) DEFAULT NULL COMMENT '提现订单号',
	`mbl_no` varchar(45) DEFAULT NULL COMMENT '申请人电话',
	`cash_amount` double(45,2) DEFAULT NULL COMMENT '应还本金总和',
	`total_repay_interest` double(45,2) DEFAULT NULL COMMENT '应还利息总和',
	`pay_principal` double(45,2) DEFAULT NULL COMMENT '本期应还本金',
	`pay_interest` double(45,2) DEFAULT NULL COMMENT '本期应还利息',
	`pay_sever_fee` double(45,2) DEFAULT NULL COMMENT '本期应还服务费',
	`pay_late_fee` double(45,2) DEFAULT NULL COMMENT '本期应还滞纳金',
	`pay_penalty` double(45,2) DEFAULT NULL COMMENT '本期应还违约金',
	`repay_time` varchar(45) DEFAULT NULL COMMENT '本期还款时间',
	`repay_amount` double(45,2) DEFAULT NULL COMMENT '实际还款金额',
	`remaind_amount` double(45,2) DEFAULT NULL COMMENT '本期剩余结清金额',
	`status` varchar(45) DEFAULT NULL COMMENT '结清状态：\n1逾期 \n0未结清 \n1整除结清 \n2逾期结清',
	`settle_time` varchar(45) DEFAULT NULL COMMENT '结清时间',
	`record_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '入库时间',
	`hash` varchar(128) NOT NULL COMMENT '全列的hash值',
	PRIMARY KEY (`id`),
)   ENGINE = InnoDB DEFAULT CHARSET=utf8;















