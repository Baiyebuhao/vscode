2020年1月10日至今，金融苑电子商城分销系统，广元市旭华商贸有限责任公司代理下，金融苑注册数据、信用钱包、任性贷申请、授信、提现数据

有一个电子商城的需求，谁来处理


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
   ) f
  ON e.app_code=f.mall_code
GROUP BY substr(e.registe_date,1,10),
         f.manager_name,
         f.mall_name
		 
		 


1.分销商
2.分销员
3.分销订单 distribution_order

select a1.mobile,
       a1.promote_sales_code,
	   a2.user_account,
	   a2.goods_name,
	   a3.distributor_account,
	   a3.distributor_name,
	   a3.distributor_merchant_id,
	   a4.distributor_name,
	   a4.mall_code,
	   a4.mall_name
from original_all_platform_user_info a1                                  ---用户表
join warehouse_atomic_distribut_distribution_order a2                    ---订单表
  on a1.promote_sales_code = a2.promote_sales_code           ---推广码关联
  
join warehouse_atomic_distribut_distributor_staff_info a3                ---分销员
  on a2.mall_code = a3.mall_code
 and a2.user_account = a3.distributor_account
left join warehouse_atomic_distribut_distributor_merchant_info a4        ---分销商
  on a3.distributor_merchant_id = a4.id                      ---分销商id 关联
 


 
select *
from warehouse_atomic_distribut_distribution_order a2
join warehouse_atomic_distribut_distributor_staff_info a3                ---分销员
  on a2.mall_code = a3.mall_code
 and a2.user_account = a3.distributor_account
join warehouse_atomic_distribut_distributor_merchant_info a4        ---分销商
  on a3.distributor_merchant_id = a4.id