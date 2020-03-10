317	Push需求 徐超 2019.5.28	刘虹 移动手机贷	2019.5.29
一次性需求	全平台	移动手机贷	移动手机贷	
push营销
1.2019年4月1日至今，马上随借随还有提现行为的用户，剔除已申请好借钱的用户。

select a1.mbl_no,a1.data_source
from warehouse_data_user_withdrawals_info a1
left outer join (select distinct mbl_no,data_source
			     from warehouse_data_user_review_info a
			     where product_name = '现金分期-招联'
				   and data_source = 'sjd') a2
			on a1.mbl_no = a2.mbl_no
           and a1.data_source = a2.data_source
where a1.product_name = '随借随还-马上'
  and a1.data_source = 'sjd'
  and a1.cash_amount > '0'
  and a1.cash_time between '2019-04-01' and '2019-05-28'
  and a2.mbl_no is null


2.2019年4月1日至今，在app中有点击好借钱立即申请按钮，但未提交申请资料的用户。
3..2019年4月1日至今实名用户中，在智能推荐系统中，产品中审批通过率好借钱排名第一的用户。