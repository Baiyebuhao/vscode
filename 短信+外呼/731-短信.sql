731 短信需求  徐超     3、重要不紧急 纪春艳 平台运营 2019.11.15 2019.11.15 
一次性需求 趣借钱 移动手机贷 移动手机贷 短信营销  
近3个月已实名用户，测评资料中填写大专及以上的联通用户，剔除已申请过趣借钱产品的用户，剔除已授信过马上随借随还产品的用户  

select a1.mbl_no,
       a1.data_source
from (select mbl_no,data_source
      from warehouse_atomic_user_info a
	  where a.data_source = 'sjd'
        and a.isp = '联通') a1
join (select * 
      from warehouse_atomic_all_process_info a
	  where a.action_name = '实名'
	    and a.data_source = 'sjd'
        and a.action_date between '2019-08-16' and '2019-11-16') a2
  on a1.mbl_no = a2.mbl_no 
---评测填写填写大专及以上
join (select distinct mbl_no
      from warehouse_atomic_evaluation_process_info a
      where que_id = '2015081218010001'
        and TRIM(OPT_SEQ) in ('3','4','5')
        and data_source = 'sjd') a3
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
---剔除已授信过马上随借随还产品的用户 
left outer join  
      (select distinct mbl_no 
	   from warehouse_data_user_review_info a1
	   where product_name = '随借随还-马上'
	     and status = '通过'
	     and amount > 0
	   ) a5
	 on a1.mbl_no = a5.mbl_no
where a4.mbl_no is null
  and a5.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');






(---
desc warehouse_atomic_evaluation_answer
que_id = '2015081218010001'
opt_seq = '3'
opt_cont = '大专'

desc warehouse_atomic_evaluation_quest 
que_id = '2015081218010001'
que_seq = '8'
que_tit = '您的教育水平'
que_sts = '1'

desc warehouse_atomic_evaluation_process_info
max(jrn_no)
que_id = '2015081218010001'
opt_seq = '3'
)
