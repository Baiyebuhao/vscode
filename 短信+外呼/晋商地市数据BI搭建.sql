select year(date(a.apply_time)) AS YEAR,
       date_trunc('week',date(a.apply_time)) AS weekday,
       min(apply_time) AS extractday,
       b.district,b.store,a.store,
       count(distinct a.customer_phone) as sq,
       count(distinct case when a.apply_state in ('已放款','审批通过，等待放款') then a.customer_phone end) as sx,
       count(distinct case when a.apply_state = '贷款被拒绝' then a.customer_phone end) as bj,
       sum(case when a.apply_state  in ('已放款','审批通过，等待放款') then cast(a.approval_amount AS double) end) as je1,
       sum(case when a.apply_state = '已放款' then cast(a.approval_amount AS double) end) as je2
       
from default.warehouse_data_jinshang_disi_info b

left join default.warehouse_atomic_new_dis_order a

on a.store = b.store
group by year(date(a.apply_time)),
       date_trunc('week',date(a.apply_time)),b.district,b.store,a.store
	   


select b.district,b.store,
       count(distinct a.customer_phone) as sq,
       count(distinct case when a.apply_state in ('已放款','审批通过，等待放款') then a.customer_phone end)sx,
       count(distinct case when a.apply_state = '贷款被拒绝' then a.customer_phone end) as bj,
       sum(case when a.apply_state  in ('已放款','审批通过，等待放款') then a.approval_amount end) as je1,
       sum(case when a.apply_state = '已放款' then a.approval_amount end) as je2
	   
from warehouse_data_jinshang_disi_info b
left join warehouse_atomic_new_dis_order a
  on b.store = a.store
group by b.district,b.store