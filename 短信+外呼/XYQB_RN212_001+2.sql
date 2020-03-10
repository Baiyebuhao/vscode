push营销  移动手机贷
1、2019年手机贷平台，申请马上随借随还授信未提现用户，剔除（手机贷+享宇钱包平台）已申请信用钱包产品用户；
2、2019年手机贷平台，申请马上随借随还审核不通过用户，剔除（手机贷+享宇钱包平台）已申请优智借产品用户；

---1.2019年手机贷平台，申请马上随借随还授信未提现用户，剔除（手机贷+享宇钱包平台）已申请信用钱包产品用户；
----
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_review_info a1
left outer join(select mbl_no,data_source 
                from warehouse_data_user_withdrawals_info a
                where product_name = '随借随还-马上'
				  and data_source = 'sjd'
				  and cash_time between '2019-01-01' and '2019-12-31') a2
		on a1.mbl_no = a2.mbl_no
	   and a1.data_source = a2.data_source
			   
left outer join(select mbl_no,data_source 
                from warehouse_data_user_review_info a
			    where product_name = '信用钱包'
				and data_source in ('sjd','xyqb'))a3
		on a1.mbl_no = a3.mbl_no
where a1.product_name = '随借随还-马上'
  and a1.data_source = 'sjd'
  and a1.status = '通过'
  and a1.apply_time between '2019-01-01' and '2019-12-31'
  and a2.mbl_no is null
  and a3.mbl_no is null
  and a1.mbl_no like 'MT%'
  
---2.2019年手机贷平台，申请马上随借随还审核不通过用户，剔除（手机贷+享宇钱包平台）已申请优智借产品用户；
----
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_review_info a1
left outer join(select mbl_no,data_source 
                from warehouse_data_user_review_info a
			    where product_name = '随借随还-马上'
				and data_source = 'sjd'
				and status = '通过')a2
		on a1.mbl_no = a2.mbl_no
	   and a1.data_source = a2.data_source

left outer join(select mbl_no,data_source 
                from warehouse_data_user_review_info a
			    where product_name = '优智借'
				and data_source in ('sjd','xyqb'))a3
		on a1.mbl_no = a3.mbl_no

join (select distinct mbl_no
           from warehouse_newtrace_click_record b1
           where extractday between '2019-03-01' and '2019-06-31'
           and platform = 'sjd'
           UNION
           select distinct mbl_no
           from warehouse_atomic_user_action b2
           where sys_id = 'sjd'
           and extractday between '2019-03-01' and '2019-06-31') a4
   on a1.mbl_no = a4.mbl_no

where a1.product_name = '随借随还-马上'
  and a1.data_source = 'sjd'
  and a1.apply_time between '2019-01-01' and '2019-12-31'
  and a2.mbl_no is null
  and a3.mbl_no is null
  and a1.mbl_no like 'MT%'

---1
---
(INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'xyqb' as data_source, 
                a.cus_no,
                'XYQB_RN212_001',
                "PS",
				'2019-06-17' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (select distinct a1.mbl_no,a1.data_source
            from warehouse_data_user_review_info a1
            left outer join(select mbl_no,data_source 
                            from warehouse_data_user_withdrawals_info a
                            where product_name = '随借随还-马上'
            				  and data_source = 'sjd'
            				  and cash_time between '2019-01-01' and '2019-12-31') a2
            		on a1.mbl_no = a2.mbl_no
            	   and a1.data_source = a2.data_source
            			   
            left outer join(select mbl_no,data_source 
                            from warehouse_data_user_review_info a
            			    where product_name = '信用钱包'
            				and data_source in ('sjd','xyqb'))a3
            		on a1.mbl_no = a3.mbl_no
            where a1.product_name = '随借随还-马上'
              and a1.data_source = 'sjd'
              and a1.status = '通过'
              and a1.apply_time between '2019-01-01' and '2019-12-31'
              and a2.mbl_no is null
              and a3.mbl_no is null
			  and a1.mbl_no like 'MT%') AS c
 ON a.mbl_no = c.mbl_no  

WHERE a.data_source='sjd'  and length(c.mbl_no) > 4)

---2
---
(INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'xyqb' as data_source, 
                a.cus_no,
                'XYQB_RN212_002',
                "PS",
				'2019-06-17' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (select distinct a1.mbl_no,a1.data_source
            from warehouse_data_user_review_info a1
            left outer join(select mbl_no,data_source 
                            from warehouse_data_user_review_info a
            			    where product_name = '随借随还-马上'
            				and data_source = 'sjd'
            				and status = '通过')a2
            		on a1.mbl_no = a2.mbl_no
            	   and a1.data_source = a2.data_source
            
            left outer join(select mbl_no,data_source 
                            from warehouse_data_user_review_info a
            			    where product_name = '优智借'
            				and data_source in ('sjd','xyqb'))a3
            		on a1.mbl_no = a3.mbl_no
join (select distinct mbl_no
      from warehouse_newtrace_click_record b1
      where extractday between '2019-03-01' and '2019-06-31'
      and platform = 'sjd'
      UNION
      select distinct mbl_no
      from warehouse_atomic_user_action b2
      where sys_id = 'sjd'
      and extractday between '2019-03-01' and '2019-06-31') a4
 on a1.mbl_no = a4.mbl_no
            
            where a1.product_name = '随借随还-马上'
              and a1.data_source = 'sjd'
              and a1.apply_time between '2019-01-01' and '2019-12-31'
              and a2.mbl_no is null
              and a3.mbl_no is null
			  and a1.mbl_no like 'MT%') AS c
 ON a.mbl_no = c.mbl_no  

WHERE a.data_source='sjd'  and length(c.mbl_no) > 4)
  
  
  
  
  
  
  