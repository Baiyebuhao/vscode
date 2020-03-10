--汇智信客户申请、调查、通过
--申请
select substr(a1.loan_apply_time,1,10) as apply_date,
       a2.name,
       count(distinct a1.customer_id) as num1
from warehouse_atomic_hzx_research_task a1
left join warehouse_atomic_hzx_b_bank_base_info a2
on a1.bank_id = a2.id
where a1.m_state = '5'
  and a2.name = '卢龙家银村镇银行'
group by substr(a1.loan_apply_time,1,10),
         a2.name
--调查
select substr(a1.research_over_time,1,10) as diaocha_date,
       a2.name,
       count(distinct a1.customer_id) as num1
from warehouse_atomic_hzx_research_task a1
left join warehouse_atomic_hzx_b_bank_base_info a2
on a1.bank_id = a2.id
where a1.research_status = '4'
  and a2.name = '卢龙家银村镇银行'
group by substr(a1.research_over_time,1,10),
         a2.name 

--通过
select substr(a1.research_over_time,1,10) as diaocha_date,
       a2.name,
       count(distinct a1.customer_id) as num1,
       sum(a1.rec_amount)
from warehouse_atomic_hzx_research_task a1
left join warehouse_atomic_hzx_b_bank_base_info a2
on a1.bank_id = a2.id
where a1.research_status = '4'
  and a1.rec_amount > '0'
  and a2.name = '卢龙家银村镇银行'
group by substr(a1.research_over_time,1,10),
         a2.name
