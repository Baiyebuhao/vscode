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
                  '康保银丰村镇银行')
group by a2.name,
         substr(a1.c_time,1,10)
		 
		 
		 