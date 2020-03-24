--汇智信 抚宁 季度报告取数2
--客户画像
性别比
年龄分布

--1.性别比
SELECT sex,
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
	   a1.id_card as id_card,                       --客户身份证号
	   a1.sex,                                     --性别
	   a1.age                                      --年龄
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
  and substr(c_date,1,10) between '2020-01-01' and '2020-04-01'
GROUP BY sex,
         bank_name

--1.年龄分布
SELECT age,
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
	   a1.id_card as id_card,                       --客户身份证号
	   a1.sex,                                     --性别
	   a1.age                                      --年龄
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
  and substr(c_date,1,10) between '2020-01-01' and '2020-04-01'
GROUP BY age,
         bank_name		 