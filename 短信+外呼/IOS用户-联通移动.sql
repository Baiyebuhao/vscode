240	取数需求	徐超	1、紧急且重要	2019.5.7	刘虹	移动手机贷	2019.5.8	一次性需求	全平台	移动手机贷	短信营销	

1.2019年4月24日-5月7日iOS端新注册用户，只取联通和移动
2.2019年4月24日-5月7日在移动手机贷app中有过登录行为的Ios用户，剔除2019年4月24日-5月7日iOS端新注册用户，只取联通和移动
3.2019年1月1日-5月6日实名未申请兴业消费的用户，只取联通和移动	
---------	
---------1.2019年4月24日-5月7日iOS端新注册用户，只取联通和移动
select data_source,mbl_no
from warehouse_atomic_user_info a
where registe_date between '2019-04-24' and '2019-05-07'
and isp in ('联通','移动')
and chan_no_desc in ('苹果','苹果市场')
and data_source = 'sjd'
and a.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');
------------
------------2.2019年4月24日-5月7日在移动手机贷app中有过登录行为的Ios用户，剔除2019年4月24日-5月7日iOS端新注册用户，只取联通和移动
SELECT a2.data_source,
       a1.mbl_no
FROM
  (SELECT DISTINCT mbl_no
   FROM warehouse_newtrace_click_record b1
   WHERE extractday BETWEEN '2019-04-24' AND '2019-05-07'
     AND platform = 'sjd'
   UNION SELECT DISTINCT mbl_no
   FROM warehouse_atomic_user_action b2
   WHERE sys_id = 'sjd'
     AND extractday BETWEEN '2019-04-24' AND '2019-05-07' ) a1
JOIN warehouse_atomic_user_info a2 ON a1.mbl_no = a2.mbl_no
WHERE a2.data_source = 'sjd'
  AND a2.chan_no_desc IN ('苹果','苹果市场')
  AND isp IN ('联通','移动')
  AND registe_date < '2019-04-24'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');
--------- 
---------3.2019年1月1日-5月6日实名未申请兴业消费的用户，只取联通和移动	 
select a.data_source, 
       a.mbl_no,
	   a.isp
from warehouse_atomic_user_info a
  join warehouse_atomic_all_process_info c
    on a.mbl_no = c.mbl_no 
   and a.data_source = c.data_source
left outer join warehouse_data_user_review_info b1
    on a.mbl_no = b1.mbl_no 
   and a.data_source = b1.data_source
   and b1.product_name = '现金分期-兴业消费'
 where c.action_name = '实名'
   and c.action_date between '2019-04-01' and '2019-05-06'
   and a.data_source = 'sjd'
   and a.isp IN ('联通','移动')
   and b1.mbl_no is null
   and a.mbl_no NOT IN 
   (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
    WHERE eff_flg = '1' 
    UNION 
    SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
    WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() 
    AND marketing_type = 'DX');
 
