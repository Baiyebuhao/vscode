每日产品申请点击人数
select extractday,count(distinct mbl_no) as dj
from warehouse_data_user_action_day a
where data_source = 'jry'
  and product_name = '随借随还-马上'
  and extractday between '2019-04-12' and '2019-04-14'
  and applypv > '0'
group by extractday
每日申请-授信-提现数据
select * 
from warehouse_data_user_review_withdrawals_info a
where data_source = 'jry'
  and extractday between '2019-04-12' and '2019-04-14'
  and product_name = '随借随还-马上'