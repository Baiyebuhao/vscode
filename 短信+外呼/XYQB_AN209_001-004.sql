322	短信需求 徐超  3、重要不紧急 2019.5.29  纪春艳  享宇钱包  2019.5.30
一次性需求  钱伴  享宇钱包  享宇钱包  短信营销  按产品分包
----------
1、历史享宇钱包平台，已提现中邮产品的移动用户        -----'现金分期-中邮'
2、历史享宇钱包平台，已提现兴业现金分期产品的移动用户-----'现金分期-兴业消费'
3、历史享宇钱包平台，已提现万达普惠产品的移动用户    -----'现金分期-万达普惠'
4、历史享宇钱包平台，已提现现金分期点点产品的移动用户-----'现金分期-点点'

select distinct a1.mbl_no,a1.data_source,a2.name,a2.sex_desc
from warehouse_data_user_withdrawals_info a1
join warehouse_atomic_user_info a2
  on a1.mbl_no = a2.mbl_no
 and a1.data_source = a2.data_source
where a1.data_source = 'xyqb'
  and a1.product_name = '现金分期-中邮'
  and a1.cash_amount > '0'
  and a2.isp = '移动'
  and a1.mbl_no NOT IN (SELECT mbl_no
                        FROM warehouse_atomic_smstunsubscribe 
                        WHERE eff_flg = '1' UNION SELECT mbl_no_encode 
						FROM warehouse_atomic_operation_promotion 
                        WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() 
						AND marketing_type = 'DX');

