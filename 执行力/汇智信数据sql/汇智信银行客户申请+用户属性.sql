------申请+用户属性
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
	   a1.age,
	   a1.sex,
	   substr(a3.loan_apply_time,1,10) AS data_date,
	   count(DISTINCT CASE
                             WHEN a3.m_state = 5 THEN a3.customer_id
                         END) AS applyOver
   
   FROM warehouse_atomic_hzx_c_customer AS a1
   JOIN warehouse_atomic_hzx_research_task AS a3 ON a1.id = a3.customer_id 
   JOIN warehouse_atomic_hzx_b_bank_base_info AS a4 ON a1.bank_id = a4.id  and a3.bank_id = a4.id
   JOIN warehouse_atomic_hzx_bank_product_info AS a2 on a2.id = a3.bank_pro_id
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
			 a1.age,
			 a1.sex,
             substr(a3.loan_apply_time,1,10)) a5
             where a5.bankname = '卢龙家银村镇银行'
