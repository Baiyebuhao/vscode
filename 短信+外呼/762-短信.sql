762 短信需求  徐超 已编码    3、重要不紧急 纪春艳 平台运营 2019.11.26 2019.11.27 
一次性需求 万达普惠 移动手机贷 移动手机贷 短信营销 按序号分包 

1、上周点击过产品立即申请的联通用户，剔除已申请过万达普惠的用户；
2、2019年，马上随借随还有过提现行为的联通用户；剔除已申请过万达普惠的用户；
3、10.1至今已注册用户中，本月有过产品点击行为的联通用户；剔除已申请过万达普惠的用户；

--上周('2019-11-18' and '2019-11-24')
--SJD_AN445_001
select a1.mbl_no as mbl_no,
      'sjd' as data_source
from (select distinct mbl_no
     from warehouse_data_user_action_day a
     where applypv > '0'
       and extractday between '2019-11-18' and '2019-11-24'
       and product_name <> 'NULL'
       and mbl_no <> 'NULL'
       and data_source = 'sjd') a1

join (select distinct mbl_no
      from warehouse_atomic_user_info a
      where isp = '联通'
	    and data_source = 'sjd') a2
on a1.mbl_no = a2.mbl_no

left outer join
      (select distinct mbl_no
       from warehouse_data_user_review_info a
       where product_name = '现金分期-万达普惠'
         and data_source = 'sjd') a3
on a1.mbl_no = a3.mbl_no
where a3.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');

--SJD_AN445_002
select a1.mbl_no as mbl_no,
       a1.data_source as data_source
from 
(SELECT distinct mbl_no,
       data_source
   FROM warehouse_data_user_withdrawals_info
   WHERE cash_amount > 0
     AND product_name = '随借随还-马上'
     AND data_source = 'sjd'
     AND mbl_no IS NOT NULL
	 and cash_time >= '2019-01-01') a1

join (select distinct mbl_no
      from warehouse_atomic_user_info a
      where isp = '联通'
	    and data_source = 'sjd') a2
on a1.mbl_no = a2.mbl_no
left outer join
      (select distinct mbl_no
       from warehouse_data_user_review_info a
       where product_name = '现金分期-万达普惠'
         and data_source = 'sjd') a3
on a1.mbl_no = a3.mbl_no
where a3.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');

---SJD_AN445_003
select a1.mbl_no as mbl_no,
       a1.data_source as data_source
from (select mbl_no,
             data_source
     from warehouse_atomic_user_info a
     where registe_date >= '2019-10-01'
       and data_source = 'sjd'
       and isp = '联通') a1 
	   
join (select distinct a.mbl_no
     from warehouse_data_user_action_day a
     where a.applypv > '0'
     and a.extractday >= '2019-11-01'
     and a.product_name <> 'NULL'
     and a.mbl_no like 'MT%'
     and a.data_source = 'sjd') a2
on a1.mbl_no = a2.mbl_no

left outer join
      (select distinct mbl_no
       from warehouse_data_user_review_info a
       where product_name = '现金分期-万达普惠'
         and data_source = 'sjd') a3
on a1.mbl_no = a3.mbl_no
where a3.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');