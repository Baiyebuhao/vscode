--BI重建-注册实名

select data_source,
       mall_code,
	   mall_name,
	   channel_code,
	   promoter_name,
	   case promoter_type when 1 then '安卓' when 2 then 'IOS' when 3 then 'H5' end promoter_type,
	   extractday,
	   
	   count(DISTINCT CASE
                          WHEN code='注册' THEN mbl_no
                      END) AS regnum,
       count(DISTINCT CASE
                          WHEN code='实名' THEN mbl_no
                      END) AS autnum
from
(--注册
SELECT '注册' as code,
       a1.data_source as data_source,
	   a1.mbl_no as mbl_no,
	   
	   substr(a1.registe_date,1,10) as extractday,
	   
       a2.mall_code,       ---商城编码
       a2.mall_name,       ---商城名
	   
       a1.chan_no as channel_code,         ---渠道号
	   
	   case when a2.promoter_name is NULL then a1.chan_no_desc 
	        else a2.promoter_name end promoter_name,   --渠道名称
       a2.promoter_type--,    ---渠道类型
	   
	   --'' as xy_order_no,   --享宇订单号
	   --
	   --'' as product_no,    --产品编号
	   --'' as goods_name,    ---产品名
	   --
	   --'' as status,        ---授信状态
	   --'' as amount  ---授信金额 

FROM warehouse_atomic_user_info a1
LEFT JOIN

     (SELECT * 
      from warehouse_jry_business_promoter a --渠道
      LEFT JOIN warehouse_all_platform_mall_info b
      	   on a.general_code = b.mall_code) a2
 on a1.chan_no = a2.promoter_code
and a1.app_code=a2.mall_code
WHERE substr(a1.registe_date,1,10) >= date_sub(current_date(),90)
union all

--实名
SELECT '实名' as code,
       a1.data_source as data_source,
	   a1.mbl_no as mbl_no,
	   
	   substr(a1.authentication_date,1,10) as extractday,
	   
       a2.mall_code,       ---商城编码
       a2.mall_name,       ---商城名
	   
       a1.chan_no as channel_code,         ---渠道号
	   
	   case when a2.promoter_name is NULL then a1.chan_no_desc 
	        else a2.promoter_name end promoter_name,   --渠道名称
       a2.promoter_type--,    ---渠道类型
	   
	   --'' as xy_order_no,   --享宇订单号
	   --
	   --'' as product_no,    --产品编号
	   --'' as goods_name,    ---产品名
	   --
	   --'' as status,        ---授信状态
	   --'' as amount  ---授信金额 

FROM warehouse_atomic_user_info a1
LEFT JOIN

     (SELECT * 
      from warehouse_jry_business_promoter a --渠道
      LEFT JOIN warehouse_all_platform_mall_info b
      	   on a.general_code = b.mall_code) a2
 on a1.chan_no = a2.promoter_code
and a1.app_code=a2.mall_code
where a1.authentication_date is not null
  and substr(a1.authentication_date,1,10) >= date_sub(current_date(),90)
) a

where extractday <= date_sub(current_date(),1)
group by data_source,
       mall_code,
	   mall_name,
	   channel_code,
	   promoter_name,
	   promoter_type,
	   extractday