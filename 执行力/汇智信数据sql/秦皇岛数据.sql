--秦皇岛数据
--申请
select '申请' AS code,
       substr(a1.loan_apply_time,1,7) as apply_date,
       a2.name,
       count(distinct a1.customer_id) as num1,
       '0' as amount
from warehouse_atomic_hzx_research_task a1
left join warehouse_atomic_hzx_b_bank_base_info a2
on a1.bank_id = a2.id
where a1.m_state = '5'
  and a2.name in ('秦皇岛抚宁家银村镇银行','卢龙家银村镇银行','昌黎家银村镇银行')
group by substr(a1.loan_apply_time,1,7),
         a2.name
union all
--调查
select '调查' AS code,
       substr(a1.research_over_time,1,7) as apply_date,
       a2.name,
       count(distinct a1.customer_id) as num1,
       '0' as amount
from warehouse_atomic_hzx_research_task a1
left join warehouse_atomic_hzx_b_bank_base_info a2
on a1.bank_id = a2.id
where a1.research_status = '4'
  and a2.name in ('秦皇岛抚宁家银村镇银行','卢龙家银村镇银行','昌黎家银村镇银行')
group by substr(a1.research_over_time,1,7),
         a2.name
union all
--通过
select '通过' AS code,
       substr(a1.research_over_time,1,7) as apply_date,
       a2.name,
       count(distinct a1.customer_id) as num1,
       sum(a1.rec_amount) as amount
from warehouse_atomic_hzx_research_task a1
left join warehouse_atomic_hzx_b_bank_base_info a2
on a1.bank_id = a2.id
where a1.research_status = '4'
  and a1.rec_amount > '0'
  and a2.name in ('秦皇岛抚宁家银村镇银行','卢龙家银村镇银行','昌黎家银村镇银行')
group by substr(a1.research_over_time,1,7),
         a2.name