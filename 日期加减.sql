当前日期加减天，月，年
date(if(length(b.credit_time)>0,substr(b.credit_time,1,10))) + interval '1' day as credit_date
date(if(length(b.credit_time)>0,substr(b.credit_time,1,10))) + interval '1' month as credit_date
date(if(length(b.credit_time)>0,substr(b.credit_time,1,10))) + interval '1' year as credit_end_date


select msd_return_time,
date(substr(a.msd_return_time,1,10)) - interval '1' day as credit_date
from warehouse_atomic_msd_withdrawals_result_info a
limit 10