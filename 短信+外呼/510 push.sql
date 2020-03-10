510 push需求  徐超 已编码    3、重要不紧急 纪春艳 平台运营 2019.8.8 2019.8.8 
一次性需求 被拒产品 移动手机贷 移动手机贷 push营销
7.1-8.7日申请任意产品审核不通过用户

select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_review_info a1
left outer join 
               (select distinct mbl_no
                from warehouse_data_user_review_info a
                where data_source = 'sjd'
				  and status = '通过'
				  and apply_time between '2019-07-01' and '2019-08-07') a2
on a1.mbl_no = a2.mbl_no
where a1.data_source = 'sjd'
  and a1.apply_time between '2019-07-01' and '2019-08-07'
  and a2.mbl_no is null
  
入库：
(INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN246_001',
                "PS",
				'2019-08-09' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (select distinct a1.mbl_no,a1.data_source
            from warehouse_data_user_review_info a1
            left outer join 
                           (select distinct mbl_no
                            from warehouse_data_user_review_info a
                            where data_source = 'sjd'
            				  and status = '通过'
            				  and apply_time between '2019-07-01' and '2019-08-07') a2
            on a1.mbl_no = a2.mbl_no
            where a1.data_source = 'sjd'
              and a1.apply_time between '2019-07-01' and '2019-08-07'
              and a2.mbl_no is null) AS c
 ON a.mbl_no = c.mbl_no
 WHERE a.data_source='sjd'  and length(c.mbl_no) > 4)
 
--PUSH取数
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN246_001'