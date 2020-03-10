
点点新老用户判定
select a.*
       ,'N' as is_old
   from (select a.*
                ,date(if(length(a.apply_time)>0,substr(a.apply_time,1,10))) as appl_date
             from default.warehouse_atomic_diandian_review_result_info as a) as a
    where not exists(select *
                      from (select mbl_no
                                   ,apply_time
                                   ,creadit_time as credit_time
                                   ,date(if(length(b.creadit_time)>0,substr(b.creadit_time,1,10))) + interval '1' day as credit_date
                                   ,date(if(length(b.creadit_time)>0,substr(b.creadit_time,1,10))) + interval '3' month as credit_end_date
                              from default.warehouse_atomic_diandian_review_result_info as b
                              where message = '成功') as b
                     where a.mbl_no=b.mbl_no
                     and a.appl_date between credit_date and credit_end_date)
union all
select a.*
       ,'Y' as is_old
   from (select a.*
                ,date(if(length(a.apply_time)>0,substr(a.apply_time,1,10))) as appl_date
             from default.warehouse_atomic_diandian_review_result_info as a) as a
    where exists(select *
                      from (select mbl_no
                                   ,apply_time
                                   ,creadit_time as credit_time
                                   ,date(if(length(b.creadit_time)>0,substr(b.creadit_time,1,10))) + interval '1' day as credit_date
                                   ,date(if(length(b.creadit_time)>0,substr(b.creadit_time,1,10))) + interval '3' month as credit_end_date
                              from default.warehouse_atomic_diandian_review_result_info as b
                              where message = '成功') as b
                 where a.mbl_no=b.mbl_no
                   and a.appl_date between credit_date and credit_end_date)
				   
				   
				   
现金分期
select a.*
       ,'N' as is_old
  from default.warehouse_atomic_msd_cashord_result_info as a
  where not exists(select *
                      from (select order_no
                                   ,mbl_no
                                   ,apply_time
                                   ,approval_time as credit_time
                                   ,date(if(length(b.approval_time)>0,substr(b.approval_time,1,10))) + interval '1' day as credit_date
                                   ,case when approval_period='3' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10))) + interval '3' month
                                    when approval_period='6' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10))) + interval '6' month
                                    when approval_period='9' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10))) + interval '9' month
                                    when approval_period='12' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10))) + interval '12' month
                                    when approval_period='18' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10))) + interval '18' month
                                    when approval_period='24' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10))) + interval '24' month end as credit_end_date
                              from default.warehouse_atomic_msd_cashord_result_info as b
                              where approval_status in('N','A')) as b
                 where a.mbl_no=b.mbl_no
                   and date(a.apply_time) between credit_date and credit_end_date)
union all
select a.*
       ,'Y' as is_old
  from default.warehouse_atomic_msd_cashord_result_info as a
  where exists(select *
                      from (select order_no
                                   ,mbl_no
                                   ,apply_time
                                   ,approval_time as credit_time
                                   ,date(if(length(b.approval_time)>0,substr(b.approval_time,1,10))) + interval '1' day as credit_date
                                   ,case when approval_period='3' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10))) + interval '3' month
                                    when approval_period='6' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10))) + interval '6' month
                                    when approval_period='9' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10))) + interval '9' month
                                    when approval_period='12' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10))) + interval '12' month
                                    when approval_period='18' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10))) + interval '18' month
                                    when approval_period='24' then date(if(length(b.approval_time)>0,substr(b.approval_time,1,10))) + interval '24' month end as credit_end_date
                              from default.warehouse_atomic_msd_cashord_result_info as b
                              where approval_status in('N','A')) as b
                 where a.mbl_no=b.mbl_no
                   and date(a.apply_time) between credit_date and credit_end_date)