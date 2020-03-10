移动白条-马上产品
申请人数=在马上贷审批记录表中的人 warehouse_atomic_msd_review_result_info
审批通过人数=（授信结果appral_res=通过的人数）
提现人数=马上贷提现记录表warehouse_atomic_msd_withdrawals_result_info 	放款时间msd_return_time在2018-08-10后

免息券领取人数
select a.data_source,
       count(distinct a.phone_number),
	   count(distinct b.mbl_no)
from warehouse_atomic_coupon_code a 
     left join warehouse_atomic_user_info b
     on a.phone_number=b.mbl_no
where a.coupon_type='2'
and substring(a.tm_smp,1,8) between '20180929' and '20181010'
group by a.data_source

申请人数
select warehouse_atomic_msd_review_result_info.data_source,
count(distinct warehouse_atomic_msd_review_result_info.mbl_no)
from warehouse_atomic_msd_review_result_info
where substring(appl_time,1,10) between '2018-09-29' and '2018-10-14'
and warehouse_atomic_msd_review_result_info.mbl_no in 
           (select distinct warehouse_atomic_coupon_code.phone_number
            from warehouse_atomic_coupon_code
            where warehouse_atomic_coupon_code.coupon_type='2'
            and substring(warehouse_atomic_coupon_code.tm_smp,1,8) between '20180810' and '20180910')
group by warehouse_atomic_msd_review_result_info.data_source

审批通过人数
select warehouse_atomic_msd_review_result_info.data_source,
       count(distinct warehouse_atomic_msd_review_result_info.mbl_no)
from warehouse_atomic_msd_review_result_info
where substring(warehouse_atomic_msd_review_result_info.appl_time,1,10) between '2018-09-29' and '2018-10-14'
      and substring(warehouse_atomic_msd_review_result_info.credit_time,1,10) between '2018-09-29' and '2018-10-14'
	  and warehouse_atomic_msd_review_result_info.appral_res ='通过'
      and warehouse_atomic_msd_review_result_info.mbl_no in 
           (select distinct warehouse_atomic_coupon_code.phone_number
            from warehouse_atomic_coupon_code
            where warehouse_atomic_coupon_code.coupon_type='2'
            and substring(warehouse_atomic_coupon_code.tm_smp,1,8) between '20180929' and '20181014')
group by warehouse_atomic_msd_review_result_info.data_source

提现人数
select warehouse_atomic_msd_withdrawals_result_info.data_source,
       count(distinct warehouse_atomic_msd_withdrawals_result_info.mbl_no)
from warehouse_atomic_msd_withdrawals_result_info
where substring(msd_return_time,1,10) between '2018-09-29' and '2018-10-10'
      and warehouse_atomic_msd_withdrawals_result_info.mbl_no in 
           (select distinct warehouse_atomic_coupon_code.phone_number
            from warehouse_atomic_coupon_code
            where warehouse_atomic_coupon_code.coupon_type='2'
              and substring(warehouse_atomic_coupon_code.tm_smp,1,8) between '20180929' and '20181010')
group by warehouse_atomic_msd_withdrawals_result_info.data_source

提现金额
select warehouse_atomic_msd_withdrawals_result_info.data_source,
       warehouse_atomic_msd_withdrawals_result_info.mbl_no,
       warehouse_atomic_msd_withdrawals_result_info.total_amount,
       warehouse_atomic_msd_withdrawals_result_info.ltd_lend_amt,
	   warehouse_atomic_msd_withdrawals_result_info.msd_return_time
from warehouse_atomic_msd_withdrawals_result_info
where substring(msd_return_time,1,10) between '2018-09-29' and '2018-10-14'
      and total_amount is not null
      and warehouse_atomic_msd_withdrawals_result_info.mbl_no in 
           (select distinct warehouse_atomic_coupon_code.phone_number
            from warehouse_atomic_coupon_code
            where warehouse_atomic_coupon_code.coupon_type='2'
              and substring(warehouse_atomic_coupon_code.tm_smp,1,8) between '20180929' and '20181014')