---商城-店铺-产品（1）

select distinct a4.goods_name,
       a4.store_name,
       a3.shop_name,
       a4.store_code,
	   a4.state,
	   a4.status,
       a3.shop_code,
       a2.mall_name,
	   a2.mall_code,
       a2.mall_name_en,
       a2.mall_cre_time,
       a2.contact_name

from warehouse_jry_goods_info a4



right join newframe_shop_info a3
       ---on a4.store_name = a3.shop_name     --存在问题，抚宁百惠贷无法关联
	   on a4.store_code = a3.shop_code
 
right join
(select b.mall_name,
		b.mall_code,
        b.mall_name_en,
        b.create_date AS mall_cre_time,
        b.contact_name
 from warehouse_all_platform_mall_info b) a2  --商城+管理员
	   on a3.origin_mall_code = a2.mall_code   


	   
1.先开通商城（附加管理员账号）
1.2 商城下配置产品1

2.商城下面开通商店

3。商店下面配置产品2

select  b.mall_name,
		b.mall_code,
        b.mall_name_en,
        b.create_date AS mall_cre_time,
        b.contact_name,
		a.product_name

 from warehouse_all_platform_mall_info b         --商城
 left join(select distinct a.mall_code,
                  a.prod_id,
				  c.product_code,
				  c.product_name
           from warehouse_newframe_product_mcc_inf a
		   left join warehouse_newframe_all_product_info c
                  on a.prod_id = c.product_code
		   where a.state = '1')a         
        on b.mall_code = a.mall_code              --所有产品


