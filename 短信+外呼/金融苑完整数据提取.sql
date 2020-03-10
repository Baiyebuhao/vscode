--金融苑完整数据提取 
--用户表 warehouse_atomic_time_user
--渠道表 warehouse_jry_business_promoter
select '注册' AS code,
       a.data_source,
       a.registe_date AS extractday,
       'null' as the_2nd_level,
       b.promoter_name as the_3rd_level,
       a.chan_no,
       a.child_chan,
       a.mbl_no,
	   0 as product_name,
	   0 as credit_amount,
	   0 as cash_amount
from warehouse_atomic_time_user a
     left join warehouse_jry_business_promoter b 
         on a.chan_no = b.promoter_code
where substring(a.registe_date,1,10) between '2019-09-30' and '2019-10-06'                  ---------选择注册时间维度
  and a.data_source = 'jry'



