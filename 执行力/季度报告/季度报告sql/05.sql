--申请到调查
select bankname,
        count(case when days=0 then 1 end ) as x1,
        count(case when days>=1 and days<=2 then 1 end  ) as x23,
        count(case when days>=3 and days<=5 then 1 end  ) as x35,
        count(case when  days>5 or days is null then 1 end  ) as x5
        from 
(select a2.name as bankname,
        datediff(substr(research_apply_time,1,10) ,
                 substr(loan_apply_time,1,10)) as days
from warehouse_atomic_hzx_research_task a1
left join warehouse_atomic_hzx_b_bank_base_info a2
on a1.bank_id = a2.id
where a1.m_state='5'--营销完成
  and substr(a1.loan_apply_time,1,10) between '2020-01-01' and '2020-03-31'
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
                  '武陟农村商业银行'))x
group by bankname
--调查到调查完成
select bankname,
        count(case when days=0 then 1 end ) as x1,
        count(case when days>=1 and days<=2 then 1 end  ) as x23,
        count(case when days>=3 and days<=5 then 1 end  ) as x35,
        count(case when  days>5 or days is null then 1 end  ) as x5
        from (
select a2.name as bankname,
       datediff(substr(research_over_time,1,10) ,
                 substr(research_apply_time,1,10)) as days                           -----research_apply_time
from warehouse_atomic_hzx_research_task a1
left join warehouse_atomic_hzx_b_bank_base_info a2
on a1.bank_id = a2.id
where a1.m_state='5'--营销完成
  and a1.distribution = '1'  --已分配
  and a1.research_status in ('2','3','4','5')--待调查2,调查中3,调查完成4,拒绝本次申请5'
  and substr(a1.loan_apply_time,1,10) between '2020-01-01' and '2020-03-31'
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
                  '武陟农村商业银行'))x
group by bankname