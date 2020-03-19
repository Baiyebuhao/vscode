--电子商城BI_2
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
WHERE (a.manager_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行','新华恒升快易贷')
   or b.mall_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行','新华恒升快易贷'))
  and b.mall_name not in ('享宇银行' , '番茄银行') ) a
left join warehouse_newframe_opt_log b
on a.manager_code = b.opt_code
)

(
--1、活跃用户量
select '活跃' AS code,
       a1.extractday as extractday,
	   '' as manager_name,
       a3.platform as mall_name,
	   count(distinct case when (length(a1.phone_number)<>0) then a1.phone_number end) as mbl_num,
	   count(distinct case when (length(a3.ip)<>0) then a3.ip end) as num_1
from default.warehouse_atomic_newframe_burypoint_buttonoperations a1   ---按钮
join (select distinct start_id,platform,ip
      from default.warehouse_atomic_newframe_burypoint_baseoperations     
      where platform in ('交子普惠','宣化家银'))a3                                      --基础
  on a1.start_id = a3.start_id
group by a1.extractday,
         a3.platform
		 
union all
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

   WHERE (a.manager_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行')
   or b.mall_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行'))) f
  ON e.app_code=f.mall_code
GROUP BY substr(e.registe_date,1,10),
         f.manager_name,
         f.mall_name
		 
union all
--3.实名数
SELECT '实名' as code,
       substr(e.authentication_date,1,10) AS extractday,
       f.manager_name,
       f.mall_name,
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

   WHERE (a.manager_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行')
   or b.mall_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行'))) f
  ON e.app_code=f.mall_code
WHERE e.authentication_date IS NOT NULL
  AND length(e.authentication_date)<>0
  AND e.authentication_date<>'NULL'
GROUP BY substr(e.authentication_date,1,10),
         f.manager_name,
         f.mall_name
		 
union all
--订单数及下单人数 
SELECT '订单' as code,
       substr(a1.create_date,1,10) AS extractday,
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
     WHERE (a.manager_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行')
     or b.mall_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行'))) a4
     ON a1.mall_code = a4.mall_code

GROUP BY substr(a1.create_date,1,10),
         a4.manager_name,
         a4.mall_name
union all
--累计活跃数
select '累计活跃' AS code,
       '' as extractday,
	   '' as manager_name,
       a3.platform as mall_name,
	   count(distinct case when (length(a1.phone_number)<>0) and a1.phone_number is NOT NULL then a1.phone_number end) as mbl_num,
	   count(distinct case when (length(a3.ip)<>0) and a3.ip is NOT NULL then a3.ip end) as num_1
from default.warehouse_atomic_newframe_burypoint_buttonoperations a1   ---按钮
join (select distinct start_id,platform,ip
      from default.warehouse_atomic_newframe_burypoint_baseoperations     
      where platform in ('交子普惠','宣化家银'))a3                                      --基础
  on a1.start_id = a3.start_id
group by a3.platform

union all
--累计注册量 
 SELECT '累计注册' AS code,
       '' AS extractday,
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

   WHERE (a.manager_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行')
   or b.mall_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行'))) f
  ON e.app_code=f.mall_code
GROUP BY f.manager_name,
         f.mall_name
union all
--累计实名数
SELECT '累计实名' as code,
       '' AS extractday,
       f.manager_name,
       f.mall_name,
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

   WHERE (a.manager_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行')
   or b.mall_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行'))) f
  ON e.app_code=f.mall_code
WHERE e.authentication_date IS NOT NULL
  AND length(e.authentication_date)<>0
  AND e.authentication_date<>'NULL'
GROUP BY f.manager_name,
         f.mall_name

union all
--订单数及下单人数 
SELECT '累计订单' as code,
       '' AS extractday,
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
     WHERE (a.manager_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行')
     or b.mall_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行'))) a4
     ON a1.mall_code = a4.mall_code

GROUP BY a4.manager_name,
         a4.mall_name
)
