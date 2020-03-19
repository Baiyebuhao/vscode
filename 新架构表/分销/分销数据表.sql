--分销数据表
/*==============================================================*/
/* Table: distributor_merchant_info       分销商信息            */
/*==============================================================*/
create table xye_core_distribution_management_test.distributor_merchant_info
(
   id                   varchar(100) not null comment '分销商id',
   distributor_name     varchar(100) comment '分销商名称',
   login_account        varchar(100),
   distributor_code     varchar(100) comment '分销员编码',
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

(/*==============================================================*/
/* Table: distributor_staff_info    分销员信息                  */
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