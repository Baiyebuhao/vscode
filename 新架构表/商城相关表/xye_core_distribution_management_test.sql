--重构数据库PDM_xye_core_distribution_management_test-2020.01.09

(drop table if exists xye_core_distribution_management_test.cash_out_apply_info;

/*==============================================================*/
/* Table: cash_out_apply_info                                   */
/*==============================================================*/
create table xye_core_distribution_management_test.cash_out_apply_info
(
   id                   varchar(100) not null comment '申请id',
   apply_id             varchar(100) comment '申请人ID',
   superior             varchar(100) comment '上级ID',
   apply_name           varchar(100) comment '申请人名称',
   cash_out_amount      varchar(20) comment '提现金额',
   apply_level          int(2) comment '申请人级别',
   cash_out_order       longtext comment '提现订单',
   status               int(2) comment '申请状态（0：待结清，1：已结清）',
   mall_code            varchar(100) comment '商城编码',
   mall_name            varchar(255) comment '商城名称',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(2) default 1 comment '状态 0:删除 1：正常',
   applicants_type      int(2) comment '申请人类型 0-分销员 1-分销商',
   contact_number       varchar(20) comment '联系电话',
   contact_name         varchar(100) comment '联系人',
   primary key (id)
);

alter table xye_core_distribution_management_test.cash_out_apply_info comment '提现申请表';
)

(drop table if exists xye_core_distribution_management_test.cash_out_limit;

/*==============================================================*/
/* Table: cash_out_limit                                        */
/*==============================================================*/
create table xye_core_distribution_management_test.cash_out_limit
(
   id                   varchar(100) not null,
   quota_limit          varchar(100) comment '额度限制',
   time_limit           varchar(100) comment '时间限制',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(2) default 1 comment '状态 0:删除 1：正常',
   mall_code            varchar(100) comment '商城编码',
   primary key (id),
   key mallId (mall_code)
);

alter table xye_core_distribution_management_test.cash_out_limit comment '提现限制';
)

(drop table if exists xye_core_distribution_management_test.commission_detaile;

/*==============================================================*/
/* Table: commission_detaile                                    */
/*==============================================================*/
create table xye_core_distribution_management_test.commission_detaile
(
   id                   varchar(100) not null comment '明细id',
   order_code           varchar(100) comment '订单编号',
   sub_order_code       varchar(100) comment '子订单编号',
   mall_code            varchar(100) comment '商城编码',
   mall_name            varchar(255) comment '商城名称',
   store_code           varchar(100) comment '店铺编码',
   store_name           varchar(255) comment '店铺名称',
   distributor_merchant_staff_id varchar(100) comment '分销商ID/分销员ID',
   distributor_merchant_staff_name varchar(200) comment '分销商/分销员商名称',
   distributor_type     varchar(100) comment '分销员类型 0-分销员 1-分销商',
   order_total_amount   varchar(20) comment '订单总金额',
   commission_percentage varchar(20) comment '佣金比例',
   commission_amount    varchar(20) comment '佣金（订单总金额*佣金比例）',
   settlement_status    int(2) comment '结算状态(0:未结算，1:提现中, 2:已结算)',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(2) default 1 comment '状态 0:删除 1：正常',
   cash_out_apply_id    varchar(100) comment '提现申请Id',
   settlement_node      varchar(100) comment '结算节点 0-注册 1-放款',
   settlement_mode      varchar(100) comment '结算方式 0-单笔 1-比例',
   distributor_merchant_level int(2) comment '分销商等级',
   goods_id             varchar(255) comment '商品名称',
   goods_name           varchar(255),
   user_account         varchar(255) comment '用户账号',
   primary key (id)
);

alter table xye_core_distribution_management_test.commission_detaile comment '佣金明细';
)

(drop table if exists xye_core_distribution_management_test.con_plan_merchant;

/*==============================================================*/
/* Table: con_plan_merchant                                     */
/*==============================================================*/
create table xye_core_distribution_management_test.con_plan_merchant
(
   id                   varchar(100),
   distributor_merchan_id varchar(100) comment '分销商/分销员id',
   distribution_plan_id varchar(100) comment '分销计划id',
   con_status           int(2) comment '启用禁用',
   type                 int(11) comment '分销员或分销商(0-分销员 1-分销商)',
   settlement_node      int(2) comment '结算节点 0-注册 1-放款',
   mall_code            varchar(100) comment '商城编码',
   goods_id             varchar(100) comment '商品id',
   distributor_merchant_name varchar(100) comment '分销员/分销商名称',
   branch               varchar(255) comment '分支',
   apply_id             varchar(100) comment '分销申请id',
   comments             varchar(255),
   create_date          datetime,
   create_by            varchar(30),
   update_date          datetime,
   update_by            varchar(30),
   state                int(2),
   distributor_level    int(2) default -1 comment '创建分销计划的分销商的级别,(如果不是分销商非分销商，如商城为 则该值为-1）',
   distributor_id       varchar(100) comment '创建分销计划的分销商Id',
   amount_or_proportion varchar(100) comment '当前分销计划的比例'
);

alter table xye_core_distribution_management_test.con_plan_merchant comment '分销计划与分销商关系表';
)

(drop table if exists xye_core_distribution_management_test.distribution_order;

/*==============================================================*/
/* Table: distribution_order                                    */
/*==============================================================*/
create table xye_core_distribution_management_test.distribution_order
(
   id                   varchar(100) not null comment 'ID',
   order_code           varchar(100) comment '订单编号',
   mall_code            varchar(100) comment '商城编号',
   sub_order_code       varchar(100),
   order_type           varchar(200) comment '订单类型',
   mall_name            varchar(255) comment '商城名称',
   store_code           varchar(100) comment '店铺编码',
   store_name           varchar(255) comment '店铺名称',
   goods_num            int(11) comment '商品数量',
   goods_price          varchar(100) comment '商品单价',
   goods_total_price    varchar(100) comment '商品总价',
   goods_sku            varchar(255),
   distribution_plan_json longtext comment '分销计划数据json [{"distributorLevel":"分销商级别","distributorMerchantStaffId":"分销商ID","distributorMerchantStaffName":"分销商名称","distributorCommissionRate":"分销商比例","distributorMerchantStaffType":"分销商类型","settlementNode":"结算节点","settlementMode":"结算方式"},{"distributorLevel":"分销商级别","distributorMerchantStaffId":"分销商ID","distributorMerchantStaffName":"分销商名称","distributorCommissionRate":"分销商比例","distributorMerchantStaffType":"分销商类型","settlementNode":"结算节点","settlementMode":"结算方式"}]',
   settlement_status    int(2) comment '0 未结算 1：已结算',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(2) default 1 comment '状态 0:删除 1：正常',
   settlement_node      int(2),
   distributor_staff_id varchar(255) comment '订单分销员ID',
   product_type         varchar(50) comment '产品类型（随借随还，现金分期）',
   promote_sales_code   varchar(200) comment '推广码',
   order_snapshot       text comment '订单快照',
   goods_id             varchar(255) comment '商品ID',
   goods_name           varchar(255) comment '商品名称',
   user_account         varchar(255) comment '下单用户账号',
   primary key (id)
);

alter table xye_core_distribution_management_test.distribution_order comment '分销订单';
)

(drop table if exists xye_core_distribution_management_test.distribution_plan_apply;

/*==============================================================*/
/* Table: distribution_plan_apply                               */
/*==============================================================*/
create table xye_core_distribution_management_test.distribution_plan_apply
(
   id                   varchar(100) not null comment '分销计划id',
   apply_shop_id        varchar(100) comment '申请店铺id',
   apply_shop_name      varchar(100) comment '申请店铺名称',
   apply_id             varchar(100) comment '申请人ID',
   apply_name           varchar(100) comment '申请人名称',
   mall_code            varchar(100) comment '商城编码',
   goods_id             varchar(100) comment '商品id',
   goods_name           varchar(200) comment '商品名称',
   settlement_node      int(2) comment '结算节点 0-注册 1-放款',
   settlement_mode      int(2) comment '结算方式 0-单笔 1-比例',
   amount_or_proportion varchar(100) comment '分销金额比例',
   status               int(2) default 0 comment '状态（0:待审核 1：审核通过 2：审核
            
            驳回）',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(2) default 1 comment '状态 0:删除 1：正常',
   enable               int(2) default 1 comment '禁用/启用 0-禁用 1-启用',
   sum_of_plan          varchar(255) comment '分销申请下的一级分销计划总数',
   is_hidden            int(2) default 0 comment '当前注册节点的分销计划是不会创建的，在代码实现上该记录需要存在，故通过该字段来限制记录是否在页面显示',
   primary key (id)
);

alter table xye_core_distribution_management_test.distribution_plan_apply comment '分销计划申请';
)

(drop table if exists xye_core_distribution_management_test.distribution_plan_info;

/*==============================================================*/
/* Table: distribution_plan_info                                */
/*==============================================================*/
create table xye_core_distribution_management_test.distribution_plan_info
(
   id                   varchar(100) not null comment '分销计划id',
   mall_code            varchar(100) comment '商城编码',
   apply_shop_id        varchar(100) comment '商铺id',
   apply_shop_name      varchar(255) comment '商铺名称',
   goods_id             varchar(100) comment '商品id',
   goods_name           varchar(200) comment '商品名称',
   settlement_node      varchar(100) comment '结算节点 0-注册 1-放款',
   settlement_mode      varchar(100) comment '结算方式 0-单笔 1-比例',
   amount_or_proportion varchar(100) comment '分销金额比例',
   sub_ount_or_proportion varchar(100) comment '下级分销金额比例',
   status               int(2) comment '分销计划状态(0：关闭，1：启用)',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(2) default 1 comment '状态 0:删除 1：正常',
   parent_id            varchar(100),
   apply_id             varchar(100) comment '分销申请id',
   branch               varchar(255) comment '分支',
   sum_of_plan          varchar(10) comment '下级分销计划总数',
   enable               int(2) comment '分销申请禁用/启用',
   distributor_level    int(2) default -1 comment '创建分销计划的分销商的级别,(如果不是分销商非分销商，如商城为 则该值为-1）',
   distributor_id       varchar(100) comment '创建分销计划的分销商的id',
   distributor_name     varchar(255),
   primary key (id)
);

alter table xye_core_distribution_management_test.distribution_plan_info comment '分销计划';
)

(drop table if exists xye_core_distribution_management_test.distribution_wallet_info;

/*==============================================================*/
/* Table: distribution_wallet_info                              */
/*==============================================================*/
create table xye_core_distribution_management_test.distribution_wallet_info
(
   id                   varchar(100) not null comment '钱包ID',
   owner_id             varchar(100) comment '所属ID（分销商id、分销员id）',
   wallet_total_amount  varchar(100) default '0' comment '钱包总金额',
   wallet_amount        varchar(100) default '0' comment '钱包金额',
   wallet_freeze_amount varchar(100) default '0' comment '冻结金额',
   wallet_cash_out_amount varchar(100) default '0' comment '已提金额',
   wallet_status        int(2) comment '钱包状态( 0:冻结 1：正常 )',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(2) default 1 comment '状态 0:删除 1：正常',
   cash_out_in_amount   varchar(100) default '0' comment '提现中',
   primary key (id)
);

alter table xye_core_distribution_management_test.distribution_wallet_info comment '分销用户钱包';
)

(drop table if exists xye_core_distribution_management_test.distributor_merchant_info;

/*==============================================================*/
/* Table: distributor_merchant_info                             */
/*==============================================================*/
create table xye_core_distribution_management_test.distributor_merchant_info
(
   id                   varchar(100) not null comment '分销商id',
   distributor_name     varchar(100) comment '分销商名称',
   login_account        varchar(100),
   distributor_code     varchar(100),
   contact_number       varchar(20) comment '联系电话',
   manager_code         varchar(255) comment '用户编码',
   contact_name         varchar(100) comment '联系人',
   remittance_bank_name varchar(200) comment '打款银行名称',
   remittance_bank_number varchar(100) comment '打款银行账号',
   opening_bank_name    varchar(200) comment '开户行名称',
   opener_name          varchar(100) comment '开户人姓名',
   mall_code            varchar(200) comment '商城编码',
   mall_name            varchar(255) comment '商城名称',
   channel_number       varchar(100) comment '推广渠道号',
   parent_id            varchar(100) comment '父级id',
   parent_name          varchar(200) comment '父级名称',
   parent_level         int(2) comment '父级级别',
   distributor_level    int(2) comment '分销商级别',
   status               int(2) comment '分销商状态(1:正常 0：禁用)',
   enclosure_url        varchar(255) comment '附件地址',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(2) default 1 comment '状态 0:删除 1：正常',
   primary key (id)
);

alter table xye_core_distribution_management_test.distributor_merchant_info comment '分销商信息';
)

(drop table if exists xye_core_distribution_management_test.distributor_staff_info;

/*==============================================================*/
/* Table: distributor_staff_info                                */
/*==============================================================*/
create table xye_core_distribution_management_test.distributor_staff_info
(
   id                   varchar(100) not null comment '分销员id',
   distributor_name     varchar(100) comment '分销员名称',
   distributor_account  varchar(20) comment '分销员账号（app账号）',
   remittance_bank_name varchar(200) comment '打款银行名称',
   remittance_bank_number varchar(100) comment '打款银行账号',
   channel_number       varchar(100) comment '推广渠道号',
   distributor_merchant_id varchar(100) comment '分销商id',
   status               int(2) comment '分销员状态(1:正常 0：禁用)',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(2) default 1 comment '状态 0:删除 1：正常',
   mall_code            varchar(255) comment '商城编码',
   distributor_code     varchar(255) comment '分销员编码',
   user_code            varchar(255) comment '用户编码',
   mall_name            varchar(255) comment '商城名称',
   primary key (id)
);

alter table xye_core_distribution_management_test.distributor_staff_info comment '分销员信息';
)

(drop table if exists xye_core_distribution_management_test.recommend_goods_info;

/*==============================================================*/
/* Table: recommend_goods_info                                  */
/*==============================================================*/
create table xye_core_distribution_management_test.recommend_goods_info
(
   id                   varchar(100),
   register_invitation_configure_id varchar(100) comment '配置ID',
   picture_url          varchar(100) comment '图片url',
   jump_link_type       int(2) default 0 comment '跳转类型 0：不跳转 1：链接 2：商品',
   jump_link_url        varchar(200) comment '跳转链接',
   goods_id             varchar(255) comment '商品ID',
   goods_name           varchar(255) comment '商品名称',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(2) default 1 comment '状态 0:删除 1：正常'
);

alter table xye_core_distribution_management_test.recommend_goods_info comment '注册邀请优质产品列表';
)

(drop table if exists xye_core_distribution_management_test.register_invitation_configure;

/*==============================================================*/
/* Table: register_invitation_configure                         */
/*==============================================================*/
create table xye_core_distribution_management_test.register_invitation_configure
(
   id                   varchar(100),
   mall_code            varchar(200) comment '商城编码',
   theme_colour         varchar(100) comment '主题色',
   background_colour    varchar(100) comment '背景色',
   qr_code_url          varchar(200) comment '二维码url',
   login_top_picture_url varchar(200) comment '登陆页顶部图片',
   login_bottom_picture_url varchar(200) comment '登陆页底部图片',
   down_top_picture_url varchar(200) comment '下载页顶部图片',
   android_down_url     varchar(200) comment '安卓下载地址',
   ios_down_url         varchar(200) comment 'ios 下载地址',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(2) default 1 comment '状态 0:删除 1：正常'
);

alter table xye_core_distribution_management_test.register_invitation_configure comment '注册邀请配置';
)

(drop table if exists xye_core_distribution_management_test.short_url_info;

/*==============================================================*/
/* Table: short_url_info                                        */
/*==============================================================*/
create table xye_core_distribution_management_test.short_url_info
(
   id                   varchar(100) not null comment 'id',
   short_url_key        varchar(100) comment '键',
   short_url_type       varchar(50) comment '短链接类型（注册、提现）',
   user_code            varchar(200) comment '用户编码',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(2) default 1 comment '状态 0:删除 1：正常',
   primary key (id)
);
)
