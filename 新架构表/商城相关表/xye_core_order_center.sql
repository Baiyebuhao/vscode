--重构数据库PDM_xye_core_order_center_test-2020.01.09

(drop table if exists xye_core_order_center_test.core_order;

/*==============================================================*/
/* Table: core_order                                            */
/*==============================================================*/
create table xye_core_order_center_test.core_order
(
   id                   varchar(36) not null comment 'id',
   order_code           varchar(255) comment '订单编码',
   order_type           varchar(200) comment '订单类型 信贷订单、商品订单',
   mall_code            varchar(200) comment '商城编码',
   store_code           varchar(200) comment '店铺编码',
   mall_name            varchar(200) comment '商城名字',
   store_name           varchar(200) comment '店铺名称',
   user_code            varchar(100) comment '用户编码',
   user_account         varchar(100) comment '用户账号',
   user_name            varchar(100) comment '用户名称',
   order_snapshot       text comment '订单快照',
   channel_code         varchar(50) comment '订单来源渠道',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(100) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(100) comment '修改人',
   state                int(3) default 1 comment '状态 0:删除 1：正常',
   order_status         varchar(50) comment '订单状态（CLOSE_ORDER，PENDING_CREDIT，COMPLETE_ORDER）',
   sub_order_status     varchar(50) comment '订单状态2(TIME_OUT_CLOSE：超时关闭，ALREADY_APPLY：已申请，LOAN_SUCCESS：放款成功，BUYER_CLOSE：买家手动取消)',
   status_name          varchar(50) comment '状态描述',
   etl_time             datetime,
   etl_source           varchar(60),
   primary key (id)
);

alter table xye_core_order_center_test.core_order comment '订单基础信息';
)
