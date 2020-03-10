(
--申请调查表warehouse_atomic_hzx_research_task
--customer_id 客户id
--loan_apply_time 贷款申请时间
--m_state 营销完成-5
--research_apply_time 调查时间
--research_status 调查完成4
--research_over_time 调查完成时间
--rec_amount 建议额度
--bank_id 银行id
)
---取申请完成
---warehouse_atomic_hzx_research_task
select substr(a1.loan_apply_time,1,10) as apply_date,
       a2.name,
       count(distinct a1.customer_id) as num1
from warehouse_atomic_hzx_research_task a1
left join warehouse_atomic_hzx_b_bank_base_info a2
on a1.bank_id = a2.id
where a1.m_state = '5'
  and substr(a1.loan_apply_time,1,10) between '2019-10-01' and '2019-12-31'
  and a2.name in ('阜城家银村镇银行',
                  '武强家银村镇银行',
                  '万全家银村镇银行',
                  '赤城家银村镇银行',
                  '卢龙家银村镇银行',
                  '宣化家银村镇银行',
                  '秦皇岛抚宁家银村镇银行',
                  '张北信达村镇银行',
                  '故城家银村镇银行',
                  '昌黎家银村镇银行',
                  '唐山市开平汇金村镇银行',
                  '蔚县银泰村镇银行',
                  '康保银丰村镇银行')
group by substr(a1.loan_apply_time,1,10),
         a2.name

---取调查完成
---warehouse_atomic_hzx_research_task
select substr(a1.research_over_time,1,10) as diaocha_date,
       a2.name,
       count(distinct a1.customer_id) as num1
from warehouse_atomic_hzx_research_task a1
left join warehouse_atomic_hzx_b_bank_base_info a2
on a1.bank_id = a2.id
where a1.research_status = '4'
  and substr(a1.research_over_time,1,10) between '2019-10-01' and '2019-12-31'
  and a2.name in ('阜城家银村镇银行',
                  '武强家银村镇银行',
                  '万全家银村镇银行',
                  '赤城家银村镇银行',
                  '卢龙家银村镇银行',
                  '宣化家银村镇银行',
                  '秦皇岛抚宁家银村镇银行',
                  '张北信达村镇银行',
                  '故城家银村镇银行',
                  '昌黎家银村镇银行',
                  '唐山市开平汇金村镇银行',
                  '蔚县银泰村镇银行',
                  '康保银丰村镇银行')
group by substr(a1.research_over_time,1,10),
         a2.name

---取审批通过（有金额）
---warehouse_atomic_hzx_research_task
select substr(a1.research_over_time,1,10) as diaocha_date,
       a2.name,
       count(distinct a1.customer_id) as num1,
       sum(a1.rec_amount)
from warehouse_atomic_hzx_research_task a1
left join warehouse_atomic_hzx_b_bank_base_info a2
on a1.bank_id = a2.id
where a1.research_status = '4'
  and substr(a1.research_over_time,1,10) between '2019-10-01' and '2019-12-31'
  and a1.rec_amount > '0'
  and a2.name in ('阜城家银村镇银行',
                  '武强家银村镇银行',
                  '万全家银村镇银行',
                  '赤城家银村镇银行',
                  '卢龙家银村镇银行',
                  '宣化家银村镇银行',
                  '秦皇岛抚宁家银村镇银行',
                  '张北信达村镇银行',
                  '故城家银村镇银行',
                  '昌黎家银村镇银行',
                  '唐山市开平汇金村镇银行',
                  '蔚县银泰村镇银行',
                  '康保银丰村镇银行')
group by substr(a1.research_over_time,1,10),
         a2.name
