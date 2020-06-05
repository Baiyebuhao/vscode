--每个产品，调查完成次数
--近一年的
--总量，不分银行

(--分产品调查
select * from 
(SELECT --a4.name AS BankName,
--         CASE
--             WHEN a2.pro_type =1 THEN '信易贷'
--             WHEN a2.pro_type =2 THEN '信福时贷'
--             WHEN a2.pro_type =3 THEN '精细化'
--             WHEN a2.pro_type =4 THEN '银行产品'
--             ELSE '未归类'
--         END AS pro_type,		 
       a2.id AS product_id,
       a2.name AS product_name,
--	   substr(a3.research_over_time,1,10) AS data_date,
	   count(DISTINCT CASE
                             WHEN a3.research_status = '4' THEN a3.customer_id
                         END) AS diaochaOver
   
   FROM warehouse_atomic_hzx_bank_product_info a2
   JOIN warehouse_atomic_hzx_research_task AS a3 ON a2.id = a3.bank_pro_id
   JOIN warehouse_atomic_hzx_b_bank_base_info AS a4 ON a3.bank_id = a4.id
   where a2.id IS NOT NULL
    GROUP BY a4.name,
--	         CASE
--               WHEN a2.pro_type =1 THEN '信易贷'
--               WHEN a2.pro_type =2 THEN '信福时贷'
--               WHEN a2.pro_type =3 THEN '精细化'
--               WHEN a2.pro_type =4 THEN '银行产品'
--               ELSE '未归类'
--            END,
			 a2.id,
             a2.name--,
             --substr(a3.research_over_time,1,10)
			 
			 ) a5
             where a5.bankname = '卢龙家银村镇银行'
)

select * from 
(SELECT  	 
       a2.id AS product_id,
       a2.name AS product_name,
 
	   count(DISTINCT CASE
                             WHEN a3.research_status = '4' THEN a3.customer_id
                         END) AS diaochaOver
   
   FROM warehouse_atomic_hzx_bank_product_info a2
   JOIN warehouse_atomic_hzx_research_task AS a3 ON a2.id = a3.bank_pro_id
   JOIN warehouse_atomic_hzx_b_bank_base_info AS a4 ON a3.bank_id = a4.id
   where a2.id IS NOT NULL
    GROUP BY a4.name,
 
			 a2.id,
             a2.name 
			 
			 ) a5
             where a5.bankname = '卢龙家银村镇银行'
			 
			 
select * from 
(SELECT  substr(a3.research_over_time,1,7) AS data_mouth,	 

       count(DISTINCT CASE
                             WHEN a3.research_status = '4' THEN a3.customer_id
                         END) AS diaochaOver
   
   FROM warehouse_atomic_hzx_bank_product_info a2
   JOIN warehouse_atomic_hzx_research_task AS a3 ON a2.id = a3.bank_pro_id
   JOIN warehouse_atomic_hzx_b_bank_base_info AS a4 ON a3.bank_id = a4.id
   where a2.id IS NOT NULL
     and substr(a3.research_over_time,1,10) between '2019-05-01' and '2020-05-31'
    GROUP BY substr(a3.research_over_time,1,7)
			 
			 ) a5