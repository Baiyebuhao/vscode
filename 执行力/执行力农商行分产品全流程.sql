--武陟农村商业银行
select BankName,
       product_id,
       product_name,
       sum(case when code = '申请' then p_num end) AS apply_num,
       sum(case when code = '调查' then p_num end) AS dc_num,
       sum(case when code = '通过' then p_num end) AS tg_num,
       sum(case when code = '通过' then dc_amount end) AS tg_amount

from 
(
------各产品申请
select a5.*,'申请' as code

from 
(SELECT a4.name AS BankName,
	 
       a2.id AS product_id,
       a2.name AS product_name,
	   count(DISTINCT CASE
                             WHEN a3.m_state = 5 THEN a3.customer_id
                         END) AS p_num,
       0 as dc_amount
   FROM warehouse_atomic_hzx_bank_product_info a2
   JOIN warehouse_atomic_hzx_research_task AS a3 ON a2.id = a3.bank_pro_id
   JOIN warehouse_atomic_hzx_b_bank_base_info AS a4 ON a3.bank_id = a4.id
   where a2.id IS NOT NULL
     and substr(a3.loan_apply_time,1,10) between '2019-01-01' and '2019-12-31'
    GROUP BY a4.name,
			 a2.id,
             a2.name) a5
             where a5.bankname in ('武陟农村商业银行')

union all
---调查完成
select a5.*,'调查' as code
from 	
(SELECT a4.name AS BankName,
		 
       a2.id AS product_id,
       a2.name AS product_name,
	   count(DISTINCT CASE
                             WHEN a3.research_status in('4','5') THEN a3.customer_id
                         END) AS p_num,
       0 as dc_amount
   
   FROM warehouse_atomic_hzx_bank_product_info a2
   JOIN warehouse_atomic_hzx_research_task AS a3 ON a2.id = a3.bank_pro_id
   JOIN warehouse_atomic_hzx_b_bank_base_info AS a4 ON a3.bank_id = a4.id
   where a2.id IS NOT NULL
     and substr(a3.research_over_time,1,10) between '2019-01-01' and '2019-12-31'
    GROUP BY a4.name,

			 a2.id,
             a2.name) a5
             where a5.bankname in ('武陟农村商业银行')
union all
---通过客户
select a5.*,'通过' as code
from 	                  --------sum(a5.diaochaOver)
(SELECT a4.name AS BankName,
	 
       a2.id AS product_id,
       a2.name AS product_name,
	   count(DISTINCT CASE
                             WHEN a3.research_status = '4' THEN a3.customer_id
                         END) AS p_num,
       sum(CASE 
	            when a3.research_status = '4' THEN a3.rec_amount
	            end) as dc_amount
   FROM warehouse_atomic_hzx_bank_product_info a2
   JOIN warehouse_atomic_hzx_research_task AS a3 ON a2.id = a3.bank_pro_id
   JOIN warehouse_atomic_hzx_b_bank_base_info AS a4 ON a3.bank_id = a4.id
   where a2.id IS NOT NULL
     and substr(a3.research_over_time,1,10) between '2019-01-01' and '2019-12-31'
     and a3.rec_amount > 0
    GROUP BY a4.name,

			 a2.id,
             a2.name) a5
             where a5.bankname in ('武陟农村商业银行')
) b
group by BankName,
         product_id,
         product_name