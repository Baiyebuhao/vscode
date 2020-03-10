602 push需求  徐超     重要不紧急 纪春艳 平台运营 2019.9.17 2019.9.18 
一次性需求 任性贷 移动手机贷 移动手机贷 push营销 
按序号分包，包与包之间去重
1、R值为1,2，且M值为1，2的用户；剔除已申请任性贷产品的用户
2、好借钱已授信用户；剔除已申请任性贷产品的用户

---R值为1,2，且M值为1，2的用户；剔除已申请任性贷产品的用户
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_channel_info a1
left outer join(select mbl_no 
                from warehouse_data_user_review_info a
			    where product_name = '任性贷')a2
		on a1.mbl_no = a2.mbl_no
where a1.rtype in ('1','2')
  and a1.mtype in ('1','2')
  and a1.data_source = 'sjd'
  and a1.mbl_no like 'MT%'
  and a2.mbl_no is null

---好借钱已授信用户；剔除已申请任性贷产品的用户
select distinct a1.mbl_no,
                a1.data_source
from warehouse_data_user_review_info a1

left outer join(select distinct mbl_no 
                from warehouse_data_user_review_info a
			    where product_name = '任性贷')a2
		on a1.mbl_no = a2.mbl_no
where a1.product_name = '现金分期-招联'
   and a1.data_source = 'sjd'
   and a1.status = '通过'
   and a2.mbl_no is null
(--去重
select a1.mbl_no_encode as mbl_no
from warehouse_data_push_user a1
left outer join(select mbl_no_encode 
                from warehouse_data_push_user a
				where a.data_code = 'SJD_RN291_001'
                )a2
				on a1.mbl_no_encode = a2.mbl_no_encode
where a1.data_code = 'SJD_RN291_002'
  and a2.mbl_no_encode is null)
---入库1
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN291_001',
                "PS",
				'2019-09-18' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (
             ) AS c
             ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
)
(---入库4

INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN291_004',
                "PS",
				'2019-09-18' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (select a1.mbl_no_encode as mbl_no
            from warehouse_data_push_user a1
            left outer join(select mbl_no_encode 
                            from warehouse_data_push_user a
            				where a.data_code = 'SJD_RN291_001'
                            )a2
							on a1.mbl_no_encode = a2.mbl_no_encode
            where a1.data_code = 'SJD_RN291_002'
              and a2.mbl_no_encode is null
             ) AS c
             ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='sjd'  and length(c.mbl_no) > 4)
(
---PUSH取数
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN291_001'
)