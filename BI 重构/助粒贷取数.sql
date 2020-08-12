---助粒贷取数
SELECT a.mbl_no,
                    CASE
                    WHEN a.platform_id=1 THEN 'sjd'
                    WHEN a.platform_id=2 THEN 'jry'
                    WHEN a.platform_id=4 THEN 'xyqb'
                    END platform,
                    substr(d.create_time,1,10) AS apply_time,
                    --授信记录创建时间，新用户的授信记录创建时间与授信时间check_time是同一天
                    --老用户可能现有check_time，再有create_time
                    substr(d.check_time,1,10) as credit_time,
                    '助粒贷' AS product_name,
                    if(d.status=1,'通过','未通过') AS status,
                    if(d.status=1,cast(int(d.check_amount) AS decimal(12,2))/100,0) AS amount
   FROM warehouse_atomic_api_p_user_info a
   JOIN warehouse_atomic_api_p_user_prod_inf b ON a.id=b.user_id
   JOIN warehouse_atomic_api_p_order_inf c ON b.id=c.user_prod_id
   JOIN warehouse_atomic_api_p_apply_record d ON c.id=d.order_id
   JOIN warehouse_atomic_api_p_prod_inf e ON b.prod_id=e.id
   WHERE e.prod_name='助粒贷' 