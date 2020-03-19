--重构数据库PDM_xye_core_distributi_test-2020.01.09

(drop table if exists xye_core_distributi_test.dis_order;

/*==============================================================*/
/* Table: dis_order                                             */
/*==============================================================*/
create table xye_core_distributi_test.dis_order
(
   id                   varchar(100) not null comment '申请编号',
   customer_name        varchar(100) comment '客户名称',
   customer_phone       varchar(11) comment '手机号',
   customer_id_card     varchar(30) comment '证件号码',
   loan_type            varchar(50) comment '贷款类型',
   loan_kind            varchar(255) comment '贷款品种',
   special_case_describe varchar(255) comment '专案描述',
   store                varchar(255) comment '门店(商户名称)',
   apply_amount         varchar(50) comment '申请金额',
   approval_amount      varchar(255) comment '审批金额',
   apply_term           varchar(100) comment '申请期限',
   approval_term        varchar(100) comment '审批期限',
   apply_time           varchar(100) comment '申请日期',
   apply_artificial_company varchar(255) comment '申请人工作单位',
   contract_signing_time varchar(100) comment '合同签订时间',
   channel              varchar(255) comment '渠道来源',
   credit_director      varchar(100) comment '信贷经理',
   market_director      varchar(100) comment '市场经理',
   sale_adviser         varchar(100) comment '销售顾问',
   transactors          varchar(100) comment '当前办理人',
   apply_state          varchar(255) comment '申请状态',
   create_date          datetime comment '添加时间',
   create_by            varchar(255) comment '创建人',
   update_date          datetime comment '更新时间',
   update_by            varchar(255) comment '更新人',
   state                int(2) default 1 comment '数据状态1：正常 0：删除',
   comments             varchar(255) comment '备注',
   primary key (id)
);
)

(drop table if exists xye_core_distributi_test.dis_order_history;

/*==============================================================*/
/* Table: dis_order_history                                     */
/*==============================================================*/
create table xye_core_distributi_test.dis_order_history
(
   id                   varchar(100) not null comment 'id',
   apply_number         varchar(200) comment '申请编号',
   customer_name        varchar(100) comment '客户名称',
   customer_phone       varchar(11) comment '手机号',
   customer_id_card     varchar(30) comment '证件号码',
   loan_type            varchar(50) comment '贷款类型',
   loan_kind            varchar(255) comment '贷款品种',
   special_case_describe varchar(255) comment '专案描述',
   store                varchar(255) comment '门店',
   apply_amount         varchar(50) comment '申请金额',
   approval_amount      varchar(255) comment '审批金额',
   apply_term           varchar(100) comment '申请期限',
   approval_term        varchar(100) comment '审批期限',
   apply_time           varchar(100) comment '申请日期',
   apply_artificial_company varchar(255) comment '申请人工作单位',
   contract_signing_time varchar(100) comment '合同签订时间',
   channel              varchar(255) comment '渠道来源',
   credit_director      varchar(100) comment '信贷经理',
   market_director      varchar(100) comment '市场经理',
   sale_adviser         varchar(100) comment '销售顾问',
   transactors          varchar(100) comment '当前办理人',
   apply_state          varchar(255) comment '申请状态',
   create_date          datetime comment '添加时间',
   create_by            varchar(255) comment '创建人',
   update_date          datetime comment '更新时间',
   update_by            varchar(255) comment '更新人',
   state                int(2) default 1 comment '数据状态1：正常 0：删除',
   comments             varchar(255) comment '备注',
   batch_number         varchar(255) comment '导入批次号',
   primary key (id)
);
)

(drop table if exists xye_core_distributi_test.export_task;

/*==============================================================*/
/* Table: export_task                                           */
/*==============================================================*/
create table xye_core_distributi_test.export_task
(
   id                   varchar(100) not null comment '任务ID',
   condition_info       text comment '导出条件',
   data_size            int(11) comment '导出数据量',
   status               int(2) comment '状态：0 导出开始 1：导出成功 2：导出失败',
   file_down_path       varchar(255) comment '文件下载路径',
   file_down_num        int(11) comment '文件下载次数',
   create_date          datetime comment '添加时间',
   create_by            varchar(255) comment '创建人',
   update_date          datetime comment '更新时间',
   update_by            varchar(255) comment '更新人',
   state                int(2) default 1 comment '数据状态1：正常 0：删除',
   comments             varchar(255) comment '备注',
   primary key (id)
);
)

(drop table if exists xye_core_distributi_test.import_task;

/*==============================================================*/
/* Table: import_task                                           */
/*==============================================================*/
create table xye_core_distributi_test.import_task
(
   id                   varchar(100) not null comment '任务ID',
   data_size            int(11) comment '导入数据量',
   status               int(2) comment '状态：0 导入开始 1：导入成功 2：导入失败',
   create_date          datetime comment '添加时间',
   create_by            varchar(255) comment '创建人',
   update_date          datetime comment '更新时间',
   update_by            varchar(255) comment '更新人',
   state                int(2) default 1 comment '数据状态1：正常 0：删除',
   comments             varchar(255) comment '备注',
   primary key (id)
);
)

(drop table if exists xye_core_distributi_test.merchant_approval_info;

/*==============================================================*/
/* Table: merchant_approval_info                                */
/*==============================================================*/
create table xye_core_distributi_test.merchant_approval_info
(
   id                   varchar(100) not null,
   merchant_id          varchar(100) comment '商户ID',
   id_card_front_url    varchar(255) comment '省份证正面Url',
   id_card_back_url     varchar(255) comment '省份证反面Url',
   legal_person_name    varchar(10) comment '法人姓名',
   legal_person_phone   varchar(11) comment '法人联系电话',
   legal_perso_id_card_front_url varchar(255) comment '法人身份证正面url',
   legal_perso_id_card_back_url varchar(255) comment '法人身份证反面url',
   legal_perso_bank_card_front_url varchar(255) comment '法人银行卡正面url',
   business_license_url varchar(255) comment '营业执照',
   salesman_id_card_front_url varchar(255) comment '营业员省份证正面Url',
   salesman_id_card_back_url varchar(255) comment '营业员省份证反面Url',
   salesman_id_card_hand_url varchar(255) comment '营业员省份证手持Url',
   salesman_name        varchar(255) comment '营业员名称',
   salesman_phone       varchar(255) comment '营业员手机号',
   store_exterior_url   varchar(255) comment '门店外景带门头照url',
   store_interior_url   varchar(255) comment '门店内景url',
   store_area           varchar(255) comment '门店面积',
   cmcc_authorize_url   varchar(255) comment '移动授权url',
   credit_authorize_url varchar(255) comment '个人征信授权url',
   create_date          datetime comment '添加时间',
   create_by            varchar(255) comment '创建人',
   update_date          datetime comment '更新时间',
   update_by            varchar(255) comment '更新人',
   state                int(2) default 1 comment '数据状态1：正常 0：删除',
   comments             varchar(255) comment '备注',
   primary key (id)
);
)

(drop table if exists xye_core_distributi_test.merchant_approval_log;

/*==============================================================*/
/* Table: merchant_approval_log                                 */
/*==============================================================*/
create table xye_core_distributi_test.merchant_approval_log
(
   id                   varchar(100) not null,
   merchant_id          varchar(100) comment '商户ID',
   approval_date        datetime comment '审核时间',
   approval_by          varchar(255) comment '审批人员',
   approval_state       int(2) default 0 comment '审批状态 0：未提交审批资料 1：代审批 2：审批失败 3：审批通过',
   approval_comments    text comment '审核备注',
   primary key (id)
);
)

(drop table if exists xye_core_distributi_test.merchant_info;

/*==============================================================*/
/* Table: merchant_info                                         */
/*==============================================================*/
create table xye_core_distributi_test.merchant_info
(
   id                   varchar(100) not null comment '商户ID',
   merchant_name        varchar(255) comment '商户名称',
   contacts             varchar(255) comment '联系人',
   contact_phone        varchar(11) comment '联系电话',
   merchant_level       int(2) comment '商户级别',
   parent_id            varchar(200) comment '父级id',
   parent_name          varchar(255) comment '父级名称',
   login_account        varchar(50) comment '登陆账号',
   user_center_code     varchar(200) comment '用户中心关联userCode',
   submit_approval_date datetime comment '提交审批时间',
   approval_date        datetime comment '审核时间',
   approval_by          varchar(255) comment '审批人员',
   approval_state       int(2) default 0 comment '审批状态 0：未提交审批资料 1：代审批 2：审批失败 3：审批通过',
   approval_comments    text comment '审核备注(失败原因)',
   status               int(2) default 1 comment '商户状态 1：合作中 0：冻结',
   create_date          datetime comment '添加时间',
   create_by            varchar(255) comment '创建人',
   update_date          datetime comment '更新时间',
   update_by            varchar(255) comment '更新人',
   state                int(2) default 1 comment '数据状态1：正常 0：删除',
   comments             varchar(255) comment '备注',
   primary key (id)
);
)

