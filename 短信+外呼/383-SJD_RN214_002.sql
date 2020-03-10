383	Push需求  徐超    3、重要不紧急 2019.6.17 李薇薇 金融苑 2019.6.19 
一次性需求 马上随借随还 移动手机贷 移动手机贷 push营销 所有用户 
历史以来授信马上随借随还提过现的所有用户，且近半年（2019年1月1日-2019年6月17日）在手机贷平台有过点击行为的用户，
剔除近1个月（2019年5月17-2019年6月17日）提过现的用户
(
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_withdrawals_info a1
join (select distinct mbl_no,'sjd' as data_source
     from warehouse_newtrace_click_record b1
     where extractday between '2019-01-01' and '2019-06-17'
     and platform = 'sjd'
     UNION
     select distinct mbl_no,'sjd' as data_source
     from warehouse_atomic_user_action b2
     where sys_id = 'sjd'
     and extractday between '2019-01-01' and '2019-06-17') a2
 on a1.mbl_no = a2.mbl_no
and a1.data_source = a2.data_source
left outer join(select mbl_no,data_source
                from warehouse_data_user_withdrawals_info a
                where data_source = 'sjd'
                  and product_name = '随借随还-马上'
				  and cash_time between '2019-05-17' and '2019-06-17'
                  and cash_amount > '0') a3
 on a1.mbl_no = a3.mbl_no
and a1.data_source = a3.data_source
where a1.data_source = 'sjd'
  and a1.product_name = '随借随还-马上'
  and a1.mbl_no like 'MT%'
  and a1.cash_amount > '0'
  and a3.mbl_no is null
 )
 
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN214_002',
                "PS",
				'2019-06-18' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (select distinct a1.mbl_no,a1.data_source
            from warehouse_data_user_withdrawals_info a1
            join (select distinct mbl_no,'sjd' as data_source
                 from warehouse_newtrace_click_record b1
                 where extractday between '2019-01-01' and '2019-06-17'
                 and platform = 'sjd'
                 UNION
                 select distinct mbl_no,'sjd' as data_source
                 from warehouse_atomic_user_action b2
                 where sys_id = 'sjd'
                 and extractday between '2019-01-01' and '2019-06-17') a2
             on a1.mbl_no = a2.mbl_no
            and a1.data_source = a2.data_source
            left outer join(select mbl_no,data_source
                            from warehouse_data_user_withdrawals_info a
                            where data_source = 'sjd'
                              and product_name = '随借随还-马上'
            				  and cash_time between '2019-05-17' and '2019-06-17'
                              and cash_amount > '0') a3
             on a1.mbl_no = a3.mbl_no
            and a1.data_source = a3.data_source
            where a1.data_source = 'sjd'
			  and a1.mbl_no like 'MT%'
              and a1.product_name = '随借随还-马上'
              and a1.cash_amount > '0'
              and a3.mbl_no is null) AS c
 ON a.mbl_no = c.mbl_no

WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
)

(
---PUSH取数SJD_RN214_002
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN214_002'
)
  
  