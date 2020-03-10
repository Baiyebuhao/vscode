2019.4.30	何渝宏	客服组	2019.5.6	一次性需求	马上随借随还	享宇钱包	外呼营销钱伴、兴业现金分期

在享宇钱包平台 已提现马上随借随还， 
且在近一个月在APP有登陆行为的用户，
剔除申请钱伴及兴业现金分期的用户
（保留用户姓名，手机号，马上随借随还授信时间及额度）	所有用户	

select distinct a1.mbl_no,a4.name,a4.sex_desc,a1.data_source,a1.product_name,a5.credit_time,a5.amount
from warehouse_data_user_withdrawals_info a1
left join warehouse_data_user_review_info a5
 on a1.mbl_no = a5.mbl_no
and a1.data_source = a5.data_source
and a1.product_name = a5.product_name
left join warehouse_atomic_user_info a4
 on a1.mbl_no = a4.mbl_no
and a1.data_source = a4.data_source
left outer join (select * from warehouse_data_user_review_info a6
				 where a6.product_name in ('现金分期-兴业消费','现金分期-钱伴')) a7
			     on a1.mbl_no = a7.mbl_no
				 and a1.data_source = a7.data_source
left outer join (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe WHERE eff_flg = '1') a8
			     on a1.mbl_no = a8.mbl_no
where a1.product_name = '随借随还-马上' 
and a5.product_name = '随借随还-马上' 
and a5.amount > '0'
and a5.status = '通过'
and a1.data_source = 'xyqb' 
and a1.mbl_no in (
                  select distinct a2.mbl_no from warehouse_newtrace_click_record a2
				  where a2.platform = 'xyqb' 
				  and a2.extractday between '2019-04-01' and '2019-04-30'
				  UNION
                  select distinct a3.mbl_no
                  from warehouse_atomic_user_action a3
                  where a3.sys_id = 'xyqb'
				  and a3.extractday between '2019-04-01' and '2019-04-30')
and a7.mbl_no is null
and a8.mbl_no is null




