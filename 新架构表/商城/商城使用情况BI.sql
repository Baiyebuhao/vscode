(
★商城使用情况★
开通银行7家：豫丰、鹿泉、宣化、万全、围场、交子、新华恒升
配置产品5家：鹿泉、宣化、围场、交子、新华恒升
开通店铺5家：鹿泉、宣化、万全、围场、交子
在店铺上架商品2家：宣化、交子

select date_sub(current_date(),1) as extractday,
       a1.contact_name,
       a2.mall_name,
	   case when a1.code = '开通商城' and a1.num = 1 then '是'
	        when a1.code = '开通商城' and a1.num = 0 then '否'
	   end as code1,
	   
	   case when a2.code = '配置产品' and a2.num = 1 then '是'
	        when a2.code = '配置产品' and a2.num = 0 then '否'
	   end as code2,
	   
	   case when a3.code = '开通店铺' and a3.num = 1 then '是'
	        when a3.code = '开通店铺' and a3.num = 0 then '否'
	   end as code3,
	   
	   case when a4.code = '上架商品' and a4.num = 1 then '是'
	        when a4.code = '上架商品' and a4.num = 0 then '否'
	   end as code4
from
(--1.开通商城的银行
SELECT '开通商城' as code,
       a.contact_name,
       a.mall_name,
       count(distinct case when (length(a.mall_name)<>0) then a.mall_name end) as num
       
FROM warehouse_all_platform_mall_info a  --商城
WHERE (a.contact_name like '%银行%' or a.mall_name in ('交子普惠'))  
  and a.mall_name not in ('享宇银行' , '番茄银行')	
GROUP BY a.contact_name,a.mall_name) a1

left join
(--2.配置产品的银行
SELECT '配置产品' as code,
       a.contact_name,
       a.mall_name,
	   count(distinct case when (length(c.product_name)<>0 
	                             and c.product_name is not null) then a.contact_name end) as num

FROM warehouse_all_platform_mall_info a  --商城
LEFT JOIN
  (SELECT b.mall_code,
          b.prod_id
   FROM warehouse_newframe_product_mcc_inf b --商城产品
   WHERE b.state=1) b --正常
ON b.mall_code = a.mall_code
LEFT JOIN warehouse_newframe_all_product_info c ON b.prod_id=c.product_code
WHERE (a.contact_name like '%银行%' or a.mall_name in ('交子普惠'))  
  and a.mall_name not in ('享宇银行' , '番茄银行')
GROUP BY a.contact_name,a.mall_name) a2
      on a1.contact_name = a2.contact_name
	 and a1.mall_name = a2.mall_name

left join 
(--3.开通店铺的银行
SELECT '开通店铺' as code,
       a.contact_name,
       a.mall_name,
	   count(distinct case when (length(d.shop_name)<>0 
	                             and d.shop_name is not null) then a.contact_name end) as num
	   
FROM warehouse_all_platform_mall_info a  --商城

LEFT JOIN newframe_shop_info d ON a.mall_code=d.origin_mall_code--店铺
WHERE (a.contact_name like '%银行%' or a.mall_name in ('交子普惠'))  
  and a.mall_name not in ('享宇银行' , '番茄银行')
GROUP BY a.contact_name,a.mall_name) a3
      on a1.contact_name = a3.contact_name
	 and a1.mall_name = a3.mall_name

left join
(--4.在店铺上架商品的银行
SELECT '上架商品' as code,
       a.contact_name,
       a.mall_name,
	   count(distinct case when (length(d.shop_name)<>0 
	                             and d.shop_name is not null 
								 and length(e.goods_name)<>0 
								 and e.goods_name is not null) then a.contact_name end) as num

FROM warehouse_all_platform_mall_info a  --商城
LEFT JOIN newframe_shop_info d ON a.mall_code=d.origin_mall_code--店铺
LEFT JOIN warehouse_jry_goods_info e ON e.store_code=d.shop_code--商品
WHERE (a.contact_name like '%银行%' or a.mall_name in ('交子普惠'))  
  and a.mall_name not in ('享宇银行' , '番茄银行')
GROUP BY a.contact_name,a.mall_name) a4
      on a1.contact_name = a4.contact_name
	 and a1.mall_name = a4.mall_name
	 
)