-----新用户转化（分产品）2        
-----注册 点击申请 申请人数 授信人数 提现人数 放款金额
--product_name = '随借随还-马上'   
--                随借随还-钱包易贷                 
--                信用钱包                          
--                现金分期-万达普惠                
--                现金分期-兴业消费

select *
from 
(select count(distinct mbl_no) as zc
from warehouse_atomic_user_info
where registe_date between '2019-03-25' and '2019-03-31'
) b1
left join 
(select count(distinct a1.mbl_no) as ts         ------推送人数
from warehouse_data_user_page_action a1
where a1.extractday between '2019-03-25' and '2019-03-31'
and a1.button_name in ('申请','立即申请') 
and a1.product_name = '随借随还-马上'
and a1.mbl_no in
(select distinct a.mbl_no from warehouse_atomic_user_info a
where a.registe_date between '2019-03-25' and '2019-03-31')
-----新用户推送
) b2 
left join 
(select count(distinct a1.mbl_no) as sq
from warehouse_data_user_review_info a1
where a1.apply_time between '2019-03-25' and '2019-03-31'
and a1.product_name = '随借随还-马上'
and a1.mbl_no in
(select distinct a.mbl_no from warehouse_atomic_user_info a
where a.registe_date between '2019-03-25' and '2019-03-31')
-----新用户申请
) b3
left join 
(select count(distinct a1.mbl_no) as sx
from warehouse_data_user_review_info a1
where a1.apply_time between '2019-03-25' and '2019-03-31'
and a1.status = '通过'
and a1.product_name = '随借随还-马上'
and a1.mbl_no in
(select distinct a.mbl_no from warehouse_atomic_user_info a
where a.registe_date between '2019-03-25' and '2019-03-31')
-----新用户授信
) b4
left join 
(select count(distinct a1.mbl_no) as tx,
       sum(a1.cash_amount) as txe
from warehouse_data_withdrawals_info a1
where a1.cash_time between '2019-03-25' and '2019-03-31'
and a1.product_name = '随借随还-马上'
and a1.mbl_no in
(select distinct a.mbl_no from warehouse_atomic_user_info a
where a.registe_date between '2019-03-25' and '2019-03-31')
-----新用户提现
) b5