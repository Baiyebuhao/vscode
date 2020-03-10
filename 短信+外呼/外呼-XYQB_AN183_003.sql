2019.4.30	何渝宏	客服组	2019.5.5	一次性需求	全平台	        享宇钱包	外呼营销钱伴、兴业现金分期

享宇钱包OPPO渠道，2019年4月28日-5月4日注册，
但至今未授信用户，剔除申请钱伴用户（保留姓名，手机号，注册时间）

select a1.mbl_no,a1.data_source,a1.name,a1.registe_date
from warehouse_atomic_user_info a1
left outer join (select * from warehouse_data_user_review_info a2
                 where a2.status = '通过') a3
				 on a1.mbl_no = a3.mbl_no
left outer join (select * from warehouse_data_user_review_info a4
                 where a4.product_name = '现金分期-钱伴') a5
				 on a1.mbl_no = a5.mbl_no
where a1.chan_no = '309'
  and a1.registe_date between '2019-04-28' and '2019-05-04'
  and a1.data_source = 'xyqb'
  and a3.mbl_no is null
  and a5.mbl_no is null
  and a1.mbl_no not in (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe WHERE eff_flg = '1') 
  
验证：
select *                            
from warehouse_data_user_review_info
where mbl_no in ('MTM2OTI2MzI4MjU=',
                 'MTM3MTk4NDg4NTM=',
                 'MTM3NTMxNDM1NTE=',
                 'MTM3NjkyOTIxMTU=',
                 'MTM4MDI4NTE4NDU=',
                 'MTM4MDY3NzEzMjQ=',
                 'MTM4Mjg3MTM0MDc=',
                 'MTM4Mzg1OTg2NTQ=',
                 'MTM4NjYxMzA3NDI=',
                 'MTM5MDYwNzQyODE=',
                 'MTM5MjQxMTQwNzY=',
                 'MTM5MjcxNzc4OTk=',
                 'MTM5NDQ5NDIzNzY=',
                 'MTM5NTEwMjIzODU=',
                 'MTM5NTI5NzgyOTQ=',
                 'MTM5NTIwODk3MjQ=',
                 'MTM5NTk4MDg3NTY=',
                 'MTM5NjAxNzAwODc=',
                 'MTM5NjkzNjg2MzE=',
                 'MTM5ODU0MzI1OTQ=',
                 'MTM5ODcyODkzMDc=',
                 'MTMwMjE2ODY5NzU=',
                 'MTMwMzIzNjI5MzM=')

