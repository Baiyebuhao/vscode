489 短信需求  徐超 已编码    3、重要不紧急 2019.8.1 纪春艳 平台运营 2019.8.2上午 
一次性需求 好借钱 金融苑 金融苑 短信营销 不要15日去重
金融苑平台，7月申请好借钱产品已授信至今未提现用户 

select distinct a1.mbl_no,
                a1.data_source
from warehouse_data_user_review_info a1

left outer join (select  distinct mbl_no,data_source
                 from warehouse_data_user_withdrawals_info a
                 where data_source = 'jry'
				   and product_name = '现金分期-招联'
				   and cash_amount > '0') a2
            on a1.mbl_no = a2.mbl_no
           and a1.data_source = a2.data_source
		   
where a1.product_name = '现金分期-招联'
   and a1.data_source = 'jry'
   and a1.status = '通过'
   and a1.credit_time between '2019-07-01' and '2019-07-31'
   and a2.mbl_no is null