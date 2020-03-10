574 push需求  徐超     重要不紧急 纪春艳 平台运营 2019.9.3 2019.9.4 
一次性需求 好借钱 移动手机贷 移动手机贷 push营销 按序号分包
1、手机贷平台，R值为1,2，F值为1,2的用户；剔除已申请好借钱产品用户；
2、手机贷平台，优智借/马上现金分期/钱包易贷已授信用户且近三个月有点击行为用户；剔除已申请好借钱产品用户；
3、手机贷平台，马上随借随还授信已过期用户，且2019年在APP上有点击行为的用户，剔除已申请好借钱产品用户
--1.手机贷平台，R值为1,2，F值为1,2的用户；剔除已申请好借钱产品用户；
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_channel_info a1
left outer join(select distinct mbl_no 
                from warehouse_data_user_review_info a
			    where product_name = '现金分期-招联'
				  and data_source = 'sjd')a2
		on a1.mbl_no = a2.mbl_no
where a1.rtype in ('1','2')
  and a1.ftype in ('1','2')
  and a1.data_source = 'sjd'
  and a2.mbl_no is null
  and a1.mbl_no like 'MT%'
  
--2.手机贷平台，优智借/马上现金分期/钱包易贷已授信用户且近三个月有点击行为用户；剔除已申请好借钱产品用户；
select distinct a1.mbl_no,
       a1.data_source
from warehouse_data_user_review_info a1

left outer join (select distinct mbl_no
                 from warehouse_data_user_review_info a
                 where product_name = '现金分期-招联'
				 and data_source = 'sjd') a2
         on a1.mbl_no = a2.mbl_no
join (select distinct mbl_no
      from warehouse_data_user_action_day a
      where extractday between '2019-06-04' and '2019-09-04'
	    and data_source = 'sjd') a3
		on a1.mbl_no = a3.mbl_no
		
where a1.data_source = 'sjd'
  and a1.product_name in ('优智借','现金分期-马上','随借随还-钱包易贷')
  and a1.status = '通过'
  and a1.mbl_no <> 'NULL'
  and a2.mbl_no is null
  
--3.手机贷平台，马上随借随还授信已过期用户，剔除已申请好借钱产品用户
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
  and a1.paid_out_time <= '2019-09-05'
  and a1.mbl_no <> 'NULL'
  and a2.mbl_no is null

---入库1
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN276_001',
                "PS",
				'2019-09-05' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (--1.手机贷平台，R值为1,2，F值为1,2的用户；剔除已申请好借钱产品用户；
            select distinct a1.mbl_no,a1.data_source
            from warehouse_data_user_channel_info a1
            left outer join(select distinct mbl_no 
                            from warehouse_data_user_review_info a
            			    where product_name = '现金分期-招联'
            				  and data_source = 'sjd')a2
            		on a1.mbl_no = a2.mbl_no
            where a1.rtype in ('1','2')
              and a1.ftype in ('1','2')
              and a1.data_source = 'sjd'
              and a2.mbl_no is null
              and a1.mbl_no like 'MT%'
             ) AS c
             ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='sjd'  and length(c.mbl_no) > 4;

--PUSH取数1
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN276_001' 
)

---入库2
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN276_002',
                "PS",
				'2019-09-05' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (--2.手机贷平台，优智借/马上现金分期/钱包易贷已授信用户且近三个月有点击行为用户；剔除已申请好借钱产品用户；
            select distinct a1.mbl_no,
                   a1.data_source
            from warehouse_data_user_review_info a1
            
            left outer join (select distinct mbl_no
                             from warehouse_data_user_review_info a
                             where product_name = '现金分期-招联'
            				 and data_source = 'sjd') a2
                     on a1.mbl_no = a2.mbl_no
            join (select distinct mbl_no
                  from warehouse_data_user_action_day a
                  where extractday between '2019-06-04' and '2019-09-04'
            	    and data_source = 'sjd') a3
            		on a1.mbl_no = a3.mbl_no
            		
            where a1.data_source = 'sjd'
              and a1.product_name in ('优智借','现金分期-马上','随借随还-钱包易贷')
              and a1.status = '通过'
              and a1.mbl_no <> 'NULL'
              and a2.mbl_no is null
             ) AS c
             ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='sjd'  and length(c.mbl_no) > 4;

--PUSH取数2
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN276_002' 
)
---入库3
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN276_004',
                "PS",
				'2019-09-05' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (--3.手机贷平台，马上随借随还授信已过期用户，且2019年在APP上有点击行为的用户，剔除已申请好借钱产品用户
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
              and a1.paid_out_time <= '2019-09-05'
              and a1.mbl_no <> 'NULL'
              and a2.mbl_no is null
             ) AS c
             ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='sjd'  and length(c.mbl_no) > 4;

--PUSH取数3
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN276_004' 
)