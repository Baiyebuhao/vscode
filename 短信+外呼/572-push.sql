572 push需求  徐超     重要不紧急 纪春艳 平台运营 2019.9.2 2019.9.3 
一次性需求 优智借/信用钱包 移动手机贷 移动手机贷 push营销 按产品分包 
1、8.1-8.26日手机贷平台，优智借产品已授信未提现用户，剔除放款失败的用户;
2、8.1-8.31日手机贷平台，信用钱包产品已授信未提现用户
---1、8.1-8.26日手机贷平台，优智借产品已授信未提现用户，剔除放款失败的用户
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
   and a1.credit_time between '2019-08-01' and '2019-08-26'
   and a2.mbl_no is null

--2、8.1-8.31日手机贷平台，信用钱包产品已授信未提现用户
select distinct a1.mbl_no,
                a1.data_source
from warehouse_data_user_review_info a1
left outer join 
    (select mbl_no,data_source 
     from warehouse_data_user_withdrawals_info a
     where data_source = 'sjd'
       and product_name = '信用钱包'
       and cash_amount > '0') a2
  on a1.data_source =a2.data_source
 and a1.mbl_no = a2.mbl_no
where a1.data_source = 'sjd'
  and a1.product_name = '信用钱包'
  and a1.status = '通过'
  and a1.credit_time between '2019-08-01' and '2019-08-31'
  and a2.mbl_no is null

--入库
(--入库1
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN274_001',
                "PS",
				'2019-09-04' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (---1、8.1-8.26日手机贷平台，优智借产品已授信未提现用户，剔除放款失败的用户
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
               and a1.credit_time between '2019-08-01' and '2019-08-26'
               and a2.mbl_no is null
			) AS c
 ON a.mbl_no = c.mbl_no
 WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
 
--PUSH取数1
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN274_001' 
)

(--入库2
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN274_002',
                "PS",
				'2019-09-04' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (--2、8.1-8.31日手机贷平台，信用钱包产品已授信未提现用户
            select distinct a1.mbl_no,
                            a1.data_source
            from warehouse_data_user_review_info a1
            left outer join 
                (select mbl_no,data_source 
                 from warehouse_data_user_withdrawals_info a
                 where data_source = 'sjd'
                   and product_name = '信用钱包'
                   and cash_amount > '0') a2
              on a1.data_source =a2.data_source
             and a1.mbl_no = a2.mbl_no
            where a1.data_source = 'sjd'
              and a1.product_name = '信用钱包'
              and a1.status = '通过'
              and a1.credit_time between '2019-08-01' and '2019-08-31'
              and a2.mbl_no is null
			) AS c
 ON a.mbl_no = c.mbl_no
 WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
 
--PUSH取数2
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN274_002' 
)