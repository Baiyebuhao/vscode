---分行员排序
------申请完成
select * from 	                  --------sum(a5.applyOver)
(SELECT a4.name AS BankName,
        a3.user_id,
        a6.user_name,
	    substr(a3.loan_apply_time,1,10) AS data_date,
	    count(DISTINCT CASE
                             WHEN a3.m_state = 5 THEN a3.customer_id
                         END) AS applyOver

   FROM warehouse_atomic_hzx_bank_product_info a2
   JOIN warehouse_atomic_hzx_research_task AS a3 ON a2.id = a3.bank_pro_id
   JOIN warehouse_atomic_hzx_b_bank_base_info AS a4 ON a3.bank_id = a4.id
   left join warehouse_atomic_hzx_b_bank_user a6 on a3.user_id = a6.id
   where a2.id IS NOT NULL
    GROUP BY a4.name,
			 a3.user_id,
			 a6.user_name,
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
                                   '康保银丰村镇银行')
			   and a5.data_date between '2019-10-01' and '2019-12-31'
			  
--调查完成
select * from 	                  --------sum(a5.diaochaOver)
(SELECT a4.name AS BankName,
        a3.a_user_id,
        a6.user_name,
	   substr(a3.research_over_time,1,10) AS data_date,
	   count(DISTINCT CASE
                             WHEN a3.research_status = '4' THEN a3.customer_id
                         END) AS diaochaOver
   
   FROM warehouse_atomic_hzx_bank_product_info a2
   JOIN warehouse_atomic_hzx_research_task AS a3 ON a2.id = a3.bank_pro_id
   JOIN warehouse_atomic_hzx_b_bank_base_info AS a4 ON a3.bank_id = a4.id
   left join warehouse_atomic_hzx_b_bank_user a6 on a3.a_user_id = a6.id
   where a2.id IS NOT NULL
    GROUP BY a4.name,
	         a3.a_user_id,
			 a6.user_name,
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
                                   '康保银丰村镇银行')
                 and a5.data_date between '2019-10-01' and '2019-12-31'	
				 
---通过客户
select * from 	                  --------sum(a5.diaochaOver)
(SELECT a4.name AS BankName,
        a3.a_user_id,
        a6.user_name,
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
   left join warehouse_atomic_hzx_b_bank_user a6 on a3.a_user_id = a6.id
   where a2.id IS NOT NULL
     and a3.rec_amount > 0
    GROUP BY a4.name,
	         a3.a_user_id,
			 a6.user_name,
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
                                   '康保银丰村镇银行')
                 and a5.data_date between '2019-10-01' and '2019-12-31'		
				 