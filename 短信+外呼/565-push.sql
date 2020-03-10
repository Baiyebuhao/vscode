565 push需求  徐超     3、重要不紧急 纪春艳 平台运营 2019.8.29 2019.8.30 
一次性需求 及贷 移动手机贷 移动手机贷 push营销  

8.1日-8.28日点击及贷产品未提交申请用户

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
  and a1.extractday between '2019-08-01' and '2019-08-28'
  and a2.mbl_no is null

---入库
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN272_001',
                "PS",
				'2019-08-29' as rk_date
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
              and a1.extractday between '2019-08-01' and '2019-08-28'
              and a2.mbl_no is null
			) AS c
             ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
)

---PUSH取数
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN272_001'