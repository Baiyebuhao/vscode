607 push需求   徐超 已编码    重要不紧急 纪春艳 平台运营 2019.9.23 2019.9.24 
一次性需求 优卡贷 移动手机贷 移动手机贷 push营销 按序号分包，包与包之间去重 
1、2019年有提现行为的用户；
2、9月有产品点击行为用户；
3、9月注册未申请任一产品用户
---2019年有提现行为的用户SJD_RN293_001
select distinct a1.mbl_no
from warehouse_data_user_withdrawals_info a1
where a1.cash_time >= '2019-01-01'
and a1.data_source = 'sjd'
and a1.mbl_no like 'MT%'

---9月有产品点击行为用户SJD_RN293_002
select distinct a1.mbl_no
from warehouse_data_user_action_day a1
left outer join(select a.mbl_no_encode as mbl_no
                from warehouse_data_push_user a
				where a.data_code = 'SJD_RN293_001'
                )a2
				on a1.mbl_no = a2.mbl_no
where a1.applypv > '0'
and a1.extractday >= '2019-09-01'
and a1.product_name <> 'NULL'
and a1.mbl_no like 'MT%'
and a1.data_source = 'sjd'
and a2.mbl_no is null

---9月注册未申请任一产品用户
select distinct a1.mbl_no
from warehouse_atomic_user_info a1
left outer join (select distinct mbl_no
                 from warehouse_data_user_review_info a
                 where data_source = 'sjd'
				 ) a2
         on a1.mbl_no = a2.mbl_no
left outer join(select a.mbl_no_encode as mbl_no
                from warehouse_data_push_user a
				where a.data_code = 'SJD_RN293_001'
                )a3
				on a1.mbl_no = a3.mbl_no
left outer join(select a.mbl_no_encode as mbl_no
                from warehouse_data_push_user a
				where a.data_code = 'SJD_RN293_002'
                )a4
				on a1.mbl_no = a4.mbl_no
where a1.data_source = 'sjd'
  and a1.registe_date between '2019-09-01' and '2019-09-30'
  and a1.mbl_no like 'MT%'
  and a2.mbl_no is null
  and a3.mbl_no is null
  and a4.mbl_no is null
---入库1
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN293_001',
                "PS",
				'2019-09-24' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (
             ) AS c
             ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='sjd' and length(c.mbl_no) > 4
)

(
---PUSH取数
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN293_001'
)