--重构数据库PDM_xye_core_appconfig_test-2020.01.09
(drop table if exists xye_core_appconfig_test.cfg_agreement;

/*==============================================================*/
/* Table: cfg_agreement                                         */
/*==============================================================*/
create table xye_core_appconfig_test.cfg_agreement
(
   id                   varchar(50) not null comment 'ID',
   agreement_name       varchar(50) comment '名称',
   agreement_type       varchar(20) comment '类型（暂时未用到此字段）',
   agreement_txt        longtext comment '内容',
   file_id              text comment '文件id',
   mall_code            varchar(50) comment '商城code',
   content_type         varchar(20) comment '文件类型（暂时未用到此字段）',
   create_date          timestamp comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          timestamp comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   file_name            varchar(500) comment '文件名',
   is_accredit          int(1) comment '是否为授权文件 0:否 1:是',
   primary key (id)
);

alter table xye_core_appconfig_test.cfg_agreement comment '媒体资源';

)

(drop table if exists xye_core_appconfig_test.cfg_article;

/*==============================================================*/
/* Table: cfg_article                                           */
/*==============================================================*/
create table xye_core_appconfig_test.cfg_article
(
   id                   varchar(50) not null comment 'id',
   article_title        varchar(30) comment '文章标题',
   article_content      text comment '文章内容',
   share_title          varchar(255) comment '分享标题',
   share_content        varchar(255) comment '分享内容',
   share_img            varchar(255) comment '分享图片',
   article_icon         varchar(255) comment '列表图标',
   mall_code            varchar(50) comment '所属商城',
   os_type              varchar(50) comment '投放系统类型（Android,ios,h5）',
   create_date          datetime comment '创建时间',
   create_by            varchar(50) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(50) comment '修改人',
   state                int(11) default 1 comment '状态(0：删除 1：正常 默认为1)',
   comments             varchar(200) comment '备注',
   is_material          tinyint(2) default 1 comment '是否是素材(1:素材 0：快照)',
   primary key (id)
);

alter table xye_core_appconfig_test.cfg_article comment '文章表';
)

(drop table if exists xye_core_appconfig_test.cfg_h5_login_market;

/*==============================================================*/
/* Table: cfg_h5_login_market                                   */
/*==============================================================*/
create table xye_core_appconfig_test.cfg_h5_login_market
(
   id                   varchar(50) not null,
   adv_name             varchar(100) comment '广告名称',
   adv_desc             varchar(255) comment '广告描述',
   theme_color          varchar(100) comment '主题色',
   background_color     varchar(100) comment '背景色',
   top_pic              varchar(200) comment '顶部图片',
   bottom_pic           varchar(200) comment '底部图片',
   media_type           varchar(10) comment '资源类型（pic图片 video 视频）',
   normal_media_path    varchar(255) comment '资源路径',
   full_screen_media_path varchar(255) comment '全屏资源路径',
   link_type            varchar(50) comment '触发类型',
   link_cat             varchar(10) comment '触发商品分类（loan, credit, insurance, goods)',
   link_target          text comment '触发目标',
   mall_code            varchar(50) comment 'mall_code',
   share_title          varchar(255) comment '分享标题',
   share_content        text comment '分享内容',
   share_img            varchar(500) comment '分享图片',
   status               int(4) default 1 comment '状态(1上线/0下线)',
   create_date          datetime comment '创建时间',
   create_by            varchar(50) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(50) comment '修改人',
   state                int(11) default 1 comment '状态(0：删除 1：正常 默认为1)',
   comments             varchar(200) comment '备注',
   primary key (id)
);

alter table xye_core_appconfig_test.cfg_h5_login_market comment 'H5登陆营销';
)

(drop table if exists xye_core_appconfig_test.cfg_market;

/*==============================================================*/
/* Table: cfg_market                                            */
/*==============================================================*/
create table xye_core_appconfig_test.cfg_market
(
   id                   varchar(50) not null comment 'ID',
   adv_name             varchar(50) comment '广告名称',
   adv_desc             varchar(200) comment '广告描述',
   adv_type             varchar(10) comment '广告类型 
            (1:开屏广告
            /2:banner)',
   media_type           varchar(10) comment '资源类型（pic图片 video 视频）',
   normal_media_path    varchar(255) comment '资源路径',
   full_screen_media_path varchar(255),
   publish_position     varchar(100) comment '发布位置',
   link_type            varchar(50) comment '触发类型',
   link_cat             varchar(10) comment '触发商品分类（loan, credit, insurance, goods）',
   link_target          text comment '触发目标',
   head_img             varchar(255) comment '顶图',
   mall_code            varchar(50) comment '所属商城',
   os_control           varchar(50) comment '操作系统控制',
   user_trigger_condition varchar(50) comment '用户触发人群',
   is_pop               varchar(50) comment '是否弹窗(暂时未用到此字段)',
   pop_condition        varchar(50) comment '弹窗触发规则',
   show_time            tinyint(4) comment '展示时间',
   share_title          varchar(100) comment '分享标题',
   share_content        varchar(500) comment '分享内容',
   share_img            varchar(500) comment '分享图片',
   status               tinyint(4) default 0 comment '状态(1上线/0下线)',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态',
   comments             varchar(200) comment '备注',
   coopen_target        varchar(255) comment '开屏跳转目标',
   primary key (id)
);

alter table xye_core_appconfig_test.cfg_market comment '广告';
)

(drop table if exists xye_core_appconfig_test.cfg_notice;

/*==============================================================*/
/* Table: cfg_notice                                            */
/*==============================================================*/
create table xye_core_appconfig_test.cfg_notice
(
   id                   varchar(50) not null,
   notice_title         varchar(200) comment '公告标题',
   notice_sub_title     varchar(255) comment '公告副标题',
   notice_type          varchar(20) comment '公告类型（暂时未用到此字段）',
   is_pop               varchar(30) comment '是否弹窗推送（暂时未用到此字段）',
   notice_content       varchar(255) comment '公告内容',
   link_url             varchar(255) comment '活动链接',
   mall_code            varchar(200) comment '所属商城',
   status               int(11) default 0 comment '上线/下线(1:上线，0：下线)',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态（0：删除 1：正常 默认为1）',
   comments             varchar(200) comment '备注',
   primary key (id)
);
)

(drop table if exists xye_core_appconfig_test.cfg_promotion;

/*==============================================================*/
/* Table: cfg_promotion                                         */
/*==============================================================*/
create table xye_core_appconfig_test.cfg_promotion
(
   id                   varchar(50) not null comment 'ID',
   adv_name             varchar(50) comment '广告名称',
   adv_desc             varchar(200) comment '广告描述',
   adv_type             varchar(10) comment '广告类型 
            (轮播banner/主题/单图)',
   media_type           varchar(10) comment '资源类型（pic图片 video 视频）',
   media_path           varchar(500) comment '资源路径',
   link_type            varchar(100) comment '触发类型（prod_detail：产品详情 link_url：外部链接 prod_list：产品列表 station ：频道）',
   link_cat             varchar(10) comment '触发商品分类（loan, credit, insurance, goods）',
   link_target          text comment '触发目标',
   mall_code            varchar(50) comment '所属商城',
   os_type              varchar(50) comment '投放操作系统类型',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态（0：删除 1：正常 默认为1）',
   comments             varchar(200) comment '备注',
   user_type            varchar(10) comment '人员类型
                        游客
                        登录',
   share_title          varchar(100) comment '分享标题',
   share_content        varchar(100) comment '分享内容',
   share_img            varchar(500) comment '分享图片',
   head_img             varchar(500) comment '顶图',
   is_material          tinyint(2) default 1 comment '是否是素材(1:素材 0：快照)',
   is_login             tinyint(2) default 1 comment '可进分区人群(0:仅登录用户可进 1：无限制 全部用户可进)',
   primary key (id)
);

alter table xye_core_appconfig_test.cfg_promotion comment '广告';
)

(drop table if exists xye_core_appconfig_test.cfg_push;

/*==============================================================*/
/* Table: cfg_push                                              */
/*==============================================================*/
create table xye_core_appconfig_test.cfg_push
(
   id                   varchar(50) not null,
   push_title           varchar(50) comment '推送标题',
   task_type            varchar(20) comment '任务类型（marketing：营销）',
   push_content         varchar(255) comment '推送内容',
   link_type            int(11) comment '跳转类型（1：商品详情2：外链3：列表 4：频道）',
   link_target          text comment '跳转目标',
   push_img             varchar(255) comment '图片',
   mall_code            varchar(255) comment '所属商城',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态（0：删除 1：正常 默认为1）',
   comments             varchar(200) comment '备注',
   content_url          varchar(1024) comment '二级页面的url',
   audit_state          int(11) comment '审核状态',
   share_img            varchar(255) comment '分享图片',
   share_title          varchar(50) comment '分享标题',
   share_content        varchar(255) comment '分享内容',
   top_img              varchar(255) comment '顶图',
   primary key (id)
);

alter table xye_core_appconfig_test.cfg_push comment '推送模板表';
)

(drop table if exists xye_core_appconfig_test.cfg_push_action;

/*==============================================================*/
/* Table: cfg_push_action                                       */
/*==============================================================*/
create table xye_core_appconfig_test.cfg_push_action
(
   id                   varchar(50) not null,
   push_template_id     varchar(50) comment '推送id',
   push_record_id       varchar(50) comment '推送任务记录ID',
   push_type            int(11) comment '推送时间类型',
   os_type              int(11) comment '系统类型 1 IOS 2 android 3 全部',
   store_id             varchar(50) comment '商城编号',
   push_user_type       int(11) comment '推送用户类型',
   push_time            varchar(50) comment '推送时间',
   create_date          datetime comment '创建时间',
   create_by            varchar(50) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(50) comment '修改人',
   state                int(11) comment '状态（0：删除 1：正常 默认为1）',
   comments             varchar(200) comment '备注',
   primary key (id)
);

alter table xye_core_appconfig_test.cfg_push_action comment '推送记录表';
)

(drop table if exists xye_core_appconfig_test.cfg_push_app;

/*==============================================================*/
/* Table: cfg_push_app                                          */
/*==============================================================*/
create table xye_core_appconfig_test.cfg_push_app
(
   app_id               varchar(50),
   app_key              varchar(200),
   app_secret           varchar(200),
   plateform_Id         varchar(50),
   id                   varchar(50) not null,
   app_pack_path        varchar(500) comment '包路径',
   app_name             varchar(100),
   store_id             varchar(100) comment '商城编号',
   create_date          datetime comment '创建时间',
   create_by            varchar(50) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(50) comment '修改人',
   state                int(11) comment '状态（0：删除 1：正常 默认为1）',
   comments             varchar(200) comment '备注',
   primary key (id)
);

alter table xye_core_appconfig_test.cfg_push_app comment '推送基础配置表';
)

(drop table if exists xye_core_appconfig_test.cfg_skin;

/*==============================================================*/
/* Table: cfg_skin                                              */
/*==============================================================*/
create table xye_core_appconfig_test.cfg_skin
(
   id                   varchar(50) not null,
   skin_name            varchar(50) comment '皮肤名称',
   theme_color          varchar(20) comment '主题色',
   background_color     varchar(20) comment '背景色',
   button_color         varchar(20) comment '按钮颜色',
   is_default           tinyint(2) default 0 comment '是否默认(1:默认, 0:非默认)',
   preview_pic_url      varchar(400) comment '预览图片',
   detail_pic_url       varchar(400) comment '详情图片',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态（0：删除 1：正常 默认为1）',
   comments             varchar(200) comment '备注',
   primary key (id)
);
)

(drop index index_mall_code on xye_core_appconfig_test.cfg_skin_rel;

drop table if exists xye_core_appconfig_test.cfg_skin_rel;

/*==============================================================*/
/* Table: cfg_skin_rel                                          */
/*==============================================================*/
create table xye_core_appconfig_test.cfg_skin_rel
(
   id                   varchar(50) not null,
   mall_code            varchar(100) comment '模板id',
   skin_id              varchar(255) comment '皮肤id',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态（0：删除 1：正常 默认为1）',
   comments             varchar(200) comment '备注',
   primary key (id)
);

/*==============================================================*/
/* Index: index_mall_code                                       */
/*==============================================================*/
create index index_mall_code on xye_core_appconfig_test.cfg_skin_rel
(
   mall_code
);
)

(drop table if exists xye_core_appconfig_test.cfg_tag;

/*==============================================================*/
/* Table: cfg_tag                                               */
/*==============================================================*/
create table xye_core_appconfig_test.cfg_tag
(
   id                   varchar(50) not null,
   prod_id              varchar(50) comment '产品id',
   tag_name             varchar(50) comment '标签文字',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态（0：删除 1：正常 默认为1）',
   comments             varchar(200) comment '备注',
   primary key (id)
);
)

(drop table if exists xye_core_appconfig_test.cfg_template;

/*==============================================================*/
/* Table: cfg_template                                          */
/*==============================================================*/
create table xye_core_appconfig_test.cfg_template
(
   id                   varchar(50) not null comment 'id',
   template_name        varchar(50) comment '模板名称',
   is_dispark           int(11) default 0 comment '是否开放（0-否，1-是）',
   is_online            int(11) default 0 comment '是否底部栏展示（0-否，1-是）',
   is_using             int(11) default 1 comment '启用状态 
                 1 启用
                        0 未启用',
   logo_url             varchar(200) comment 'logo url',
   channel_type         varchar(10) comment '投放渠道类型',
   belong_code          varchar(50) comment '所属商城编码',
   online_content       longtext comment '模板编辑内容',
   ord                  int(5) comment '排序',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态（0：删除 1：正常 默认为1）',
   comments             varchar(200) comment '备注',
   primary key (id)
);

alter table xye_core_appconfig_test.cfg_template comment '模板表';
)

(drop table if exists xye_core_appconfig_test.cfg_template_cate_rel;

/*==============================================================*/
/* Table: cfg_template_cate_rel                                 */
/*==============================================================*/
create table xye_core_appconfig_test.cfg_template_cate_rel
(
   id                   varchar(50) not null,
   cate_id              varchar(60) not null,
   template_id          varchar(60) not null,
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态',
   comments             varchar(200) comment '备注',
   primary key (id)
);
)

(drop table if exists xye_core_appconfig_test.cfg_template_conf;

/*==============================================================*/
/* Table: cfg_template_conf                                     */
/*==============================================================*/
create table xye_core_appconfig_test.cfg_template_conf
(
   id                   varchar(50) not null,
   template_id          varchar(50) comment '模板id',
   component_name       varchar(100) comment '自定义组件名称',
   conf_type            varchar(25) comment '配置类型',
   conf_content         text comment '配置内容',
   ord                  int(11) comment '排序',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态（0：删除 1：正常 默认为1）',
   comments             varchar(200) comment '备注',
   is_show_more         int(2) default 1 comment '商品列表是否显示更多，其他组件无用 1：显示 0：不显示',
   primary key (id)
);

alter table xye_core_appconfig_test.cfg_template_conf comment '模板配置表';
)

(drop table if exists xye_core_appconfig_test.cfg_template_user;

/*==============================================================*/
/* Table: cfg_template_user                                     */
/*==============================================================*/
create table xye_core_appconfig_test.cfg_template_user
(
   id                   varchar(50) not null comment 'id',
   template_name        varchar(50) comment '模板名称',
   belong_code          varchar(50) comment '所属商城编码',
   is_slogan            tinyint(11) default 0 comment '是否展示商场口号  0不展示 1展示',
   slogan_content       varchar(200) comment '口号内容',
   is_order             tinyint(11) default 1 comment '是否展示我的订单  0不展示 1展示',
   is_auth              tinyint(11) default 1 comment '是否展示实名认证  0不展示 1展示',
   is_aboutus           tinyint(11) default 1 comment '是否展示关于我们  0不展示 1展示',
   is_install           tinyint(11) default 1 comment '是否展示设置  0不展示 1展示',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态（0：删除 1：正常 默认为1）',
   comments             varchar(200) comment '备注',
   primary key (id)
);
)

(drop table if exists xye_core_appconfig_test.cfg_userlimit;

/*==============================================================*/
/* Table: cfg_userlimit                                         */
/*==============================================================*/
create table xye_core_appconfig_test.cfg_userlimit
(
   id                   varchar(50) not null comment '主键ID 用户限制弹窗id',
   mall_code            varchar(100) comment '所属商城 商城ID',
   userlimit_name       varchar(100) comment '用户限制弹窗名称',
   status               int(11) default 0 comment '状态(1上线/0下线)',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态（0：删除 1：正常 默认为1）',
   comments             varchar(200) comment '备注',
   primary key (id)
);
)

(drop table if exists xye_core_appconfig_test.cfg_userlimit_conf;

/*==============================================================*/
/* Table: cfg_userlimit_conf                                    */
/*==============================================================*/
create table xye_core_appconfig_test.cfg_userlimit_conf
(
   id                   varchar(50) not null comment '主键ID',
   mall_code            varchar(100) comment '所属商城 商城ID',
   userlimit_id         varchar(50) comment '用户限制弹窗id',
   img_url              varchar(100) comment '图片url',
   link_type            varchar(50) comment '触发类型 即跳转类型',
   link_target          text comment '触发目标 即跳转内容',
   share_title          varchar(100) comment '分享标题',
   share_content        varchar(500) comment '分享内容',
   share_img            varchar(500) comment '分享图片',
   status               int(11) default 0 comment '状态(1展示/0不展示)',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态（0：删除 1：正常 默认为1）',
   comments             varchar(200) comment '备注',
   primary key (id)
);
)

(drop table if exists xye_core_appconfig_test.cfg_userlimit_rel;

/*==============================================================*/
/* Table: cfg_userlimit_rel                                     */
/*==============================================================*/
create table xye_core_appconfig_test.cfg_userlimit_rel
(
   id                   varchar(50) not null comment '主键ID',
   mall_code            varchar(100) comment '所属商城 商城ID',
   userlimit_id         varchar(50) comment '用户限制弹窗id',
   goods_id             varchar(50) comment '关联商品ID(要在哪个商品上展示此用户限制弹窗)',
   status               int(11) default 0 comment '状态(1生效/0失效)',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态（0：删除 1：正常 默认为1）',
   comments             varchar(200) comment '备注',
   primary key (id)
);
)

(drop table if exists xye_core_appconfig_test.cfg_version_control;

/*==============================================================*/
/* Table: cfg_version_control                                   */
/*==============================================================*/
create table xye_core_appconfig_test.cfg_version_control
(
   id                   varchar(100) not null,
   mall_code            varchar(100),
   version_code         varchar(50),
   download_url         varchar(255),
   is_forced_to_update  int(1),
   version_content      varchar(255),
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime,
   update_by            varchar(30),
   state                int(11) comment '状态（0：删除 1：正常 默认为1）',
   comments             varchar(255),
   primary key (id)
);
)

(drop table if exists xye_core_appconfig_test.con_channel_no_h5_login_market;

/*==============================================================*/
/* Table: con_channel_no_h5_login_market                        */
/*==============================================================*/
create table xye_core_appconfig_test.con_channel_no_h5_login_market
(
   id                   varchar(100) not null,
   channel_no           varchar(100) comment '渠道号',
   channel_name         varchar(100),
   h5_login_market_id   varchar(100) comment '配置ID',
   create_date          datetime comment '创建时间',
   create_by            varchar(50) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(50) comment '修改人',
   state                int(11) default 1 comment '状态(0：删除 1：正常 默认为1)',
   comments             varchar(200) comment '备注',
   channel_id           varchar(100),
   primary key (id)
);
)

(drop table if exists xye_core_appconfig_test.obs_file_info;

/*==============================================================*/
/* Table: obs_file_info                                         */
/*==============================================================*/
create table xye_core_appconfig_test.obs_file_info
(
   file_id              national varchar(32) not null comment 'UUID',
   app_id               national varchar(50) comment '所属系统',
   file_name            national varchar(255) comment '文件名称',
   is_sensitive         int(11) comment '是否敏感:0-不敏感/1-敏感',
   file_type            national varchar(50) comment '文件类型',
   file_size            bigint(20) comment '文件大小',
   file_url             national varchar(255) comment '文件地址',
   state                int(11) comment '状态:0-无效/1-有效',
   upload_by            national varchar(50) comment '上传模式:流/字节数组',
   upload_usetime       bigint(20) comment '上传耗时',
   upload_time          datetime comment '上传时间',
   download_count       int(11) comment '下载次数',
   download_time        datetime comment '下载时间',
   primary key (file_id)
);

alter table xye_core_appconfig_test.obs_file_info comment 'fastdfs文件上传记录表';
)