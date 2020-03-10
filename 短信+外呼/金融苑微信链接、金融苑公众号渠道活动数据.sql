259	取数需求		徐超				
3、重要不紧急	2019.5.9	夏玮扬	金融苑	2019.5.16	不定期需求	金融苑平台全产品	金融苑	数据统计	

2019年5月1日-5月15日机构（金融苑有T+1返数的产品）返回授信成功中有多少人在h5页面点击了立即申请（这部分用户提现的总金额）
渠道名称：金融苑微信链接、金融苑公众号	
-------------
-------------授信通过用户 53人
select distinct mbl_no
from warehouse_data_user_review_info a1
where credit_time between '2019-05-01' and '2019-05-16'
and status = '通过'
and data_source = 'jry'

(
1	jryapp
2	jrydx
3	wxbzs
4	jrywxlj
5	mxqzx
6	scyddxyx
7	wxff)

-----------
-----------金融苑微信链接 点击用户 152人
select distinct inbox_mbl_no as mbl_no
from warehouse_newtrace_click_record a2
where extractday between '2019-05-01' and '2019-05-16'
and page_enname like 'H5%'
and platform = 'jry'
and channel = 'jrywxlj'
-----------
-----------授信4
select count(distinct a1.mbl_no)
from warehouse_data_user_withdrawals_info a1
where a1.cash_time between '2019-05-01' and '2019-05-16'
  and a1.data_source = 'jry' 
  and a1.mbl_no in 
  (select distinct a2.inbox_mbl_no as mbl_no
   from warehouse_newtrace_click_record a2
   where a2.extractday between '2019-05-01' and '2019-05-16'
   and a2.page_enname like 'H5%'
   and a2.platform = 'jry'
   and a2.channel = 'jrywxlj')


---------
---------提现4人,21500元
---------现金分期-招联	3	17200
---------随借随还-马上	1	4300
select count(distinct a1.mbl_no),sum(cash_amount)
from warehouse_data_user_withdrawals_info a1
where a1.cash_time between '2019-05-01' and '2019-05-16'
  and a1.data_source = 'jry' 
  and a1.mbl_no in 
  (select distinct a2.inbox_mbl_no as mbl_no
   from warehouse_newtrace_click_record a2
   where a2.extractday between '2019-05-01' and '2019-05-16'
   and a2.page_enname like 'H5%'
   and a2.platform = 'jry'
   and a2.channel = 'jrywxlj')



















