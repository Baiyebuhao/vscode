--重构数据库PDM_xye_core_goods_test-2020.01.09
(drop table if exists xye_core_goods_test.goods_base_attr;

/*==============================================================*/
/* Table: goods_base_attr                                       */
/*==============================================================*/
create table xye_core_goods_test.goods_base_attr
(
   id                   varchar(50) not null comment 'ID',
   goods_id             varchar(50) comment '商品编码',
   attr                 varchar(30) comment '属性',
   is_sku               int(11) comment 'sku标志（暂时未用到此字段）',
   val                  varchar(30) comment '属性值',
   cbox_type            int(11) comment '控件类型,1label,2单选radio,3复选checkbox,4输入框input,5日期框date',
   is_required          int(11) comment '是否必填 1是0否',
   is_enabled           int(11) comment '是否可编辑1是0否',
   ord                  int(11) comment '排序',
   create_date          timestamp comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          timestamp comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   primary key (id)
);

alter table xye_core_goods_test.goods_base_attr comment '商品基本属性';
)

(drop table if exists xye_core_goods_test.goods_brande;

/*==============================================================*/
/* Table: goods_brande                                          */
/*==============================================================*/
create table xye_core_goods_test.goods_brande
(
   id                   varchar(50) not null comment 'ID',
   brande_name          varchar(200) comment '商品名称',
   brande_desc          varchar(200) comment '商品简述',
   pic                  varchar(200) comment '缩略图',
   logo                 varchar(200),
   link                 varchar(200) comment '官方地址',
   is_display           int(11) comment '是否显示1是0否',
   ord                  int(11) comment '排序',
   create_date          timestamp comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          timestamp comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   mall_code            varchar(50) comment '商城编码',
   primary key (id)
);

alter table xye_core_goods_test.goods_brande comment '品牌';
)

(drop table if exists xye_core_goods_test.goods_cate;

/*==============================================================*/
/* Table: goods_cate                                            */
/*==============================================================*/
create table xye_core_goods_test.goods_cate
(
   id                   varchar(50) not null comment 'ID',
   cate_name            varchar(50) comment '分类名称',
   parent_id            varchar(50) comment '上级编码',
   cate_level           int(11) default 0 comment '层级从0开始',
   unit                 varchar(45) comment '单位',
   ord                  int(11) comment '排序',
   mall_code            varchar(50) comment '商城编码',
   store_code           varchar(50) comment '所属店铺编码（暂时未用到此字段）',
   create_date          timestamp comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          timestamp comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常状态',
   comments             varchar(200) comment '备注',
   primary key (id)
);

alter table xye_core_goods_test.goods_cate comment '商品分类';
)

(drop table if exists xye_core_goods_test.goods_cate_attr;

/*==============================================================*/
/* Table: goods_cate_attr                                       */
/*==============================================================*/
create table xye_core_goods_test.goods_cate_attr
(
   id                   varchar(50) not null comment 'ID',
   attr_name            varchar(100) comment '属性名称',
   cate_id              varchar(50) comment '分类编码',
   is_required          int(11) comment '必填标志 1是0否',
   cbox_type            int(11) comment '控件类型,1label,2单选radio,3复选checkbox,4输入框input,5日期框date',
   attr_type            int(11) comment '属性类型（暂时未用到此字段）',
   ord                  int(11) comment '排序',
   is_enabled           int(11) comment '是否可编辑,1是0否',
   create_date          timestamp comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          timestamp comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   mall_code            varchar(50),
   primary key (id)
);

alter table xye_core_goods_test.goods_cate_attr comment '分类属性';
)

(drop table if exists xye_core_goods_test.goods_cate_attr_val;

/*==============================================================*/
/* Table: goods_cate_attr_val                                   */
/*==============================================================*/
create table xye_core_goods_test.goods_cate_attr_val
(
   id                   varchar(50) not null comment 'ID',
   val                  varchar(100) comment '属性值',
   ord                  char(10) comment '排序',
   cate_id              varchar(50) comment '对应所属分类code',
   attr_id              varchar(50) comment '对应属性名称code',
   create_date          timestamp comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          timestamp comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(30) comment '备注',
   primary key (id)
);

alter table xye_core_goods_test.goods_cate_attr_val comment '属性值';
)

(drop table if exists xye_core_goods_test.goods_info;

/*==============================================================*/
/* Table: goods_info                                            */
/*==============================================================*/
create table xye_core_goods_test.goods_info
(
   id                   varchar(50) not null comment 'ID',
   goods_name           varchar(200) comment '商品名称',
   store_code           varchar(50) comment '商户编码',
   cate_id              varchar(50) comment '分类编码',
   goods_desc           varchar(200) comment '商品简述',
   mall_code            varchar(50),
   store_name           varchar(45) comment '店铺名称',
   mall_name            varchar(45) comment '商城名称',
   pic                  varchar(1000) comment '缩略图',
   url                  varchar(200) comment '商品链接',
   product_id           varchar(50) comment '产品编码',
   brande_id            varchar(50) comment '品牌编码',
   content              mediumtext comment '商品详情',
   seo_keys             varchar(100) comment '关键词',
   status               int(11) comment '业务状态,1上架2下架',
   create_date          timestamp comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          timestamp comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   price_min            double comment '现价',
   price_max            double comment '现价',
   old_price_min        double comment '原价',
   old_price_max        double comment '原价',
   delivery             varchar(10) comment '物流标志',
   ready_date           varchar(20) comment '上架日期',
   is_applyable         int(11) comment '是否直接申请1是0否',
   is_splitable         int(11) comment '是否支持实物分期1是0否',
   rate_type            int(11) comment '利率类型1日息2月息3年息',
   rate                 double comment '利率',
   max_rate             double,
   is_fixation_rate     int(11) default 1 comment '是否固定利率 0-利率区间 1-固定利率',
   location             varchar(1000) comment '上架区域',
   loc_sel_type         int(11) comment '区域选择类型1全国2正选3反选',
   periods              varchar(255) comment '期数',
   super_cate_id        varchar(50) comment '根分类id',
   org_id               varchar(50),
   goods_seq            double comment '产品顺序',
   list_pic             varchar(1000) comment '设为列表图片',
   fang_pic             varchar(1000) comment '方形图片',
   primary key (id)
);

alter table xye_core_goods_test.goods_info comment '商品';
)

(drop table if exists xye_core_goods_test.goods_loan_con;

/*==============================================================*/
/* Table: goods_loan_con                                        */
/*==============================================================*/
create table xye_core_goods_test.goods_loan_con
(
   id                   varchar(50) not null,
   loan_goods_id        varchar(50) comment '贷款商品id',
   goods_id             varchar(50) comment '实物商品id',
   create_date          datetime,
   create_by            varchar(45),
   update_date          datetime,
   update_by            varchar(45),
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200),
   primary key (id)
);

alter table xye_core_goods_test.goods_loan_con comment '商品关联表';
)

(drop table if exists xye_core_goods_test.goods_media_res;

/*==============================================================*/
/* Table: goods_media_res                                       */
/*==============================================================*/
create table xye_core_goods_test.goods_media_res
(
   id                   varchar(50) not null comment 'ID',
   goods_id             varchar(50) comment '商品编码',
   res_type             varchar(20) comment '资源类型（pic图片 video 视频）',
   res_path             varchar(1000) comment '资源路径',
   ord                  int(11) comment '排序',
   create_date          timestamp comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          timestamp comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   primary key (id)
);

alter table xye_core_goods_test.goods_media_res comment '媒体资源';
)

(drop table if exists xye_core_goods_test.goods_product;

/*==============================================================*/
/* Table: goods_product                                         */
/*==============================================================*/
create table xye_core_goods_test.goods_product
(
   id                   varchar(50) not null comment 'ID',
   product_name         varchar(200) comment '产品名称',
   store_code           varchar(50) comment '商户编码',
   cate_id              varchar(50) comment '分类编码',
   product_type         varchar(45) comment '子分类',
   product_desc         varchar(200) comment '产品简述',
   status               varchar(200) comment '对接状态（暂时未用到此字段）',
   rate                 double,
   credit_amt_min       double comment '授信金额',
   credit_amt_max       double comment '授信金额',
   org_id               varchar(50) comment '机构id',
   create_date          timestamp comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          timestamp comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   periods              varchar(50) comment '期数支持',
   repay_type           varchar(45) comment '还款方式支持  PRINCIPAL 等额本金  INTEREST 等额本息',
   primary key (id)
);

alter table xye_core_goods_test.goods_product comment '产品接入表';
)

(drop table if exists xye_core_goods_test.goods_sku;

/*==============================================================*/
/* Table: goods_sku                                             */
/*==============================================================*/
create table xye_core_goods_test.goods_sku
(
   id                   varchar(50) not null comment 'ID',
   price                double comment '价格',
   stock_id             varchar(50) comment '库存id',
   goods_id             varchar(50) comment '商品编码',
   create_date          timestamp comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          timestamp comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   sku_id               varchar(50) comment '自定义id',
   stock_warning        int(11) comment '预警值',
   primary key (id)
);

alter table xye_core_goods_test.goods_sku comment '商品sku';
)

(drop table if exists xye_core_goods_test.goods_sku_attr;

/*==============================================================*/
/* Table: goods_sku_attr                                        */
/*==============================================================*/
create table xye_core_goods_test.goods_sku_attr
(
   id                   varchar(50) not null comment 'ID',
   attr                 varchar(30) comment '属性',
   val                  varchar(30) comment '属性值',
   goods_id             varchar(50) comment '商品编码',
   sku_id               varchar(50) comment 'sku编码',
   is_sku               int(11) comment 'sku标志',
   create_date          timestamp comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_by            varchar(30) comment '修改人',
   update_date          timestamp comment '修改时间',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   primary key (id)
);

alter table xye_core_goods_test.goods_sku_attr comment '商品属性';
)

(drop table if exists xye_core_goods_test.goods_stock;

/*==============================================================*/
/* Table: goods_stock                                           */
/*==============================================================*/
create table xye_core_goods_test.goods_stock
(
   id                   varchar(50) not null,
   sku_id               varchar(50) comment '商品skuid',
   stock_count          int(11) default 0 comment '库存',
   stock_lock_count     int(11) default 0 comment '已锁定数量',
   sold_count           int(11) default 0 comment '销量',
   create_date          datetime comment '创建日期',
   create_by            varchar(45),
   update_date          datetime,
   update_by            varchar(45),
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200),
   primary key (id)
);
)

(drop table if exists xye_core_goods_test.goods_stock_log;

/*==============================================================*/
/* Table: goods_stock_log                                       */
/*==============================================================*/
create table xye_core_goods_test.goods_stock_log
(
   id                   varchar(50) not null,
   goods_id             varchar(50),
   sku_id               varchar(50),
   stock_id             varchar(50) comment '库存id',
   operations_count     int(11) comment '操作数量',
   order_code           varchar(50) comment '订单号',
   log_status           int(11) comment '业务状态.1锁定2成功释放3取消释放0异常回滚',
   stock_old            int(11),
   stock_new            int(11),
   create_date          datetime comment '创建日期',
   create_by            varchar(50),
   update_date          datetime,
   update_by            varchar(50),
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200),
   primary key (id)
);
)

(drop table if exists xye_core_goods_test.opt_log;

/*==============================================================*/
/* Table: opt_log                                               */
/*==============================================================*/
create table xye_core_goods_test.opt_log
(
   id                   varchar(50) not null comment 'ID',
   opt_msg              varchar(200) comment '操作信息',
   opt_model            varchar(200) comment '操作模块',
   opt_type             varchar(30) comment '操作类型（暂时未用到此字段）',
   details              varchar(30) comment '具体参数',
   create_date          timestamp comment '创建时间',
   create_by            varchar(30) comment '创建人',
   update_date          timestamp comment '修改时间',
   update_by            varchar(30) comment '修改人',
   state                int(11) default 1 comment '状态 0:删除 1：正常',
   comments             varchar(200) comment '备注',
   primary key (id)
);

alter table xye_core_goods_test.opt_log comment '操作日志表';
)

(drop table if exists xye_core_goods_test.tmp_goods_product;

/*==============================================================*/
/* Table: tmp_goods_product                                     */
/*==============================================================*/
create table xye_core_goods_test.tmp_goods_product
(
   product_id           varchar(50) comment '产品编码',
   store_code           varchar(50) comment '商户编码',
   store_name           varchar(45) comment '店铺名称',
   mall_code            varchar(50),
   mall_name            varchar(45) comment '商城名称',
   goods_id             varchar(50) not null comment 'ID',
   goods_name           varchar(200) comment '商品名称',
   pic                  varchar(1000) comment '缩略图'
);
)
