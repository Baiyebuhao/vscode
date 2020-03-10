583 push需求  徐超 已编码    重要不紧急 纪春艳 平台运营 2019.9.5 2019.9.6 
一次性需求 及贷 移动手机贷 移动手机贷 push营销  
8.26-9.4日点击及贷产品未提交申请用户
select distinct a1.mbl_no
from warehouse_newtrace_click_record a1
left outer join 
               (select distinct mbl_no
               from warehouse_data_user_review_info a
               where product_name = '及贷'
			     and data_source = 'sjd') a2
         on a1.mbl_no = a2.mbl_no
where a1.platform = 'sjd'
  and a1.product_name like '%及贷%'
  and a1.extractday between '2019-08-26' and '2019-09-04'
  and a2.mbl_no is null
  
---入库
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN281_001',
                "PS",
				'2019-09-06' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (select distinct a1.mbl_no
            from warehouse_newtrace_click_record a1
            left outer join 
                           (select distinct mbl_no
                           from warehouse_data_user_review_info a
                           where product_name = '及贷'
            			     and data_source = 'sjd') a2
                     on a1.mbl_no = a2.mbl_no
            where a1.platform = 'sjd'
              and a1.product_name like '%及贷%'
              and a1.extractday between '2019-08-26' and '2019-09-04'
              and a2.mbl_no is null
			) AS c
             ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
)

---PUSH取数
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN281_001'