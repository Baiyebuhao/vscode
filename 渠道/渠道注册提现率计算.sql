--渠道注册提现率计算
select count(DISTINCT CASE
                          WHEN code='注册' THEN mbl_no
                      END) AS regnum,
	   count(DISTINCT CASE
                          WHEN code='总提现' THEN mbl_no
                      END) AS ztx,
	   count(DISTINCT CASE
                          WHEN code='新提现' THEN mbl_no
                      END) AS xtx
from
(------新注册用户
select '注册' AS code,
       a.mbl_no
from warehouse_atomic_user_info a   
     left join warehouse_data_chan_info b 
         on a.data_source = b.data_source 
         and a.chan_no = b.chan_no 
         and a.child_chan = b.child_chan
where a.registe_date between '2020-02-24' and '2020-03-01'                  ---------选择注册时间维度
  and a.data_source in ('sjd','xyqb')
UNION ALL
select '注册' AS code,
       a.mbl_no
from warehouse_atomic_time_user a
     left join warehouse_jry_business_promoter b 
         on a.chan_no = b.promoter_code
where substring(a.registe_date,1,10) between '2020-02-24' and '2020-03-01'                  ---------选择注册时间维度
  and a.data_source in ('jry','bhd')


UNION ALL
----------用户提现
select '总提现' AS code,
       a.mbl_no
from warehouse_atomic_user_info a   
     left join warehouse_data_chan_info b 
         on a.data_source = b.data_source 
        and a.chan_no = b.chan_no 
        and a.child_chan = b.child_chan        
     left join warehouse_data_user_withdrawals_info c
         on a.mbl_no = c.mbl_no 
        and a.data_source = c.data_source
where a.data_source in ('sjd','xyqb')
  and c.cash_time between '2020-02-24' and '2020-03-01'                ---------选择提现时间维度
  and c.cash_amount > 0
UNION ALL
select '总提现' AS code,
       a.mbl_no
from warehouse_atomic_time_user a   
     left join warehouse_jry_business_promoter b 
         on a.chan_no = b.promoter_code       
     left join warehouse_data_user_withdrawals_info c
         on a.mbl_no = c.mbl_no 
        and a.data_source = c.data_source
where a.data_source in ('jry','bhd')
  and c.cash_time between '2020-02-24' and '2020-03-01'                ---------选择提现时间维度
  and c.cash_amount > 0
  
UNION ALL  
---------新注册用户提现
select '新提现' AS code,
       a.mbl_no
from warehouse_atomic_user_info a   
     left join warehouse_data_chan_info b 
         on a.data_source = b.data_source 
        and a.chan_no = b.chan_no 
        and a.child_chan = b.child_chan        
     left join warehouse_data_user_withdrawals_info c
         on a.mbl_no = c.mbl_no 
        and a.data_source = c.data_source
where a.registe_date between '2020-02-24' and '2020-03-01'              ---------选择注册时间维度
  and a.data_source in ('sjd','xyqb')
  and c.cash_time between '2020-02-24' and '2020-03-01'                ---------选择提现时间维度
  and c.cash_amount > 0

UNION ALL
select '新提现' AS code,
       a.mbl_no
from warehouse_atomic_time_user a   
     left join warehouse_jry_business_promoter b 
         on a.chan_no = b.promoter_code       
     left join warehouse_data_user_withdrawals_info c
         on a.mbl_no = c.mbl_no 
        and a.data_source = c.data_source
where substring(a.registe_date,1,10) between '2020-02-24' and '2020-03-01'              ---------选择注册时间维度
  and a.data_source in ('jry','bhd')
  and c.cash_time between '2020-02-24' and '2020-03-01'                ---------选择提现时间维度
  and c.cash_amount > 0
) a
