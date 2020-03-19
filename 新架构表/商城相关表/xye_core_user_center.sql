--重构数据库PDM_xye_core_user_center_test-2020.01.09

(drop index userCodeNormalIndex on xye_core_user_center_test.user_account;

drop index accountNormalIndex on xye_core_user_center_test.user_account;

drop table if exists xye_core_user_center_test.user_account;

/*==============================================================*/
/* Table: user_account                                          */
/*==============================================================*/
create table xye_core_user_center_test.user_account
(
   ID                   national varchar(50) not null comment 'ID',
   user_code            national varchar(50) comment '用户编码',
   platform_code        national varchar(50) comment '平台编码，如汇智信，金融苑',
   app_code             national varchar(50) comment '应用编码，一个平台下可能有多款应用',
   account              national varchar(50) comment '账号',
   mobile               national varchar(30) comment '账户绑定的手机号',
   account_type         int(1) comment '账号类型（用户-0，管理-1）',
   account_status       int(1) default 1 comment '账号状态(0-未激活，1-启用，2-冻结)',
   password             national varchar(255) comment '加密后的密码',
   create_date          datetime comment '创建时间',
   create_by            national varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            national varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             national varchar(200) comment '备注',
   login_sign           national varchar(45) comment '登陆标识',
   last_login_date      datetime comment '最后登陆日期',
   device_type          national varchar(255) comment '设备类型',
   primary key (ID)
);

alter table xye_core_user_center_test.user_account comment '用户账号信息表';

/*==============================================================*/
/* Index: accountNormalIndex                                    */
/*==============================================================*/
create index accountNormalIndex on xye_core_user_center_test.user_account
(
   account
);

/*==============================================================*/
/* Index: userCodeNormalIndex                                   */
/*==============================================================*/
create index userCodeNormalIndex on xye_core_user_center_test.user_account
(
   user_code
);
)

(drop table if exists xye_core_user_center_test.user_address;

/*==============================================================*/
/* Table: user_address                                          */
/*==============================================================*/
create table xye_core_user_center_test.user_address
(
   ID                   national varchar(50) not null comment 'ID',
   user_code            national varchar(50) comment '用户编码',
   province             national varchar(50) comment '所在省份',
   city                 national varchar(50) comment '所在城市',
   area                 national varchar(50) comment '所在区县',
   address              national varchar(300) comment '街道详细地址',
   address_type         national varchar(20) comment '地址类型（暂时未用到此字段）',
   is_def               int(11) comment '是否默认地址',
   postcode             national varchar(10) comment '邮政编码',
   create_date          datetime comment '创建时间',
   create_by            national varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            national varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             national varchar(200) comment '备注',
   mobile               national varchar(50) comment '电话',
   nick_name            national varchar(50) comment '昵称',
   primary key (ID)
);

alter table xye_core_user_center_test.user_address comment '用户地址信息表';
)

(drop table if exists xye_core_user_center_test.user_auth;

/*==============================================================*/
/* Table: user_auth                                             */
/*==============================================================*/
create table xye_core_user_center_test.user_auth
(
   ID                   national varchar(50) not null comment 'ID',
   user_code            national varchar(50) comment '用户编码',
   user_name            national varchar(80) comment '姓名',
   sex                  national varchar(4) comment '性别',
   brithday             national varchar(32) comment '出生日期',
   idcard               national varchar(20) comment 'user_account身份证号',
   idcard_valid_date    datetime comment '身份证有效期',
   idcard_org           national varchar(100) comment '发证机关',
   create_date          datetime comment '创建时间',
   create_by            national varchar(30) comment '创建人',
   update_date          datetime comment '更新时间',
   update_by            national varchar(30) comment '更新人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             national varchar(200) comment '备注',
   primary key (ID)
);

alter table xye_core_user_center_test.user_auth comment '用户实名认证表';
)

(drop table if exists xye_core_user_center_test.user_contact;

/*==============================================================*/
/* Table: user_contact                                          */
/*==============================================================*/
create table xye_core_user_center_test.user_contact
(
   ID                   national varchar(32) not null comment 'ID',
   user_code            national varchar(30) comment '用户编码',
   contact_relationship national varchar(10) comment '联系人关系',
   contact_type         national varchar(10) comment '联系类型',
   contact_name         national varchar(80) comment '联系人姓名',
   contact_mobile       national varchar(20) comment '联系人电话',
   contact_address      national varchar(300) comment '联系人地址',
   create_date          datetime comment '创建时间',
   create_by            national varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            national varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             national varchar(200) comment '备注',
   primary key (ID)
);

alter table xye_core_user_center_test.user_contact comment '用户联系信息表';
)

(drop index userCodeNormalIndex on xye_core_user_center_test.user_info;

drop index mobileNormalIndex on xye_core_user_center_test.user_info;

drop table if exists xye_core_user_center_test.user_info;

/*==============================================================*/
/* Table: user_info                                             */
/*==============================================================*/
create table xye_core_user_center_test.user_info
(
   ID                   national varchar(50) not null comment 'ID',
   user_code            national varchar(50) comment '用户编码',
   user_name            national varchar(50),
   idcard               national varchar(20),
   birthday             national varchar(32),
   mobile               national varchar(15) comment '手机号',
   reg_date             datetime comment '注册时间',
   user_status          national varchar(10) comment '用户状态',
   avatar               national varchar(100) comment '头像',
   is_cert              int(11) comment '是否实名认证',
   create_date          datetime comment '创建时间',
   create_by            national varchar(50) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            national varchar(50) comment '修改人',
   state                int(11) default 1 comment '状态',
   comments             national varchar(200) comment '备注',
   primary key (ID)
);

alter table xye_core_user_center_test.user_info comment '用户基本信息表';

/*==============================================================*/
/* Index: mobileNormalIndex                                     */
/*==============================================================*/
create index mobileNormalIndex on xye_core_user_center_test.user_info
(
   mobile
);

/*==============================================================*/
/* Index: userCodeNormalIndex                                   */
/*==============================================================*/
create index userCodeNormalIndex on xye_core_user_center_test.user_info
(
   user_code
);
)

(drop table if exists xye_core_user_center_test.user_log;

/*==============================================================*/
/* Table: user_log                                              */
/*==============================================================*/
create table xye_core_user_center_test.user_log
(
   ID                   national varchar(32) not null comment 'ID',
   user_code            national varchar(50) comment '用户编码',
   platform_code        national varchar(50),
   app_code             national varchar(50) comment '应用编码',
   term_code            national varchar(50) comment '终端编码',
   account              national varchar(50) comment '账号',
   login_date           datetime comment '登录时间',
   imei                 national varchar(20) comment 'IMEI',
   is_login_success     int(11) comment '是否登录成功',
   failed_reason        national varchar(30) comment '登录失败原因',
   login_ip             national varchar(50) comment '登录IP',
   primary key (ID)
);

alter table xye_core_user_center_test.user_log comment '用户登录日志表';
)

(drop table if exists xye_core_user_center_test.user_mobile;

/*==============================================================*/
/* Table: user_mobile                                           */
/*==============================================================*/
create table xye_core_user_center_test.user_mobile
(
   ID                   national varchar(32) not null comment 'ID',
   user_code            national varchar(30) comment '用户编码',
   mob_local_code       national varchar(30) comment '手机归属地编码',
   mob_local_province   national varchar(20) comment '手机归属省份',
   mob_local_city       national varchar(30) comment '手机归属地市',
   operator             national varchar(10) comment '运营商',
   create_date          datetime comment '创建时间',
   create_by            national varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            national varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             national varchar(200) comment '备注',
   primary key (ID)
);

alter table xye_core_user_center_test.user_mobile comment '用户手机信息表';
)
