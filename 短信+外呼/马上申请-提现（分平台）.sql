申请（分平台）
select data_source,min_date,count(mbl_no) as num
from (select mbl_no,data_source,min(substring(appl_time,1,10)) as min_date
	from warehouse_atomic_msd_review_result_info
	group by mbl_no,data_source ) a

where substring(min_date,1,10) between '2018-08-22' and '2018-08-28'    
group by data_source,min_date  



授信（分平台）
select data_source,min_date, count(mbl_no) as num
from (select mbl_no,data_source,min(substring(appl_time,1,10)) as min_date
	from warehouse_atomic_msd_review_result_info
	where appral_res = '通过'
	group by mbl_no,data_source ) a

where substring(min_date,1,10) between '2018-08-22' and '2018-08-28'    
group by data_source,min_date  

提现（分平台）
select a.data_source,a.min_date,count(a.mbl_no),sum(c.total_amount)
from warehouse_atomic_msd_withdrawals_result_info c,
     (select mbl_no,data_source,min(substring(appl_time,1,10)) as min_date
	from warehouse_atomic_msd_review_result_info
	where appral_res = '通过'
	group by mbl_no,data_source ) a
    where a.mbl_no = c.mbl_no
    and substring(min_date,1,10) between '2018-08-22' and '2018-08-28'  
group by a.data_source,a.min_date