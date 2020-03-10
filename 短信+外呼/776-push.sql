776 push需求  徐超 已编码    3、重要不紧急 纪春艳 平台运营 2019.12.4 2019.12.5 
一次性需求 趣借钱 移动手机贷 移动手机贷 push营销 按序号分包，包与包去重 
11月申请万达普惠未获得授信的用户；

SELECT DISTINCT a1.mbl_no
FROM warehouse_atomic_wanda_loan_info a1
LEFT OUTER JOIN
  (SELECT DISTINCT mbl_no
   FROM warehouse_atomic_wanda_loan_info a
   WHERE substr(a.apply_time,1,10) BETWEEN '2019-11-01' AND '2019-11-30'
     AND a.finish_time IS NULL
     AND a.data_source = 'sjd') a2
	 on a1.mbl_no = a2.mbl_no
WHERE substr(a1.apply_time,1,10) BETWEEN '2019-11-01' AND '2019-11-30'
  AND a1.data_source = 'sjd'
  AND a2.mbl_no IS NULL
  
---入库
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN348_001',
                "PS",
				'2019-12-06' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (SELECT DISTINCT a1.mbl_no
            FROM warehouse_atomic_wanda_loan_info a1
            LEFT OUTER JOIN
              (SELECT DISTINCT mbl_no
               FROM warehouse_atomic_wanda_loan_info a
               WHERE substr(a.apply_time,1,10) BETWEEN '2019-11-01' AND '2019-11-30'
                 AND a.finish_time IS NULL
                 AND a.data_source = 'sjd') a2
				 on a1.mbl_no = a2.mbl_no
            WHERE substr(a1.apply_time,1,10) BETWEEN '2019-11-01' AND '2019-11-30'
              AND a1.data_source = 'sjd'
              AND a2.mbl_no IS NULL) AS c
 ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
)

---PUSH取数
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN348_001'