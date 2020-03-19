--分销（关联产品，取申请授信）（去重问题+关联问题）
1.不同产品订单号长短不一样（感觉没毛病），2.关联出多笔订单（一个用户多笔订单好像也没毛病）
select a1.id,                        --分销商id
       a1.distributor_name,          --分销商名称
	   a1.channel_number,            --分销商推广渠道号
	   a1.distributor_code,          --分销员（商）编码
	   a1.parent_name,               --父级名称（分销商）
	  
       a2.id,                         --分销员id
	   a2.distributor_name,           --分销员名称
	   a2.distributor_account,        --分销员账号（app账号）
	   a2.channel_number,             --分销员推广渠道号
	   a2.distributor_code,           --分销员编码
	   
	   a3.user_account,            --用户号码
       a3.promote_sales_code,      --推广码
	   a3.goods_id,                --商品ID
	   a3.goods_name,              --商品名称
	   a3.create_date as dd_date,    --订单日期
	   a3.mall_name,                 --商城名称
	   a3.order_code,                --订单号
	   a3.sub_order_code,            --子订单号
	   a3.order_type,                 --订单类型
	   
	   a4.data_source,               --平台
	   a4.apply_time,                   --申请时间
	   a4.credit_time,                  --授信时间
	   a4.product_name,                 --产品
	   a4.check_status,                 --授信状态
	   a4.amount                        --授信金额
	   
 
from warehouse_atomic_distribut_distribution_order a3  ---订单表

left join warehouse_atomic_distribut_distributor_staff_info a2  --分销员信息
       on a3.promote_sales_code = a2.channel_number     ---渠道推广码
    ---on a3.distributor_staff_id = a2.id               ---分销员ID关联 (两种方式） 
left join warehouse_atomic_distribut_distributor_merchant_info a1  ---分销商信息
       on a1.id= a2.distributor_merchant_id             --分销商id关联
	   
left join 
(--产品任性贷
SELECT mbl_no,                                          ---号码
       data_source,                                     ---平台
	   order_id,            ---订单号
	   apply_time,                                      ---申请时间
	   credit_time,                                     ---授信日期
	   product_name,                                    ---产品
	   CASE WHEN check_status ='0' THEN '授信中'
            WHEN check_status ='1' THEN '通过'
            WHEN check_status ='2' THEN '未通过'
            END check_status,                           ---授信状态 
       amount                                           ---授信金额
	   
	   
FROM
   (SELECT c.mbl_no,                                    ---号码
           b.prod_name as product_name,                 ---产品
		   e.id,                                        ---订单号（不是这个）
		   cast(e.platform_order_no as string) as order_id,    --平台订单号
           f.status AS check_status,                    ---授信状态  --- '授信状态 0 授信中，1授信成功，2授信失败',
		   substr(f.create_time,1,10) as apply_time,    ---申请时间
           substr(f.check_time,1,10) as credit_time,    ---授信日期
		   cast(f.check_amount as string) as amount,      ---订单金额
		   CASE
           WHEN c.platform_id=1 THEN 'sjd'
           WHEN c.platform_id=2 THEN 'jry'
           WHEN c.platform_id=4 THEN 'xyqb'
           END data_source                              ---平台
    FROM warehouse_atomic_api_p_user_prod_inf AS a
    JOIN warehouse_atomic_api_p_prod_inf AS b ON a.prod_id=b.id
    JOIN warehouse_atomic_api_p_user_info AS c ON a.user_id=c.id
    LEFT JOIN warehouse_atomic_api_p_order_inf AS e ON a.id=e.user_prod_id           --id   订单号
    LEFT JOIN warehouse_atomic_api_p_apply_record AS f ON e.id=f.order_id            --order_id 订单号
	) a1
WHERE a1.product_name = '任性贷'
  and apply_time IS NOT NULL
  
union all 
---产品信用钱包
SELECT mbl_no,                                                         --号码
       data_source,                                                    --平台
	   channelorderno as order_id,                                     --订单号
       substr(applytime,1,10) AS apply_time,                           --申请时间
       if(approvalamount>0,substr(applytime,1,10),NULL) credit_time,   --授信时间
       '信用钱包' AS product_name,                                     --产品
       if(approvalamount>0,'通过','未通过') AS check_status,           --授信状态
       if(approvalamount>0,approvalamount,0) AS amount                 --授信金额
   FROM default.warehouse_atomic_lhp_review_result_info
) a4
on a3.order_code = a4.order_id    --订单ID关联
  
where a1.distributor_name like '%旭华%' or a1.parent_name like '%旭华%'



left join 
(--产品任性贷
SELECT mbl_no,                                          ---号码
       data_source,                                     ---平台
	   order_id,            ---订单号
	   apply_time,                                      ---申请时间
	   credit_time,                                     ---授信日期
	   product_name,                                    ---产品
	   CASE WHEN check_status ='0' THEN '授信中'
            WHEN check_status ='1' THEN '通过'
            WHEN check_status ='2' THEN '未通过'
            END check_status,                           ---授信状态 
       amount                                           ---授信金额
	   
	   
FROM
   (SELECT c.mbl_no,                                    ---号码
           b.prod_name as product_name,                 ---产品
		   e.id,                                        ---订单号（不是这个）
		   cast(e.platform_order_no as string) as order_id,    --平台订单号
           f.status AS check_status,                    ---授信状态  --- '授信状态 0 授信中，1授信成功，2授信失败',
		   substr(f.create_time,1,10) as apply_time,    ---申请时间
           substr(f.check_time,1,10) as credit_time,    ---授信日期
		   cast(f.check_amount as string) as amount,      ---订单金额
		   CASE
           WHEN c.platform_id=1 THEN 'sjd'
           WHEN c.platform_id=2 THEN 'jry'
           WHEN c.platform_id=4 THEN 'xyqb'
           END data_source                              ---平台
    FROM warehouse_atomic_api_p_user_prod_inf AS a
    JOIN warehouse_atomic_api_p_prod_inf AS b ON a.prod_id=b.id
    JOIN warehouse_atomic_api_p_user_info AS c ON a.user_id=c.id
    LEFT JOIN warehouse_atomic_api_p_order_inf AS e ON a.id=e.user_prod_id           --id   订单号
    LEFT JOIN warehouse_atomic_api_p_apply_record AS f ON e.id=f.order_id            --order_id 订单号
	) a1
WHERE a1.product_name = '任性贷'
  and apply_time IS NOT NULL
  
union all 
---产品信用钱包
SELECT mbl_no,                                                         --号码
       data_source,                                                    --平台
	   channelorderno as order_id,                                     --订单号
       substr(applytime,1,10) AS apply_time,                           --申请时间
       if(approvalamount>0,substr(applytime,1,10),NULL) credit_time,   --授信时间
       '信用钱包' AS product_name,                                     --产品
       if(approvalamount>0,'通过','未通过') AS check_status,           --授信状态
       if(approvalamount>0,approvalamount,0) AS amount                 --授信金额
   FROM default.warehouse_atomic_lhp_review_result_info
) a4
on a3.order_code = a4.order_id    --订单ID关联
