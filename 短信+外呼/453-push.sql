453 push需求  徐超 已编码   3、重要不紧急 2019.7.15 纪春艳 平台运营 2019.7.17 一次性需求 
优智借 移动手机贷 享宇钱包 push营销 放一个包里 

7.8-7.14上周点击钱伴未提现用户；
7.8-7.14点击优智借banner未提交申请用户；
7.8-7.14好借钱/兴业未授信用户；
(三个条件的用户合并后剔除重复的)

1.7.8-7.14上周点击钱伴未提现用户；
select a1.mbl_no
from 
(select distinct mbl_no
from warehouse_newtrace_click_record b1
where extractday between '2019-07-08' and '2019-07-14'
and platform = 'sjd'
and button_enname = 'apply'
and product_name = '钱伴'
UNION
select distinct mbl_no
from warehouse_atomic_user_action b2
where sys_id = 'sjd'
and extractday between '2019-07-08' and '2019-07-14'
and event_id = 'product'
and product_name = '钱伴') a1
left outer join 
                (select distinct mbl_no
                from warehouse_data_user_withdrawals_info a
                where data_source = 'sjd'
                  and product_name = '钱伴'
                  and cash_amount > '0'
                ) a2
         on a1.mbl_no = a2.mbl_no
where a2.mbl_no is null

2.7.8-7.14点击优智借banner未提交申请用户；
select distinct a1.mbl_no
from warehouse_newtrace_click_record a1
left outer join 
               (select distinct mbl_no
               from warehouse_data_user_review_info a
               where product_name = '优智借'
			     and apply_time >= '2019-07-08') a2
         on a1.mbl_no = a2.mbl_no
where a1.platform = 'sjd'
  and a1.page_enname = 'supermarket'
  and a1.button_enname = 'banner'
  and a1.ad_name = '优智借'
  and a1.extractday between '2019-07-08' and '2019-07-14'
  and a2.mbl_no is null
 
3.7.8-7.14好借钱/兴业未授信用户；
select distinct a1.mbl_no
from warehouse_data_user_review_info a1
left outer join
                (select distinct mbl_no
                from warehouse_data_user_review_info a
                where product_name in ('现金分期-招联','现金分期-兴业消费')
                  and status = '通过'
				  and data_source = 'sjd') a2
		 on a1.mbl_no = a2.mbl_no
where a1.product_name in ('现金分期-招联','现金分期-兴业消费')
  and a1.data_source = 'sjd'
  and a1.apply_time between '2019-07-08' and '2019-07-14'
  and a2.mbl_no is null
  
合并
(select a1.mbl_no
from 
(select distinct mbl_no
from warehouse_newtrace_click_record b1
where extractday between '2019-07-08' and '2019-07-14'
and platform = 'sjd'
and button_enname = 'apply'
and product_name = '钱伴'
UNION
select distinct mbl_no
from warehouse_atomic_user_action b2
where sys_id = 'sjd'
and extractday between '2019-07-08' and '2019-07-14'
and event_id = 'product'
and product_name = '钱伴') a1
left outer join 
                (select distinct mbl_no
                from warehouse_data_user_withdrawals_info a
                where data_source = 'sjd'
                  and product_name = '钱伴'
                  and cash_amount > '0'
                ) a2
         on a1.mbl_no = a2.mbl_no
where a2.mbl_no is null

union

select distinct a1.mbl_no
from warehouse_newtrace_click_record a1
left outer join 
               (select distinct mbl_no
               from warehouse_data_user_review_info a
               where product_name = '优智借'
			     and apply_time >= '2019-07-08') a2
         on a1.mbl_no = a2.mbl_no
where a1.platform = 'sjd'
  and a1.page_enname = 'supermarket'
  and a1.button_enname = 'banner'
  and a1.ad_name = '优智借'
  and a1.extractday between '2019-07-08' and '2019-07-14'
  and a2.mbl_no is null
 
union

select distinct a1.mbl_no
from warehouse_data_user_review_info a1
left outer join
                (select distinct mbl_no
                from warehouse_data_user_review_info a
                where product_name in ('现金分期-招联','现金分期-兴业消费')
                  and status = '通过'
				  and data_source = 'sjd') a2
		 on a1.mbl_no = a2.mbl_no
where a1.product_name in ('现金分期-招联','现金分期-兴业消费')
  and a1.data_source = 'sjd'
  and a1.apply_time between '2019-07-08' and '2019-07-14'
  and a2.mbl_no is null)


入库
(INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'xyqb' as data_source, 
                a.cus_no,
                'XYQB_RN225_001',
                "PS",
				'2019-07-16' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (select a1.mbl_no
            from 
            (select distinct mbl_no
            from warehouse_newtrace_click_record b1
            where extractday between '2019-07-08' and '2019-07-14'
            and platform = 'sjd'
            and button_enname = 'apply'
            and product_name = '钱伴'
            UNION
            select distinct mbl_no
            from warehouse_atomic_user_action b2
            where sys_id = 'sjd'
            and extractday between '2019-07-08' and '2019-07-14'
            and event_id = 'product'
            and product_name = '钱伴') a1
            left outer join 
                            (select distinct mbl_no
                            from warehouse_data_user_withdrawals_info a
                            where data_source = 'sjd'
                              and product_name = '钱伴'
                              and cash_amount > '0'
                            ) a2
                     on a1.mbl_no = a2.mbl_no
            where a2.mbl_no is null
            
            union
            
            select distinct a1.mbl_no
            from warehouse_newtrace_click_record a1
            left outer join 
                           (select distinct mbl_no
                           from warehouse_data_user_review_info a
                           where product_name = '优智借'
            			     and apply_time >= '2019-07-08') a2
                     on a1.mbl_no = a2.mbl_no
            where a1.platform = 'sjd'
              and a1.page_enname = 'supermarket'
              and a1.button_enname = 'banner'
              and a1.ad_name = '优智借'
              and a1.extractday between '2019-07-08' and '2019-07-14'
              and a2.mbl_no is null
             
            union
            
            select distinct a1.mbl_no
            from warehouse_data_user_review_info a1
            left outer join
                            (select distinct mbl_no
                            from warehouse_data_user_review_info a
                            where product_name in ('现金分期-招联','现金分期-兴业消费')
                              and status = '通过'
            				  and data_source = 'sjd') a2
            		 on a1.mbl_no = a2.mbl_no
            where a1.product_name in ('现金分期-招联','现金分期-兴业消费')
              and a1.data_source = 'sjd'
              and a1.apply_time between '2019-07-08' and '2019-07-14'
              and a2.mbl_no is null) AS c
 ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='sjd'  and length(c.mbl_no) > 4)