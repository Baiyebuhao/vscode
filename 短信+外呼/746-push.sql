746 push需求  徐超     3、重要不紧急 纪春艳 平台运营 2019.11.21 2019.11.21 
一次性需求 万达普惠 移动手机贷 移动手机贷 push营销 按序号分包，包与包去重
1、马上随借随还已提现用户中，近2个月有产品申请行为的用户，剔除已申请万达产品的用户；
2、本月申请任一产品未获得授信的用户，剔除已申请万达的用户；
---SJD_RN331_001
select distinct a1.mbl_no
from warehouse_data_user_withdrawals_info a1
join (select distinct mbl_no
      from warehouse_data_user_review_info a
      where data_source = 'sjd'
	    and apply_time between '2019-09-21' and '2019-11-21') a2
on a1.mbl_no = a2.mbl_no
LEFT OUTER JOIN (SELECT distinct mbl_no
                 FROM warehouse_data_user_review_info a
                 WHERE product_name = '现金分期-万达普惠') a3 
ON a1.mbl_no = a3.mbl_no
LEFT OUTER JOIN 	   
  (SELECT mbl_no
   FROM warehouse_atomic_smstunsubscribe
   WHERE eff_flg = '1'
   UNION SELECT DISTINCT mbl_no_encode as mbl_no
   FROM warehouse_data_push_user
   WHERE rk_date = substr(current_date(),1,10)) a4
ON a1.mbl_no = a4.mbl_no
where a1.data_source = 'sjd'
  and a1.product_name = '随借随还-马上'
  and a3.mbl_no is null
  and a4.mbl_no is null 

  
---SJD_RN331_002
select distinct a1.mbl_no
from 
(select distinct mbl_no
from warehouse_data_user_review_info a
where data_source = 'sjd'
  and apply_time between '2019-11-01' and '2019-11-21') a1
  
left outer join 
(select distinct mbl_no
from warehouse_data_user_review_info a
where data_source = 'sjd'
  and apply_time between '2019-11-01' and '2019-11-21'
  and status = '通过') a2
on a1.mbl_no = a2.mbl_no

left outer join 
(select distinct mbl_no
from warehouse_data_user_review_info a
where data_source = 'sjd'
  and product_name = '现金分期-万达普惠') a3
on a1.mbl_no = a3.mbl_no
LEFT OUTER JOIN 	   
  (SELECT mbl_no
   FROM warehouse_atomic_smstunsubscribe
   WHERE eff_flg = '1'
   UNION SELECT DISTINCT mbl_no_encode as mbl_no
   FROM warehouse_data_push_user
   WHERE rk_date = substr(current_date(),1,10)) a4
ON a1.mbl_no = a4.mbl_no
where a2.mbl_no is null
  and a3.mbl_no is null
  and a4.mbl_no is null


---入库
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN331_001',
                "PS",
				'2019-11-22' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN () AS c
 ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
)

---PUSH取数
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN331_001'
