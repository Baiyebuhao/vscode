--商城BI （KPI模式）
(--1、活跃用户量
select '活跃' AS code,
       a1.extractday,
       a3.platform as mall_name,
       --a1.pagenamecn as page_name,
       --a1.click_name,
	   count(distinct case when (length(a1.phone_number)<>0) then a1.phone_number end) as djrs,
	   count(distinct case when (length(a3.ip)<>0) then a3.ip end) as iprs,
	   count(a1.cus_no) as djcs
from default.warehouse_atomic_newframe_burypoint_buttonoperations a1   ---按钮
join (select distinct start_id,platform,ip
      from default.warehouse_atomic_newframe_burypoint_baseoperations
)a3                                      --基础
  on a1.start_id = a3.start_id
where a1.extractday >= date_sub(current_date(),1)
group by a1.extractday,
         a3.platform

--2、注册量 
 SELECT '注册' AS code,
       substr(e.registe_date,1,10) AS extractday,
       f.manager_name as manager_name,
       f.mall_name as mall_name,
       count(DISTINCT e.mbl_no) AS mbl_num,
	   0 as num_1
FROM warehouse_atomic_user_info e
JOIN
  (SELECT a.manager_name,
          b.mall_name,
          b.mall_name_en,
          b.create_date AS mall_cre_time,
          b.mall_code
   FROM newframe_sys_manager a --商户
LEFT JOIN warehouse_all_platform_mall_info b ON b.mall_code=a.belong_code--商城

   WHERE (a.manager_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行','新华恒升快易贷')
   or b.mall_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行','新华恒升快易贷'))) f
  ON e.app_code=f.mall_code
where e.registe_date >= date_sub(current_date(),1)
GROUP BY substr(e.registe_date,1,10),
         f.manager_name,
         f.mall_name


--3、累计注册量
  SELECT  f.manager_name,
       f.mall_name,
       count(DISTINCT e.mbl_no) AS reg_num
FROM warehouse_atomic_user_info e
JOIN
  (SELECT a.manager_name,
          b.mall_name,
          b.mall_name_en,
          b.create_date AS mall_cre_time,
          b.mall_code
   FROM newframe_sys_manager a --商户
LEFT JOIN warehouse_all_platform_mall_info b ON b.mall_code=a.belong_code--商城

   WHERE (a.manager_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行','新华恒升快易贷')
   or b.mall_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行','新华恒升快易贷'))) f
  ON e.app_code=f.mall_code
GROUP BY  f.manager_name,
         f.mall_name
ORDER BY  f.manager_name,
         f.mall_name
		 

--4、累计实名人数 

SELECT f.manager_name,
       f.mall_name,
       count(DISTINCT e.mbl_no) AS reg_num
FROM warehouse_atomic_user_info e
JOIN
  (SELECT a.manager_name,
          b.mall_name,
          b.mall_name_en,
          b.create_date AS mall_cre_time,
          b.mall_code
   FROM newframe_sys_manager a --商户
LEFT JOIN warehouse_all_platform_mall_info b ON b.mall_code=a.belong_code--商城

   WHERE (a.manager_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行','新华恒升快易贷')
   or b.mall_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行','新华恒升快易贷'))) f
  ON e.app_code=f.mall_code
WHERE e.authentication_date IS NOT NULL
  AND length(e.authentication_date)<>0
  AND e.authentication_date<>'NULL'
GROUP BY f.manager_name,
         f.mall_name
ORDER BY f.manager_name,
         f.mall_name
		 

---累计订单
SELECT '订单' as code,
       a4.manager_name,
       a4.mall_name,
       count(DISTINCT a1.mobile) as mbl_num,
	   count(DISTINCT a1.order_code) as num_1
	   
FROM warehouse_credit_core_order a1
JOIN(SELECT a.manager_name,
            b.mall_name,
            b.mall_name_en,
            b.create_date AS mall_cre_time,
            b.mall_code
     FROM newframe_sys_manager a --商户
     LEFT JOIN warehouse_all_platform_mall_info b --商城
            ON a.belong_code = b.mall_code
     WHERE (a.manager_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行','新华恒升快易贷')
     or b.mall_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行','新华恒升快易贷'))) a4
     ON a1.mall_code = a4.mall_code

GROUP BY a4.manager_name,
         a4.mall_name


---目前已开通电子商城的银行的产品/商品情况
SELECT a.contact_name,
       a.mall_name,
       c.product_name,
       d.shop_name,
       e.goods_name
FROM warehouse_all_platform_mall_info a  --商城
LEFT JOIN
  (SELECT b.mall_code,
          b.prod_id
   FROM warehouse_newframe_product_mcc_inf b --商城产品
   WHERE b.state=1) b --正常
ON b.mall_code = a.mall_code
LEFT JOIN warehouse_newframe_all_product_info c ON b.prod_id=c.product_code
LEFT JOIN newframe_shop_info d ON a.mall_code=d.origin_mall_code--店铺
LEFT JOIN warehouse_jry_goods_info e ON e.store_code=d.shop_code--商品
WHERE (a.contact_name like '%银行%' or a.mall_name in ('交子普惠'))  
  and a.mall_name not in ('享宇银行' , '番茄银行');		 
)
  
(★商城使用情况★
开通银行7家：豫丰、鹿泉、宣化、万全、围场、交子、新华恒升
配置产品5家：鹿泉、宣化、围场、交子、新华恒升
开通店铺5家：鹿泉、宣化、万全、围场、交子
在店铺上架商品2家：宣化、交子

--商城使用情况
select code,
       date_sub(current_date(),1) as extractday,
       contact_name as bank_name,
	   mall_name,
	   case when num = 1 then '是' 
	        else '否' 
	   end as status
from 
(
--1.开通商城的银行
SELECT '开通商城' as code,
       a.contact_name,
       a.mall_name,
       count(distinct case when (length(a.mall_name)<>0) then a.mall_name end) as num
       
FROM warehouse_all_platform_mall_info a  --商城
WHERE (a.contact_name like '%银行%' or a.mall_name in ('交子普惠'))  
  and a.mall_name not in ('享宇银行' , '番茄银行')	
GROUP BY a.contact_name,a.mall_name

union all
--2.配置产品的银行
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
GROUP BY a.contact_name,a.mall_name

union all
--3.开通店铺的银行
SELECT '开通店铺' as code,
       a.contact_name,
       a.mall_name,
	   count(distinct case when (length(d.shop_name)<>0 
	                             and d.shop_name is not null) then a.contact_name end) as num
	   
FROM warehouse_all_platform_mall_info a  --商城

LEFT JOIN newframe_shop_info d ON a.mall_code=d.origin_mall_code--店铺
WHERE (a.contact_name like '%银行%' or a.mall_name in ('交子普惠'))  
  and a.mall_name not in ('享宇银行' , '番茄银行')
GROUP BY a.contact_name,a.mall_name

union all
--4.在店铺上架商品的银行
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
GROUP BY a.contact_name,a.mall_name
) a


)