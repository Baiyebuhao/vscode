1季度(1月1号-3月26号)新老用户转化（享宇钱包平台）         
注册 点击申请 申请人数 授信人数 提现人数 申请次数 授信次数 提现次数 放款金额

1.取注册
select count(distinct mbl_no)
from warehouse_atomic_user_info
where registe_date between '2019-01-01' and '2019-03-26'
and data_source = 'xyqb'

2.取推送
select count(distinct a1.mbl_no) as tsrs,         ------推送人数
       count(a1.mbl_no) as tscs                   ------推送次数
from warehouse_data_user_page_action a1
where a1.extractday between '2019-01-01' and '2019-03-26'
and a1.button_name in ('申请','立即申请') 
and a1.sys_id = 'xyqb'
-----总推送
and a1.mbl_no in
(select distinct a.mbl_no from warehouse_atomic_user_info a
where a.registe_date between '2019-01-01' and '2019-03-26'
and a.data_source = 'xyqb')
-----新用户推送
3.取申请
select count(distinct a1.mbl_no) as sqrs,
       count(a1.mbl_no) as sqcs
from warehouse_data_user_review_info a1
where a1.apply_time between '2019-01-01' and '2019-03-26'
and a1.data_source = 'xyqb'
-----总申请
and a1.mbl_no in
(select distinct a.mbl_no from warehouse_atomic_user_info a
where a.registe_date between '2019-01-01' and '2019-03-26'
and a.data_source = 'xyqb')
-----新用户申请
4.取授信
select count(distinct a1.mbl_no) as sxrs,
       count(a1.mbl_no) as sxcs
from warehouse_data_user_review_info a1
where a1.apply_time between '2019-01-01' and '2019-03-26'
and a1.status = '通过'
and a1.data_source = 'xyqb'
-----总授信
and a1.mbl_no in
(select distinct a.mbl_no from warehouse_atomic_user_info a
where a.registe_date between '2019-01-01' and '2019-03-26'
and a.data_source = 'xyqb')
-----新用户授信
5.取提现
select count(distinct a1.mbl_no) as txrs,
       count(a1.mbl_no) as txcs,
       sum(a1.cash_amount) as txje
from warehouse_data_withdrawals_info a1
where a1.cash_time between '2019-01-01' and '2019-03-26'
and a1.data_source = 'xyqb'
-----总提现
and a1.mbl_no in
(select distinct a.mbl_no from warehouse_atomic_user_info a
where a.registe_date between '2019-01-01' and '2019-03-26'
and a.data_source = 'xyqb')
-----新用户提现