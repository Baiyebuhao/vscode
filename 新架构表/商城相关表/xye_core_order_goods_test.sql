--重构数据库PDM_xye_core_order_goods_test-2020.01.09
--商品表
(drop table if exists xye_core_order_goods_test.goods_core_order;

/*==============================================================*/
/* Table: goods_core_order                                      */
/*==============================================================*/
create table xye_core_order_goods_test.goods_core_order
(
   id                   varchar(50) not null comment 'id',
   order_code           varchar(200) comment '订单编码',
   order_type           varchar(200) comment '订单类型(COMPLETE_ORDER，PENDING_LOAN)',
   order_status         varchar(200) comment '订单状态',
   sub_order_status     varchar(200) comment '订单子状态',
   channel_code         varchar(255) comment '订单来源渠道',
   user_account         varchar(100),
   user_code            varchar(255),
   store_code           varchar(200) comment '店铺编码',
   store_name           varchar(200) comment '店铺名称',
   mall_code            varchar(200) comment '商城编码',
   mall_name            varchar(200) comment '商城名称',
   logistics_type       int(2) comment '物流标识
                        1    快递
                        2    自提
                        0    其他',
   out_order_no         varchar(200) comment '三方订单号',
   total_price          double(16,2) comment '订单总金额',
   actual_price         double(16,2) comment '优惠后金额',
   user_comments        varchar(255),
   order_snapshot       text comment '订单快照',
   comments             varchar(255) comment '备注1',
   create_date          datetime comment '创建时间',
   create_by            varchar(200) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(200) comment '修改人',
   state                int(3) default 1 comment '状态 0:删除 1：正常',
   primary key (id)
);

alter table xye_core_order_goods_test.goods_core_order comment '商品订单';
)

(drop table if exists xye_core_order_goods_test.goods_order_change;

/*==============================================================*/
/* Table: goods_order_change                                    */
/*==============================================================*/
create table xye_core_order_goods_test.goods_order_change
(
   id                   varchar(50) not null comment 'id',
   order_code           varchar(255) comment '订单编码',
   update_time          datetime comment '订单变化时间',
   old_status           varchar(200) comment '变化前状态',
   update_status        varchar(200) comment '变化后状态',
   old_sub_status       varchar(200) comment '变化前子状态',
   update_sub_status    varchar(200) comment '变化后子状态',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(100) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(100) comment '修改人',
   state                int(3) default 1 comment '状态 0:删除 1：正常',
   primary key (id)
);

alter table xye_core_order_goods_test.goods_order_change comment '商品订单变化表';
)

(drop table if exists xye_core_order_goods_test.goods_order_close;

/*==============================================================*/
/* Table: goods_order_close                                     */
/*==============================================================*/
create table xye_core_order_goods_test.goods_order_close
(
   id                   varchar(50) not null comment 'id',
   order_code           varchar(255) comment '订单编码',
   close_time           datetime comment '订单取消时间',
   close_reason         varchar(255) comment '取消原因',
   close_type           varchar(200) comment '取消类型',
   order_old_status     varchar(200) comment '取消时订单状态',
   order_old_sub_status varchar(200) comment '取消时订单子状态',
   user_code            varchar(200) comment '取消人员编码',
   close_remark         varchar(255) comment '订单取消处理备注',
   handle_idea          varchar(255) comment '处理意见',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(100) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(100) comment '修改人',
   state                int(3) default 1 comment '状态 0:删除 1：正常',
   primary key (id)
);

alter table xye_core_order_goods_test.goods_order_close comment '商品订单订单取消表';
)

(drop table if exists xye_core_order_goods_test.goods_order_express;

/*==============================================================*/
/* Table: goods_order_express                                   */
/*==============================================================*/
create table xye_core_order_goods_test.goods_order_express
(
   id                   varchar(50) not null comment 'id',
   order_code           varchar(255) comment '订单编码',
   delivery_number      varchar(255) comment '快递单号',
   express_name         varchar(200) comment '快递公司',
   contact_name         varchar(200) comment '收货人',
   contact_phone        varchar(20) comment '联系方式',
   province             varchar(20) comment '省',
   city                 varchar(20) comment '市',
   area                 varchar(20) comment '区',
   address              varchar(255) comment '详细地址',
   zip                  varchar(255) comment 'ZIP',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(100) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(100) comment '修改人',
   state                int(3) default 1 comment '状态 0:删除 1：正常',
   primary key (id)
);

alter table xye_core_order_goods_test.goods_order_express comment '商品订单物流信息表';
)

(drop table if exists xye_core_order_goods_test.goods_order_finance;

/*==============================================================*/
/* Table: goods_order_finance                                   */
/*==============================================================*/
create table xye_core_order_goods_test.goods_order_finance
(
   id                   varchar(50) not null comment 'id',
   order_code           varchar(255) comment '订单编码',
   payment_status       int(3) comment '支付状态',
   coupon_info          varchar(255) comment '优惠券信息',
   freight              double(16,2) comment '运费',
   pay_record_code      varchar(255) comment '支付记录编码',
   actual_payment       double(16,2) comment '实际付款金额',
   payment_time         datetime comment '付款时间',
   payment_way          varchar(10) comment '付款方式',
   is_checked           int(11) comment '是否确认款项',
   check_user_id        varchar(255) comment '确认人员ID',
   check_balance_time   datetime comment '确认款项时间',
   finace_comment       varchar(255) comment '财务意见',
   credit_lock          varchar(255) comment '积分抵扣',
   wallet_lock          varchar(255) comment '钱包抵扣',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   primary key (id)
);

alter table xye_core_order_goods_test.goods_order_finance comment '财务表';
)

(drop table if exists xye_core_order_goods_test.goods_order_item;

/*==============================================================*/
/* Table: goods_order_item                                      */
/*==============================================================*/
create table xye_core_order_goods_test.goods_order_item
(
   id                   varchar(50) not null comment 'id',
   order_code           varchar(255) comment '订单编码',
   goods_id             varchar(200) comment '商品编码',
   goods_sku_id         varchar(200) comment '商品SKU',
   goods_sku_attr       varchar(200) comment '商品sku属性',
   goods_cate_id        varchar(200) comment '商品分类编码',
   goods_sku_price      double(16,2) comment '商品单价',
   goods_actual_price   double(16,2),
   goods_count          int(11) comment '商品数量',
   goods_name           varchar(200) comment '商品名称',
   goods_desc           varchar(255) comment '商品描述',
   goods_title_img      varchar(1000) comment '标题图',
   goods_unit           varchar(10) comment '单位',
   package_code         varchar(200) comment '套餐编码',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(100) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(100) comment '修改人',
   state                int(3) default 1 comment '状态 0:删除 1：正常',
   fang_pic             varchar(1000) comment '方形图片',
   primary key (id)
);

alter table xye_core_order_goods_test.goods_order_item comment '商品订单商品详情';
)

(drop table if exists xye_core_order_goods_test.goods_order_payment_history;

/*==============================================================*/
/* Table: goods_order_payment_history                           */
/*==============================================================*/
create table xye_core_order_goods_test.goods_order_payment_history
(
   id                   varchar(50) not null,
   pay_record_code      varchar(255) comment '支付记录编码',
   order_code           varchar(255) comment '订单编号',
   payment_time         datetime comment '支付时间',
   payment_way          varchar(200) comment '支付方式',
   payment_result       int(3) comment '支付结果(0 支付中1 支付成功 2支付失败)',
   payment_amount       double(16,2) comment '支付金额',
   trd_payment_successed_time datetime comment '三方支付成功时间',
   trd_payment_order_number varchar(200) comment '三方支付票号',
   trd_payment_result   varchar(255) comment '三方支付结果',
   trd_payment_message  varchar(255) comment '三方支付报文',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(100) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(100) comment '修改人',
   state                int(3) default 1 comment '状态 0:删除 1：正常',
   primary key (id)
);

alter table xye_core_order_goods_test.goods_order_payment_history comment '商品订单付款记录表';
)

(drop table if exists xye_core_order_goods_test.goods_order_status_dict;

/*==============================================================*/
/* Table: goods_order_status_dict                               */
/*==============================================================*/
create table xye_core_order_goods_test.goods_order_status_dict
(
   id                   varchar(50) not null comment 'id',
   status_type          varchar(30) comment '状态类型：信贷、保险、信用卡、商品',
   status_code          varchar(50) comment '状态值',
   status_name          varchar(100) comment '显示文字',
   parent_id            varchar(100) comment '客户描述',
   status_desc          varchar(255),
   status_sort          int(3),
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(100) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(100) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   primary key (id)
);

alter table xye_core_order_goods_test.goods_order_status_dict comment '订单状态字典表';
)

(drop table if exists xye_core_order_goods_test.goods_order_trans;

/*==============================================================*/
/* Table: goods_order_trans                                     */
/*==============================================================*/
create table xye_core_order_goods_test.goods_order_trans
(
   trans_id             varchar(50) not null comment '请求号',
   trans_type           varchar(20) comment '类型',
   order_code           varchar(50) comment '订单号',
   create_date          datetime comment '插入时间',
   timeout_date         datetime comment '过期时间',
   primary key (trans_id)
);

alter table xye_core_order_goods_test.goods_order_trans comment '请求流水表';
)

(drop table if exists xye_core_order_goods_test.order_delivery_code;

/*==============================================================*/
/* Table: order_delivery_code                                   */
/*==============================================================*/
create table xye_core_order_goods_test.order_delivery_code
(
   id                   varchar(50) not null,
   order_code           varchar(200) comment '订单编码',
   delivery_code        varchar(200) comment '提货码',
   delivery_code_status varchar(200) comment '提货码状态 0：未使用 1：已核销',
   delivery_start_time  datetime comment '提货码有效开始时间',
   delivery_end_time    datetime comment '提货码有效结束时间',
   verification_time    datetime comment '提货码核销时间',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(100) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(100) comment '修改人',
   state                int(3) default 1 comment '状态 0:删除 1：正常',
   mall_code            varchar(100),
   store_code           varchar(100),
   user_account         varchar(100),
   verification_by      varchar(100),
   send_phone           varchar(20),
   primary key (id)
);
)

(drop table if exists xye_core_order_goods_test.order_price_revise;

/*==============================================================*/
/* Table: order_price_revise                                    */
/*==============================================================*/
create table xye_core_order_goods_test.order_price_revise
(
   id                   varchar(50) not null comment 'id',
   order_code           varchar(255) comment '订单编码',
   revise_price_time    datetime comment '修改价格时间',
   total_orig           double(16,2) comment '修改前价格(总价格)',
   revise_price         double(16,2) comment '修改价格(总价格)',
   revise_comment       varchar(255) comment '修改备注',
   revise_op_id         varchar(255) comment '修改人员id',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(100) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(100) comment '修改人',
   state                int(3) default 1 comment '状态 0:删除 1：正常',
   primary key (id)
);

alter table xye_core_order_goods_test.order_price_revise comment '订单价格修改表';
)

(drop table if exists xye_core_order_goods_test.pay_request_record;

/*==============================================================*/
/* Table: pay_request_record                                    */
/*==============================================================*/
create table xye_core_order_goods_test.pay_request_record
(
   id                   varchar(50) not null comment 'id',
   pm_merchant_no       varchar(255) comment '商户号',
   pm_pay_request_no    varchar(255) comment '付款请求号',
   bs_trade_no          varchar(255) comment '订单编号',
   amount               varchar(255) comment '订单金额',
   trans_descript       varchar(255) comment '商品说明',
   request_time         varchar(255) comment '发送时间',
   pm_server_notify_URL varchar(255) comment '服务器回调url',
   pm_page_notify_URL   varchar(255) comment '页面回调url',
   pm_req_return_state  int(2) comment '请求响应状态 0：请求成功',
   pm_req_return_msg    text comment '请求响应消息',
   payment_state        varchar(255) comment '支付状态（成功：SUCCESS 失败：FAIL 付款中：
            IN_PAYMENT）',
   call_bank_count      int(1) comment '回调次数',
   call_bank_time       varchar(255) comment '回调时间',
   call_bank_msg        text,
   primary key (id)
);

alter table xye_core_order_goods_test.pay_request_record comment '付款请求记录';
)

(drop table if exists xye_core_order_goods_test.refund_request_record;

/*==============================================================*/
/* Table: refund_request_record                                 */
/*==============================================================*/
create table xye_core_order_goods_test.refund_request_record
(
   id                   varchar(50) not null,
   pm_merchant_no       varchar(255) comment '商户号',
   pm_refund_request_no varchar(255) comment '退款请求号',
   pm_pay_request_no    varchar(255) comment '付款请求号',
   bs_trade_no          varchar(255) comment '付款订单号',
   bs_refund_no         varchar(255) comment '退款编号',
   amount               varchar(255) comment '退款金额',
   request_time         varchar(255) comment '请求时间',
   pm_server_notify_URL varchar(255) comment '服务器通知url',
   pm_req_return_state  int(2) comment '请求响应状态 0：请求成功',
   pm_req_return_msg    text comment '请求响应消息',
   refund_state         varchar(255) comment '支付状态（成功：SUCCESS 失败：FAIL 付款中：
            IN_PAYMENT）',
   call_bank_count      int(1) comment '回调次数',
   call_bank_time       varchar(255),
   call_bank_msg        text,
   primary key (id)
);

alter table xye_core_order_goods_test.refund_request_record comment '退款请求记录';
)
