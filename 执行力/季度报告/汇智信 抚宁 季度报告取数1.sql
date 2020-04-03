--汇智信 抚宁 季度报告取数1
--1.汇智信建档
--count(DISTINCT mobile_phone) as mbl_num
SELECT substr(c_date,1,7) as c_date,
       bank_name,
	   count(DISTINCT mbl_no) as mbl_num
from 
(
SELECT distinct substr(c_date,1,10) as c_date,
       bank_name,
	   '线下' as data_source,
       mobile_phone as mbl_no
from 
(SELECT a1.c_time as c_date,                        --建档时间
       a2.name as bank_name,                       --银行名称
	   a1.dot_id,                                  --网点ID
	   a4.dot_name,                                -- 网点名
	   a1.c_user as c_user,                        --客户经理ID
	   a3.user_name as user_name,                  --客户经理
	   a1.m_id as customer_owner_id,  --客户归属ID
       a1.id as id,                                --客户建档ID 
       a1.mobile as mobile_phone, --客户建档号码
	   a1.id_card as id_card                       --客户身份证号
FROM warehouse_atomic_hzx_c_customer AS a1
left join warehouse_atomic_hzx_b_bank_base_info a2  
       on a1.bank_id = a2.id
left join warehouse_atomic_hzx_b_bank_user a3
       on a1.c_user = a3.id
	  and a2.id = a3.bank_id
	  
left join warehouse_atomic_hzx_b_dot a4
       on a1.bank_id = a4.bank_id
	  and a1.dot_id = a4.id
where a1.id is not null
  and a1.mobile is not null
) a
where bank_name = '秦皇岛抚宁家银村镇银行'
  and substr(c_date,1,10) between '2020-01-01' and '2020-03-31'
  
union 

select distinct substr(a.registe_date,1,10) as c_date,
       '秦皇岛抚宁家银村镇银行' as bank_name,
	     '线上' as data_source,
      a.mbl_no as mbl_no
from default.warehouse_atomic_time_user a
WHERE a.data_source in ('bhh','bhd')
AND substr(a.registe_date,1,10) between '2020-01-01' and '2020-03-31'
) a

group by substr(c_date,1,7),
         bank_name
		 
		 
---取申请完成
---u_marketing_research_task
select substr(a1.loan_apply_time,1,7) as apply_date,
       a2.name,
       count(distinct a1.customer_id) as num1
from warehouse_atomic_hzx_research_task a1
left join warehouse_atomic_hzx_b_bank_base_info a2
on a1.bank_id = a2.id
where a1.m_state = '5'
  and substr(a1.loan_apply_time,1,10) between '2020-01-01' and '2020-03-31'
  and a2.name in ('秦皇岛抚宁家银村镇银行')
group by substr(a1.loan_apply_time,1,7),
         a2.name
		 
---取调查完成
---u_marketing_research_task
select substr(a1.research_over_time,1,7) as diaocha_date,
       a2.name,
       count(distinct a1.customer_id) as num1
from warehouse_atomic_hzx_research_task a1
left join warehouse_atomic_hzx_b_bank_base_info a2
on a1.bank_id = a2.id
where a1.research_status in ('4','5')
  and substr(a1.research_over_time,1,10) between '2020-01-01' and '2020-03-31'
  and a2.name in ('秦皇岛抚宁家银村镇银行')
group by substr(a1.research_over_time,1,7),
         a2.name
		 
--取审批通过（有金额）
---u_marketing_research_task
select substr(a1.research_over_time,1,7) as diaocha_date,
       a2.name,
       count(distinct a1.customer_id) as num1,
       sum(a1.rec_amount)
from warehouse_atomic_hzx_research_task a1
left join warehouse_atomic_hzx_b_bank_base_info a2
on a1.bank_id = a2.id
where a1.research_status = '4'
  and substr(a1.research_over_time,1,10) between '2020-01-01' and '2020-03-31'
  and a1.rec_amount > '0'
  and a2.name in ('秦皇岛抚宁家银村镇银行')
group by substr(a1.research_over_time,1,7),
         a2.name