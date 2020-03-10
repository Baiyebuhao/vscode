领取
select a.sys_type,
       count(distinct a.phone_number),
	   count(distinct b.mbl_no)
from warehouse_atomic_coupon_code a 
     left join warehouse_atomic_user_info b
     on a.phone_number=b.mbl_no
where a.coupon_type='2'
and substring(a.tm_smp,1,8) between '20180827' and '20180907'
group by a.sys_type

申请

select warehouse_atomic_msd_review_result_info.data_source,count(distinct warehouse_atomic_msd_review_result_info.mbl_no)
from warehouse_atomic_msd_review_result_info
where warehouse_atomic_msd_review_result_info.mbl_no in 
           (select distinct warehouse_atomic_coupon_code.phone_number
            from warehouse_atomic_coupon_code
            where warehouse_atomic_coupon_code.coupon_type='2'
            and substring(warehouse_atomic_coupon_code.tm_smp,1,8) between '20180827' and '20180907')
	and substring(warehouse_atomic_msd_review_result_info.appl_time,1,10) between '2018-08-27' and '2018-09-07'
group by warehouse_atomic_msd_review_result_info.data_source

通过
select warehouse_atomic_msd_review_result_info.data_source,count(distinct warehouse_atomic_msd_review_result_info.mbl_no)
from warehouse_atomic_msd_review_result_info
where warehouse_atomic_msd_review_result_info.appral_res ='通过'
         and warehouse_atomic_msd_review_result_info.mbl_no in 
           (select distinct warehouse_atomic_coupon_code.phone_number
            from warehouse_atomic_coupon_code
            where warehouse_atomic_coupon_code.coupon_type='2'
            and substring(warehouse_atomic_coupon_code.tm_smp,1,8) between '20180827' and '20180907')
	and substring(warehouse_atomic_msd_review_result_info.credit_time,1,10) between '2018-08-27' and '2018-09-07'
group by warehouse_atomic_msd_review_result_info.data_source

提现

select warehouse_atomic_msd_withdrawals_result_info.data_source,
       warehouse_atomic_msd_withdrawals_result_info.mbl_no,
       warehouse_atomic_msd_withdrawals_result_info.total_amount,
       warehouse_atomic_msd_withdrawals_result_info.ltd_lend_amt,
	   warehouse_atomic_msd_withdrawals_result_info.msd_return_time
from warehouse_atomic_msd_withdrawals_result_info
where substring(msd_return_time,1,10) between '2018-08-27' and '2018-09-07'
      and total_amount is not null
      and warehouse_atomic_msd_withdrawals_result_info.mbl_no in 
           (select distinct warehouse_atomic_coupon_code.phone_number
            from warehouse_atomic_coupon_code
            where warehouse_atomic_coupon_code.coupon_type='2'
              and substring(warehouse_atomic_coupon_code.tm_smp,1,8) between '20180827' and '20180907')