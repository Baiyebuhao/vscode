---渠道总用户(新版)('2020-06-01' and '2020-06-31'暂时)(BI重构）（2020-08-03更新）
SELECT data_source,
       the_2nd_level,
       the_3rd_level,
       chan_no,
       child_chan,
       count(DISTINCT CASE
                          WHEN code='注册' THEN mbl_no
                      END) AS regnum,
       count(DISTINCT CASE
                          WHEN code='申请' THEN mbl_no
                      END) AS apllynum,
       count(DISTINCT CASE
                          WHEN code='授信' THEN mbl_no
                      END) AS creditnum,
       count(DISTINCT CASE
                          WHEN code='提现' THEN mbl_no
                      END) AS cashnum,
       sum(credit_amount) AS credit_amount,
       sum(cash_amount) AS cash_amount
from
(
--------用户注册
select '注册' AS code,
       a.data_source,
       a.registe_date AS extractday,
       b.the_2nd_level,
       b.the_3rd_level,
       a.chan_no,
       a.child_chan,
       a.mbl_no,
	   '0' as product_name,
	   0 as credit_amount,
	   0 as cash_amount
from warehouse_atomic_user_info a   
     left join warehouse_data_chan_info b 
         on a.data_source = b.data_source 
         and a.chan_no = b.chan_no 
         and a.child_chan = b.child_chan
where a.registe_date between '2020-06-01' and '2020-06-31'                   ---------选择注册时间维度
  and a.data_source in ('xyqb')
UNION ALL
select '注册' AS code,
       a.data_source,
       a.registe_date AS extractday,
       'null' as the_2nd_level,
       b.promoter_name as the_3rd_level,
       a.chan_no,
       a.child_chan,
       a.mbl_no,
	   '0' as product_name,
	   0 as credit_amount,
	   0 as cash_amount
from warehouse_atomic_time_user a

LEFT JOIN
   (SELECT * 
    FROM warehouse_jry_business_promoter x --渠道
    LEFT JOIN warehouse_all_platform_mall_info y   --商城
           ON x.general_code = y.mall_code) b
		   
     ON a.chan_no = b.promoter_code   --渠道号
     AND a.app_code=b.mall_code       --商城号

where substring(a.registe_date,1,10) between '2020-06-01' and '2020-06-31'                  ---------选择注册时间维度
  and a.data_source in ('sjd','jry','bhd')

UNION ALL
--------用户申请
select '申请' AS code,
       a.data_source,
       c.apply_time AS extractday,
       b.the_2nd_level,
       b.the_3rd_level,
       a.chan_no,
       a.child_chan,
       a.mbl_no,
	   c.product_name,
	   0 as credit_amount,
	   0 as cash_amount
from warehouse_atomic_user_info a   
     left join warehouse_data_chan_info b 
         on a.data_source = b.data_source 
        and a.chan_no = b.chan_no 
        and a.child_chan = b.child_chan
     left join warehouse_data_user_review_info c
         on a.mbl_no = c.mbl_no 
        and a.data_source = c.data_source
where a.data_source in ('xyqb')
  and c.apply_time between '2020-06-01' and '2020-06-31'                 ---------选择申请时间维度
  and c.product_name in ('信用钱包','任性贷')
UNION ALL
select '申请' AS code,
       a.data_source,
       c.apply_time AS extractday,
       'null' as the_2nd_level,
       b.promoter_name as the_3rd_level,
       a.chan_no,
       a.child_chan,
       a.mbl_no,
	   c.product_name,
	   0 as credit_amount,
	   0 as cash_amount
from warehouse_atomic_time_user a   
LEFT JOIN
   (SELECT * 
    FROM warehouse_jry_business_promoter x --渠道
    LEFT JOIN warehouse_all_platform_mall_info y   --商城
           ON x.general_code = y.mall_code) b   
      ON a.chan_no = b.promoter_code   --渠道号
     AND a.app_code=b.mall_code       --商城号

left join warehouse_data_user_review_info c
       on a.mbl_no = c.mbl_no 
      and a.data_source = c.data_source
where a.data_source in ('sjd','jry','bhd')
  and c.apply_time between '2020-06-01' and '2020-06-31'                  ---------选择申请时间维度
  and c.product_name in ('信用钱包','任性贷')
UNION ALL
--------用户授信
select '授信' AS code,
       a.data_source,
       c.credit_time AS extractday,
       b.the_2nd_level,
       b.the_3rd_level,
       a.chan_no,
       a.child_chan,
       a.mbl_no,
	   c.product_name,
	   c.amount as credit_amount,
	   0 as cash_amount
from warehouse_atomic_user_info a   
     left join warehouse_data_chan_info b 
         on a.data_source = b.data_source 
        and a.chan_no = b.chan_no 
        and a.child_chan = b.child_chan
     left join warehouse_data_user_review_info c
         on a.mbl_no = c.mbl_no 
        and a.data_source = c.data_source
where a.data_source in ('xyqb')
  and c.credit_time between '2020-06-01' and '2020-06-31'                 ---------选择授信时间维度
  and c.status = '通过'
  and c.product_name in ('信用钱包','任性贷')

UNION ALL
select '授信' AS code,
       a.data_source,
       c.credit_time AS extractday,
       'null' as the_2nd_level,
       b.promoter_name as the_3rd_level,
       a.chan_no,
       a.child_chan,
       a.mbl_no,
	   c.product_name,
	   c.amount as credit_amount,
	   0 as cash_amount
from warehouse_atomic_time_user a   
LEFT JOIN
   (SELECT * 
    FROM warehouse_jry_business_promoter x --渠道
    LEFT JOIN warehouse_all_platform_mall_info y   --商城
           ON x.general_code = y.mall_code) b   
      ON a.chan_no = b.promoter_code   --渠道号
     AND a.app_code=b.mall_code       --商城号
	 
left join warehouse_data_user_review_info c
       on a.mbl_no = c.mbl_no 
      and a.data_source = c.data_source
where a.data_source in ('sjd','jry','bhd')
  and c.credit_time between '2020-06-01' and '2020-06-31'                 ---------选择授信时间维度
  and c.status = '通过'
  and c.product_name in ('信用钱包','任性贷')

UNION ALL
----------用户提现
select '提现' AS code,
       a.data_source,
       c.cash_time AS extractday,
       b.the_2nd_level,
       b.the_3rd_level,
       a.chan_no,
       a.child_chan,
       a.mbl_no,
	   c.product_name,
	   0 as credit_amount,
	   c.cash_amount as cash_amount
from warehouse_atomic_user_info a   
     left join warehouse_data_chan_info b 
         on a.data_source = b.data_source 
        and a.chan_no = b.chan_no 
        and a.child_chan = b.child_chan        
     left join warehouse_data_user_withdrawals_info c
         on a.mbl_no = c.mbl_no 
        and a.data_source = c.data_source
where a.data_source in ('xyqb')
  and c.cash_time between '2020-06-01' and '2020-06-31'                 ---------选择提现时间维度
  and c.cash_amount > 0
  and c.product_name in ('信用钱包','任性贷')

UNION ALL
select '提现' AS code,
       a.data_source,
       c.cash_time AS extractday,
       'null' as the_2nd_level,
       b.promoter_name as the_3rd_level,
       a.chan_no,
       a.child_chan,
       a.mbl_no,
	   c.product_name,
	   0 as credit_amount,
	   c.cash_amount as cash_amount
from warehouse_atomic_time_user a   
LEFT JOIN
   (SELECT * 
    FROM warehouse_jry_business_promoter x --渠道
    LEFT JOIN warehouse_all_platform_mall_info y   --商城
           ON x.general_code = y.mall_code) b   
      ON a.chan_no = b.promoter_code   --渠道号
     AND a.app_code=b.mall_code       --商城号
	      
left join warehouse_data_user_withdrawals_info c
       on a.mbl_no = c.mbl_no 
      and a.data_source = c.data_source
where a.data_source in ('sjd','jry','bhd')
  and c.cash_time between '2020-06-01' and '2020-06-31'                 ---------选择提现时间维度
  and c.cash_amount > 0
  and c.product_name in ('信用钱包','任性贷')
) as a1
group by data_source,
       the_2nd_level,
       the_3rd_level,
       chan_no,
       child_chan