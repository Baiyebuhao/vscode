申请提数数据，具体需求为：手机分期通过和未通过用户明文数据各1500个，包括：姓名 、电话号码、身份证号码
通过用户
select * from 
(select distinct customer_phone,
       customer_name,
       customer_id_card
from warehouse_atomic_new_dis_order a
where apply_state in('已放款','审批通过，等待放款')
order by customer_phone) a
distribute by rand()
sort by rand()
limit 1500;
   
被拒用户   
select * from 
             (select distinct a1.customer_phone,
                     a1.customer_name,
                     a1.customer_id_card
              from warehouse_atomic_new_dis_order as a1
			  left outer join (select distinct a2.customer_phone
                               from warehouse_atomic_new_dis_order as a2
                               where a2.apply_state in('已放款','审批通过，等待放款')) a3
					      on a1.customer_phone = a3.customer_phone
              where a1.apply_state = '贷款被拒绝'
			  
                and a3.customer_phone is null
              ) d
distribute by rand()
sort by rand()
limit 1500;