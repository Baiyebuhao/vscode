--重构数据库PDM_xye_core_platform_statistics_test-2020.01.09

(drop table if exists xye_core_platform_statistics_test.statistics_register_record;

/*==============================================================*/
/* Table: statistics_register_record                            */
/*==============================================================*/
create table xye_core_platform_statistics_test.statistics_register_record
(
   id                   varchar(36) not null comment '主键id',
   record_time          varchar(50) comment '记录时间',
   begin_time           varchar(50) comment '开始时间',
   enddate_time         varchar(50) comment '结束时间',
   msg_type             varchar(50) comment '短信模板类型 oneday:全天短信 twohours:2小时短信 ringwarning:环比预警 registerwarning:注册预警',
   jry_reg_num          int(11) comment '金融苑注册数量',
   jry_real_name_num    int(11) comment '金融苑实名认证数量',
   jry_apply_num        int(11) comment '金融苑申请数量',
   chain_proportion     varchar(50) comment '环比率',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   primary key (id)
);
)

(drop table if exists xye_core_platform_statistics_test.statistics_send_mbl_conf;

/*==============================================================*/
/* Table: statistics_send_mbl_conf                              */
/*==============================================================*/
create table xye_core_platform_statistics_test.statistics_send_mbl_conf
(
   id                   varchar(36) not null comment '主键id',
   mall_code            varchar(50) comment '商城编码',
   mbl_no               varchar(200) comment '电话号码',
   msg_type             varchar(50) comment '短信模板类型 oneday:全天短信 twohours:2小时短信 ringwarning:环比预警 registerwarning:注册预警',
   chain_proportion     varchar(50) comment '环比率',
   on_off               int(11) comment '短信模板开关 0、关 1、开',
   create_date          datetime comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   primary key (id)
);
)
