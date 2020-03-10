533 push需求  徐超 已编码    3、重要不紧急 纪春艳 平台运营 2019.8.20 2019.8.21 
一次性需求 优智借 移动手机贷 移动手机贷 push营销 按序号分包 
1、手机贷平台，8.12-8.20优智借产品已授信未提现用户（剔除放款失败的用户）
2、手机贷平台，8.14-8.20点击好借钱产品未提交申请用户，剔除已申请优智借产品用户

---1、手机贷平台，8.12-8.20优智借产品已授信未提现用户（剔除放款失败的用户）
select distinct a1.mbl_no,
                a1.data_source
				
from warehouse_data_user_review_info a1
left outer join (select  distinct mbl_no,data_source
                 from warehouse_atomic_yzj_withdrawals_result_info a
				 where data_source = 'sjd') a2
            on a1.mbl_no = a2.mbl_no
           and a1.data_source = a2.data_source
		   
where a1.product_name = '优智借'
   and a1.data_source = 'sjd'
   and a1.status = '通过'
   and a1.credit_time between '2019-08-12' and '2019-08-20'
   and a2.mbl_no is null

--2、手机贷平台，8.14-8.20点击好借钱产品未提交申请用户，剔除已申请优智借产品用户
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
  and a1.extractday between '2019-08-14' and '2019-08-20'
  and a2.mbl_no is null
  and a3.mbl_no is null
  
(--入库1
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN254_001',
                "PS",
				'2019-08-21' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (---1、手机贷平台，8.12-8.20优智借产品已授信未提现用户（剔除放款失败的用户）
            select distinct a1.mbl_no,
                            a1.data_source
            				
            from warehouse_data_user_review_info a1
            left outer join (select  distinct mbl_no,data_source
                             from warehouse_atomic_yzj_withdrawals_result_info a
            				 where data_source = 'sjd') a2
                        on a1.mbl_no = a2.mbl_no
                       and a1.data_source = a2.data_source
            		   
            where a1.product_name = '优智借'
               and a1.data_source = 'sjd'
               and a1.status = '通过'
               and a1.credit_time between '2019-08-12' and '2019-08-20'
               and a2.mbl_no is null) AS c
 ON a.mbl_no = c.mbl_no
 WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
 
--PUSH取数1
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN254_001' 
)
(--入库2
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN254_002',
                "PS",
				'2019-08-21' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (--2、手机贷平台，8.14-8.20点击好借钱产品未提交申请用户，剔除已申请优智借产品用户
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
              and a1.extractday between '2019-08-14' and '2019-08-20'
              and a2.mbl_no is null
              and a3.mbl_no is null) AS c
 ON a.mbl_no = c.mbl_no
 WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
 
--PUSH取数2
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN254_002'
)