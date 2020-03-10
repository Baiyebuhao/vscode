750 短信需求  徐超 已编码    3、重要不紧急 纪春艳 平台运营 2019.11.21 2019.11.22 
一次性需求 来钱花 移动手机贷 移动手机贷 短信营销  
2019年已获得授信的联通用户，剔除已获得马上随借随还授信额度的用户
---SJD_AN437_001
select a1.mbl_no,
       a1.data_source
from 
(select distinct mbl_no,data_source
from warehouse_data_user_review_info a
where data_source = 'sjd'
  and credit_time between '2019-01-01' and '2019-11-21'
  and status = '通过') a1
left outer join 
(select distinct mbl_no,data_source
from warehouse_data_user_review_info a
where data_source = 'sjd'
  and product_name = '随借随还-马上'
  and status = '通过') a2
on a1.mbl_no = a2.mbl_no
join 
(select * 
 from warehouse_atomic_user_info a
 where isp LIKE '%联通%'
   and data_source = 'sjd') a3
on a1.mbl_no = a3.mbl_no
where a2.mbl_no is null
  and a1.mbl_no like 'MT%'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');