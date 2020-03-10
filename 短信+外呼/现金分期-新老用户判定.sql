现金分期-马上
select a.*,
      'N' as is_old
  from default.warehouse_atomic_msd_cashord_result_info as a
  where not exists (select * from 
                           (select  b.order_no
                                   ,b.mbl_no
                                   ,b.apply_time
                                   ,b.approval_time as credit_time
                                   ,date(if(length(b.approval_time)>0,substr(b.approval_time,1,10),null)) + interval '1' day as credit_date
                                   ,case when approval_period = '3' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10),0)) + interval '3' month
                                    when approval_period = '6' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10),0)) + interval '6' month
                                    when approval_period = '9' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10),0)) + interval '9' month
                                    when approval_period = '12' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10),0)) + interval '12' month
                                    when approval_period = '18' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10),0)) + interval '18' month
                                    when approval_period = '24' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10),0)) + interval '24' month end as credit_end_date
                              from default.warehouse_atomic_msd_cashord_result_info b
                              where approval_status in('N','A')) b
				    where a.mbl_no = b.mbl_no
                    and a.apply_time between b.credit_date and b.credit_end_date)
union all
select a.*,
      'Y' as is_old
  from default.warehouse_atomic_msd_cashord_result_info as a
  where exists  (select * from 
                           (select  b.order_no
                                   ,b.mbl_no
                                   ,b.apply_time
                                   ,b.approval_time as credit_time
                                   ,date(if(length(b.approval_time)>0,substr(b.approval_time,1,10),null)) + interval '1' day as credit_date
                                   ,case when approval_period = '3' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10),0)) + interval '3' month
                                    when approval_period = '6' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10),0)) + interval '6' month
                                    when approval_period = '9' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10),0)) + interval '9' month
                                    when approval_period = '12' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10),0)) + interval '12' month
                                    when approval_period = '18' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10),0)) + interval '18' month
                                    when approval_period = '24' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10),0)) + interval '24' month end as credit_end_date
                              from default.warehouse_atomic_msd_cashord_result_info as b
                              where approval_status in('N','A')) b
				    where a.mbl_no = b.mbl_no
                   and a.apply_time between b.credit_date and b.credit_end_date)