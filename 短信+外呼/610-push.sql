610 push需求  徐超     1、紧急且重要 纪春艳 平台运营 2019.9.25 2019.9.25 
一次性需求 马上随借随还 移动手机贷 移动手机贷 push营销  
手机贷平台，马上随借随还多次提现用户（额度有效期内）
---手机贷平台，马上随借随还产品，额度在合同有效期内，有多次提现记录的用户
select distinct a1.mbl_no
from
(SELECT a.mbl_no,
        count(a.msd_return_time) AS n
FROM warehouse_atomic_msd_withdrawals_result_info a
WHERE a.total_amount >0
  and a.paid_out_time > '2019-09-25'
  AND a.data_source = 'sjd'
group by a.mbl_no) a1
where a1.n > 1 

---入库1
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN296_001',
                "PS",
				'2019-09-25' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (select distinct a1.mbl_no
            from
            (SELECT a.mbl_no,
                    count(a.msd_return_time) AS n
            FROM warehouse_atomic_msd_withdrawals_result_info a
            WHERE a.total_amount >0
              and a.paid_out_time > '2019-09-25'
              AND a.data_source = 'sjd'
            group by a.mbl_no) a1
            where a1.n > 1 
             ) AS c
             ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
)

(
---PUSH取数
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN296_001'
)