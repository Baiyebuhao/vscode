423 push需求  徐超 已编码   3、重要不紧急 2019.7.1 纪春艳 平台运营 2019.7.3 
一次性需求 优智借 手机贷 享宇钱包 push营销 按序号分包 

1、---XYQB_RN218_001
手机贷平台6.24-6.30日点击钱伴未提现用户，剔除已申请优智借产品用户
select a1.mbl_no
from 
(select distinct mbl_no
from warehouse_newtrace_click_record b1
where extractday between '2019-06-24' and '2019-06-30'
and platform = 'sjd'
and button_enname = 'apply'
and product_name = '钱伴'
UNION
select distinct mbl_no
from warehouse_atomic_user_action b2
where sys_id = 'sjd'
and extractday between '2019-06-24' and '2019-06-30'
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
left outer join 
                (select distinct mbl_no
                from warehouse_data_user_review_info a
                where product_name = '优智借'
                ) a3
         on a1.mbl_no = a3.mbl_no
where a2.mbl_no is null
  and a3.mbl_no is null


2、---XYQB_RN218_002   
手机贷平台，历史点击优智借banner未提交申请用户
select distinct a1.mbl_no
from warehouse_newtrace_click_record a1
left outer join 
               (select distinct mbl_no
               from warehouse_data_user_review_info a
               where product_name = '优智借') a2
         on a1.mbl_no = a2.mbl_no
where a1.platform = 'sjd'
  and a1.page_enname = 'supermarket'
  and a1.button_enname = 'banner'
  and a1.ad_name = '优智借'
  and a1.extractday > '2019-05-01'
  and a2.mbl_no is null

3、---XYQB_RN218_003
手机贷平台，6.24-6.30日申请好借钱/兴业未授信用户，剔除已申请优智借产品用户

select distinct a1.mbl_no
from warehouse_data_user_review_info a1
left outer join
                (select distinct mbl_no
                from warehouse_data_user_review_info a
                where product_name in ('现金分期-招联','现金分期-兴业消费')
                  and status = '通过'
                ) a2
		 on a1.mbl_no = a2.mbl_no
left outer join 
               (select distinct mbl_no
               from warehouse_data_user_review_info a
               where product_name = '优智借') a3
         on a1.mbl_no = a3.mbl_no	
where a1.product_name in ('现金分期-招联','现金分期-兴业消费')
  and a1.data_source = 'sjd'
  and a1.apply_time between '2019-06-04' and '2019-06-30'
  and a2.mbl_no is null
  and a3.mbl_no is null
---
---入库1
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'xyqb' as data_source, 
                a.cus_no,
                'XYQB_RN218_001',
                "PS",
				'2019-07-04' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (select a1.mbl_no
            from 
            (select distinct mbl_no
            from warehouse_newtrace_click_record b1
            where extractday between '2019-06-24' and '2019-06-30'
            and platform = 'sjd'
            and button_enname = 'apply'
            and product_name = '钱伴'
            UNION
            select distinct mbl_no
            from warehouse_atomic_user_action b2
            where sys_id = 'sjd'
            and extractday between '2019-06-24' and '2019-06-30'
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
            left outer join 
                            (select distinct mbl_no
                            from warehouse_data_user_review_info a
                            where product_name = '优智借'
                            ) a3
                     on a1.mbl_no = a3.mbl_no
            where a2.mbl_no is null
              and a3.mbl_no is null) AS c
 ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
)

---
---入库2
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'xyqb' as data_source, 
                a.cus_no,
                'XYQB_RN218_002',
                "PS",
				'2019-07-04' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (select distinct a1.mbl_no
            from warehouse_newtrace_click_record a1
            left outer join 
                           (select distinct mbl_no
                           from warehouse_data_user_review_info a
                           where product_name = '优智借') a2
                     on a1.mbl_no = a2.mbl_no
            where a1.platform = 'sjd'
              and a1.page_enname = 'supermarket'
              and a1.button_enname = 'banner'
              and a1.ad_name = '优智借'
              and a1.extractday > '2019-05-01'
              and a2.mbl_no is null) AS c
             ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
)

---
---入库3
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'xyqb' as data_source, 
                a.cus_no,
                'XYQB_RN218_003',
                "PS",
				'2019-07-04' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (select distinct a1.mbl_no
            from warehouse_data_user_review_info a1
            left outer join
                            (select distinct mbl_no
                            from warehouse_data_user_review_info a
                            where product_name in ('现金分期-招联','现金分期-兴业消费')
                              and status = '通过'
                            ) a2
            		 on a1.mbl_no = a2.mbl_no
            left outer join 
                           (select distinct mbl_no
                           from warehouse_data_user_review_info a
                           where product_name = '优智借') a3
                     on a1.mbl_no = a3.mbl_no	
            where a1.product_name in ('现金分期-招联','现金分期-兴业消费')
              and a1.data_source = 'sjd'
              and a1.apply_time between '2019-06-04' and '2019-06-30'
              and a2.mbl_no is null
              and a3.mbl_no is null) AS c
			  
             ON a.mbl_no = c.mbl_no    
WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
)

