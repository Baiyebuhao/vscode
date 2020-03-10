2019.4.30	何渝宏	客服组	2019.5.7	一次性需求	兴业现金分期	享宇钱包	外呼营销钱伴、信用钱包

2019年4月1日-5月6日，在享宇钱包平台 申请兴业现金分期 授信未通过用户，
剔除已申请信用钱包及钱伴的用户（保留用户姓名，手机号及申请时间）

select a1.mbl_no,a1.data_source,a4.name,max(a1.apply_time)
from warehouse_data_user_review_info a1
left join warehouse_atomic_user_info a4
          on a1.mbl_no = a4.mbl_no
left outer join(select * from warehouse_data_user_review_info a2
			    where a2.product_name in ('现金分期-钱伴','信用钱包'))a3
				on a1.mbl_no = a3.mbl_no
where a1.product_name = '现金分期-兴业消费'
and  a1.data_source = 'xyqb'
and a1.status in ('未通过','不通过')
and a1.apply_time between '2019-04-01' and '2019-05-06'
and a3.mbl_no is null
and a1.mbl_no not in (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe WHERE eff_flg = '1') 
group by a1.mbl_no,a1.data_source,a4.name



验证：
select * from warehouse_data_user_review_info a
where mbl_no in ('MTgzNjcxMjk5NDg=',    
                 'MTgzOTE1NjQyMDM=',    
                 'MTg4MjM3OTE2NzI=',    
                 'MTg4NjcyOTM4NzY=',    
                 'MTg2MDczMjc3NTU=',    
                 'MTg2MzM1NDkwMDk=',    
                 'MTUxMDYwMTIzMzc=',    
                 'MTUxMTA5Mzg3NTM=',    
                 'MTUxMTgwNzcwMjQ=',    
                 'MTMyNDY4NTA4ODY=',    
                 'MTMyNDc1MTE4MzY=',    
                 'MTM2NzY2NjE4MTQ=',    
                 'MTM2NzkyNzYyMzU=',    
                 'MTM2OTQ1OTE1NjY=',    
                 'MTM0Mzc1MTkwODE=',    
                 'MTM1MDUxNzc1MzM=')    





