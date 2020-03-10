2、上周 07-01 07-07
手机贷平台点击优智借banner未提交申请用户

select distinct a1.mbl_no
from warehouse_newtrace_click_record a1
left outer join 
               (select distinct mbl_no
               from warehouse_data_user_review_info a
               where product_name = '优智借'
			     and apply_time >= '2019-07-01') a2
         on a1.mbl_no = a2.mbl_no
where a1.platform = 'sjd'
  and a1.page_enname = 'supermarket'
  and a1.button_enname = 'banner'
  and a1.ad_name = '优智借'
  and a1.extractday between '2019-07-01' and '2019-07-07'
  and a2.mbl_no is null

---入库
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'xyqb' as data_source, 
                a.cus_no,
                'XYQB_RN222_002',
                "PS",
				'2019-07-10' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (select distinct a1.mbl_no
            from warehouse_newtrace_click_record a1
            left outer join 
                           (select distinct mbl_no
                           from warehouse_data_user_review_info a
                           where product_name = '优智借'
            			     and apply_time >= '2019-07-01') a2
                     on a1.mbl_no = a2.mbl_no
            where a1.platform = 'sjd'
              and a1.page_enname = 'supermarket'
              and a1.button_enname = 'banner'
              and a1.ad_name = '优智借'
              and a1.extractday between '2019-07-01' and '2019-07-07'
              and a2.mbl_no is null) AS c
 ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
)

---PUSH取数
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'XYQB_RN222_002'