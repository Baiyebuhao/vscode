--BI 重构1
商城-平台-渠道-用户

--注册
SELECT e.mbl_no,
       e.data_source,
	   substr(e.registe_date,1,10) as registe_date,
       e.chan_no,         ---渠道号
       e.chan_no_desc,    ---渠道名称1
       g.promoter_name,   ---渠道名称
       g.promoter_type,   ---渠道类型
       g.mall_code,       ---商城编码
       g.mall_name        ---商城名

FROM warehouse_atomic_user_info e
LEFT JOIN

     (SELECT * 
      from warehouse_jry_business_promoter a1 --渠道
      LEFT JOIN warehouse_all_platform_mall_info a2
      	   on a1.general_code = a2.mall_code) g
 on e.chan_no = g.promoter_code
and e.app_code=g.mall_code


where substr(e.registe_date,1,10) >='2020-03-01'
(
(--申请

--享宇订单号关联，查mall_code
申请表 l_application_inf     xy_order_no  享宇订单号
    `data_source` varchar(45) DEFAULT NULL COMMENT '业务平台'，
	`org_no` varchar(45) DEFAULT NULL COMMENT '机构编号',
	`product_no` varchar(45) DEFAULT NULL COMMENT '产品编号',
	`xy_order_no` varchar(45) DEFAULT NULL COMMENT  '享宇订单号',
	`mbl_no` varchar(45) DEFAULT NULL COMMENT '申请人电话',
	`apply_time` datetime DEFAULT NULL COMMENT '申请时间',
	`status` varchar(45) DEFAULT NULL COMMENT '授信状态',
	`credit_time` varchar(45) DEFAULT NULL COMMENT '授信时间',
	`credit_amount` double(11,2) DEFAULT NULL COMMENT '授信金额（可用金额）',
	`loan_term` varchar(45) DEFAULT NULL COMMENT '授信额度有效期',
	`refuse_desc` varchar(100) DEFAULT NULL COMMENT '授信未通过原因',
订单表 credit_core_order  
   order_code           varchar(50) comment '订单号',
   channel_code         varchar(50) comment '订单来源渠道',
   user_code            varchar(50) comment '用户code',
   user_account         varchar(50) comment '用户账号（号码）',
   mobile               varchar(45) comment '手机',
   store_code           varchar(50) comment '店铺编码',
   store_name           varchar(200) comment '店铺名称',
   mall_code            varchar(50) comment '商城编码',
   mall_name            varchar(200) comment '商城名称',
   goods_id             varchar(50) comment '商品id',
   goods_name           varchar(50) comment '商品名称',
)
(   
from warehouse_ledger_l_application_inf a1  ---标准台账-申请    
                                            ---问题：1.同一个享宇订单号，多笔数据问题 
											       --2.xy_order_no为空的情况 
												   --3.享宇订单号相同三笔，其中两笔数据完全一样，另一笔机构订单号不一样
left join warehouse_credit_core_order a2    ---订单表
       on a1.xy_order_no = a2.order_code    ---订单号
)

(--申请
select a1.mbl_no,
       a2.mobile,
       a1.data_source,
	   
	   a2.mall_code,     ---商城
	   a2.mall_name,     ---商城名
	   a2.channel_code,  --渠道号
	   a3.promoter_name, --渠道名称
       a3.promoter_type, --渠道类型
	   a1.xy_order_no,   --享宇订单号
	   
	   a1.product_no,    --产品编号
	   a2.goods_id,      --产品编号2
	   a2.goods_name,    ---产品名
	   
	   a1.apply_time,    ---申请时间
	   a1.credit_time,   ---授信时间
	   a1.status,        ---授信状态
	   a1.credit_amount  ---授信金额 
	   
from 
(SELECT distinct a.data_source,
       a.mbl_no,
       a.org_no,
       a.xy_order_no,
       a.product_no,
       a.apply_time,
       a.status,
       a.credit_time,
       a.credit_amount,
       a.refuse_desc
       
from warehouse_ledger_l_application_inf a
where a.apply_time >='2020-03-01'
  and a.xy_order_no IS NOT NULL) a1

LEFT JOIN warehouse_credit_core_order a2    ---订单表
       on a1.xy_order_no = a2.order_code    ---订单号
	   
LEFT JOIN
   (SELECT * 
    FROM warehouse_jry_business_promoter a --渠道
    LEFT JOIN warehouse_all_platform_mall_info b   --商城
           ON a.general_code = b.mall_code) a3
		      
ON a2.channel_code = a3.promoter_code   --渠道号
AND a2.mall_code=a3.mall_code       --商城号
)

(
---
-----
select b1.*,
       a3.promoter_name,
       a3.promoter_type
from
(
select a1.mbl_no,
       a2.mobile,
       a1.data_source,
	   
	   a2.mall_code,
	   a2.mall_name,
	   a2.channel_code,
	   ---a3.promoter_name,
       ---a3.promoter_type,
	   a1.xy_order_no,
	   
	   a1.product_no,
	   a2.goods_id,
	   a2.goods_name,
	   
	   a1.apply_time,
	   a1.credit_time,
	   a1.status,
	   a1.credit_amount
	   
from 
(SELECT distinct a.data_source,
       a.mbl_no,
       a.org_no,
       a.xy_order_no,
       a.product_no,
       a.apply_time,
       a.status,
       a.credit_time,
       a.credit_amount,
       a.refuse_desc
       
from warehouse_ledger_l_application_inf a
where a.apply_time >='2020-03-01'
  and a.xy_order_no IS NOT NULL) a1
left join warehouse_credit_core_order a2    ---订单表
       on a1.xy_order_no = a2.order_code    ---订单号
)  b1
LEFT JOIN
   (SELECT * 
    FROM warehouse_jry_business_promoter a --渠道
    LEFT JOIN warehouse_all_platform_mall_info b   --商城
           ON a.general_code = b.mall_code) a3
		      
ON b1.channel_code = a3.promoter_code   --渠道号
AND b1.mall_code=a3.mall_code       --商城号
)

)

(
--授信


)
(
--提现
select a1.mbl_no,
       a2.mobile,
       a1.data_source,
	   
	   a2.mall_code,     ---商城
	   a2.mall_name,     ---商城名
	   a2.channel_code,  --渠道号
	   a3.promoter_name, --渠道名称
       a3.promoter_type, --渠道类型
	   a1.xy_order_no,   --享宇订单号
	
	   a1.product_no,    --产品编号
	   a2.goods_id,      --产品编号2
	   a2.goods_name,    ---产品名
	   
	   a1.loan_time,     --放款时间
	   a1.loan_status,   --放款状态
	   a1.loan_amount    --放款金额

from 
(SELECT distinct a.data_source,
       a.mbl_no,
       a.org_no,
       a.xy_order_no,
       a.product_no,
       a.loan_status,      ---放款状态
	   a.loan_time,        ---放款时间
	   a.loan_amount       ---放款金额
       
from warehouse_ledger_l_payment_inf a
where a.loan_time >='2020-03-01'
  and a.xy_order_no IS NOT NULL) a1

LEFT JOIN warehouse_credit_core_order a2    ---订单表
       on a1.xy_order_no = a2.order_code    ---订单号
	   
LEFT JOIN
   (SELECT * 
    FROM warehouse_jry_business_promoter a --渠道
    LEFT JOIN warehouse_all_platform_mall_info b   --商城
           ON a.general_code = b.mall_code) a3
		      
ON a2.channel_code = a3.promoter_code   --渠道号
AND a2.mall_code=a3.mall_code       --商城号


)