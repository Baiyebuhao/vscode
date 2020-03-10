--和包2.0数据表

('''--
CREATE TABLE `credit_apply_error_status` (
  `id` bigint(20) DEFAULT NULL,
  `qry_credit_id` varchar(128) DEFAULT NULL COMMENT '授信流水号',
  `hb_usr_no` varchar(20) DEFAULT NULL COMMENT '和包用户号',
  `mbl_no` varchar(11) DEFAULT NULL COMMENT '手机号',
  `usr_Id_card` varchar(20) DEFAULT NULL COMMENT '身份证号码',
  `credit_amt` decimal(24,2) DEFAULT NULL COMMENT '授信额度',
  `credit_result` varchar(3) DEFAULT NULL COMMENT '授信状态 0:授信中 1：授信成功 2：失败',
  `credit_ret_msg` varchar(128) DEFAULT NULL COMMENT '授信订单状态描述',
  `eff_dt` varchar(16) DEFAULT NULL COMMENT '授信额度生效日期',
  `exp_dt` varchar(16) DEFAULT NULL COMMENT '授信额度失效日期',
  `credit_lock_tm` varchar(16) DEFAULT NULL COMMENT '授信锁定到期时间',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='授信申请状态表';
'''
)

--授信申请状态表
--warehouse_hebao_credit_apply_status
CREATE TABLE `credit_apply_status` (
  `id` bigint(20) DEFAULT NULL,
  `qry_credit_id` varchar(128) DEFAULT NULL COMMENT '授信流水号',
  `hb_usr_no` varchar(20) DEFAULT NULL COMMENT '和包用户号',
  `mbl_no` varchar(11) DEFAULT NULL COMMENT '手机号',
  `usr_id_name` varchar(50) DEFAULT NULL,
  `usr_Id_card` varchar(20) DEFAULT NULL COMMENT '身份证号码',
  `credit_amt` decimal(24,2) DEFAULT NULL COMMENT '授信额度',
  `credit_result` varchar(3) DEFAULT NULL COMMENT '授信状态 0:授信中 1：授信成功 2：失败',
  `credit_ret_msg` varchar(8) DEFAULT NULL COMMENT '授信订单状态描述',
  `eff_dt` varchar(16) DEFAULT NULL COMMENT '授信额度生效日期',
  `exp_dt` varchar(16) DEFAULT NULL COMMENT '授信额度失效日期',
  `credit_lock_tm` varchar(16) DEFAULT NULL COMMENT '授信锁定到期时间',
  `extra_field` varchar(256) DEFAULT NULL COMMENT '附加字段，以json格式存储',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='授信申请状态表';

--用户信息1
--warehouse_hebao_credit_apply_user_inf
CREATE TABLE `credit_apply_user_inf` (
  `id` bigint(20) NOT NULL,
  `qry_creditId` varchar(128) DEFAULT NULL COMMENT '授信流水',
  `hb_usr_no` varchar(128) DEFAULT NULL COMMENT '和包贷用户号\r\n            ',
  `mbl_no` varchar(11) DEFAULT NULL COMMENT '用户注册手机号\r\n            ',
  `usr_id_name` varchar(50) DEFAULT NULL COMMENT '用户身份证姓名\r\n            ',
  `usr_id_card` varchar(50) DEFAULT NULL COMMENT '用户身份证号码\r\n            ',
  `address` varchar(255) DEFAULT NULL COMMENT '家庭住址编码\r\n            ',
  `in_come` varchar(50) DEFAULT NULL COMMENT '收入区间\r\n            ',
  `user_job` varchar(128) DEFAULT NULL COMMENT '用户工作类型\r\n            ',
  `contact_name` varchar(50) DEFAULT NULL COMMENT '紧急联系人姓名\r\n            ',
  `contact_mbl_no` varchar(50) DEFAULT NULL COMMENT '紧急联系人电话\r\n            ',
  `contact_relation` varchar(50) DEFAULT NULL COMMENT '紧急联系人关系\r\n            ',
  `bank_card_no` varchar(50) DEFAULT NULL COMMENT '银行卡号\r\n            ',
  `bank_card_name` varchar(50) DEFAULT NULL COMMENT '银行卡实名姓名\r\n            ',
  `bank_mbl_no` varchar(11) DEFAULT NULL COMMENT '银行卡预留手机号\r\n            ',
  `bank_code` varchar(8) DEFAULT NULL COMMENT '银行编码\r\n            ',
  `company_name` varchar(128) DEFAULT NULL COMMENT '公司名称\r\n            ',
  `company_address` varchar(255) DEFAULT NULL COMMENT '公司地址\r\n            ',
  `company_address_code` varchar(128) DEFAULT NULL COMMENT '公司地址省市编码\r\n            ',
  `company_mbl_no` varchar(30) DEFAULT NULL COMMENT '公司联系电话\r\n            ',
  `schooling` varchar(16) DEFAULT NULL COMMENT '学历\r\n            ',
  `social_identity` varchar(3) DEFAULT NULL COMMENT '社会身份\r\n            ',
  `user_mail` varchar(128) DEFAULT NULL COMMENT '常用邮箱\r\n            ',
  `marital_sta` varchar(20) DEFAULT NULL COMMENT '婚姻情况 1已婚 0未婚\r\n            ',
  `id_exp_dt` varchar(50) DEFAULT NULL COMMENT '身份证有效日期\r\n            ',
  `country` varchar(20) DEFAULT NULL COMMENT '国籍\r\n            ',
  `nation` varchar(64) DEFAULT NULL COMMENT '民族\r\n            ',
  `cus_sex` varchar(4) DEFAULT NULL COMMENT '"性别  0 男 1；女 2:未知"\r\n            ',
  `usr_prov_no` varchar(6) DEFAULT NULL COMMENT '用户归属省份\r\n            ',
  `cre_time` datetime DEFAULT NULL,
  `update_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--用户信息2
--warehouse_hebao_credit_apply_user_ext_inf
CREATE TABLE `credit_apply_user_ext_inf` (
  `id` bigint(20) NOT NULL,
  `qry_credit_id` varchar(128) DEFAULT NULL COMMENT '授信流水\r\n            ',
  `id_card_front_id` varchar(255) DEFAULT NULL COMMENT '身份证正面图片ID\r\n            ',
  `id_card_back_id` varchar(255) DEFAULT NULL COMMENT '身份证反面图片ID\r\n            ',
  `live_picture_id` varchar(255) DEFAULT NULL COMMENT '活体照片截图图片ID\r\n            ',
  `id_card_front_url` varchar(255) DEFAULT NULL COMMENT '身份证正面图片链接\r\n            ',
  `id_card_back_url` varchar(255) DEFAULT NULL COMMENT '身份证反面图片链接\r\n            ',
  `live_picture_url` varchar(255) DEFAULT NULL COMMENT '活体照片截图图片链接\r\n            ',
  `zip_code` varchar(16) DEFAULT NULL COMMENT '邮政编码\r\n            ',
  `address_code` varchar(128) DEFAULT NULL COMMENT '家庭住址编码\r\n            ',
  `live_org_nm` varchar(128) DEFAULT NULL COMMENT '活体识别结构名称\r\n            ',
  `live_org_id` varchar(32) DEFAULT NULL COMMENT '活体识别结构编号\r\n            ',
  `live_score` decimal(24,0) DEFAULT NULL COMMENT '活体识别分数\r\n            ',
  `app_id` varchar(24) DEFAULT NULL COMMENT '渠道编码\r\n            ',
  `hb_score` varchar(12) DEFAULT NULL COMMENT '和包分数\r\n            ',
  `credit_tot_score` varchar(20) DEFAULT NULL COMMENT '研究院信用总分数\r\n            ',
  `credit_mod_score` varchar(20) DEFAULT NULL COMMENT '研究院信用购机模型评分总分\r\n            ',
  `opr_id` varchar(128) DEFAULT NULL COMMENT '营业员编号\r\n            ',
  `opr_mbl_no` varchar(11) DEFAULT NULL COMMENT '营业员手机号\r\n            ',
  `reg_dt` varchar(14) DEFAULT NULL COMMENT '注册日期\r\n            ',
  `user_star_lvl` varchar(6) DEFAULT NULL COMMENT '用户星级\r\n            ',
  `user_type` varchar(4) DEFAULT NULL COMMENT '用户准入结果\r\n            ',
  `apply_modelcode` varchar(128) DEFAULT NULL COMMENT '用户借款申请手机串码\r\n            ',
  `apply_ip` varchar(128) DEFAULT NULL COMMENT '用户借款申请IP地址\r\n            ',
  `total_bonus_amt` decimal(24,2) DEFAULT NULL COMMENT '总红包额\r\n            ',
  `applseq` varchar(24) DEFAULT NULL COMMENT '签章流水号\r\n            ',
  `contact_name1` varchar(50) DEFAULT NULL COMMENT '第二个紧急联系人姓名\r\n            ',
  `contact_mbl_no1` varchar(50) DEFAULT NULL COMMENT '第二个紧急联系人电话\r\n            ',
  `contact_relation1` varchar(50) DEFAULT NULL COMMENT '第二个紧急联系人关系\r\n            ',
  `contact_name2` varchar(50) DEFAULT NULL COMMENT '第3个紧急联系人姓名\r\n            ',
  `contact_mbl_no2` varchar(50) DEFAULT NULL COMMENT '第3个紧急联系人电话\r\n            ',
  `contact_relation2` varchar(50) DEFAULT NULL COMMENT '第3个紧急联系人关系\r\n            ',
  `cre_time` datetime DEFAULT NULL,
  `update_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--借款申请信息表
-- warehouse_hebao_loan_apply_info
CREATE TABLE `loan_apply_info` (
  `id` bigint(20) DEFAULT NULL,
  `mbl_no` varchar(11) DEFAULT NULL COMMENT '手机号',
  `hb_usr_no` varchar(20) DEFAULT NULL COMMENT '和包用户号',
  `brw_ord_no` varchar(32) DEFAULT NULL COMMENT '和包订单号',
  `brw_ord_dt` varchar(10) DEFAULT NULL COMMENT '和包贷借款订单日期',
  `product_nm` varchar(128) DEFAULT NULL COMMENT '套餐描述',
  `product_id` varchar(32) DEFAULT NULL COMMENT '套餐编号',
  `pkg_amt` decimal(24,2) DEFAULT NULL COMMENT '套餐金额',
  `loan_amt` decimal(24,2) DEFAULT NULL COMMENT '贷款金额',
  `loan_month` decimal(24,0) DEFAULT NULL COMMENT '贷款分期数',
  `good_id` varchar(128) DEFAULT NULL COMMENT '商品编号',
  `good_nm` varchar(128) DEFAULT NULL COMMENT '商品名称',
  `opr_id` varchar(128) DEFAULT NULL COMMENT '营业员编号',
  `opr_mbl_no` varchar(11) DEFAULT NULL COMMENT '营业员手机号',
  `dep_id` varchar(128) DEFAULT NULL COMMENT '营业厅编号',
  `dep_nm` varchar(128) DEFAULT NULL COMMENT '营业厅名称',
  `dep_mng_mbl_no` varchar(11) DEFAULT NULL COMMENT '业务办理营业厅负责人手机号',
  `app_Id` varchar(16) DEFAULT NULL COMMENT '渠道编码',
  `apply_model_code` varchar(128) DEFAULT NULL COMMENT '用户借款申请手机串码',
  `apply_ip` varchar(128) DEFAULT NULL COMMENT '用户借款申请IP地址',
  `mng_model` varchar(6) DEFAULT NULL COMMENT '营业厅经营模式',
  `bus_typ` varchar(6) DEFAULT NULL COMMENT '业务类型',
  `dep_prov_no` varchar(6) DEFAULT NULL COMMENT '营业厅省份编号',
  `dep_city_no` varchar(6) DEFAULT NULL COMMENT '营业厅地市编号',
  `dep_reg_no` varchar(16) DEFAULT NULL COMMENT '营业厅区域编号',
  `merc_id` varchar(50) DEFAULT NULL COMMENT '门店商户号',
  `merc_nm` varchar(128) DEFAULT NULL COMMENT '门店商户名称',
  `act_brw_mbl_no` varchar(11) DEFAULT NULL COMMENT '实际借款用户手机号',
  `act_brw_hb_usr_no` varchar(20) DEFAULT NULL COMMENT '实际借款和包ID',
  `act_brw_id_no` varchar(20) DEFAULT NULL COMMENT '实际借款用户身份证号',
  `actual_orgId` varchar(30) DEFAULT NULL COMMENT '实际借款出',
  `prov_stg_day` varchar(10) DEFAULT NULL,
  `credit_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '修改时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='借款申请状态表';


--省市地市对照表
--warehouse_hebao_prov_city_info
CREATE TABLE `warehouse_hebao_prov_city_info` (
  `dep_prov_no` varchar(4) NOT NULL COMMENT '省编码',
  `dep_prov_name` varchar(16) NOT NULL COMMENT '省名称',
  `dep_city_no` varchar(6) NOT NULL COMMENT '市编码',
  `dep_city_name` varchar(20) NOT NULL COMMENT '市名称',
  `dep_reg_no` varchar(10) NOT NULL COMMENT '区编码',
  `dep_reg_name` varchar(50) NOT NULL COMMENT '区名称'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


--借款申请状态表
-- warehouse_hebao_loan_apply_status
CREATE TABLE `loan_apply_status` (
  `id` bigint(20) NOT NULL,
  `brw_ord_no` varchar(32) DEFAULT NULL COMMENT '和包订单号',
  `org_ord_no` varchar(50) DEFAULT NULL COMMENT '资金方借款订单号',
  `hb_usr_no` varchar(20) DEFAULT NULL COMMENT '和包用户号',
  `mbl_no` varchar(11) DEFAULT NULL COMMENT '手机号',
  `usr_Id_card` varchar(20) DEFAULT NULL,
  `loan_amt` decimal(24,2) DEFAULT NULL,
  `brw_ord_dt` varchar(16) DEFAULT NULL COMMENT '借款订单日期',
  `brw_ord_sts` varchar(3) DEFAULT NULL COMMENT '借款订单状态--\r\nP：借款处理中\r\nS：借款成功\r\nF：借款失败',
  `brw_ord_msg` varchar(50) DEFAULT NULL COMMENT '借款结果描述',
  `actual_org_id` varchar(32) DEFAULT NULL COMMENT '实际出资方编号',
  `actual_Org_nm` varchar(32) DEFAULT NULL COMMENT '实际出资方名称',
  `extra_field` varchar(256) DEFAULT NULL COMMENT '附加字段，以json格式存储',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='借款申请状态表';



--套餐记录表
--warehouse_hebao_business_record
CREATE TABLE `business_record` (
  `id` bigint(20) NOT NULL,
  `brw_ord_no` varchar(50) DEFAULT NULL COMMENT '和包贷借款订单号',
  `brw_ord_dt` varchar(20) DEFAULT NULL COMMENT '和包贷借款订单日期',
  `org_ord_no` varchar(50) DEFAULT NULL COMMENT '资金方借款订单号',
  `acp_tm` varchar(20) DEFAULT NULL COMMENT '业务办理时间',
  `model_code` varchar(128) DEFAULT NULL COMMENT '机型串码编号',
  `app_id` varchar(20) DEFAULT NULL COMMENT '渠道编码',
  `pick_code` varchar(12) DEFAULT NULL COMMENT '取货码',
  `opr_id` varchar(128) DEFAULT NULL COMMENT '营业员编号',
  `opr_mbl_no` varchar(11) DEFAULT NULL COMMENT '营业员手机号',
  `dep_id` varchar(128) DEFAULT NULL COMMENT '营业厅编号',
  `dep_nm` varchar(128) DEFAULT NULL COMMENT '营业厅名称',
  `mbl_no` varchar(11) DEFAULT NULL COMMENT '用户注册手机号',
  `group_picture_url` varchar(255) DEFAULT NULL COMMENT '取货图片地址链接',
  `ticket_picture_url` varchar(255) DEFAULT NULL COMMENT '小票图片地址链接',
  `group_picture_id` varchar(255) DEFAULT NULL COMMENT '取货图片ID',
  `ticket_picture_id` varchar(255) DEFAULT NULL COMMENT '小票图片ID',
  `cre_time` datetime DEFAULT NULL,
  `update_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='套餐记录表';


--还款计划表
--warehouse_hebao_repayent_plan
CREATE TABLE `repayent_plan` (
  `id` bigint(20) NOT NULL,
  `brw_ord_no` varchar(50) DEFAULT NULL COMMENT '和包贷借款订单号\r\n            ',
  `org_ord_no` varchar(50) DEFAULT NULL COMMENT '资金方借款订单号\r\n            ',
  `brw_ord_dt` varchar(14) DEFAULT NULL COMMENT '和包贷借款订单日期\r\n            ',
  `ord_mod` varchar(5) DEFAULT NULL COMMENT '借款订单模式',
  `rpy_mod` varchar(5) DEFAULT NULL COMMENT '还款模式',
  `rpy_seq` varchar(5) DEFAULT NULL COMMENT '还款期数',
  `org_plan_no` varchar(50) DEFAULT NULL COMMENT '资金方还款计划号',
  `act_rpy_amt` decimal(24,2) DEFAULT NULL COMMENT '实际还款金额',
  `plan_list` text COMMENT '还款计划json\r\n            ',
  `cre_time` datetime DEFAULT NULL COMMENT '创建时间\r\n            ',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='还款计划表';


--还款记录表
--warehouse_hebao_repayment_record
CREATE TABLE `repayment_record` (
  `id` bigint(20) NOT NULL,
  `brw_ord_no` varchar(50) DEFAULT NULL COMMENT '和包贷借款订单号\r\n            ',
  `brw_ord_dt` varchar(14) DEFAULT NULL COMMENT '和包订单日期',
  `org_ord_no` varchar(50) DEFAULT NULL COMMENT '资金方借款订单号\r\n            ',
  `ord_mod` varchar(2) DEFAULT NULL COMMENT '借款订单模式 1：分期还款\r\n            ',
  `rpy_mod` varchar(4) DEFAULT NULL COMMENT '1：还某期2：提前清贷3：退货\r\n            ',
  `rpy_seq` decimal(24,2) DEFAULT NULL COMMENT '还款期数\r\n            ',
  `org_plan_no` varchar(32) DEFAULT NULL COMMENT '资金方还款计划号\r\n            ',
  `rpy_amt` decimal(24,2) DEFAULT NULL COMMENT '当期应还账单金额（本金）\r\n            ',
  `rpy_ord_no` varchar(50) DEFAULT NULL COMMENT '和包贷还款订单号\r\n            ',
  `rpy_ord_dt` varchar(14) DEFAULT NULL COMMENT '和包贷还款订单日期\r\n      ',
  `rpy_sts` varchar(2) DEFAULT NULL COMMENT '还款状态；S成功/F失败\r\n            ',
  `is_overdue` varchar(2) DEFAULT NULL COMMENT '0：未逾期  1:逾期\r\n            ',
  `buisness_id` varchar(3) DEFAULT NULL COMMENT '001:号码借002：购机直降\r\n            ',
  `rpy_desc` varchar(128) DEFAULT NULL COMMENT '还款结果描述\r\n            ',
  `cap_corg` varchar(16) DEFAULT NULL COMMENT '用户还款卡银行编码\r\n            ',
  `crd_no_last` varchar(10) DEFAULT NULL COMMENT '用户还款卡末四位\r\n            ',
  `ac_pay_typ` varchar(4) DEFAULT NULL COMMENT '001：用户还款卡100：用户和包余额101：还款卡+余额\r\n            ',
  `cre_time` datetime DEFAULT NULL,
  `update_time` timestamp NULL DEFAULT NULL,
  `syn_status_result` varchar(2) DEFAULT NULL COMMENT '资方同步还款状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='还款记录表';

--扣款结果表
-- warehouse_hebao_fund_charge
CREATE TABLE `fund_charge` (
  `id` bigint(20) NOT NULL,
  `brw_ord_no` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '和包借款订单号',
  `org_ord_no` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '资金方借款订单号',
  `brw_ord_dt` varchar(14) COLLATE utf8_bin DEFAULT NULL COMMENT '和包贷借款订单日期',
  `ord_mod` varchar(5) COLLATE utf8_bin DEFAULT NULL COMMENT '借款订单模式',
  `rpy_mod` varchar(5) COLLATE utf8_bin DEFAULT NULL COMMENT '还款模式',
  `rpy_seq` varchar(5) COLLATE utf8_bin DEFAULT NULL COMMENT '还款期数',
  `apply_rpy_amt` decimal(24,2) DEFAULT NULL COMMENT '申请应还金额',
  `serviceFee` decimal(24,2) DEFAULT NULL COMMENT '手续服务费',
  `lateFee` decimal(24,2) DEFAULT NULL COMMENT '逾期服务费',
  `rpy_pre_dt` varchar(10) COLLATE utf8_bin DEFAULT NULL COMMENT '和包贷还款预处理日期',
  `rpy_pre_jrn` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '和包贷还款预处理流水号',
  `busRspCd` varchar(10) COLLATE utf8_bin DEFAULT NULL COMMENT '业务响应码',
  `status` varchar(5) COLLATE utf8_bin DEFAULT NULL COMMENT '还款状态',
  `status_msg` varchar(128) COLLATE utf8_bin DEFAULT NULL COMMENT '扣款结果描述',
  `buisnessId` varchar(5) COLLATE utf8_bin DEFAULT NULL COMMENT '业务类型',
  `cre_time` datetime DEFAULT NULL COMMENT '????ʱ??\r\n            ',
  `update_time` timestamp NULL DEFAULT NULL COMMENT '????ʱ??',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='扣款结果表';