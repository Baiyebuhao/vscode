--------申请人数----
select warehouse_atomic_msd_review_result_info.data_source,count(distinct warehouse_atomic_msd_review_result_info.mbl_no)

from warehouse_atomic_msd_review_result_info

where substr (appl_time ,1,10) between  '2018-08-10' and '2018-09-10' and 
            warehouse_atomic_msd_review_result_info.mbl_no in 
                   (select distinct warehouse_atomic_coupon_code.phone_number
                    from warehouse_atomic_coupon_code
                    where warehouse_atomic_coupon_code.coupon_type='2'
                    and substring(warehouse_atomic_coupon_code.tm_smp,1,8) between '20180810' and '20180910')
group by warehouse_atomic_msd_review_result_info.data_source

--------审批通过人数-------
select warehouse_atomic_msd_review_result_info.data_source,count(distinct warehouse_atomic_msd_review_result_info.mbl_no)
from warehouse_atomic_msd_review_result_info
where warehouse_atomic_msd_review_result_info.appral_res ='通过' and substr (credit_time ,1,10) between  '2018-08-10' and '2018-09-10'
      and warehouse_atomic_msd_review_result_info.mbl_no in 
           (select distinct warehouse_atomic_coupon_code.phone_number
            from warehouse_atomic_coupon_code
            where warehouse_atomic_coupon_code.coupon_type='2'
            and substring(warehouse_atomic_coupon_code.tm_smp,1,8) between '20180810' and '20180910')
group by warehouse_atomic_msd_review_result_info.data_source

免息券领取人数
select a.sys_type,
       count(distinct a.phone_number),
	   b.os_type
from warehouse_atomic_coupon_code a left join warehouse_atomic_user_info b
on a.phone_number=b.mbl_no
where a.coupon_type='2'
      and substring(a.tm_smp,1,8) between '20180810' and '20180910'
group by a.sys_type,
         b.os_type























