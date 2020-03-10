618 push需求  徐超     3、重要不紧急 纪春艳 平台运营 2019.9.29 2019.9.30 ]
一次性需求 业主贷 移动手机贷 移动手机贷 push营销 按序号分包；包与包之间去重 
1、9.1-9.28日点击过业主贷产品的用户；
2、近3个月有过提现行为的用户，且填写过有房信息的用户

--9.1-9.28日点击过业主贷产品的用户；SJD_RN301_001
select distinct a1.mbl_no
from warehouse_data_user_action_day a1
where a1.product_name = '业主贷-招联'
  and a1.data_source = 'sjd'
  and a1.extractday between '2019-09-01' and '2019-09-28'


--近3个月有过提现行为的用户，且填写过有房信息的用户;SJD_RN301_002
(--用户测评填写有房信息的用户
select distinct mbl_no
from warehouse_atomic_evaluation_process_info a
where que_id = '2015070612070004'
  and TRIM(OPT_SEQ) = '1'
  and data_source = 'sjd')
---
---
select distinct a1.mbl_no
from warehouse_data_user_withdrawals_info a1
join (--用户测评填写有房信息的用户
      select distinct mbl_no
      from warehouse_atomic_evaluation_process_info a
      where que_id = '2015070612070004'
        and TRIM(OPT_SEQ) = '1'
        and data_source = 'sjd') a2
	on a1.mbl_no = a2.mbl_no
left outer join(select mbl_no_encode as mbl_no
                from warehouse_data_push_user a
				where a.data_code = 'SJD_RN301_001'   --包去重
                )a3
	on a1.mbl_no = a3.mbl_no
where a1.data_source = 'sjd'
  and a1.cash_time between '2019-07-01' and '2019-09-28'
  and a1.cash_amount > '0'
  and a3.mbl_no is null


---入库1
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN301_001',
                "PS",
				'2019-09-29' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (--9.1-9.28日点击过业主贷产品的用户；SJD_RN301_001
            select distinct a1.mbl_no
            from warehouse_data_user_action_day a1
            where a1.product_name = '业主贷-招联'
              and a1.data_source = 'sjd'
              and a1.extractday between '2019-09-01' and '2019-09-28'
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
                'SJD_RN301_002',
                "PS",
				'2019-09-29' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (select distinct a1.mbl_no
            from warehouse_data_user_withdrawals_info a1
            join (--用户测评填写有房信息的用户
                  select distinct mbl_no
                  from warehouse_atomic_evaluation_process_info a
                  where que_id = '2015070612070004'
                    and TRIM(OPT_SEQ) = '1'
                    and data_source = 'sjd') a2
            	on a1.mbl_no = a2.mbl_no
            left outer join(select mbl_no_encode as mbl_no
                            from warehouse_data_push_user a
            				where a.data_code = 'SJD_RN301_001'   --包去重
                            )a3
            	on a1.mbl_no = a3.mbl_no
            where a1.data_source = 'sjd'
              and a1.cash_time between '2019-07-01' and '2019-09-28'
              and a1.cash_amount > '0'
              and a3.mbl_no is null
             ) AS c
             ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
)

(
---PUSH取数
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN301_001'
)