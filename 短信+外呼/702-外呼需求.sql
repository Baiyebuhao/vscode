702 外呼需求  赵小庆     
1、紧急且重要 何渝宏 客服部 2019.11.5 2019.11.6 
一次性需求 趣借钱 移动手机贷 移动手机贷 外呼调研 所有用户 
在2019年11月4日-5日注册，有点击立刻申请跳转到申请授信页面，但无任何点击行为的用户，剔除历史以来申请过该产品的用户
（保留用户姓名、手机号、操作时间）

select distinct a1.data_source,
       a1.mbl_no,
	   a1.name,
	   a1.registe_date
from warehouse_atomic_user_info a1
join warehouse_data_user_action_day a2
  on a1.mbl_no = a2.mbl_no
 and a1.data_source = a2.data_source
join (SELECT DISTINCT a.phone_number as mbl_no
      FROM
        (SELECT *
         FROM warehouse_atomic_newframe_burypoint_buttonoperations
         WHERE substr(extractday,1,10) between '2019-11-05' and '2019-11-06') a
      LEFT JOIN
        (SELECT *
         FROM warehouse_atomic_newframe_burypoint_pageoperations
         WHERE substr(extractday,1,10) between '2019-11-05' and '2019-11-06') b ON a.start_id = b.start_id
      WHERE b.product_id ='60000001'
        and a.pagenamecn = '申请授信'
      ) a3
	on a1.mbl_no = a3.mbl_no
left outer join 
     (SELECT DISTINCT a.phone_number as mbl_no
      FROM
        (SELECT *
         FROM warehouse_atomic_newframe_burypoint_buttonoperations
         WHERE substr(extractday,1,10) between '2019-11-05' and '2019-11-06') a
      LEFT JOIN
        (SELECT *
         FROM warehouse_atomic_newframe_burypoint_pageoperations
         WHERE substr(extractday,1,10) between '2019-11-05' and '2019-11-06') b ON a.start_id = b.start_id
      WHERE b.product_id ='60000001'
        and a.pagenamecn <> '申请授信'
	  ) a4
	on a1.mbl_no = a4.mbl_no
left outer join 
     (SELECT mbl_no
        FROM
           (SELECT c.mbl_no,
                   b.prod_name,
                   f.status AS check_status
            FROM warehouse_atomic_api_p_user_prod_inf AS a
            JOIN warehouse_atomic_api_p_prod_inf AS b ON a.prod_id=b.id
            JOIN warehouse_atomic_api_p_user_info AS c ON a.user_id=c.id
            LEFT JOIN warehouse_atomic_api_p_order_inf AS e ON a.id=e.user_prod_id
            LEFT JOIN warehouse_atomic_api_p_apply_record AS f ON e.id=f.order_id) b1
         WHERE b1.check_status IN(1,2,0)
           AND b1.prod_name = '趣借钱'
      union 
      SELECT mbl_no
        FROM warehouse_data_user_review_info
       WHERE product_name='趣借钱'
	     and data_source = 'sjd'
         AND substr(apply_time,1,10) < '2019-11-05'
	  ) a5
	  on a1.mbl_no = a5.mbl_no
where a1.data_source = 'sjd'
  and a1.registe_date between '2019-11-05' and '2019-11-06'
  and a2.applypv > 0
  and a2.extractday between '2019-11-05' and '2019-11-06'
  and a4.mbl_no is null
  and a5.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe WHERE eff_flg = '1')

