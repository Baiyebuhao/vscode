---对账数据提取
---马上
select contact_no,msd_return_time,data_source,product_name,sum(total_amount)/100 
from warehouse_atomic_msd_withdrawals_result_info a
where msd_return_time between '2019-09-01' and '2019-09-30'
  and total_amount > 0
group by contact_no,msd_return_time,data_source,product_name