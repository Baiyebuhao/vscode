between '2018-04-27' and '2018-05-23' 
between '2018-05-23' and '2018-06-05' 
between '2018-06-28' and '2018-07-17' 
between '2018-08-10' and '2018-08-27' 
between '2018-09-29' and '2018-10-14' 
between '2018-11-05' and '2018-11-16' 



(

select data_source,
       count(distinct mbl_no)
from warehouse_atomic_msd_withdrawals_result_info
     where substring(msd_return_time,1,10) between '2018-04-27' and '2018-05-23' 
	 and total_num > 0
     and mbl_no in
	   (select distinct a.mbl_no 
	   from warehouse_atomic_msd_withdrawals_result_info a
	   where substring(a.msd_return_time,1,10) < '2018-04-27'
	   and total_num > 0) 	  
group by data_source

)

(

select data_source,
       count(distinct mbl_no)
from warehouse_atomic_msd_withdrawals_result_info
     where substring(msd_return_time,1,10) between '2018-04-27' and '2018-05-23' 
	 and total_num > 0
     and mbl_no not in
	   (select distinct a.mbl_no 
	   from warehouse_atomic_msd_withdrawals_result_info a
	   where substring(a.msd_return_time,1,10) < '2018-04-27'
	   and total_num > 0) 	  
group by data_source

)