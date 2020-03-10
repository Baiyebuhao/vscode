596 外呼需求  1、紧急且重要 刘虹 平台运营 2019.9.16 2019.9.16 
一次性需求 钱伴/优卡贷/信用钱包 三平台 三平台 外呼营销

2019年9月9日-9月15日参加中秋活动，并成功申请 钱伴、优卡贷、信用钱包且放款的用户
（需提供用户姓名、电话号码、放款金额、放款金额由高到低排序）

---参加中秋活动(无法取)

---申请授信时间为9月9日-9月15日

---提现时间为9月9日-9月15日

mbl_no,data_source,name,产品,apply_time,授信结果,授信金额,放款时间,放款金额

select * from
(select a1.mbl_no,
       a1.data_source,
	   a3.name,
	   a1.product_name,
	   sum(a1.cash_amount) as amount
from warehouse_data_user_withdrawals_info a1
join warehouse_data_user_review_info a2
 on a1.mbl_no = a2.mbl_no
and a1.data_source = a2.data_source
and a1.product_name = a2.product_name
left join warehouse_atomic_user_info a3
 on a1.mbl_no = a3.mbl_no
and a1.data_source = a3.data_source
where a1.cash_time between '2019-09-09' and '2019-09-15'
  and a1.product_name in ('现金分期-钱伴','信用钱包')
  and a2.apply_time between '2019-09-09' and '2019-09-15'
  and a2.credit_time between '2019-09-09' and '2019-09-15'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe WHERE eff_flg = '1')
group by a1.mbl_no,
         a1.data_source,
	     a3.name,
	     a1.product_name) b
order by b.amount desc


