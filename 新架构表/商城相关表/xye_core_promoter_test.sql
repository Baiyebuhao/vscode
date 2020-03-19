--重构数据库PDM_xye_core_promoter_test-2020.01.09

(drop table if exists xye_core_promoter_test.business_promoter;

/*==============================================================*/
/* Table: business_promoter                                     */
/*==============================================================*/
create table xye_core_promoter_test.business_promoter
(
   id                   varchar(255),
   promoter_code        varchar(255) comment '渠道编码',
   promoter_name        varchar(255) comment '渠道名称',
   general_code         varchar(255) comment '通用编码',
   promoter_type        varchar(255) comment '渠道类型',
   description          varchar(255) comment '描述',
   comments             national varchar(255) comment '备注',
   create_date          datetime comment '创建时间',
   create_by            national varchar(100) comment '创建人',
   update_date          datetime comment '修改时间',
   update_by            national varchar(100) comment '修改人',
   state                int(3) default 1 comment '状态 0:删除 1：正常',
   is_enabled           int(1) default 1 comment '是否启用 0禁用 1启用'
);
)
