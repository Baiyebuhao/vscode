---汇智信相关表
---营销调查人员单次任务表
warehouse_atomic_hzx_research_task
CREATE TABLE `u_marketing_research_task` (
  `id` bigint(20) NOT NULL,
  `bank_id` bigint(20) DEFAULT NULL COMMENT '银行id',
  `dot_id` bigint(20) DEFAULT NULL COMMENT '网点id',
  `user_id` bigint(20) DEFAULT NULL COMMENT '营销人员id',
  `customer_id` bigint(20) DEFAULT NULL COMMENT '客户id',
  `questionnaire_apply_id` bigint(20) DEFAULT NULL COMMENT '调研id',
  `questionnaire_time` timestamp NULL DEFAULT NULL COMMENT '调研时间',
  `loan_apply_id` bigint(20) DEFAULT NULL COMMENT '申请id',
  `pro_id` bigint(20) DEFAULT NULL COMMENT '申请产品id',
  `pro_version` int(11) DEFAULT NULL COMMENT '申请产品版本',
  `loan_apply_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '贷款申请时间',
  `m_state` int(11) DEFAULT NULL COMMENT '开始营销-1,完成调研问卷-2,创建客户资料完成-3,开始填写贷款申请书-4,营销完成-5,无申请模式营销完成-6,猪宝宝贷提交申请-7',
  `action_state` int(11) DEFAULT NULL COMMENT '营销状态（提交贷款申请后为已营销）',
  `research_status` int(1) DEFAULT NULL COMMENT '未调查-1,待预约1,待调查2,调查中3,调查完成4,拒绝本次申请5',
  `research_apply_id` bigint(20) DEFAULT NULL COMMENT '调查id',
  `research_apply_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '调查时间',
  `score_id` bigint(20) DEFAULT NULL COMMENT '评分卡id',
  `distribution` int(11) DEFAULT NULL COMMENT '是否分配 2重新分配 1已分配  0未分配',
  `dis_time` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT '调查任务分配时间',
  `a_user_id` bigint(20) DEFAULT NULL COMMENT '调查a角',
  `b_user_id` bigint(20) DEFAULT NULL COMMENT '调查b角',
  `research_user_id` bigint(20) DEFAULT NULL COMMENT '调研客户经理',
  `apply_user_id` bigint(20) DEFAULT NULL COMMENT '贷款申请人客户经理',
  `customer_name` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '客户姓名',
  `c_customer_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '客户创建时间',
  `refuse_remark` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '其他原因或补充理由',
  `refuse` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '拒绝原因(手选)',
  `bespeak_time` timestamp NULL DEFAULT NULL COMMENT '预约时间',
  `research_over_time` timestamp NULL DEFAULT NULL COMMENT '调查完成时间',
  `research_plan_over_time` timestamp NULL DEFAULT NULL COMMENT '调查计划完成时间',
  `research_apply_version` bigint(20) DEFAULT NULL COMMENT '申请书版本',
  `rec_amount` decimal(20,0) DEFAULT NULL COMMENT '建议额度',
  `score` double(10,3) DEFAULT NULL COMMENT '评分',
  `bank_pro_id` bigint(20) DEFAULT NULL COMMENT '银行产品ID',
  `res_templets_version` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '本次调查采用的调查模板版本',
  `from_h5` tinyint(1) DEFAULT '0' COMMENT '是否来自h5的申请',
  `res_report_status` int(11) DEFAULT '0' COMMENT '调查报告生成状态[0-未生成1-生成中2-生成完成-3生成异常]',
  `qrcode` bigint(20) DEFAULT NULL COMMENT '二维码ID',
  `version_id` bigint(20) DEFAULT '-1' COMMENT '版本ID',
  `origin` int(11) DEFAULT '1' COMMENT '0-汇智信 APP （默认），1-汇智信H5 、2-金融苑app',
  `customer_level` int(11) DEFAULT '-1' COMMENT '客户分层结果：1-优质客户，2-普通客户，3-拒绝',
  `customer_level_research_id` bigint(20) DEFAULT '-1' COMMENT '外键,指向客户分层记录 ',
  `cutomized_templet` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '定制化模板',
  `store_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '商户ID',
  `warning_state` tinyint(1) DEFAULT '0' COMMENT '预警状态:0:未监控,1:监控中,2:已停止',
  `warning_opt_user_id` bigint(20) DEFAULT NULL COMMENT '预警状态操作人员',
  `warning_opt_time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '预警操作时间',
  `order_number` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '订单号',
  PRIMARY KEY (`id`),
  KEY `ind_task_loan_apply_time` (`loan_apply_time`),
  KEY `ind_task_research_over_time` (`research_over_time`),
  KEY `ind_task_dis_time` (`dis_time`),
  KEY `ind_task_mstate` (`m_state`),
  KEY `ind_task_researchstatus` (`research_status`),
  KEY `ind_task_auserid` (`a_user_id`),
  KEY `idx_research_apply_id` (`research_apply_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='营销调查人员单次任务表';

---银行产品调查页签与产品关系表
warehouse_atomic_hzx_b_loan_research_group_relate
CREATE TABLE `b_loan_research_group_relate` (
  `id` bigint(20) NOT NULL DEFAULT '0' COMMENT 'id',
  `version_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '版本id',
  `xy_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '享宇产品调查问题对应的页签ID',
  `group_id` bigint(20) DEFAULT NULL COMMENT '页签组id',
  `pro_id` bigint(20) DEFAULT NULL,
  `pro_version` int(11) DEFAULT NULL,
  `ENABLE` tinyint(1) DEFAULT NULL COMMENT '是否启用 1启用 0停用',
  `sort` int(10) DEFAULT NULL COMMENT '展現順序',
  PRIMARY KEY (`id`),
  KEY `idx_version_id` (`version_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='银行产品调查页签与产品关系表';

---银行产品调查问题表
warehouse_atomic_hzx_b_research_content_templet
CREATE TABLE `b_research_content_templet` (
  `id` bigint(20) NOT NULL DEFAULT '0' COMMENT 'id',
  `version_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '版本id',
  `xy_id` bigint(20) NOT NULL DEFAULT '0' COMMENT '享宇产品调查问题id',
  `p_id` bigint(20) DEFAULT NULL,
  `p_version` int(11) DEFAULT NULL,
  `g_id` bigint(20) DEFAULT NULL COMMENT '组 id',
  `target_id` bigint(20) DEFAULT NULL COMMENT '指标id，关联指标表',
  `is_target` tinyint(1) DEFAULT NULL,
  `question` varchar(1000) COLLATE utf8_bin DEFAULT NULL COMMENT '问题名称',
  `choose` int(11) DEFAULT NULL COMMENT '0-单选，1-多选，2-输入 ，3-时间型，4-录音型，5-拍照型，6-百分数型，7-地址型',
  `c_user` bigint(20) DEFAULT NULL COMMENT '创建人',
  `u_user` bigint(20) DEFAULT NULL COMMENT '最后修改人',
  `d_user` bigint(20) DEFAULT NULL COMMENT '删除人员',
  `enable` int(11) DEFAULT NULL COMMENT '是否启用 1启用0停用',
  `c_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `u_time` timestamp NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  `d_time` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT '删除时间',
  `sort` int(11) DEFAULT NULL COMMENT '组内排序（控制显示位置）',
  `relate_id` bigint(20) DEFAULT NULL COMMENT '关联项id',
  `multiple_row` tinyint(1) DEFAULT '0' COMMENT '是否多列答案',
  `page_num` int(11) DEFAULT NULL COMMENT '页面（一组可多页显示）',
  `alias` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '组内关系别名',
  `is_required` tinyint(1) DEFAULT NULL COMMENT '1-基本问题  0-跳转问题',
  `answer_calc_formula` varchar(2000) COLLATE utf8_bin DEFAULT NULL COMMENT '问题计算公式',
  `validate` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '校验规则',
  `go_answer_id` bigint(20) DEFAULT NULL COMMENT '跳转问题ID',
  `is_tapes` tinyint(1) DEFAULT '0' COMMENT '是否可录音',
  `is_pictures` tinyint(1) DEFAULT '0' COMMENT '是否可拍照',
  `case_desc` varchar(1000) COLLATE utf8_bin DEFAULT NULL COMMENT '案例',
  `speak_desc` varchar(1000) COLLATE utf8_bin DEFAULT NULL COMMENT '话术',
  `combine_name` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '组合问题名称',
  `combine_id` int(11) DEFAULT NULL COMMENT '组合问题ID',
  `is_add_row` tinyint(1) DEFAULT NULL COMMENT '是否显示加号',
  `time_flag` tinyint(1) DEFAULT '0' COMMENT '开业时间标识 1-是 0-否',
  `show_flg` int(11) DEFAULT '0' COMMENT '显示标示 0-显示全部选项，1-仅显示选择答案',
  `combine_type` smallint(1) DEFAULT '0' COMMENT '0-不是组合问题，1-组合开始问题，2-组合中间问题，3-组合末尾问题，4-该组合问题仅一个问题',
  `statement_type` int(11) DEFAULT '0' COMMENT '是否是引导语句问题 0-不是，1-是',
  `qv_switch_type` int(11) DEFAULT '1' COMMENT '看问开关类型，1：问，2：看',
  `unit_type` int(11) DEFAULT '0' COMMENT '单位后缀 0：无，1：年、2：年-月，3：年-月-日、4：元、5：万元，6：%，7:年，8：月，9：天，10：㎡',
  `calculate_type` int(11) DEFAULT '0' COMMENT '0-可参与评分卡、公式计算，1-不参与评分卡和公式计算',
  `is_entry` tinyint(1) DEFAULT '1' COMMENT '0-非必输、1-必输',
  `num_min` decimal(20,6) DEFAULT NULL COMMENT '填空数字-最小值',
  `num_max` decimal(20,6) DEFAULT NULL COMMENT '填空数字-最大值',
  `voice_name` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `picture_name` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `obj_name` varchar(50) COLLATE utf8_bin DEFAULT '-1' COMMENT '征信对象名称',
  `question_type` int(11) DEFAULT '1' COMMENT '问题类型： 1：常规问题   2：特殊问题',
  `incom_type` int(11) DEFAULT '0' COMMENT '收入计算类型：1：个税  2：代发薪',
  `is_cross_check` smallint(6) DEFAULT '0' COMMENT '是否填写只选择了一种交叉核验原因  0不填写  1填写',
  `cross_check_times` smallint(6) DEFAULT '0' COMMENT '参与交叉核验次数',
  PRIMARY KEY (`id`),
  KEY `b_research_content_templet_v_id_index` (`version_id`,`xy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='银行产品调查问题表';

---标准调查结果记录表
warehouse_atomic_hzx_l_research_result
CREATE TABLE `l_research_result` (
  `id` bigint(20) NOT NULL,
  `research_id` bigint(20) DEFAULT NULL COMMENT '调查申请id',
  `r_id` bigint(20) DEFAULT NULL COMMENT '问题id',
  `input_type` int(11) DEFAULT NULL COMMENT '录入值类型（用来在评分时转换为基本格式，从指标池冗余过来）',
  `answer` text CHARACTER SET utf8 COMMENT '答案值',
  `c_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `target_id` bigint(20) DEFAULT NULL COMMENT '关联指标id',
  `multiple_row` tinyint(1) DEFAULT NULL COMMENT '是否多列答案',
  `row_num` int(11) DEFAULT '0' COMMENT '多列答案序号',
  `a_id` bigint(20) DEFAULT NULL COMMENT '备选答案id',
  `import_task_id` bigint(20) DEFAULT NULL COMMENT '银行客户导入任务ID',
  `parent_id` bigint(20) DEFAULT NULL COMMENT '父问题ID：存放该问题是从哪个问题跳转过来的ID',
  `parent_row_id` int(11) DEFAULT '0' COMMENT '父问题ID对应答案的下标：存放该问题是从哪个问题跳转过来的答案下标',
  PRIMARY KEY (`id`),
  KEY `index_import_task_id` (`import_task_id`),
  KEY `ind_l_res_rst_residandrid` (`research_id`,`r_id`) USING BTREE,
  CONSTRAINT `l_research_result_ibfk_1` FOREIGN KEY (`research_id`) REFERENCES `l_research_apply` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='标准调查结果记录表';

---标准调查拍照
warehouse_atomic_hzx_l_research_apply_photo
CREATE TABLE `l_research_apply_photo` (
  `id` bigint(20) NOT NULL,
  `research_id` bigint(20) DEFAULT NULL COMMENT '调查id',
  `master_url` varchar(300) COLLATE utf8_bin DEFAULT NULL COMMENT '图片源图url地址',
  `thum_url` varchar(300) COLLATE utf8_bin DEFAULT NULL COMMENT '调查图片url地址（带权限）',
  `task_id` bigint(20) DEFAULT NULL COMMENT '调查任务id',
  `question_id` bigint(20) DEFAULT NULL COMMENT '问题ID',
  `enable` tinyint(1) DEFAULT NULL COMMENT '状态 1：正常  0：删除？',
  `createTime` datetime DEFAULT CURRENT_TIMESTAMP,
  `bank_id` bigint(20) DEFAULT NULL COMMENT '银行id',
  `user_id` bigint(20) DEFAULT NULL COMMENT '调查人员id',
  `dot_id` bigint(20) DEFAULT NULL COMMENT '网点id',
  `url_100` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '小图',
  `url_400` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '中图',
  `url_800` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '大图',
  `row_num` int(10) DEFAULT '0' COMMENT '同一个问题多组的组序号',
  `old_pic` int(1) DEFAULT NULL COMMENT '1-相册选择，2-现场拍摄',
  PRIMARY KEY (`id`),
  KEY `fk_reference_40` (`research_id`),
  KEY `idx_photo_task_id` (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='标准调查拍照';

---客户分层调查问题不显示记录表
warehouse_atomic_hzx_l_cust_level_research_show
CREATE TABLE `l_cust_level_research_show` (
  `id` bigint(20) NOT NULL,
  `version_id` bigint(20) DEFAULT NULL COMMENT '产品版本id',
  `xy_id` bigint(20) DEFAULT NULL COMMENT '问题id',
  `task_id` bigint(20) DEFAULT NULL COMMENT '任务id',
  `show_flag` tinyint(1) DEFAULT '0' COMMENT '0：不显示',
  `cust_version_id` bigint(20) DEFAULT '0' COMMENT '分层版本id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='客户分层调查问题不显示记录表';

---根据前置条件判断不显示的页签存储表
warehouse_atomic_hzx_l_cust_group_research_show
CREATE TABLE `l_cust_group_research_show` (
  `id` bigint(20) NOT NULL,
  `version_id` bigint(20) DEFAULT NULL COMMENT '产品版本id',
  `group_id` bigint(20) DEFAULT NULL COMMENT '页签id',
  `task_id` bigint(20) DEFAULT NULL COMMENT '任务id',
  `show_flag` tinyint(1) DEFAULT '0' COMMENT '0：不显示',
  `cust_version_id` bigint(20) DEFAULT '0' COMMENT '分层版本id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='根据前置条件判断不显示的页签存储表';

--客户表
warehouse_atomic_hzx_c_customer
CREATE TABLE `c_customer` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '客户姓名',
  `m_id` bigint(20) DEFAULT NULL COMMENT '客户归属人员id',
  `bank_id` bigint(20) DEFAULT NULL COMMENT '归属银行id',
  `sex` int(11) DEFAULT NULL COMMENT '1:男,0:女',
  `mobile` varchar(15) COLLATE utf8_bin DEFAULT NULL COMMENT '客户手机号',
  `other_mobile` varchar(500) COLLATE utf8_bin DEFAULT NULL COMMENT '其他联系方式',
  `job` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '职业',
  `id_card` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '身份证号',
  `wechar` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '微信号',
  `type` int(11) DEFAULT NULL,
  `c_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `u_time` timestamp NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  `d_time` timestamp NULL DEFAULT '0000-00-00 00:00:00' COMMENT '删除时间',
  `enable` tinyint(1) DEFAULT NULL COMMENT '1:启用',
  `c_user` bigint(20) DEFAULT NULL COMMENT '创建人',
  `u_user` bigint(20) DEFAULT NULL COMMENT '最后修改人',
  `d_user` bigint(20) DEFAULT NULL COMMENT '删除人员',
  `trade` int(11) DEFAULT NULL COMMENT '客户所在行业',
  `birthday_remind` tinyint(1) DEFAULT NULL COMMENT '是否生日提醒',
  `subscribe_mp_loan` tinyint(1) DEFAULT NULL,
  `dot_id` bigint(20) DEFAULT NULL COMMENT '归属网点id',
  `distribution` tinyint(1) DEFAULT NULL,
  `age` int(5) DEFAULT NULL COMMENT '年龄',
  `remark` varchar(500) COLLATE utf8_bin DEFAULT NULL COMMENT '备注',
  `change` int(1) DEFAULT '0' COMMENT '转让标记 默认0,1-即被转让',
  `change_time` timestamp NULL DEFAULT NULL COMMENT '转让时间',
  `last_apply_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '最后申请贷款时间',
  `stem_from` int(11) DEFAULT '0' COMMENT '客户来源[0:汇至信,1:网络,3:全息图同步,4:金融苑]',
  `id_card_nine` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '身份证号后9位',
  `birth_date` varchar(10) COLLATE utf8_bin DEFAULT NULL COMMENT '出生日期',
  `registry_addr` varchar(100) COLLATE utf8_bin DEFAULT NULL COMMENT '户籍地址',
  `c_type` int(1) DEFAULT '0' COMMENT '客户类型：0-沉默客户（白名单），1-正式客户，2-潜在客户',
  `is_import` int(11) DEFAULT '0' COMMENT '客户创建时是否为导入客户[0否，1是]暂时没用，可以和is_import_reset一起用来判断客户是否来源于导入',
  `is_import_reset` int(11) DEFAULT '0' COMMENT '是否进行过导入数据重置[0未进行重置，1重置]导入时有可能已经存在了该身份证的客户，所以新增了一个字段来区分该客户被上传导入过，用处，暂时还没有',
  `hologram_id` bigint(20) DEFAULT NULL COMMENT '全息图客户ID',
  `qrcode` bigint(20) DEFAULT NULL COMMENT 'H5中扫描的二维码ID',
  PRIMARY KEY (`id`),
  KEY `ind_c_customer_idcard` (`id_card`) USING BTREE,
  KEY `ind_c_customer_bankid` (`bank_id`) USING BTREE,
  KEY `ind_c_customer_idcardnine` (`id_card_nine`) USING BTREE,
  KEY `ind_c_cust_ctime` (`c_time`),
  KEY `ind_c_cust_mid` (`m_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='客户表';

CREATE DEFINER=`root`@`%` TRIGGER `trigger_c_customer_idcard_nine` BEFORE INSERT ON `c_customer` FOR EACH ROW set new.id_card_nine=UPPER(right(new.id_card,9))
;;


