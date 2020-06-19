---渠道总用户(推送-申请-提现)
---
select data_source,       ---平台
       mall_code,         ---商城号
	   mall_name,         ---商城名
	   channel_code,      ---渠道号
	   promoter_name,     ---渠道名
	   case promoter_type when 1 then '安卓' when 2 then 'IOS' when 3 then 'H5' end promoter_type,    ---渠道类型
	   extractday,        ---日期

	   product_no,
	   goods_name,
	   
	   count(DISTINCT CASE
                          WHEN code='推送' THEN x_mbl_no
                      END) AS pushnum,
       count(DISTINCT CASE
                          WHEN code='申请' THEN x_mbl_no
                      END) AS apllynum,
       count(DISTINCT CASE
                          WHEN code='授信' and status = '2' THEN x_mbl_no
                      END) AS creditnum,
       count(DISTINCT CASE
                          WHEN code='提现' and status = '2' THEN x_mbl_no
                      END) AS cashnum,
       sum(case when code = '授信' and status = '2' then amount end) AS credit_amount,
	   sum(case when code = '提现' and status = '2' then amount end) AS cash_amount
from 
(
---产品渠道推送
select '推送' as code,
       a1.platform as data_source,
       a1.phone_number as x_mbl_no,
	   a1.extractday,
	   a1.mall_code,     ---商城
	   a2.mall_name,     ---商城名
	   a1.channel_code,  --渠道号
	   a3.promoter_name, --渠道名称
       a3.promoter_type, --渠道类型
       '' as xy_order_no,
       a1.goods_id as product_no,    --产品编号
	   a4.goods_name,    ---产品名
	   '' as status,     ---授信状态
	   '' as amount      ---授信金额 

from
(select distinct a.start_id,
                  a.mallcode as mall_code,
                  a.platform,
				  b.channel as channel_code,
				  a.goods_id as goods_id,
				  a.phone_number,
				  a.extractday
 from warehouse_atomic_newframe_burypoint_buttonoperations a
 
 left join (select distinct start_id,
				  channel
           from default.warehouse_atomic_newframe_burypoint_baseoperations)b                            --基础
       on a.start_id = b.start_id
 where a.click_name = 'order_promptly'
   and a.extractday>= date_sub(current_date(),40)) a1
 
left join(select mall_code,
                 mall_name 
          from  warehouse_all_platform_mall_info a) a2
       on a1.mall_code = a2.mall_code

LEFT JOIN
   (SELECT a.promoter_code,
           a.promoter_name, --渠道名称
           a.promoter_type, --渠道类型
		   b.mall_code
    FROM warehouse_jry_business_promoter a --渠道
    LEFT JOIN warehouse_all_platform_mall_info b   --商城
           ON a.general_code = b.mall_code) a3
		      
       ON a1.channel_code = a3.promoter_code   --渠道号
      AND a1.mall_code=a3.mall_code       --商城号

left join (SELECT distinct id, 
                  goods_name
                  from warehouse_jry_goods_info a
           where product_id is not null) a4                           --产品
  on a1.goods_id = a4.id
where a1.channel_code is not null
union all
---申请

select '申请' as code,
       a1.data_source as data_source,
	   case when a1.mbl_no is NULL then a2.mobile 
	        else a1.mbl_no end x_mbl_no,
	   substr(a1.apply_time,1,10) as extractday,    ---申请时间

	   a2.mall_code,     ---商城
	   a2.mall_name,     ---商城名
	   
	   a2.channel_code as channel_code,  --渠道号
	   a3.promoter_name, --渠道名称
       a3.promoter_type, --渠道类型

	   a1.xy_order_no,   --享宇订单号
	   
	   a1.product_no,    --产品编号
	   a2.goods_name,    ---产品名
	   '' as status,     ---授信状态
	   '' as amount      ---授信金额 

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
  where a.xy_order_no IS NOT NULL) a1

LEFT JOIN warehouse_credit_core_order a2    ---订单表
       on a1.xy_order_no = a2.order_code    ---订单号
	   
LEFT JOIN
   (SELECT * 
    FROM warehouse_jry_business_promoter a --渠道
    LEFT JOIN warehouse_all_platform_mall_info b   --商城
           ON a.general_code = b.mall_code) a3
		      
ON a2.channel_code = a3.promoter_code   --渠道号
AND a2.mall_code=a3.mall_code       --商城号

left join warehouse_atomic_user_info a4
  on a4.mbl_no = a1.mbl_no
 and a4.chan_no = a3.promoter_code
 and a4.app_code=a3.mall_code

where substr(a1.apply_time,1,10) >= date_sub(current_date(),90)
union all
--授信

select '授信' as code,
       a1.data_source as data_source,
	   case when a1.mbl_no is NULL then a2.mobile 
	        else a1.mbl_no end x_mbl_no,
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
  where a.xy_order_no IS NOT NULL
    and a.status = '2') a1

LEFT JOIN warehouse_credit_core_order a2    ---订单表
       on a1.xy_order_no = a2.order_code    ---订单号
	   
LEFT JOIN
   (SELECT * 
    FROM warehouse_jry_business_promoter a --渠道
    LEFT JOIN warehouse_all_platform_mall_info b   --商城
           ON a.general_code = b.mall_code) a3
		      
ON a2.channel_code = a3.promoter_code   --渠道号
AND a2.mall_code=a3.mall_code       --商城号

left join warehouse_atomic_user_info a4
  on a4.mbl_no = a1.mbl_no
 and a4.chan_no = a3.promoter_code
 and a4.app_code=a3.mall_code

where substr(a1.credit_time,1,10) >= date_sub(current_date(),90)
union all
--提现

select '提现' as code,
       a1.data_source as data_source,
	   case when a1.mbl_no is NULL then a2.mobile 
	        else a1.mbl_no end x_mbl_no,
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
where a.xy_order_no IS NOT NULL) a1

LEFT JOIN warehouse_credit_core_order a2    ---订单表
       on a1.xy_order_no = a2.order_code    ---订单号
	   
LEFT JOIN
   (SELECT * 
    FROM warehouse_jry_business_promoter a --渠道
    LEFT JOIN warehouse_all_platform_mall_info b   --商城
           ON a.general_code = b.mall_code) a3
		      
ON a2.channel_code = a3.promoter_code   --渠道号
AND a2.mall_code=a3.mall_code       --商城号

left join warehouse_atomic_user_info a4
  on a4.mbl_no = a1.mbl_no
 and a4.chan_no = a3.promoter_code
 and a4.app_code=a3.mall_code

 where substr(a1.loan_time,1,10) >= date_sub(current_date(),90)
) a
where extractday <= date_sub(current_date(),1)
group by data_source,
         mall_code,
	     mall_name,
	     channel_code,
	     promoter_name,
	     promoter_type,
	     extractday,
		 product_no,
		 goods_name
