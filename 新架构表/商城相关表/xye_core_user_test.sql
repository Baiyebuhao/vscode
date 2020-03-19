--重构数据库PDM_xye_core_user_test-2020.01.09

(drop table if exists xye_core_user_test.cust_auth_inf;

/*==============================================================*/
/* Table: cust_auth_inf                                         */
/*==============================================================*/
create table xye_core_user_test.cust_auth_inf
(
   id                   varchar(255),
   auth_id              varchar(100),
   mbl_prov             varchar(4),
   mbl_no               varchar(11),
   cre_time             timestamp,
   upd_time             timestamp,
   auth_type            varchar(255),
   chk_code             varchar(255),
   tm_smp               varchar(255),
   push_flag            varchar(255),
   app_code             varchar(50) comment '应用编码'
);
)

(drop table if exists xye_core_user_test.s_honeycomb_grade_data;

/*==============================================================*/
/* Table: s_honeycomb_grade_data                                */
/*==============================================================*/
create table xye_core_user_test.s_honeycomb_grade_data
(
   id                   varchar(50) not null comment 'id',
   request_no           varchar(20) comment '请求流水号',
   mobile_no            varchar(20) comment '手机号',
   honeycomb_data       text comment '蜂巢系统数据',
   status               varchar(5) default '1' comment '数据状态',
   ext                  text comment '拓展字段',
   create_time          datetime comment '创建时间',
   modify_time          timestamp not null default CURRENT_TIMESTAMP comment '修改时间',
   app_code             varchar(50) comment '应用编码',
   primary key (id)
);

alter table xye_core_user_test.s_honeycomb_grade_data comment '蜂巢系统返回蜂巢分数据表';
)

(drop table if exists xye_core_user_test.s_honeycomb_request_record;

/*==============================================================*/
/* Table: s_honeycomb_request_record                            */
/*==============================================================*/
create table xye_core_user_test.s_honeycomb_request_record
(
   id                   varchar(50) not null comment 'id',
   request_no           varchar(20) comment '请求流水号',
   mobile_no            varchar(20) comment '手机号',
   request_time         varchar(20) comment '请求时间',
   response_time        varchar(20) comment '响应时间',
   time_cost            bigint(20) comment '请求用时（单位毫秒）',
   request_status       varchar(5) comment '请求状态（1：成功  0：失败）',
   request_type         varchar(10) comment '请求类型',
   error_message        varchar(225) comment '请求错误信息',
   status               varchar(5) default '1' comment '数据状态',
   ext                  text comment '拓展字段',
   create_time          datetime comment '创建时间',
   modify_time          timestamp not null default CURRENT_TIMESTAMP comment '修改时间',
   app_code             varchar(50) comment '应用编码',
   primary key (id)
);

alter table xye_core_user_test.s_honeycomb_request_record comment '蜂巢系统请求记录表';
)

(drop table if exists xye_core_user_test.s_mbl_province_inf;

/*==============================================================*/
/* Table: s_mbl_province_inf                                    */
/*==============================================================*/
create table xye_core_user_test.s_mbl_province_inf
(
   prefix               int(5) comment '手机号前缀',
   phone                int(10) not null comment '电话号码前七位',
   province             varchar(50) comment '所在省',
   province_code        int(8) comment '省编码',
   city                 varchar(50) comment '所在城市',
   city_code            int(8) comment '城市编码',
   isp                  varchar(50) comment '运营商',
   isp_code             int(8) comment '运营商编码（1：移动 2：联通 3：电信 4：虚拟/移动 5：虚拟/联通 6：虚拟/电信）',
   post_code            int(8) comment '邮编',
   area_code            int(8) comment '地区编码',
   types                varchar(50) comment '所属类型',
   primary key (phone)
);

alter table xye_core_user_test.s_mbl_province_inf comment '电话号码归属地对照表';
)

(drop table if exists xye_core_user_test.s_mbl_province_inf_copy;

/*==============================================================*/
/* Table: s_mbl_province_inf_copy                               */
/*==============================================================*/
create table xye_core_user_test.s_mbl_province_inf_copy
(
   prefix               int(5) comment '手机号前缀',
   phone                int(10) not null comment '电话号码前七位',
   province             varchar(50) comment '所在省',
   province_code        int(8) comment '省编码',
   city                 varchar(50) comment '所在城市',
   city_code            int(8) comment '城市编码',
   isp                  varchar(50) comment '运营商',
   isp_code             int(8) comment '运营商编码（1：移动 2：联通 3：电信 4：虚拟/移动 5：虚拟/联通 6：虚拟/电信）',
   post_code            int(8) comment '邮编',
   area_code            int(8) comment '地区编码',
   types                varchar(50) comment '所属类型',
   primary key (phone)
);

alter table xye_core_user_test.s_mbl_province_inf_copy comment '电话号码归属地对照表';
)

(drop index userCodeNormalIndex on xye_core_user_test.user_account;

drop index accountNormalIndex on xye_core_user_test.user_account;

drop table if exists xye_core_user_test.user_account;

/*==============================================================*/
/* Table: user_account                                          */
/*==============================================================*/
create table xye_core_user_test.user_account
(
   ID                   varchar(36) not null comment 'ID',
   user_code            varchar(50) comment '用户编码',
   account              varchar(50) comment '账号',
   account_type         varchar(20) comment '账号类型',
   account_status       varchar(10) comment '账号状态',
   token                varchar(50) comment 'TOKEN',
   token_exp            datetime comment 'TOKEN过期日期',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   login_sign           varchar(45) comment '登陆标识',
   last_login_date      datetime comment '最后登陆日期',
   device_type          varchar(255) comment '设备类型(Android,ios,h5)',
   etl_time             datetime,
   etl_source           varchar(60),
   app_code             varchar(50) comment '应用编码',
   primary key (ID)
);

alter table xye_core_user_test.user_account comment '用户账号信息表';

/*==============================================================*/
/* Index: accountNormalIndex                                    */
/*==============================================================*/
create index accountNormalIndex on xye_core_user_test.user_account
(
   account
);

/*==============================================================*/
/* Index: userCodeNormalIndex                                   */
/*==============================================================*/
create index userCodeNormalIndex on xye_core_user_test.user_account
(
   user_code
);
)

(drop table if exists xye_core_user_test.user_address;

/*==============================================================*/
/* Table: user_address                                          */
/*==============================================================*/
create table xye_core_user_test.user_address
(
   ID                   varchar(36) not null comment 'ID',
   user_code            varchar(50) comment '用户编码',
   province             varchar(50) comment '所在省份',
   city                 varchar(50) comment '所在城市',
   area                 varchar(50) comment '所在区县',
   address              varchar(300) comment '街道详细地址',
   address_type         varchar(20) comment '地址类型',
   is_def               int(11) comment '是否默认地址',
   postcode             varchar(10) comment '邮政编码',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   mobile               varchar(50) comment '电话',
   nick_name            varchar(50) comment '昵称',
   etl_time             datetime,
   etl_source           varchar(60),
   app_code             varchar(50) comment '应用编码',
   primary key (ID)
);

alter table xye_core_user_test.user_address comment '用户地址信息表';
)

(drop index index_user_auth_user_code_state on xye_core_user_test.user_auth;

drop index idx2 on xye_core_user_test.user_auth;

drop table if exists xye_core_user_test.user_auth;

/*==============================================================*/
/* Table: user_auth                                             */
/*==============================================================*/
create table xye_core_user_test.user_auth
(
   ID                   varchar(36) not null comment 'ID',
   user_code            varchar(50) comment '用户编码',
   user_name            varchar(80) comment '姓名',
   sex                  varchar(4) comment '性别',
   brithday             varchar(32) comment '出生日期',
   idcard               varchar(20) comment 'user_account身份证号',
   idcard_valid_date    datetime comment '身份证有效期',
   idcard_org           varchar(100) comment '发证机关',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '更新时间',
   update_by            varchar(30) comment '更新人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   etl_time             datetime,
   etl_source           varchar(60),
   app_code             varchar(50) comment '应用编码',
   primary key (ID),
   key idx_user_auth_user_code (user_code)
);

alter table xye_core_user_test.user_auth comment '用户实名认证表';

/*==============================================================*/
/* Index: idx2                                                  */
/*==============================================================*/
create index idx2 on xye_core_user_test.user_auth
(
   create_date
);

/*==============================================================*/
/* Index: index_user_auth_user_code_state                       */
/*==============================================================*/
create index index_user_auth_user_code_state on xye_core_user_test.user_auth
(
   
);
)

(drop table if exists xye_core_user_test.user_contact;

/*==============================================================*/
/* Table: user_contact                                          */
/*==============================================================*/
create table xye_core_user_test.user_contact
(
   ID                   varchar(36) not null comment 'ID',
   user_code            varchar(30) comment '用户编码',
   contact_relationship varchar(10) comment '联系人关系',
   contact_type         varchar(10) comment '联系类型(暂时未用到此字段)',
   contact_name         varchar(80) comment '联系人姓名',
   contact_mobile       varchar(20) comment '联系人电话',
   contact_address      varchar(300) comment '联系人地址',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   etl_time             datetime,
   etl_source           varchar(60),
   app_code             varchar(50) comment '应用编码',
   primary key (ID)
);

alter table xye_core_user_test.user_contact comment '用户联系信息表';
)

(drop index userCodeNormalIndex on xye_core_user_test.user_info;

drop index mobileNormalIndex on xye_core_user_test.user_info;

drop index appCodeNormalIndex on xye_core_user_test.user_info;

drop table if exists xye_core_user_test.user_info;

/*==============================================================*/
/* Table: user_info                                             */
/*==============================================================*/
create table xye_core_user_test.user_info
(
   ID                   varchar(36) not null comment 'ID',
   user_code            varchar(50) comment '用户编码',
   app_code             varchar(50) comment '应用编码',
   chan_code            varchar(50) comment '渠道编码',
   mobile               varchar(15) comment '手机号',
   reg_date             datetime comment '注册时间',
   user_status          varchar(10) comment '用户状态',
   invest_code          varchar(50) comment '邀请码',
   avatar               varchar(100) comment '头像',
   is_cert              char(1) comment '是否实名认证',
   is_auth              char(1) comment '是否授权',
   is_eval              char(1) comment '是否评测',
   is_info              char(1) comment '是否填写基本信息(暂时未用到此字段)',
   is_finan             char(1) comment '是否填写财商信息(暂时未用到此字段)',
   create_date          datetime comment '创建时间',
   create_by            varchar(50) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(50) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   ver_code             varchar(255) comment '注册验证码',
   etl_time             datetime,
   etl_source           varchar(60),
   authorize_date       varchar(255) comment '授权时间',
   authorize_no         varchar(255),
   promote_sales_code   varchar(200) comment '推广码',
   is_distribution      char(1) comment '是否是分销员',
   primary key (ID)
);

alter table xye_core_user_test.user_info comment '用户基本信息表';

/*==============================================================*/
/* Index: appCodeNormalIndex                                    */
/*==============================================================*/
create index appCodeNormalIndex on xye_core_user_test.user_info
(
   app_code
);

/*==============================================================*/
/* Index: mobileNormalIndex                                     */
/*==============================================================*/
create index mobileNormalIndex on xye_core_user_test.user_info
(
   mobile
);

/*==============================================================*/
/* Index: userCodeNormalIndex                                   */
/*==============================================================*/
create index userCodeNormalIndex on xye_core_user_test.user_info
(
   user_code
);
)

(drop table if exists xye_core_user_test.user_info_ext;

/*==============================================================*/
/* Table: user_info_ext                                         */
/*==============================================================*/
create table xye_core_user_test.user_info_ext
(
   ID                   varchar(36) not null comment 'ID',
   user_code            varchar(30) comment '用户编码',
   wechat_openid        varchar(50) comment '微信openid',
   nickname             varchar(50) comment '昵称',
   occupation           varchar(30) comment '职业',
   title                varchar(30) comment '职位',
   education            varchar(20) comment '学历',
   income               varchar(20) comment '收入',
   interest             varchar(50) comment '兴趣',
   marriage             varchar(20) comment '婚姻状况',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   etl_time             datetime,
   etl_source           varchar(60),
   app_code             varchar(50) comment '应用编码',
   primary key (ID)
);

alter table xye_core_user_test.user_info_ext comment '用户信息扩展表';
)

(drop table if exists xye_core_user_test.user_log;

/*==============================================================*/
/* Table: user_log                                              */
/*==============================================================*/
create table xye_core_user_test.user_log
(
   ID                   varchar(36) not null comment 'ID',
   user_code            varchar(30) comment '用户编码',
   app_code             varchar(30) comment '应用编码',
   term_code            varchar(30) comment '终端编码',
   account              varchar(50) comment '账号',
   login_date           datetime comment '登录时间',
   imei                 varchar(64) comment 'IMEI',
   is_login_success     int(11) comment '是否登录成功（1-成功，0-失败）',
   failed_reason        varchar(200) comment '登录失败原因',
   login_ip             varchar(150) comment '登录IP',
   etl_time             datetime,
   etl_source           varchar(60),
   primary key (ID)
);

alter table xye_core_user_test.user_log comment '用户登录日志表';
)

(drop table if exists xye_core_user_test.user_logout_apply;

/*==============================================================*/
/* Table: user_logout_apply                                     */
/*==============================================================*/
create table xye_core_user_test.user_logout_apply
(
   id                   varchar(100) not null,
   user_code            varchar(200) comment '用户编码',
   app_code             varchar(200) comment '商城编码',
   account              varchar(50),
   mobile               varchar(50) comment '电话号码',
   status               int(2) default 1 comment '申请状态 1：已申请 2：审核中 3：驳回 4：已注销',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   primary key (id)
);
)

(drop index index_user_mobile_user_code on xye_core_user_test.user_mobile;

drop table if exists xye_core_user_test.user_mobile;

/*==============================================================*/
/* Table: user_mobile                                           */
/*==============================================================*/
create table xye_core_user_test.user_mobile
(
   ID                   varchar(36) not null comment 'ID',
   user_code            varchar(30) comment '用户编码',
   mob_local_code       varchar(30) comment '手机归属地编码',
   mob_local_province_name varchar(100),
   mob_local_province   varchar(20) comment '手机归属省份',
   mob_local_city_name  varchar(100),
   mob_local_city       varchar(30) comment '手机归属地市',
   operator             varchar(10) comment '运营商',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   etl_time             datetime,
   etl_source           varchar(60),
   app_code             varchar(50) comment '应用编码',
   primary key (ID)
);

alter table xye_core_user_test.user_mobile comment '用户手机信息表';

/*==============================================================*/
/* Index: index_user_mobile_user_code                           */
/*==============================================================*/
create index index_user_mobile_user_code on xye_core_user_test.user_mobile
(
   user_code
);
)
