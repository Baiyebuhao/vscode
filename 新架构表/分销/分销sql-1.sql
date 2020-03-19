--分销sql-1
select * 
from distributor_merchant_info a1  ---分销商信息

select * 
from distributor_staff_info a2  --分销员信息


on  a1.id= a2.distributor_merchant_id

--分销商+分销员
select a1.id,                        --分销商id
       a1.distributor_name,          --分销商名称
	   a1.channel_number,            --分销商推广渠道号
       a2.id,                         --分销员id
	   a2.distributor_name,           --分销员名称
	   a2.distributor_account,        --分销员账号（app账号）
	   a2.channel_number              --分销员推广渠道号
from warehouse_atomic_distribut_distributor_merchant_info a1  ---分销商信息
left join warehouse_atomic_distribut_distributor_staff_info a2  --分销员信息
       on a1.id= a2.distributor_merchant_id      --???
where a1.distributor_name like '%旭华%' or a1.parent_name like '%旭华%'

--订单
select a3.user_account,         --用户号码
       a3.promote_sales_code,   --推广码
	   a3.goods_id,             --商品ID
	   a3.goods_name,           --商品名称
	   a2.id,                         --分销员id
	   a2.distributor_name,           --分销员名称
	   a2.distributor_account,        --分销员账号（app账号）
	   a2.channel_number,             --分销员推广渠道号
	   a1.id,                        --分销商id
       a1.distributor_name,          --分销商名称
	   a1.channel_number            --分销商推广渠道号
       
from warehouse_atomic_distribut_distribution_order a3  ---订单表
left join warehouse_atomic_distribut_distributor_staff_info a2     --分销员信息
       on a3.promote_sales_code = a2.channel_number     ---渠道推广码
    ---on a3.distributor_staff_id = a2.id               ---分销员ID关联 (两种方式） 
left join warehouse_atomic_distribut_distributor_merchant_info a1  ---分销商信息
       on a1.id= a2.distributor_merchant_id 
       
--分销商+分销员+订单
select a1.id,
       a1.distributor_name,
	   a1.channel_number,
	   a1.distributor_code,
	   a1.parent_name,
       a2.id,
	   a2.distributor_name,
	   a2.distributor_account,
	   a2.channel_number,
	   a2.distributor_code,
	   a3.user_account,         --用户号码
       a3.promote_sales_code,   --推广码
	   a3.goods_id,             --商品ID
	   a3.goods_name           --商品名称
from warehouse_atomic_distribut_distributor_merchant_info a1  ---分销商信息
left join warehouse_atomic_distribut_distributor_staff_info a2  --分销员信息
       on a1.id= a2.distributor_merchant_id
       
left join warehouse_atomic_distribut_distribution_order a3  ---订单表
       on a3.promote_sales_code = a2.channel_number
       
where a1.distributor_name like '%旭华%' or a1.parent_name like '%旭华%'



--订单+分销商+分销员
select a1.id,                        --分销商id
       a1.distributor_name,          --分销商名称
	   a1.channel_number,            --分销商推广渠道号
	   a1.distributor_code,          --分销员（商）编码
	   a1.parent_name,               --父级名称（分销商）
	   a1.create_date as dd_date,    --订单日期
	   a1.mall_name,                 --商城名称
       a2.id,                         --分销员id
	   a2.distributor_name,           --分销员名称
	   a2.distributor_account,        --分销员账号（app账号）
	   a2.channel_number,             --分销员推广渠道号
	   a2.distributor_code,           --分销员编码
	   a3.user_account,         --用户号码
       a3.promote_sales_code,   --推广码
	   a3.goods_id,             --商品ID
	   a3.goods_name            --商品名称
from warehouse_atomic_distribut_distribution_order a3  ---订单表

left join warehouse_atomic_distribut_distributor_staff_info a2  --分销员信息
       on a3.promote_sales_code = a2.channel_number     ---渠道推广码
    ---on a3.distributor_staff_id = a2.id               ---分销员ID关联 (两种方式） 
left join warehouse_atomic_distribut_distributor_merchant_info a1  ---分销商信息
       on a1.id= a2.distributor_merchant_id             --分销商id关联
where a1.distributor_name like '%旭华%' or a1.parent_name like '%旭华%' 
	   

