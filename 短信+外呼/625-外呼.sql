625 外呼需求  赵小庆 已编码    3、重要不紧急 何渝宏 客服部 2019.9.29 2019.9.30
 一次性需求 趣借钱 移动手机贷 移动手机贷 外呼营销  
 移动手机贷，趣借钱9月24日-29日授信通过 ，但无提现订单的用户
 （保留用户姓名、手机号、授信时间、授信额度）

select distinct a1.mbl_no,
                a1.data_source,
				a3.name,
				a1.credit_time,
				a1.amount

from warehouse_data_user_review_info a1
left outer join
               (select distinct mbl_no
			    from warehouse_data_user_withdrawals_info a
				where product_name = '趣借钱'
				  and data_source = 'sjd'
				  and cash_amount > '0'
				  and cash_time >= '2019-09-24'
			    )a2
			   on a1.mbl_no = a2.mbl_no
left join warehouse_atomic_user_info a3
 on a1.mbl_no = a3.mbl_no
and a1.data_source = a3.data_source

where a1.credit_time between '2019-09-24' and '2019-09-29'
  and a1.product_name = '趣借钱'
  and a1.status = '通过'
  and a1.data_source = 'sjd'
  and a2.mbl_no is null
  and a3.name is not null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe WHERE eff_flg = '1')

