594-push需求  徐超     1、紧急且重要 方明 平台运营 2019.9.12 2019.9.12 
一次性需求 全平台 移动手机贷 移动手机贷 push营销
1.手机贷平台2019年3月1日至9月1日，实名未申请全平台产品的用户
2.手机贷平台2019年3月1日至9月1日期间在手机贷提现成功的用户

--1手机贷平台2019年3月1日至9月1日，实名未申请全平台产品的用户 SJD_RN287_001
select a1.mbl_no,
       a1.data_source        
from warehouse_atomic_user_info a1
join warehouse_atomic_all_process_info a2
    on a1.mbl_no = a2.mbl_no 
   and a1.data_source = a2.data_source
left outer join
               (select distinct mbl_no
			    from warehouse_data_user_review_info
				where data_source = 'sjd') a3
    on a1.mbl_no = a3.mbl_no
 where a1.data_source = 'sjd'
   and a2.action_name = '实名'
   and a2.action_date between '2019-03-01' and '2019-09-01'
   and a3.mbl_no is null
   limit 100000
   
--2手机贷平台2019年3月1日至9月1日期间在手机贷提现成功的用户 SJD_RN287_002
select distinct a1.mbl_no,
       a1.data_source
from warehouse_data_user_withdrawals_info a1
where a1.cash_time between '2019-03-01' and '2019-09-01'
  and a1.cash_amount > 0
  and a1.data_source = 'sjd'

---入库
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN287_001',
                "PS",
				'2019-09-12' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (
			) AS c
             ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
)
(
---PUSH取数
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN287_001'
)