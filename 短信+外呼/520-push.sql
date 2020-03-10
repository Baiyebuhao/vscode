520 push需求  徐超 已编码  3、重要不紧急 纪春艳 平台运营 2019.8.14 2019.8.15 
一次性需求 优智借 移动手机贷 移动手机贷 push营销
手机贷平台，8.5-8.13点击好借钱产品未提交申请用户，剔除已申请优智借产品用户
--SJD_RN250_001
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_action_day a1
left outer join 
               (select distinct mbl_no
                from warehouse_data_user_review_info a
                where product_name = '现金分期-招联'
			      and data_source = 'sjd') a2
         on a1.mbl_no = a2.mbl_no
left outer join 
               (select distinct mbl_no
                from warehouse_data_user_review_info a
                where product_name = '优智借'
			      and data_source = 'sjd') a3
         on a1.mbl_no = a3.mbl_no


where a1.data_source = 'sjd'
  and a1.product_name = '现金分期-招联'
  and a1.extractday between '2019-08-05' and '2019-08-13' 
  and a2.mbl_no is null
  and a3.mbl_no is null
  
--入库
入库：
(INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN250_001',
                "PS",
				'2019-08-16' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (select distinct a1.mbl_no,a1.data_source
            from warehouse_data_user_action_day a1
            left outer join 
                           (select distinct mbl_no
                            from warehouse_data_user_review_info a
                            where product_name = '现金分期-招联'
            			      and data_source = 'sjd') a2
                     on a1.mbl_no = a2.mbl_no
            left outer join 
                           (select distinct mbl_no
                            from warehouse_data_user_review_info a
                            where product_name = '优智借'
            			      and data_source = 'sjd') a3
                     on a1.mbl_no = a3.mbl_no
            
            
            where a1.data_source = 'sjd'
              and a1.product_name = '现金分期-招联'
              and a1.extractday between '2019-08-05' and '2019-08-13' 
              and a2.mbl_no is null
              and a3.mbl_no is null) AS c
 ON a.mbl_no = c.mbl_no
 WHERE a.data_source='sjd'  and length(c.mbl_no) > 4)
 
--PUSH取数
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN250_001'