--汇智信 抚宁 季度报告取数4-2

--计算小时差
--分配时长
select substr(dis_time,1,19),
       substr(a1.loan_apply_time,1,19),
       (hour((substr(a1.dis_time,1,19)))-hour(substr(loan_apply_time,1,19))+(datediff((substr(a1.dis_time,1,19)), substr(loan_apply_time,1,19)))*24) as hour_dValue 
from warehouse_atomic_hzx_research_task a1
left join warehouse_atomic_hzx_b_bank_base_info a2
on a1.bank_id = a2.id
where a1.m_state='5'--营销完成
  and substr(a1.loan_apply_time,1,10) between '2020-01-01' and '2020-03-31'
  and a2.name = '秦皇岛抚宁家银村镇银行'




--调查时长
select substr(research_over_time,1,19),
       substr(a1.dis_time,1,19),
       (hour((substr(a1.research_over_time,1,19)))-hour(substr(dis_time,1,19))+(datediff((substr(a1.research_over_time,1,19)), substr(dis_time,1,19)))*24) as hour_dValue 
from warehouse_atomic_hzx_research_task a1
left join warehouse_atomic_hzx_b_bank_base_info a2
on a1.bank_id = a2.id
where a1.m_state='5'--营销完成
  and a1.distribution = '1'  --已分配
  and a1.research_status in ('4','5')--待调查2,调查中3,调查完成4,拒绝本次申请5'
  and substr(a1.loan_apply_time,1,10) between '2020-01-01' and '2020-03-31'
  and a2.name = '秦皇岛抚宁家银村镇银行'