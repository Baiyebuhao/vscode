--电子商城BI

(--银行数 （银行明细）
select distinct a.manager_name,
       a.mall_name,
       a.mall_name_en,
       b.opt_type,
       substr(a.mall_cre_time,1,10) as mall_cre_time
from 
(SELECT a.manager_code,
       a.manager_name,
       a.account,
       b.mall_name,
       b.mall_name_en,
       b.create_date AS mall_cre_time,
       b.contact_name

FROM newframe_sys_manager a --商户
LEFT JOIN warehouse_all_platform_mall_info b ON b.mall_code=a.belong_code--商城
WHERE (a.manager_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行')
   or b.mall_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行'))
  and b.mall_name not in ('享宇银行' , '番茄银行') ) a
left join warehouse_newframe_opt_log b
on a.manager_code = b.opt_code
)

(--活跃
--1、活跃用户量
select '活跃' AS code,
       a1.extractday,
       a3.platform as mall_name,
       --a1.pagenamecn as page_name,
       --a1.click_name,
	   count(distinct a1.phone_number) as djrs,
	   count(a1.cus_no) as djcs
from default.warehouse_atomic_newframe_burypoint_buttonoperations a1   ---按钮
join (select distinct start_id,platform
      from default.warehouse_atomic_newframe_burypoint_baseoperations     
      where platform in ('交子普惠','宣化家银'))a3                                      --基础
  on a1.start_id = a3.start_id
where length(a1.phone_number)<>0
group by a1.extractday,
         a3.platform
)

(--注册
--2、注册量 
 SELECT '注册' AS code,
       substr(e.registe_date,1,10) AS extractday,
       f.manager_name,
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

   WHERE (a.manager_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行')
   or b.mall_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行'))) f
  ON e.app_code=f.mall_code
GROUP BY substr(e.registe_date,1,10),
         f.manager_name,
         f.mall_name
ORDER BY dt,
         f.manager_name,
         f.mall_name
)
(--3、累计注册量
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

   WHERE (a.manager_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行')
   or b.mall_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行'))) f
  ON e.app_code=f.mall_code
GROUP BY  f.manager_name,
         f.mall_name
ORDER BY  f.manager_name,
         f.mall_name
)

(--实名
--累计实名人数 

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

   WHERE (a.manager_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行')
   or b.mall_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行'))) f
  ON e.app_code=f.mall_code
WHERE e.authentication_date IS NOT NULL
  AND length(e.authentication_date)<>0
  AND e.authentication_date<>'NULL'
GROUP BY f.manager_name,
         f.mall_name
ORDER BY f.manager_name,
         f.mall_name
)

(--订单数及下单人数 
--订单数及下单人数 
SELECT substr(a1.create_date,1,7) AS dt,
       a4.manager_name,
       a4.mall_name,
       a1.goods_name,
       a2.status_code,
	   a2.status_name,
       count(DISTINCT a1.order_code) as order_num,
       count(DISTINCT a1.mobile) as mbl_num
FROM warehouse_credit_core_order a1
left join (select a.*,b.status_name 
           from warehouse_credit_apply_info a
		   left join warehouse_credit_order_status_dict b
		          on a.status_code = b.status_code) a2   ---申请授信
       on a1.order_code = a2.order_code
JOIN
  (SELECT a.manager_name,
          b.mall_name,
          b.mall_name_en,
          b.create_date AS mall_cre_time,
          b.mall_code
   FROM newframe_sys_manager a --商户
   LEFT JOIN warehouse_all_platform_mall_info b --商城
          ON a.belong_code = b.mall_code
   WHERE (a.manager_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行')
   or b.mall_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行'))) a4
   ON a1.mall_code = a4.mall_code

GROUP BY substr(a1.create_date,1,7),
         a4.manager_name,
         a4.mall_name,
         a1.goods_name,
         a2.status_code,
		 a2.status_name
ORDER BY dt,
         a4.manager_name,
         a4.mall_name,
         a1.goods_name,
         a1.goods_name,
         a2.status_code,
		 a2.status_name
)

