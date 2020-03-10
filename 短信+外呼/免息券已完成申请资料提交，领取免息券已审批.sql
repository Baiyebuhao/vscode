活动上线期间领取免息券已完成申请资料提交有多少人，领取免息券已审批多少人？
select distinct a.data_source,
       a.phone_number as mbl_no,
	   CONCAT_WS('-',substring(a.tm_smp,1,4),substring(a.tm_smp,5,2),substring(a.tm_smp,7,2)) as extractday,
	   c.product_name,
	   c.apply_time,
	   c.status
from warehouse_atomic_coupon_code a 
   left join warehouse_atomic_user_info b
          on a.phone_number = b.mbl_no
         and a.data_source = b.data_source

   left join warehouse_data_user_review_info c
          on a.phone_number = c.mbl_no
	     and a.data_source = c.data_source
where a.coupon_type='2'
  and substring(a.tm_smp,1,8) between '20190501' and '20190612'
  and c.apply_time between '2019-05-09' and '2019-06-12'