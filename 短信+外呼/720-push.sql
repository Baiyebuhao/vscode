720 push需求  徐超 已编码    3、重要不紧急 纪春艳 平台运营 2019.11.12 2019.11.13 
一次性需求 趣借钱 移动手机贷 移动手机贷 push营销  
本月点击过趣借钱未提交申请的用户
select distinct a1.mbl_no
from warehouse_data_user_action_day a1
left outer join 
   (SELECT c.mbl_no,
           b.prod_name,
           f.status AS check_status,
           substr(f.check_time,1,10) as s_date
    FROM warehouse_atomic_api_p_user_prod_inf AS a
    JOIN warehouse_atomic_api_p_prod_inf AS b ON a.prod_id=b.id
    JOIN warehouse_atomic_api_p_user_info AS c ON a.user_id=c.id
    LEFT JOIN warehouse_atomic_api_p_order_inf AS e ON a.id=e.user_prod_id
    LEFT JOIN warehouse_atomic_api_p_apply_record AS f ON e.id=f.order_id
    where b.platform_id = '1'
	  and b.prod_name = '趣借钱') a2
    on a1.mbl_no = a2.mbl_no
where a1.product_name = '趣借钱'
  and a1.data_source = 'sjd'
  and a1.extractday between '2019-11-01' and '2019-11-31'
  and a2.mbl_no is null

---push入库
--入库1
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN323_001',
                "PS",
				'2019-11-13' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (select distinct a1.mbl_no
            from warehouse_data_user_action_day a1
            left outer join 
               (SELECT c.mbl_no,
                       b.prod_name,
                       f.status AS check_status,
                       substr(f.check_time,1,10) as s_date
                FROM warehouse_atomic_api_p_user_prod_inf AS a
                JOIN warehouse_atomic_api_p_prod_inf AS b ON a.prod_id=b.id
                JOIN warehouse_atomic_api_p_user_info AS c ON a.user_id=c.id
                LEFT JOIN warehouse_atomic_api_p_order_inf AS e ON a.id=e.user_prod_id
                LEFT JOIN warehouse_atomic_api_p_apply_record AS f ON e.id=f.order_id
                where b.platform_id = '1'
            	  and b.prod_name = '趣借钱') a2
                on a1.mbl_no = a2.mbl_no
            where a1.product_name = '趣借钱'
              and a1.data_source = 'sjd'
              and a1.extractday between '2019-11-01' and '2019-11-31'
              and a2.mbl_no is null) AS c
 ON a.mbl_no = c.mbl_no
 WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
 
--PUSH取数1
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN323_001' 
