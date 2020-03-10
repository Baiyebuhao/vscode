759 短信需求  徐超 已编码    3、重要不紧急 龚月 平台运营 2019.11.26 2019.11.27 
一次性需求 抚宁百惠贷 抚宁百惠贷  一次性需求  

抚宁百惠贷所有注册用户（322名），提取联通用户进行短信营销，保留用户手机号码，地区（市），是否已在抚宁百惠贷申请产品，申请产品时间及名称

select a1.mbl_no,
       a1.name,
	   a1.city_desc,
       a2.data_source,
	   a2.product_name,
	   a3.apply_date,
	   a3.product_name
from 
  (SELECT DISTINCT mbl_no,
                   name,
                   city_desc
   FROM warehouse_atomic_user_info a
   WHERE data_source = 'bhd'
     and isp = '联通'
     AND substr(registe_date,1,10) BETWEEN '2019-09-27' AND '2019-11-28') a1

left join 
  (SELECT *
   FROM warehouse_data_user_review_info a
   WHERE apply_time >='2019-11-12') a2
   ON a1.mbl_no = a2.mbl_no

LEFT JOIN
  (SELECT distinct b1.mobile as mbl_no,
		  substr(b2.loan_apply_time,1,10) as apply_date,
		  b3.name as product_name
   FROM warehouse_atomic_hzx_c_customer b1
   JOIN warehouse_atomic_hzx_research_task b2
   on b1.id = b2.customer_id
   LEFT JOIN warehouse_atomic_hzx_bank_product_info b3
   on b2.bank_pro_id = b3.id
   where b1.mobile like 'MT%'
     and b3.name is not null) a3
   ON a1.mbl_no = a3.mbl_no