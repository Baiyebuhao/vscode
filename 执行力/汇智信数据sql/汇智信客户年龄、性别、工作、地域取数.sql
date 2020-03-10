--汇智信客户年龄、性别、工作、地域取数
(
select a1.research_apply_id,
       a4.answer,
	   count(distinct a1.customer_id)
from warehouse_atomic_hzx_research_task a1
join warehouse_atomic_hzx_b_loan_research_group_relate a2
  on a1.version_id = a2.version_id
join warehouse_atomic_hzx_b_research_content_templet a3
  on a2.group_id= a3.g_id
left join warehouse_atomic_hzx_l_research_result a4
  on a3.xy_id = a4.r_id
 and a1.research_apply_id = a4.research_id
where a4.r_id = '1951612270008087'
group by a1.research_apply_id,
         a4.answer
)	 
(--客户分层（错误数据）
---1-优质客户，2-普通客户，3-拒绝
select a1.customer_level,
       count(distinct a1.customer_id)
from warehouse_atomic_hzx_research_task a1
JOIN warehouse_atomic_hzx_b_bank_base_info a2
  ON a1.bank_id = a2.id
where a2.name = '卢龙家银村镇银行'
GROUP BY a1.customer_level
)
		 
--性别		 
SELECT b.name,
       a.sex,
       count(DISTINCT a.id_card)
FROM warehouse_atomic_hzx_c_customer a
LEFT JOIN warehouse_atomic_hzx_b_bank_base_info b ON a.bank_id = b.id
join warehouse_atomic_hzx_research_task c on a.id = c.customer_id
where b.name = '卢龙家银村镇银行'
GROUP BY b.name,
         a.sex
卢龙家银村镇银行	NULL	1
卢龙家银村镇银行	女	91
卢龙家银村镇银行	男	341
		 
---年龄
SELECT b.name,
       a.age,
       count(DISTINCT a.id_card)
FROM warehouse_atomic_hzx_c_customer a
LEFT JOIN warehouse_atomic_hzx_b_bank_base_info b ON a.bank_id = b.id
join warehouse_atomic_hzx_research_task c on a.id = c.customer_id
where b.name = '卢龙家银村镇银行'
GROUP BY b.name,
         a.age
		 
--工作
SELECT b.name,
       a.job,
       count(DISTINCT a.id_card)
FROM warehouse_atomic_hzx_c_customer a
LEFT JOIN warehouse_atomic_hzx_b_bank_base_info b ON a.bank_id = b.id
join warehouse_atomic_hzx_research_task c on a.id = c.customer_id
where b.name = '卢龙家银村镇银行'
GROUP BY b.name,
         a.job
		 
--地域 
SELECT b.name,
       a.registry_addr,
       count(DISTINCT a.id_card)
FROM warehouse_atomic_hzx_c_customer a
LEFT JOIN warehouse_atomic_hzx_b_bank_base_info b ON a.bank_id = b.id
join warehouse_atomic_hzx_research_task c on a.id = c.customer_id
where b.name = '卢龙家银村镇银行'
GROUP BY b.name,
         a.registry_addr
		 

