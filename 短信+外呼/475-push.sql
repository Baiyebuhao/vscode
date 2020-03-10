475 push需求  徐超    3、重要不紧急 2019.7.24 纪春艳 平台运营 2019.7.25 
一次性需求 好借钱 移动手机贷 移动手机贷 push营销  
马上随借随还授信已过期用户；且2019年在APP上有点击行为的用户,剔除已申请好借钱产品用户

select distinct a1.mbl_no,a1.data_source
from warehouse_atomic_msd_withdrawals_result_info a1
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
  and a1.paid_out_time <= '2019-07-24'
  and a1.mbl_no <> 'NULL'
  and a2.mbl_no is null


入库
(INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN235_002',
                "PS",
				'2019-07-25' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (select distinct a1.mbl_no,a1.data_source
            from warehouse_atomic_msd_withdrawals_result_info a1
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
              and a1.paid_out_time <= '2019-07-24'
              and a1.mbl_no <> 'NULL'
              and a2.mbl_no is null) AS c
 ON a.mbl_no = c.mbl_no
 WHERE a.data_source='sjd'  and length(c.mbl_no) > 4)
 
--PUSH取数
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN235_002'

               
