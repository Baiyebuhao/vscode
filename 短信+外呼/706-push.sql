706 push需求  徐超 已编码    3、重要不紧急 纪春艳 平台运营 2019.11.7 2019.11.7 
一次性需求 趣借钱(api) 移动手机贷 移动手机贷 push营销  
9.24日至今已授信未提现的用户（额度在有效期内）  

SELECT distinct a1.mbl_no
FROM
   (SELECT c.mbl_no,
           b.prod_name,
           f.status AS check_status,
           substr(f.check_time,1,10) as s_date
    FROM warehouse_atomic_api_p_user_prod_inf AS a
    JOIN warehouse_atomic_api_p_prod_inf AS b ON a.prod_id=b.id
    JOIN warehouse_atomic_api_p_user_info AS c ON a.user_id=c.id
    LEFT JOIN warehouse_atomic_api_p_order_inf AS e ON a.id=e.user_prod_id
    LEFT JOIN warehouse_atomic_api_p_apply_record AS f ON e.id=f.order_id
    where substr(f.check_time,1,10) between '2019-09-24' and '2019-11-08'
      and b.platform_id = '1') a1
left outer join (select distinct mbl_no,data_source
                 from warehouse_data_user_withdrawals_info a
				 where data_source = 'sjd'
				   and product_name = '趣借钱'
				   and cash_amount > 0) a2
            on a1.mbl_no = a2.mbl_no	  
WHERE a1.check_status= '1'
  AND a1.prod_name = '趣借钱'
  and a2.mbl_no is null
  
---push入库
--入库1
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN320_001',
                "PS",
				'2019-11-08' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (SELECT distinct a1.mbl_no
            FROM
               (SELECT c.mbl_no,
                       b.prod_name,
                       f.status AS check_status,
                       substr(f.check_time,1,10) as s_date
                FROM warehouse_atomic_api_p_user_prod_inf AS a
                JOIN warehouse_atomic_api_p_prod_inf AS b ON a.prod_id=b.id
                JOIN warehouse_atomic_api_p_user_info AS c ON a.user_id=c.id
                LEFT JOIN warehouse_atomic_api_p_order_inf AS e ON a.id=e.user_prod_id
                LEFT JOIN warehouse_atomic_api_p_apply_record AS f ON e.id=f.order_id
                where substr(f.check_time,1,10) between '2019-09-24' and '2019-11-08'
                  and b.platform_id = '1') a1
            left outer join (select distinct mbl_no,data_source
                             from warehouse_data_user_withdrawals_info a
            				 where data_source = 'sjd'
            				   and product_name = '趣借钱'
            				   and cash_amount > 0) a2
                        on a1.mbl_no = a2.mbl_no	  
            WHERE a1.check_status= '1'
              AND a1.prod_name = '趣借钱'
              and a2.mbl_no is null) AS c
 ON a.mbl_no = c.mbl_no
 WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
 
--PUSH取数1
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN320_001' 