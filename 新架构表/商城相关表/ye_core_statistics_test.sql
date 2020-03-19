--重构数据库PDM_xye_core_statistics_test-2020.01.09

(drop table if exists xye_core_statistics_test.user_operation;

/*==============================================================*/
/* Table: user_operation                                        */
/*==============================================================*/
create table xye_core_statistics_test.user_operation
(
   id                   varchar(50),
   oper_type            varchar(20) comment '类型 base page button',
   oper_keys            text comment '列名 ,分隔',
   oper_values          text comment '值 ,分隔',
   create_date          datetime comment '插入时间'
);

alter table xye_core_statistics_test.user_operation comment '用户操作埋点';
)
