584 push需求  徐超 已编码    重要不紧急 纪春艳 平台运营 2019.9.5 2019.9.6 
一次性需求 好借钱 移动手机贷 移动手机贷 push营销 按序号分包，2个包之间去重
1、手机贷平台，马上随借随还产品，额度在合同有效期内，当前有逾期的用户，剔除已结清的用户
2、手机贷平台，马上随借随还产品，额度在合同有效期内，有多次提现记录的用户 SJD_RN282_002

--1.手机贷平台，马上随借随还产品，额度在合同有效期内，当前有逾期的用户，剔除已结清的用户
--SJD_RN282_001

判断用户 当前有逾期
即提现后未及时还款
最近一次提现记录
select distinct a1.mbl_no
from 
(select mbl_no,
        msd_return_time,
		a.is_overdue,
		a.cpd_begin_time,
		a.prin_bal,
	    row_number() over(partition by mbl_no order by msd_return_time DESC) as num
from warehouse_atomic_msd_withdrawals_result_info a
WHERE paid_out_time > '2019-09-06'
  AND data_source = 'sjd'
  and mbl_no is not null) a1
left outer join 
               (select mbl_no
                from
               (select mbl_no,
                       msd_return_time,
               		   prin_bal,
               	       row_number() over(partition by mbl_no order by msd_return_time DESC) as num
               from warehouse_atomic_msd_withdrawals_result_info a
               WHERE paid_out_time > '2019-09-06'
                 AND data_source = 'sjd'
                 and mbl_no is not null) b1
               where b1.num = 1
                 and prin_bal = '0') a2
      on a1.mbl_no = a2.mbl_no
where a1.num = 1
  and a1.is_overdue = 'Y'
  and a2.mbl_no is null



  
 
---手机贷平台，马上随借随还产品，额度在合同有效期内，有多次提现记录的用户
select a1.mbl_no
from
(SELECT a.mbl_no,
        count(a.msd_return_time) AS n
FROM warehouse_atomic_msd_withdrawals_result_info a
WHERE a.total_amount >0
  and a.paid_out_time > '2019-09-06'
  AND a.data_source = 'sjd'
group by a.mbl_no) a1
where a1.n > 1 



---入库1
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN282_001',
                "PS",
				'2019-09-06' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (select distinct a1.mbl_no
from 
(select mbl_no,
        msd_return_time,
		a.is_overdue,
		a.cpd_begin_time,
		a.prin_bal,
	    row_number() over(partition by mbl_no order by msd_return_time DESC) as num
from warehouse_atomic_msd_withdrawals_result_info a
WHERE paid_out_time > '2019-09-06'
  AND data_source = 'sjd'
  and mbl_no is not null) a1
left outer join 
               (select mbl_no
                from
               (select mbl_no,
                       msd_return_time,
               		   prin_bal,
               	       row_number() over(partition by mbl_no order by msd_return_time DESC) as num
               from warehouse_atomic_msd_withdrawals_result_info a
               WHERE paid_out_time > '2019-09-06'
                 AND data_source = 'sjd'
                 and mbl_no is not null) b1
               where b1.num = 1
                 and prin_bal = '0') a2
      on a1.mbl_no = a2.mbl_no
where a1.num = 1
  and a1.is_overdue = 'Y'
  and a2.mbl_no is null
			) AS c
             ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
)

---入库2
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN282_002',
                "PS",
				'2019-09-06' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (---手机贷平台，马上随借随还产品，额度在合同有效期内，有多次提现记录的用户
            select a1.mbl_no
			from
                 (SELECT a.mbl_no,
                         count(a.msd_return_time) AS n
                  FROM warehouse_atomic_msd_withdrawals_result_info a
                  WHERE a.total_amount >0
            	    and a.paid_out_time > '2019-09-06'
                    AND a.data_source = 'sjd'
					group by a.mbl_no) a1
            where a1.n > 1 
			) AS c
             ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
)

---PUSH取数
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN282_001'