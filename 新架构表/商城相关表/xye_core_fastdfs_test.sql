--重构数据库PDM_xye_core_fastdfs_test-2020.01.09

drop table if exists xye_core_fastdfs_test.fastdfs_file_info;

/*==============================================================*/
/* Table: fastdfs_file_info                                     */
/*==============================================================*/
create table xye_core_fastdfs_test.fastdfs_file_info
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

alter table xye_core_fastdfs_test.fastdfs_file_info comment 'fastdfs文件上传记录表';
