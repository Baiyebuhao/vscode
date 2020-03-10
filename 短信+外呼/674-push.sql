(--10.14-10.23日申请任一产品未获得授信的用户，剔除已申请过万达普惠的用户
--先取申请，再取授信，从申请里面把授信剔掉，再剔掉产品为万达普惠的用户
--mbl_no,product_name,apply_time

SELECT DISTINCT c.mbl_no,
                c.product_name,
                c.apply_time
FROM 
(
  SELECT *
  FROM
     (SELECT *
      FROM
          (SELECT *
           FROM warehouse_data_user_review_info AS ur
           WHERE substr (ur.apply_time, 1, 10) BETWEEN '2019-10-14' AND '2019-10-23') AS a
  LEFT OUTER JOIN
     (SELECT *
      FROM warehouse_data_user_review_info AS ur
      WHERE ur.status ='通过') AS b ON a.mbl_no = b.mbl_no
   WHERE b.mbl_no IS NULL ) AS c
LEFT OUTER JOIN
  (SELECT *
   FROM warehouse_data_user_review_info
   WHERE product_name = '现金分期-万达普惠') AS d ON c.mbl_no = d.mbl_no
WHERE d.mbl_no IS NULL )
)

674 push需求 已完成 赵小庆 已编码    3、重要不紧急 纪春艳 平台运营 2019.10.25 2019.10.25 
一次性需求 万达普惠 移动手机贷 移动手机贷 push营销  
10.14-10.23日申请任一产品未获得授信的用户，剔除已申请过万达普惠的用户 

--1.申请
select distinct mbl_no,
       data_source
from warehouse_data_user_review_info a1
where substr(a1.apply_time,1,10) BETWEEN '2019-10-14' AND '2019-10-23'
  and data_source = 'sjd'

--2.授信
select * 
from warehouse_data_user_review_info a
where substr(a.apply_time,1,10) BETWEEN '2019-10-14' AND '2019-10-23'
  and a.status ='通过'
  and data_source = 'sjd'

--3.申请过万达普惠
select * 
from warehouse_data_user_review_info a
where product_name = '现金分期-万达普惠'
  --and data_source = 'sjd'
 
---
---
select distinct a1.mbl_no

from warehouse_data_user_review_info a1

left outer join (select distinct mbl_no
                 from warehouse_data_user_review_info a
                 where substr(apply_time,1,10) BETWEEN '2019-10-14' AND '2019-10-23'
                   and status ='通过'
                   and data_source = 'sjd') a2
			on a1.mbl_no = a2.mbl_no
			
left outer join (select distinct mbl_no
                 from warehouse_data_user_review_info a
                 where product_name = '现金分期-万达普惠') a3
			on a1.mbl_no = a3.mbl_no

where substr(a1.apply_time,1,10) BETWEEN '2019-10-14' AND '2019-10-23'
  and a1.data_source = 'sjd'
  and a2.mbl_no is null
  and a3.mbl_no is null
















