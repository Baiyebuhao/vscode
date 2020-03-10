476 统计需求  徐超    3、重要不紧急 2019.7.29 孙艳 商品贷 2019.8.1 
一次性需求 商品贷   分析商户办单轨迹，刺激商户办单  
分地区分别提取已办单和未办单商户；已办单商户需要提取每家所有办单量（截止日期7.28）  

warehouse_atomic_new_dis_order

warehouse_data_jinshang_disi_info

地市 - 商户 -有多少单


select b.district,a.store,
       count(distinct a.customer_phone) as sq,
       count(distinct case when a.apply_state in ('已放款','审批通过，等待放款') then a.customer_phone end)sx,
       count(distinct case when a.apply_state = '贷款被拒绝' then a.customer_phone end) as bj,
       sum(case when a.apply_state  in ('已放款','审批通过，等待放款') then a.approval_amount end) as je1,
       sum(case when a.apply_state = '已放款' then a.approval_amount end) as je2
from warehouse_data_jinshang_disi_info b
left join warehouse_atomic_new_dis_order a
  on b.store = a.store
group by b.district,a.store