526 统计需求  徐超      夏玮扬 平台运营 2019.8.19 2019.8.21 
一次性需求 优智借、好借钱、趣借钱 移动手机贷、享宇钱包  活数据统计  
2019.8.5-2019.8.18在七夕活动页面中点击过优智借、好借钱、钱伴三款产品立即申请按钮有多少用户提现、提现金额
（包括本次提现金额和历史提现金额，用于区分新老用户）（首次提现为新用户）

1.点击立即申请按钮的用户
select distinct a.mbl_no,
       a.button_enname,
	   a.platform as data_source
from warehouse_newtrace_click_record a
where a.extractday between '2019-08-05' and '2019-08-20'
and a.page_enname = 'activities'
and a.game_name = '助爱七夕 提现有礼'
and a.button_enname like 'apply%'
2.提现用户数据
select a1.mbl_no,
       a1.data_source,
	   a1.product_name,
	   sum(a1.cash_amount) as amount
from warehouse_data_user_withdrawals_info a1
where a1.cash_time >= '2019-08-05'
and a1.product_name in ('优智借','现金分期-招联','趣借钱')
and a1.mbl_no is not NULL
group by a1.mbl_no,
         a1.data_source,
	     a1.product_name
3.新老用户标记（是否首次提现）
select mbl_no,
       data_source,
	   cash_time,
	   cash_amount,
	   product_name,
	   Row_Number() OVER (partition by mbl_no,product_name ORDER BY cash_time) rank   --不同产品不同号码按时间进行排序，时间最早的为1
from warehouse_data_user_withdrawals_info a2
where a2.product_name in ('优智借','现金分期-招联','趣借钱')
and a2.mbl_no is not NULL

---结果
apply-1  优智借
apply-2  现金分期-招联
apply-3  趣借钱


(select a1.mbl_no,
       a1.data_source,
	   a1.product_name,
	   a2.button_enname,
	   a3.rank,
	   sum(a1.cash_amount) as amount
	   
from warehouse_data_user_withdrawals_info a1
left join warehouse_newtrace_click_record a2
 on a1.mbl_no = a2.mbl_no
and a1.data_source = a2.platform

left join 
(select mbl_no,
        data_source,
	    cash_time,
	    cash_amount,
	    product_name,
	    Row_Number() OVER (partition by mbl_no,product_name ORDER BY cash_time) rank   --不同产品不同号码按时间进行排序，时间最早的为1
from warehouse_data_user_withdrawals_info a2
where a2.product_name in ('优智借','现金分期-招联','趣借钱')
and a2.mbl_no is not NULL) a3
 on a1.mbl_no = a3.mbl_no
and a1.data_source = a3.data_source
and a3.rank = '1'

where a1.cash_time between '2019-08-05' and '2019-08-18'
and a1.product_name = '优智借'   ---'现金分期-招联','趣借钱'
and a1.mbl_no is not NULL
and a2.extractday between '2019-08-05' and '2019-08-18'
and a2.page_enname = 'activities'
and a2.game_name = '助爱七夕 提现有礼'
and a2.button_enname = 'apply-1' ---'apply-2','apply-3'

group by a1.mbl_no,
         a1.data_source,
	     a1.product_name,
		 a2.button_enname,
		 a3.rank)

不区分
(
select a1.mbl_no,
       a1.data_source,
	   a1.product_name,
	   a3.rank,
	   sum(a1.cash_amount) as amount
	   
from warehouse_data_user_withdrawals_info a1
left join warehouse_newtrace_click_record a2
 on a1.mbl_no = a2.mbl_no
and a1.data_source = a2.platform

left join 

(select * from
(select mbl_no,
        data_source,
	    cash_time,
	    cash_amount,
	    product_name,
	    Row_Number() OVER (partition by mbl_no,product_name ORDER BY cash_time) rank   --不同产品不同号码按时间进行排序，时间最早的为1
from warehouse_data_user_withdrawals_info a
where a.product_name in ('优智借','现金分期-招联','趣借钱')
and a.mbl_no is not NULL) b
where b.rank = '1'
and b.cash_time between '2019-08-05' and '2019-08-18') a3

 on a1.mbl_no = a3.mbl_no
and a1.data_source = a3.data_source
and a1.product_name = a3.product_name


where a1.cash_time between '2019-08-05' and '2019-08-18'
and a1.product_name in ('优智借','现金分期-招联','趣借钱')
and a1.mbl_no is not NULL
and a2.extractday between '2019-08-05' and '2019-08-18'
and a2.page_enname = 'activities'
and a2.game_name = '助爱七夕 提现有礼'
and a2.button_enname in ('apply-1','apply-2','apply-3')

group by a1.mbl_no,
         a1.data_source,
	     a1.product_name,
		 a3.rank
)




