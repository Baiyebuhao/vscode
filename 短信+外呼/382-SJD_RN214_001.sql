382	Push需求  徐超    
3、重要不紧急 2019.6.17 李薇薇 金融苑 2019.6.19 
一次性需求 招联好借钱 移动手机贷 移动手机贷 push营销 所有用户 

RFM模型汇总，R值为1和2的所有用户，剔除三平台申请过招联好借钱的用户
(
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_channel_info a1
left outer join(select mbl_no 
                from warehouse_data_user_review_info a
			    where product_name = '现金分期-招联')a2
		on a1.mbl_no = a2.mbl_no
where a1.rtype in ('1','2')
  and a1.data_source = 'sjd'
  and a2.mbl_no is null
  and a1.mbl_no like 'MT%'
)
---
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN214_001',
                "PS",
				'2019-06-18' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (select distinct a1.mbl_no,a1.data_source
            from warehouse_data_user_channel_info a1
            left outer join(select mbl_no
                            from warehouse_data_user_review_info a
            			    where product_name = '现金分期-招联')a2
            		on a1.mbl_no = a2.mbl_no
            where a1.rtype in ('1','2')
              and a1.data_source = 'sjd'
              and a2.mbl_no is null
              and a1.mbl_no like 'MT%') AS c
 ON a.mbl_no = c.mbl_no

WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
)

(
---PUSH取数
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN214_001'
)