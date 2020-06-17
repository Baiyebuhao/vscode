---产品渠道推送(新用户）
select '推送' as code,
       a1.platform as data_source,
       a1.phone_number as x_mbl_no,
	   a1.extractday,
	   a1.mall_code,     ---商城
	   a2.mall_name,     ---商城名
	   a1.channel_code,  --渠道号
	   a3.promoter_name, --渠道名称
       a3.promoter_type, --渠道类型
       '' as xy_order_no,
       a1.goods_id as product_no,    --产品编号
	   a4.goods_name,    ---产品名
	   '' as status,     ---授信状态
	   '' as amount      ---授信金额 

from
(select distinct a.start_id,
                  a.mallcode as mall_code,
                  a.platform,
				  b.channel as channel_code,
				  a.goods_id as goods_id,
				  a.phone_number,
				  a.extractday
 from warehouse_atomic_newframe_burypoint_buttonoperations a
 
 left join (select distinct start_id,
				  channel
           from default.warehouse_atomic_newframe_burypoint_baseoperations)b                            --基础
       on a.start_id = b.start_id
 where a.click_name = 'order_promptly'
   and substr(a.extractday,1,10)>= date_sub(current_date(),40)) a1
 
left join(select mall_code,
                 mall_name 
          from  warehouse_all_platform_mall_info a) a2
       on a1.mall_code = a2.mall_code

LEFT JOIN
   (SELECT a.promoter_code,
           a.promoter_name, --渠道名称
           a.promoter_type, --渠道类型
		   b.mall_code
    FROM warehouse_jry_business_promoter a --渠道
    LEFT JOIN warehouse_all_platform_mall_info b   --商城
           ON a.general_code = b.mall_code) a3
		      
       ON a1.channel_code = a3.promoter_code   --渠道号
      AND a1.mall_code=a3.mall_code       --商城号

left join (SELECT distinct id, 
                  goods_name
                  from warehouse_jry_goods_info a
           where product_id is not null) a4                           --产品
  on a1.goods_id = a4.id
  
join warehouse_atomic_user_info a5
 on a5.mbl_no = a1.phone_number
 and a5.chan_no = a1.channel_code
 and a5.app_code=a1.mall_code

where a1.channel_code is not null
  and substring(a5.registe_date,1,10) = substring(a1.extractday,1,10)



