warehouse_atomic_hzx_custmanage_c_customer   c_customer
warehouse_atomic_hzx_b_bank_base_info        b_bank_base_info
c_time    c_date

select a2.name,
       substr(a1.c_time,1,10) as r_date,
       count(distinct a1.id) as num1
from c_customer a1
left join b_bank_base_info a2
on a1.bank_id = a2.id
where substr(a1.c_time,1,10) between '2019-10-01' and '2019-12-31'
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
group by a2.name,
         substr(a1.c_time,1,10)
		 


--1.汇智信建档
SELECT substr(c_date,1,10) as c_date,
       bank_name,
       count(DISTINCT mobile_phone) as mbl_num
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
where bank_name in ('阜城家银村镇银行',
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
  and substr(c_date,1,10) between '2020-01-01' and '2020-03-31'
GROUP BY substr(c_date,1,10),
         bank_name 
		 