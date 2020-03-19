--重构数据库PDM_xye_core_platform_test-2020.01.09

(drop table if exists xye_core_platform_test.app_info;

/*==============================================================*/
/* Table: app_info                                              */
/*==============================================================*/
create table xye_core_platform_test.app_info
(
   id                   varchar(100) not null,
   mall_code            varchar(255) comment '商城编码',
   app_code             varchar(100),
   app_icon_url         varchar(255) comment 'app图标地址',
   app_name             varchar(100) comment 'app名称',
   app_customer_service varchar(20) comment 'app客服电话',
   app_wechat_qrcode_url varchar(255) comment 'app微信公众号二维码地址',
   app_version          varchar(100) comment 'app版本',
   create_date          datetime comment '创建时间',
   create_by            national varchar(50) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            national varchar(50) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             national varchar(200) comment '备注',
   app_wechat_name      varchar(200),
   mall_tag             varchar(50) comment '商城标签',
   prod_desc            varchar(200) comment '产品简介',
   more_wonderful       varchar(200) comment '更多精彩',
   primary key (id)
);
)

(drop table if exists xye_core_platform_test.demand;

/*==============================================================*/
/* Table: demand                                                */
/*==============================================================*/
create table xye_core_platform_test.demand
(
   id                   varchar(50) not null comment '主键',
   configuration_key    varchar(225) comment '配置的key',
   configuration_value  varchar(225) comment '配置的value',
   type                 int(1) comment '类型:1 当前类型',
   is_delete            int(1) default 0 comment '是否被删除:0 否 1 是',
   mall_code            varchar(255) comment '编号',
   remarks              varchar(255) comment '备注',
   primary key (id)
);
)

(drop table if exists xye_core_platform_test.fastdfs_file_info;

/*==============================================================*/
/* Table: fastdfs_file_info                                     */
/*==============================================================*/
create table xye_core_platform_test.fastdfs_file_info
(
   file_id              national varchar(32) not null comment 'UUID',
   app_id               national varchar(50) comment '所属系统',
   file_name            national varchar(255) comment '文件名称',
   file_type            national varchar(50) comment '文件类型',
   file_size            bigint(20) comment '文件大小',
   file_url             national varchar(255) comment '文件地址',
   state                int(11) comment '状态:0-无效/1-有效',
   upload_by            national varchar(50) comment '上传模式:流/字节数组',
   upload_usetime       bigint(20) comment '上传耗时',
   upload_time          datetime comment '上传时间',
   download_count       int(11) comment '下载次数',
   download_time        datetime comment '下载时间',
   is_sensitive         int(11) comment '是否敏感:0-不敏感/1-敏感',
   primary key (file_id)
);

alter table xye_core_platform_test.fastdfs_file_info comment 'fastdfs文件上传记录表';
)

(drop table if exists xye_core_platform_test.mall_info;

/*==============================================================*/
/* Table: mall_info                                             */
/*==============================================================*/
create table xye_core_platform_test.mall_info
(
   id                   varchar(100) not null comment 'ID',
   mall_code            varchar(255) comment '商城编码',
   mall_name            varchar(255) comment '商城名称',
   mall_name_en         varchar(25) comment '商城名称简写',
   create_date          datetime comment '创建时间',
   create_by            varchar(255) comment '创建人',
   update_date          datetime comment '创建时间',
   update_by            varchar(255) comment '更新人',
   state                int(2) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(255) comment '备注',
   contact_name         varchar(255) comment '联系人',
   contact_number       varchar(20) comment '联系电话',
   mall_logo            varchar(255) comment '商城图标',
   distribution_flag    int(2) default 0 comment '是否分销 0：不分销 1：分销',
   mall_settlement_flag int(2) default 0 comment '是否商城结算 0：非商城结算 1：商城结算',
   primary key (id)
);
)

(drop table if exists xye_core_platform_test.opt_log;

/*==============================================================*/
/* Table: opt_log                                               */
/*==============================================================*/
create table xye_core_platform_test.opt_log
(
   id                   varchar(100) not null comment 'ID',
   opt_msg              varchar(200) comment '操作信息',
   opt_model            varchar(200) comment '操作模块',
   opt_type             varchar(30) comment '操作类型',
   details              varchar(30) comment '具体参数',
   create_date          timestamp comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          timestamp comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态',
   comments             varchar(200) comment '备注',
   ip                   varchar(255) comment 'ip地址',
   opt_account          varchar(255) comment '操作人账号',
   opt_code             varchar(255) comment '操作人编码',
   mall_code            varchar(255) comment '商城Code',
   primary key (id)
);

alter table xye_core_platform_test.opt_log comment '操作日志表';
)

(drop table if exists xye_core_platform_test.self_mention_manage;

/*==============================================================*/
/* Table: self_mention_manage                                   */
/*==============================================================*/
create table xye_core_platform_test.self_mention_manage
(
   id                   varchar(100) not null,
   store_code           varchar(200) comment '商品编码',
   self_mention_code    varchar(200) comment '自提点编码',
   self_mention_name    varchar(200) comment '自提点名称',
   self_mention_address varchar(200) comment '自提点详细地址',
   self_mention_phone   varchar(20) comment '自提点电话',
   business_hours       varchar(100) comment '营业时间',
   status               int(11) default 1 comment '自提点状态 1:启用  0 ：关闭',
   longitude            varchar(200) comment '经度',
   latitude             varchar(200) comment '纬度',
   comments             varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            varchar(200) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(200) comment '修改人',
   state                int(3) default 1 comment '状态 0:删除 1：正常',
   primary key (id)
);
)

(drop table if exists xye_core_platform_test.shop_info;

/*==============================================================*/
/* Table: shop_info                                             */
/*==============================================================*/
create table xye_core_platform_test.shop_info
(
   ID                   varchar(100) not null comment 'ID',
   shop_code            varchar(100) comment '商店编码',
   shop_name            varchar(100) comment '商店名称',
   origin_mall_code     varchar(50) comment '开户商城编码',
   level_code           varchar(10) comment '商店等级',
   shop_type            varchar(20) comment '商店类型',
   shop_exp_date        datetime comment '商店有效期',
   shop_status          int(11) comment '商店状态(暂时未用到此字段)',
   recommend_sign       int(11) comment '推荐标志',
   sort_id              int(11) comment '排序',
   approval_state       int(11) comment '审核状态(暂时未用到此字段)',
   contact_name         varchar(50) comment '联系人',
   contact_number       varchar(50) comment '联系电话',
   create_date          datetime comment '创建时间',
   create_by            varchar(50) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(50) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   primary key (ID)
);

alter table xye_core_platform_test.shop_info comment '商店基本信息';
)

(drop table if exists xye_core_platform_test.sys_con_manager_role;

/*==============================================================*/
/* Table: sys_con_manager_role                                  */
/*==============================================================*/
create table xye_core_platform_test.sys_con_manager_role
(
   ID                   varchar(50) not null comment 'ID',
   role_code            varchar(200) comment '角色编码',
   manager_code         varchar(200) comment '管理用户编码',
   create_date          datetime comment '创建时间',
   create_by            varchar(200) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(200) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   primary key (ID)
);

alter table xye_core_platform_test.sys_con_manager_role comment '用户角色关联表';
)

(drop table if exists xye_core_platform_test.sys_con_res_role;

/*==============================================================*/
/* Table: sys_con_res_role                                      */
/*==============================================================*/
create table xye_core_platform_test.sys_con_res_role
(
   ID                   varchar(50) not null comment 'ID',
   role_code            varchar(30) comment '角色编码',
   res_code             varchar(30) comment '资源编码',
   create_date          datetime comment '创建时间',
   create_by            varchar(50) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(50) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   primary key (ID)
);

alter table xye_core_platform_test.sys_con_res_role comment '角色资源关联表';
)

(drop table if exists xye_core_platform_test.sys_manager;

/*==============================================================*/
/* Table: sys_manager                                           */
/*==============================================================*/
create table xye_core_platform_test.sys_manager
(
   ID                   varchar(50) not null comment 'ID',
   manager_code         varchar(255) comment '管理用户编码',
   manager_name         varchar(20) comment '姓名',
   account              varchar(50) comment '账号',
   account_type         varchar(255) comment '账号类型 管理员： admin 普通 ：general',
   pwd                  varchar(50) comment '密码',
   manager_mobile       varchar(20) comment '手机号',
   email                varchar(50) comment '邮箱',
   status               varchar(50) comment '账户状态 0：未激活 1：激活成功 2：冻结',
   manager_type         varchar(50) comment '账号类型：platform:平台 mall：商户 store：店铺',
   belong_code          varchar(50) comment '所属编码',
   special_resource     text comment '特殊的资源',
   is_special_account   int(1) default 0 comment '是否为特殊账号 1 是 0 否',
   create_date          datetime comment '创建时间',
   create_by            varchar(50) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(50) comment '修改人',
   state                int(11) default 1 comment '状态 0:无效 1：正常',
   comments             varchar(200) comment '备注',
   primary key (ID)
);

alter table xye_core_platform_test.sys_manager comment '后台管理用户';
)

(drop table if exists xye_core_platform_test.sys_resource;

/*==============================================================*/
/* Table: sys_resource                                          */
/*==============================================================*/
create table xye_core_platform_test.sys_resource
(
   ID                   varchar(50) not null comment 'ID',
   res_code             varchar(30) not null comment '资源编码',
   res_name             varchar(30) comment '资源名称',
   res_type             varchar(20) comment '资源类型 root:父级菜单 leaf：菜单 btn:按钮',
   res_path             varchar(100) comment '资源路径',
   router               varchar(200) comment '页面路由',
   parent_code          varchar(50) comment '上级编码',
   create_date          datetime comment '创建时间',
   create_by            varchar(50) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(50) comment '修改人',
   state                int(11) default 1 comment '状态:0：删除：1正常',
   read_only            int(11) default 0 comment '是否只有查询 1 是 0 否',
   comments             varchar(200) comment '备注',
   icon                 varchar(255) comment '列表图标',
   primary key (ID),
   key res_code_index (res_code)
);

alter table xye_core_platform_test.sys_resource comment '资源';
)

(drop table if exists xye_core_platform_test.sys_role;

/*==============================================================*/
/* Table: sys_role                                              */
/*==============================================================*/
create table xye_core_platform_test.sys_role
(
   ID                   varchar(50) not null comment 'ID',
   role_code            varchar(200) comment '角色编码',
   role_name            varchar(30) comment '角色名字',
   role_type            varchar(20) comment '角色所属类型 platform:平台 mall：商户 store：店铺',
   belong_code          varchar(50) comment '角色所属编码',
   status               varchar(11) comment '角色状态 0：禁用  1：启用',
   create_date          datetime comment '创建时间',
   create_by            varchar(50) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(50) comment '修改人',
   state                int(11) default 1 comment '状态 0：删除 1：正常',
   comments             varchar(200) comment '备注',
   role_flag            varchar(255),
   role_template_flag   int(1) default 0 comment '是否是模板角色',
   primary key (ID)
);

alter table xye_core_platform_test.sys_role comment '角色';
)
