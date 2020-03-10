##钱包易贷
select a.*
       ,'N' as is_old
  from (select a.*
          ,date(extractday) as extract_day
     from default.warehouse_atomic_user_action as a) as a
  where not exists(select *
                      from (select ord_no
                                   ,mbl_no
                                   ,appl_time
                                   ,credit_time
                                   ,date(if(length(b.credit_time)=8,concat(substr(b.credit_time,1,4),'-',substr(b.credit_time,5,2),'-',substr(b.credit_time,7,2)))) + interval '1' day as credit_date
                                   ,date(if(length(b.credit_time)=8,concat(substr(b.credit_time,1,4),'-',substr(b.credit_time,5,2),'-',substr(b.credit_time,7,2)))) + interval '1' year as credit_end_date
                              from default.warehouse_atomic_qianbao_withdrawals_result_info as b
                              where status not in('cancelled','pay_failed')) as b
                 where a.mbl_no=b.mbl_no
                   and a.extract_day between credit_date and credit_end_date)
    and product_name in('宁夏小贷','移动白条-钱包易贷')
    and event_id = 'apply'
union all
select a.*
       ,'Y' as is_old
  from (select a.*
          ,date(extractday) as extract_day
     from default.warehouse_atomic_user_action as a) as a
  where exists(select *
                      from (select ord_no
                                   ,mbl_no
                                   ,appl_time
                                   ,credit_time
                                   ,date(if(length(b.credit_time)=8,concat(substr(b.credit_time,1,4),'-',substr(b.credit_time,5,2),'-',substr(b.credit_time,7,2)))) + interval '1' day as credit_date
                                   ,date(if(length(b.credit_time)=8,concat(substr(b.credit_time,1,4),'-',substr(b.credit_time,5,2),'-',substr(b.credit_time,7,2)))) + interval '1' year as credit_end_date
                              from default.warehouse_atomic_qianbao_withdrawals_result_info as b
                              where status not in('cancelled','pay_failed')) as b
                 where a.mbl_no=b.mbl_no
                   and a.extract_day between credit_date and credit_end_date)
    and product_name in('宁夏小贷','移动白条-钱包易贷')
    and event_id = 'apply'
union all
##马上随借随还
select a.*
       ,'N' as is_old
  from (select a.*
          ,date(extractday) as extract_day
     from default.warehouse_atomic_user_action as a) as a
  where not exists(select *
                      from (select contact_no
                                   ,mbl_no
                                   ,appl_time
                                   ,credit_time
                                   ,date(if(length(b.credit_time)>0,substr(b.credit_time,1,10))) + interval '1' day as credit_date
                                   ,date(if(length(b.credit_time)>0,substr(b.credit_time,1,10))) + interval '1' year as credit_end_date
                              from default.warehouse_atomic_msd_withdrawals_result_info as b) as b
                 where a.mbl_no=b.mbl_no
                   and a.extract_day between credit_date and credit_end_date)
    and product_name in('随借随还','移动白条-马上')
    and event_id = 'apply'
union all
select a.*
       ,'Y' as is_old
  from (select a.*
          ,date(extractday) as extract_day
     from default.warehouse_atomic_user_action as a) as a
  where exists(select *
                      from (select contact_no
                                   ,mbl_no
                                   ,appl_time
                                   ,credit_time
                                   ,date(if(length(b.credit_time)>0,substr(b.credit_time,1,10))) + interval '1' day as credit_date
                                   ,date(if(length(b.credit_time)>0,substr(b.credit_time,1,10))) + interval '1' year as credit_end_date
                              from default.warehouse_atomic_msd_withdrawals_result_info as b) as b
                 where a.mbl_no=b.mbl_no
                   and a.extract_day between credit_date and credit_end_date)
    and product_name in('随借随还','移动白条-马上')
    and event_id = 'apply'