729 外呼需求  徐超     2、紧急不重要 龚月 平台运营 2019.11.15 2019.11.18 
一次性需求 抚宁百惠贷 抚宁百惠贷 三平台 外呼回访  
11月12日—11月18日，注册抚宁百惠贷平台的用户，保留号码，姓名，性别，年龄，注册时间，手机号归属地（地市）、是否申请普惠达（分产品）和汇智信。
提出给客服组外呼

SELECT DISTINCT a.mbl_no,
                substr(a.registe_date,1,10) as r_date,
                b.name,
				b.sex_desc,
				b.age,
                b.city_desc,
                IF (c.mbl_no IS NOT NULL,
                                "phd已申请",
                                "phd未申请") AS phd,
				c.data_source,
				c.product_name,
                CASE WHEN a.registe_date<=d.c_time
                       OR d.c_time IS NULL THEN d.id
                      END  AS hzx
FROM
---注册用户（？）
  (SELECT *
   FROM warehouse_atomic_time_user
   WHERE data_source IN ('bhh',
                         'bhd')
     AND chan_no='11'
     AND substr(registe_date,1,10) BETWEEN '2019-11-12' AND '2019-11-18') a
---注册用户
LEFT JOIN
  (SELECT DISTINCT mbl_no,
                   name,
				   sex_desc,
				   age,
                   city_desc
   FROM warehouse_atomic_user_info
   WHERE data_source = 'bhd'
     AND substr(registe_date,1,10) BETWEEN '2019-11-12' AND '2019-11-18' ) b 
	 ON a.mbl_no = b.mbl_no
---申请用户
LEFT JOIN
  (SELECT *
   FROM warehouse_data_user_review_info
   WHERE apply_time >='2019-11-12') c 
   ON a.mbl_no = c.mbl_no
---汇智信客户
LEFT JOIN
  (SELECT *
   FROM warehouse_atomic_hzx_c_customer) d 
   ON a.mbl_no=d.mobile
---汇智信调查
LEFT JOIN
  (SELECT *
   FROM warehouse_atomic_hzx_research_task) e 
   ON d.id=e.customer_id
where a.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe WHERE eff_flg = '1')