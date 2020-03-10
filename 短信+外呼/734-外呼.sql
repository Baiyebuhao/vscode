734 外呼需求  徐超     3、重要不紧急 何渝宏 客服部 2019.11.18 2019.11.18 
一次性需求 趣借钱 移动手机贷 移动手机贷 外呼营销  
移动手机贷上，历史以来在钱伴成功提过现，且在11月10日-18日有过登录行为的用户，剔除申请过趣借钱的用户（保留用户姓名、手机号、授信时间、授信额度）

select a1.mbl_no,
       a1.data_source,
	   a1.name,
	   a5.credit_time,
	   a5.amount
from warehouse_atomic_user_info a1
---在钱伴成功提过现
join 
(select distinct mbl_no,data_source
 from warehouse_data_user_withdrawals_info a
 where data_source = 'sjd'
   and product_name = '现金分期-钱伴'
   and cash_amount > '0') a2
 on a1.mbl_no = a2.mbl_no
and a1.data_source = a2.data_source
---在11月10日-18日有过登录行为的用户
join 
(select distinct mbl_no
from warehouse_data_user_action_day b1
where extractday between '2019-11-10' and '2019-11-18'
and data_source = 'sjd'
) a3
on a1.mbl_no = a3.mbl_no
---剔除已申请过趣借钱产品的用户
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
	  and b.prod_name = '趣借钱') a4
    on a1.mbl_no = a4.mbl_no
---取授信时间、授信额度（最近一次）
left join (select distinct mbl_no,credit_time,amount
           from 
           (select mbl_no,
                   amount,
           		credit_time,
           	    Row_Number() OVER (partition by mbl_no ORDER BY credit_time desc) rank     
           from warehouse_data_user_review_info a
           where product_name = '现金分期-钱伴'
             and data_source = 'sjd'
             and status = '通过') b
           where b.rank = '1') a5
		on a1.mbl_no = a5.mbl_no
where a4.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe WHERE eff_flg = '1')


