
一、需求

金融电子商城暂时需要以下数据 ：

【xx银行】xx日：
1、点击量--不知道取哪个表，现有埋点表？
2、注册量--user_info，如何关联到银行
3、累计注册量
4、累计实名人数--user_auth，如何关联到银行
5、累计贷款申请人数--credit_apply_info，如何关联到银行


二、取数逻辑确认

电子商城流程：
 
 1.管理员为银行开通电子商城账号 
   产生银行账号信息sys_manager
   产生商城信息mall_info（sys_manager.belong_code=mall_info.mall_code ）
   
 2.商城管理员登录账号在店铺管理中新增店铺完成店铺开通:
   产生店铺信息shop_info（与商城关联：shop_info.origin_mall_code=mall_info.mall_code）
   
 3.银行在商店上信贷产品：
   产生商品信息goods_info（与商店关联：goods_info.store_code=shop_info.shop_code)? 
   
 4.用户注册
   产生用户信息user_info（与商城关联：user_info.app_code=mall_info.mall_code）

 5.用户下单   
   产生订单信息credit_core_order（与商店关联credit_core_order.store_code=shop_info.shop_code，
                                  与商城关联credit_core_order.mall_code=mall_info.mall_code） 
 
 
三、数仓同步：
 
 
 sys_manager(newframe_sys_manager)
 mall_info（warehouse_all_platform_mall_info），不能用warehouse_jry_mall_info，此表只包含金融苑数据
 shop_info(newframe_shop_info)
 goods_info(warehouse_jry_goods_info)--由于此前新架构只包括金融苑，此表之前已入到数仓命名为jry，未来将修改表名
 user_info（warehouse_atomic_user_info），不能用original_jry_user_info，此表只包含金融苑数据
 credit_core_order（ warehouse_credit_core_order）
 
 
 
四、sql   （商务反馈目前试用银行包括：抚宁，万全，宣化，豫丰，鹿泉）
 
 
 目前已开通电子商城的银行：
 
SELECT a.manager_name,
       b.mall_name,
       b.mall_name_en,
       b.create_date AS mall_cre_time,
       b.contact_name,
       c.shop_name,
       d.goods_name
FROM newframe_sys_manager a --商户
LEFT JOIN warehouse_all_platform_mall_info b ON b.mall_code=a.belong_code--商城
LEFT JOIN newframe_shop_info c ON b.mall_code=c.origin_mall_code--店铺
LEFT JOIN warehouse_jry_goods_info d ON d.store_code=c.shop_code--商品
WHERE (a.manager_name LIKE '%银行%' or b.mall_name like '%银行%')
and  b.mall_name not in ('享宇银行' , '番茄银行');


 
 1、活跃用户量

 
 2、注册量 
 SELECT substr(e.registe_date,1,10) AS dt,
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

   WHERE (a.manager_name LIKE '%银行%' or b.mall_name like '%银行%')) f ON e.app_code=f.mall_code
GROUP BY substr(e.registe_date,1,10),
         f.manager_name,
         f.mall_name
ORDER BY dt,
         f.manager_name,
         f.mall_name
 
 
 3、累计注册量
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

   WHERE (a.manager_name LIKE '%银行%' or b.mall_name like '%银行%')) f ON e.app_code=f.mall_code
GROUP BY  f.manager_name,
         f.mall_name
ORDER BY  f.manager_name,
         f.mall_name
 
 4、累计实名人数 

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

   WHERE (a.manager_name LIKE '%银行%' or b.mall_name like '%银行%')) f ON e.app_code=f.mall_code
WHERE e.authentication_date IS NOT NULL
  AND length(e.authentication_date)<>0
  AND e.authentication_date<>'NULL'
GROUP BY f.manager_name,
         f.mall_name
ORDER BY f.manager_name,
         f.mall_name
 
 5、订单数及下单人数 

SELECT substr(d.etl_time,1,7) AS dt,
       d.goods_name,
       count(DISTINCT d.order_code) as order_num,
       count(DISTINCT d.mobile) as mbl_num
FROM warehouse_credit_core_order d
JOIN
  (SELECT a.manager_name,
          b.mall_name,
          b.mall_name_en,
          b.create_date AS mall_cre_time,
          b.mall_code
   FROM newframe_sys_manager a --商户
   LEFT JOIN warehouse_all_platform_mall_info b --商城
          ON a.belong_code = b.mall_code
   WHERE (a.manager_name LIKE '%银行%' or b.mall_name like '%银行%')) c 
   ON d.mall_code=c.mall_code

GROUP BY substr(d.etl_time,1,7),
         d.goods_name
ORDER BY dt,
         d.goods_name
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
--merchant_info 商户信息表 
--merchant_approval_info 商户审批资料   
--product_info 产品接入表
--product_mcc_inf
--core_order  订单基础信息
--credit_core_order  信贷订单
--credit_apply_info  授信申请记录
--loan_apply_info  放款提现申请记录
--statistics_register_record （统计表？JRY注册数量，环比？）
--shop_info 商店信息
--mall_info 商城信息  mall_info.mall_code=shop_info.origin_mall_code？
--user_account  用户账号信息表（含platform_code）
--user_auth  用户实名认证表
--user_info  用户基本信息表
--user_mobile  用户手机信息


