马上合同到期用户
select distinct a1.mbl_no,
                a1.data_source,
                substr(a1.paid_out_time,1,10)as end_time,
                a2.acc_lim,
                a3.name
from
    (select * from
                  (select *,
				          row_number() over(partition by mbl_no order by msd_return_time desc) as num
                   from warehouse_atomic_msd_withdrawals_result_info as b1
                   where data_source ='sjd') as b2
     where num = 1
       and substr(paid_out_time,1,7) = '2019-07') a1
left join warehouse_atomic_msd_review_result_info a2
       on a1.data_source = a2.data_source
      and a1.mbl_no = a2.mbl_no
      and a2.data_source = 'sjd'
left join warehouse_atomic_user_info a3
       on a1.data_source = a3.data_source
      and a1.mbl_no = a3.mbl_no
where a2.acc_lim is not null
  and a1.mbl_no not in (select mbl_no from warehouse_atomic_smstunsubscribe where eff_flg = '1')