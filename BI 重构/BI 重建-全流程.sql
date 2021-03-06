--BI 重建 -全流程
select data_source,
       mall_code,
	   mall_name,
	   channel_code,
	   promoter_name,
	   case promoter_type when 1 then '安卓' when 2 then 'IOS' when 3 then 'H5' end promoter_type,
	   extractday,

	   --product_no,
	   --goods_name,

	   count(DISTINCT CASE
                          WHEN code='注册' THEN s_mbl_no
                      END) AS regnum,
       count(DISTINCT CASE
                          WHEN code='申请' THEN s_mbl_no
                      END) AS apllynum,
       count(DISTINCT CASE
                          WHEN code='授信' and status = '2' THEN s_mbl_no
                      END) AS creditnum,
       count(DISTINCT CASE
                          WHEN code='提现' and status = '2' THEN s_mbl_no
                      END) AS cashnum,
       sum(case when code = '授信' and status = '2' then amount end) AS credit_amount,
	   sum(case when code = '提现' and status = '2' then amount end) AS cash_amount
from 
(
--注册
SELECT '注册' as code,
       a1.data_source as data_source,
	   a1.mbl_no as s_mbl_no,
	   
	   substr(a1.registe_date,1,10) as extractday,
	   
       a2.mall_code,       ---商城编码
       a2.mall_name,       ---商城名
	   
       a1.chan_no as channel_code,         ---渠道号
	   
	   case when a2.promoter_name is NULL then a1.chan_no_desc 
	        else a2.promoter_name end promoter_name,   --渠道名称
       a2.promoter_type,    ---渠道类型
	   
	   '' as xy_order_no,   --享宇订单号
	   
	   '' as product_no,    --产品编号
	   '' as goods_name,    ---产品名

	   '' as status,        ---授信状态
	   '' as amount  ---授信金额 

FROM warehouse_atomic_user_info a1
LEFT JOIN

     (SELECT * 
      from warehouse_jry_business_promoter a --渠道
      LEFT JOIN warehouse_all_platform_mall_info b
      	   on a.general_code = b.mall_code) a2
 on a1.chan_no = a2.promoter_code
and a1.app_code=a2.mall_code


where substr(a1.registe_date,1,10) >= date_sub(current_date(),90)
union all
--申请
select '申请' as code,
       a1.data_source as data_source,
	   case when a1.mbl_no is NULL then a2.mobile 
	        else a1.mbl_no end s_mbl_no,
	   substr(a1.apply_time,1,10) as extractday,    ---申请时间
	   
	   
	   a2.mall_code,     ---商城
	   a2.mall_name,     ---商城名
	   
	   a2.channel_code as channel_code,  --渠道号
	   a3.promoter_name, --渠道名称
       a3.promoter_type, --渠道类型
	   
	   
	   
	   a1.xy_order_no,   --享宇订单号
	   
	   a1.product_no,    --产品编号
	   a2.goods_name,    ---产品名
	   
	   '' as status,        ---授信状态
	   '' as amount  ---授信金额 

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
where a.apply_time >= date_sub(current_date(),90)
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
union all
--授信
select '授信' as code,
       a1.data_source as data_source,
	   case when a1.mbl_no is NULL then a2.mobile 
	        else a1.mbl_no end s_mbl_no,
	   substr(a1.credit_time,1,10) as extractday,    ---授信时间
	   
	   
	   a2.mall_code,     ---商城
	   a2.mall_name,     ---商城名
	   
	   a2.channel_code as channel_code,  --渠道号
	   a3.promoter_name, --渠道名称
       a3.promoter_type, --渠道类型
	   
	   
	   
	   a1.xy_order_no,   --享宇订单号
	   
	   a1.product_no,    --产品编号
	   a2.goods_name,    ---产品名


	   a1.status,        ---授信状态
	   a1.credit_amount as amount  ---授信金额 
	   
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
where a.credit_time >= date_sub(current_date(),90)
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
where a1.status = '2'
union all
--提现

select '提现' as code,
       a1.data_source as data_source,
	   case when a1.mbl_no is NULL then a2.mobile 
	        else a1.mbl_no end s_mbl_no,
	   substr(a1.loan_time,1,10) as extractday,    ---放款时间

	   
	   a2.mall_code,     ---商城
	   a2.mall_name,     ---商城名
	   
	   a2.channel_code  as channel_code,  --渠道号
	   a3.promoter_name, --渠道名称
       a3.promoter_type, --渠道类型
	   
	   a1.xy_order_no,   --享宇订单号
	
	   a1.product_no,    --产品编号

	   a2.goods_name,    ---产品名
	   

	   a1.loan_status as status,   --放款状态
	   a1.loan_amount as amount    --放款金额

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
where a.loan_time >= date_sub(current_date(),90)
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

) a
where extractday <= date_sub(current_date(),1)
group by data_source,
       mall_code,
	   mall_name,
	   channel_code,
	   promoter_name,
	   promoter_type,
	   extractday--,

	   --product_no,
	   --goods_name