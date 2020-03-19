--重构数据库PDM_xye_core_loan_test-2020.01.09
--新架构产品配置表

(drop table if exists xye_core_loan_test.product_info;

/*==============================================================*/
/* Table: product_info                                          */
/*==============================================================*/
create table xye_core_loan_test.product_info
(
   id                   national varchar(50) not null comment 'ID',
   product_code         national varchar(50) comment '产品编号',
   product_name         national varchar(200) comment '产品名称',
   cate_id              national varchar(50) comment '分类编码',
   product_type         national varchar(45) comment '产品类型 1_1现金分期 1_2随借随还 ...',
   product_desc         national varchar(200) comment '产品简述',
   status               national varchar(200) comment '对接状态（暂时未用到此字段）',
   rate                 double comment '利息',
   repay_type           national varchar(45) comment '还款方式支持  PRINCIPAL 等额本金  INTEREST 等额本息',
   periods              national varchar(200) comment '期数支持',
   credit_amt_min       double comment '授信金额',
   credit_amt_max       double comment '授信金额',
   org_id               national varchar(50) comment '机构id',
   create_date          timestamp comment '创建时间',
   create_by            national varchar(30) comment '创建人',
   update_date          timestamp comment '修改时间',
   update_by            national varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             national varchar(200) comment '备注',
   valid_day            int(255) comment '有效期 天',
   visit_url            national varchar(255) comment '访问第三方页面url',
   is_only_url          int(1) default 0 comment '是否 是短链接（0-否，1-是）',
   service_name         national varchar(80) comment '服务名称',
   max_rate             double comment '最大利率',
   is_fixation_rate     int(1) default 1 comment '是否为固定利率（暂时未用到此字段）',
   primary key (id)
);

alter table xye_core_loan_test.product_info comment '产品接入表';
)

(drop table if exists xye_core_loan_test.product_mcc_inf;

/*==============================================================*/
/* Table: product_mcc_inf                                       */
/*==============================================================*/
create table xye_core_loan_test.product_mcc_inf
(
   id                   varchar(60) not null,
   mall_code            varchar(60) comment '商户id',
   prod_id              varchar(60) comment '产品id',
   org_app_chan_no      varchar(60) comment '第三方商户码',
   org_app_sub_chan_no  varchar(60) comment '第三方机构子商户码',
   create_date          timestamp default CURRENT_TIMESTAMP comment '创建时间',
   create_by            varchar(50) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(50) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   org_web_chan_no      varchar(60) comment '第三方商户码',
   org_web_sub_chan_no  varchar(60) comment '第三方机构子商户码',
   primary key (id)
);
)

(drop table if exists xye_core_loan_test.whitelist;

/*==============================================================*/
/* Table: whitelist                                             */
/*==============================================================*/
create table xye_core_loan_test.whitelist
(
   id                   varchar(50) not null,
   prod_id              varchar(50) comment '产品id',
   mobile_no            varchar(20) comment '手机号',
   create_date          datetime comment '创建时间',
   create_by            varchar(50) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(50) comment '修改人',
   state                int(1) comment '状态 0:删除 1：正常',
   comments             varchar(255) comment '备注',
   primary key (id)
);
)
