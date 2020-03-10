563 push需求  徐超     3、重要不紧急 纪春艳 平台运营 2019.8.29 2019.8.30 
一次性需求 好借钱 移动手机贷 移动手机贷 push营销 按序号分包

1、8.27-8.29日注册未申请好借钱产品用户；
2、马上随借随还已授信用户且2019年有点击行为用户；剔除已申请好借钱产品用户

--18.27-8.29日注册未申请好借钱产品用户
select distinct a1.mbl_no,
       a1.data_source
from warehouse_atomic_user_info a1
left outer join (select distinct mbl_no
                 from warehouse_data_user_review_info a
                 where product_name = '现金分期-招联'
				   and data_source = 'sjd'
				 ) a2
         on a1.mbl_no = a2.mbl_no
where a1.data_source = 'sjd'
  and a1.registe_date between '2019-08-27' and '2019-08-29'
  and a2.mbl_no is null


---入库1
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN270_001',
                "PS",
				'2019-08-29' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (select distinct a1.mbl_no,
                   a1.data_source
            from warehouse_atomic_user_info a1
            left outer join (select distinct mbl_no
                             from warehouse_data_user_review_info a
                             where product_name = '现金分期-招联'
            				   and data_source = 'sjd'
            				 ) a2
                     on a1.mbl_no = a2.mbl_no
            where a1.data_source = 'sjd'
              and a1.registe_date between '2019-08-27' and '2019-08-29'
              and a2.mbl_no is null
			) AS c
             ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
)

---PUSH取数
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN270_001'

--2马上随借随还已授信用户且2019年有点击行为用户；剔除已申请好借钱产品用户
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_review_info a1
left outer join (select distinct mbl_no
                 from warehouse_data_user_review_info a
                 where product_name = '现金分期-招联'
				 and data_source = 'sjd'
				 ) a2
         on a1.mbl_no = a2.mbl_no
join (select distinct mbl_no
      from warehouse_data_user_action_day a
      where extractday >= '2019-01-01'
	    and data_source = 'sjd') a3
   on a1.mbl_no = a3.mbl_no
where a1.data_source = 'sjd'
  and a1.product_name = '随借随还-马上'
  and a1.status = '通过'
  and a1.mbl_no <> 'NULL'
  and a2.mbl_no is null

---入库2
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN270_002',
                "PS",
				'2019-08-29' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (select distinct a1.mbl_no,a1.data_source
            from warehouse_data_user_review_info a1
            left outer join (select distinct mbl_no
                             from warehouse_data_user_review_info a
                             where product_name = '现金分期-招联'
            				 and data_source = 'sjd'
            				 ) a2
                     on a1.mbl_no = a2.mbl_no
            join (select distinct mbl_no
                  from warehouse_data_user_action_day a
                  where extractday >= '2019-01-01'
            	    and data_source = 'sjd') a3
            		on a1.mbl_no = a3.mbl_no
            where a1.data_source = 'sjd'
              and a1.product_name = '随借随还-马上'
              and a1.status = '通过'
              and a1.mbl_no <> 'NULL'
              and a2.mbl_no is null
			) AS c
             ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
)

---PUSH取数
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN270_002'