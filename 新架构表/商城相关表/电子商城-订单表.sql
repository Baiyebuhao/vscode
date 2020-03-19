--电子商城表
--订单表
(--授信申请记录表
/*==============================================================*/
/* Table: credit_apply_info                                     */
/*==============================================================*/
create table xye_core_order_credit_test.credit_apply_info
(
   id                   varchar(50) not null comment 'id',
   order_code           varchar(50) comment '订单编码',
   product_type         varchar(10) comment '订单类型(暂时未用到此字段)',
   credit_apply_amt     double comment '授信申请金额',
   credit_apply_date    datetime comment '授信通过时间',
   periods              int(11) comment '期数',
   status_code          int(11) comment '授信状态',
   status_msg           varchar(100) comment '状态描述',
   trans_req_code       varchar(100) comment '我方请求号',
   trans_res_code       varchar(100) comment '三方响应号',
   credit_available_amt double comment '授信剩余金额',
   credit_valid_date    varchar(50) comment '授信有效期',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(50) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(50) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   credit_total_amt     double(255,0) comment '授信金额全部',
   primary key (id)
);

alter table xye_core_order_credit_test.credit_apply_info comment '授信申请记录';
)

(--status_code的状态对应表
/*==============================================================*/
/* Table: credit_order_status_dict                              */
/*==============================================================*/
create table xye_core_order_credit_test.credit_order_status_dict
(
   id                   varchar(50) not null,
   status_type          varchar(50),
   status_code          varchar(50)   int(11) comment '授信状态', 
   status_name          varchar(50)   varchar(50) comment '授信状态中文',
   parent_id            varchar(50),
   status_desc          varchar(200),
   status_sort          int(11),
   comments             varchar(50),
   create_date          datetime,
   create_by            varchar(50),
   update_date          datetime,
   update_by            varchar(50),
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   status_code_t        int(11) comment '台账对应的状态',
   primary key (id)
);
)

(
/*==============================================================*/
/* Table: credit_core_order                                     */
/*==============================================================*/
create table xye_core_order_credit_test.credit_core_order
(
   id                   varchar(36) not null comment 'id',
   order_code           varchar(50) comment '订单号',
   product_type         varchar(50) comment '产品类型（随借随还，现金分期）',
   order_type           varchar(45) comment '类型,信贷or分期',
   order_status         varchar(45) comment '父状态',
   sub_order_status     varchar(50) comment '订单子状态',
   channel_code         varchar(50) comment '订单来源渠道',
   user_code            varchar(50) comment '用户code',
   user_account         varchar(50),
   mobile               varchar(45) comment '手机',
   store_code           varchar(50) comment '店铺编码',
   store_name           varchar(200) comment '店铺名称',
   mall_code            varchar(50) comment '商城编码',
   mall_name            varchar(200) comment '商城名称',
   goods_id             varchar(50) comment '商品id',
   goods_name           varchar(50) comment '商品名称',
   goods_pic            varchar(500) comment '图片地址',
   product_id           varchar(50) comment '产品id',
   comments             varchar(255) comment '备注1',
   create_date          datetime comment '创建时间',
   create_by            varchar(50) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(50) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   add_params           varchar(1000) comment '附加参数',
   etl_time             datetime,
   etl_source           varchar(60),
   valid_day            int(11),
   repay_type           varchar(100) comment '还款方式',
   fang_pic             varchar(500) comment '方形图片',
   org_id               varchar(50) comment '机构id',
   promote_sales_code   varchar(200) comment '推广码',
   primary key (id),
   key idx_order_code (order_code)
);

alter table xye_core_order_credit_test.credit_core_order comment '信贷订单';

)

(
drop table if exists xye_core_order_credit_test.loan_apply_info;

/*==============================================================*/
/* Table: loan_apply_info                                       */
/*==============================================================*/
create table xye_core_order_credit_test.loan_apply_info
(
   id                   varchar(50) not null comment 'id',
   order_code           varchar(50) comment '订单编码',
   product_type         varchar(10) comment '订单类型',
   loan_amt             double comment '放款申请金额',
   loan_apply_date      datetime comment '放款申请时间',
   periods              int(11) comment '期数',
   status_code          int(11) comment '放款状态',
   status_msg           varchar(100) comment '状态描述',
   trans_req_code       varchar(100) comment '我方请求号',
   trans_res_code       varchar(100) comment '三方响应号',
   loan_down_date       datetime comment '放款时间',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(50) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(50) comment '修改人',
   state                int(11) not null default 1 comment '状态',
   primary key (id)
);

alter table xye_core_order_credit_test.loan_apply_info comment '放款提现申请记录';

)

(
drop table if exists xye_core_order_credit_test.credit_order_log;

/*==============================================================*/
/* Table: credit_order_log                                      */
/*==============================================================*/
create table xye_core_order_credit_test.credit_order_log
(
   id                   varchar(50) not null comment 'id',
   order_code           varchar(30) comment '订单编码',
   log_info             text comment '授信额度',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   primary key (id)
);

alter table xye_core_order_credit_test.credit_order_log comment '标准台账交互信息';
 
)