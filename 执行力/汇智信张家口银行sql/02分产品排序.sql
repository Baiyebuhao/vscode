---分产品排序
---取申请完成
---warehouse_atomic_hzx_research_task
(select substr(a1.loan_apply_time,1,10) as apply_date,
       a3.name,
       count(distinct a1.customer_id) as num1
from warehouse_atomic_hzx_research_task a1
left join warehouse_atomic_hzx_b_bank_base_info a2 on a1.bank_id = a2.id
left join warehouse_atomic_hzx_bank_product_info a3 on a1.bank_pro_id = a3.id

where a1.m_state = '5'
  and substr(a1.loan_apply_time,1,10) between '2019-08-31' and '2019-09-30'
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
                  '康保银丰村镇银行',
                  '新密农商银行',
                  '武陟农村商业银行')
group by substr(a1.loan_apply_time,1,10),
         a3.name
		 )
------分产品排序
------申请完成
select * from 	                  --------sum(a5.applyOver)
(SELECT a4.name AS BankName,
          CASE
              WHEN a2.pro_type =1 THEN '信易贷'
              WHEN a2.pro_type =2 THEN '信福时贷'
              WHEN a2.pro_type =3 THEN '精细化'
              WHEN a2.pro_type =4 THEN '银行产品'
              ELSE '未归类'
          END AS pro_type,		 
       a2.id AS product_id,
       a2.name AS product_name,
	   substr(a3.loan_apply_time,1,10) AS data_date,
	   count(DISTINCT CASE
                             WHEN a3.m_state in ('4','5') THEN a3.customer_id
                         END) AS applyOver
   
   FROM warehouse_atomic_hzx_bank_product_info a2
   JOIN warehouse_atomic_hzx_research_task AS a3 ON a2.id = a3.bank_pro_id
   JOIN warehouse_atomic_hzx_b_bank_base_info AS a4 ON a3.bank_id = a4.id
   where a2.id IS NOT NULL
    GROUP BY a4.name,
	         CASE
                WHEN a2.pro_type =1 THEN '信易贷'
                WHEN a2.pro_type =2 THEN '信福时贷'
                WHEN a2.pro_type =3 THEN '精细化'
                WHEN a2.pro_type =4 THEN '银行产品'
                ELSE '未归类'
             END,
			 a2.id,
             a2.name,
             substr(a3.loan_apply_time,1,10)) a5
             where a5.bankname in ('阜城家银村镇银行',
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
                                   '康保银丰村镇银行',
                                   '新密农商银行',
                                   '武陟农村商业银行')
			   and a5.data_date between '2019-10-01' and '2019-12-31'
---调查完成
select * from 	                  --------sum(a5.diaochaOver)
(SELECT a4.name AS BankName,
          CASE
              WHEN a2.pro_type =1 THEN '信易贷'
              WHEN a2.pro_type =2 THEN '信福时贷'
              WHEN a2.pro_type =3 THEN '精细化'
              WHEN a2.pro_type =4 THEN '银行产品'
              ELSE '未归类'
          END AS pro_type,		 
       a2.id AS product_id,
       a2.name AS product_name,
	   substr(a3.research_over_time,1,10) AS data_date,
	   count(DISTINCT CASE
                             WHEN a3.research_status = '4' THEN a3.customer_id
                         END) AS diaochaOver
   
   FROM warehouse_atomic_hzx_bank_product_info a2
   JOIN warehouse_atomic_hzx_research_task AS a3 ON a2.id = a3.bank_pro_id
   JOIN warehouse_atomic_hzx_b_bank_base_info AS a4 ON a3.bank_id = a4.id
   where a2.id IS NOT NULL
    GROUP BY a4.name,
	         CASE
                WHEN a2.pro_type =1 THEN '信易贷'
                WHEN a2.pro_type =2 THEN '信福时贷'
                WHEN a2.pro_type =3 THEN '精细化'
                WHEN a2.pro_type =4 THEN '银行产品'
                ELSE '未归类'
             END,
			 a2.id,
             a2.name,
             substr(a3.research_over_time,1,10)) a5
             where a5.bankname in ('阜城家银村镇银行',
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
                                   '康保银丰村镇银行',
                                   '新密农商银行',
                                   '武陟农村商业银行')
                 and a5.data_date between '2019-10-01' and '2019-12-31'			 
			 
---通过客户
select * from 	                  --------sum(a5.diaochaOver)
(SELECT a4.name AS BankName,
          CASE
              WHEN a2.pro_type =1 THEN '信易贷'
              WHEN a2.pro_type =2 THEN '信福时贷'
              WHEN a2.pro_type =3 THEN '精细化'
              WHEN a2.pro_type =4 THEN '银行产品'
              ELSE '未归类'
          END AS pro_type,		 
       a2.id AS product_id,
       a2.name AS product_name,
	   substr(a3.research_over_time,1,10) AS data_date,
	   count(DISTINCT CASE
                             WHEN a3.research_status = '4' THEN a3.customer_id
                         END) AS diaochaOver,
       sum(CASE 
	            when a3.research_status = '4' THEN a3.rec_amount
	            end) as dc_amount
   FROM warehouse_atomic_hzx_bank_product_info a2
   JOIN warehouse_atomic_hzx_research_task AS a3 ON a2.id = a3.bank_pro_id
   JOIN warehouse_atomic_hzx_b_bank_base_info AS a4 ON a3.bank_id = a4.id
   where a2.id IS NOT NULL
     and a3.rec_amount > 0
    GROUP BY a4.name,
	         CASE
                WHEN a2.pro_type =1 THEN '信易贷'
                WHEN a2.pro_type =2 THEN '信福时贷'
                WHEN a2.pro_type =3 THEN '精细化'
                WHEN a2.pro_type =4 THEN '银行产品'
                ELSE '未归类'
             END,
			 a2.id,
             a2.name,
             substr(a3.research_over_time,1,10)) a5
             where a5.bankname in ('阜城家银村镇银行',
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
                                   '康保银丰村镇银行',
                                   '新密农商银行',
                                   '武陟农村商业银行')
                 and a5.data_date between '2019-10-01' and '2019-12-31'					 
