712 外呼需求  徐超     1、紧急且重要 何渝宏 客服部 2019.11.11 2019.11.11下午 
一次性需求  移动手机贷 移动手机贷 外呼营销
历史以来有在优智借提过现，且11月1日-11月10日有过登录行为的用户，剔除申请过万达的用户（保留用户姓名、手机号、授信时间、授信额度）

select distinct a1.mbl_no,
       a1.data_source,
	   a4.name,
	   a5.credit_time,
	   a5.amount
from warehouse_data_user_withdrawals_info a1
left join warehouse_atomic_user_info a4
       on a1.mbl_no = a4.mbl_no
      and a1.data_source = a4.data_source
join (select distinct mbl_no
      from warehouse_data_user_action_day a
      where allpv > '0'
      and extractday between '2019-11-01' and '2019-11-10'
	  and data_source = 'sjd'
      ) a2
	  on a1.mbl_no = a2.mbl_no
left outer join (select distinct mbl_no,data_source
			     from warehouse_data_user_review_info a
			     where product_name = '现金分期-万达普惠'
				   and data_source = 'sjd') a3
			on a1.mbl_no = a3.mbl_no
           and a1.data_source = a3.data_source
		   
left join (select distinct mbl_no,credit_time,amount
			     from warehouse_data_user_review_info a
			     where product_name = '优智借'
				   and data_source = 'sjd'
				   and status = '通过') a5
			on a1.mbl_no = a5.mbl_no                    -----存疑，要取最近一次授信
where a1.product_name = '优智借'
  and a1.data_source = 'sjd'
  and a1.cash_amount > '0'
  and a3.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe WHERE eff_flg = '1')

----换成下面的脚本（取最近一次授信）
(select distinct mbl_no,credit_time,amount
from 
(select mbl_no,
        amount,
		credit_time,
	    Row_Number() OVER (partition by mbl_no ORDER BY credit_time desc) rank     
from warehouse_data_user_review_info a
where product_name = '优智借'
  and data_source = 'sjd'
  and status = '通过') b
where b.rank = '1') a5



(--
--
select distinct a1.mbl_no,
       a1.data_source,
	   a4.name,
	   a5.credit_time,
	   a5.amount
from warehouse_data_user_withdrawals_info a1
left join warehouse_atomic_user_info a4
       on a1.mbl_no = a4.mbl_no
      and a1.data_source = a4.data_source
join (select distinct mbl_no
      from warehouse_data_user_action_day a
      where allpv > '0'
      and extractday between '2019-11-01' and '2019-11-10'
	  and data_source = 'sjd'
      ) a2
	  on a1.mbl_no = a2.mbl_no
left outer join (select distinct mbl_no,data_source
			     from warehouse_data_user_review_info a
			     where product_name = '现金分期-万达普惠'
				   and data_source = 'sjd') a3
			on a1.mbl_no = a3.mbl_no
           and a1.data_source = a3.data_source
		   
left join (select distinct mbl_no,credit_time,amount
           from 
           (select mbl_no,
                   amount,
           		credit_time,
           	    Row_Number() OVER (partition by mbl_no ORDER BY credit_time desc) rank     
           from warehouse_data_user_review_info a
           where product_name = '优智借'
             and data_source = 'sjd'
             and status = '通过') b
           where b.rank = '1') a5
		on a1.mbl_no = a5.mbl_no                    -----已修改，要取最近一次授信
where a1.product_name = '优智借'
  and a1.data_source = 'sjd'
  and a1.cash_amount > '0'
  and a3.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe WHERE eff_flg = '1')
  
  )