500 短信需求  徐超 已编码    3、重要不紧急 纪春艳 平台运营 2019.8.6 2019.8.7上午 
一次性需求 优智借 享宇钱包 享宇钱包 短信营销 按序号分包 
1、享宇钱包平台，已授信优智借产品未发起提现用户（额度有效期内）
--XYQB_AN289_001
select distinct a1.mbl_no,
                a1.data_source
from warehouse_data_user_review_info a1
left outer join (select  distinct mbl_no,data_source
                 from warehouse_atomic_yzj_withdrawals_result_info a
				 where data_source = 'xyqb') a2
            on a1.mbl_no = a2.mbl_no
           and a1.data_source = a2.data_source
		   
where a1.product_name = '优智借'
   and a1.data_source = 'xyqb'
   and a1.status = '通过'
   and a2.mbl_no is null
   and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');


2、享宇钱包平台，RFM模型中，R值为1,2,、M值为1、2、3的用户，剔除已申请优智借产品用户；
--XYQB_AN289_002
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_channel_info a1
left outer join(select mbl_no 
                from warehouse_data_user_review_info a
			    where product_name = '优智借')a2
		on a1.mbl_no = a2.mbl_no
where a1.rtype in ('1','2')
  and a1.mtype in ('1','2','3')
  and a1.data_source = 'xyqb'
  and a2.mbl_no is null
  and a1.mbl_no like 'MT%'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');


3、享宇钱包平台，7.1-8.4点击好借钱产品但未放款用户，剔除已申请优智借产品用户
--XYQB_AN289_003
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_action_day a1
left outer join 
               (select distinct mbl_no
                from warehouse_data_user_withdrawals_info a
                where product_name = '现金分期-招联'
			      and data_source = 'xyqb') a2
         on a1.mbl_no = a2.mbl_no
left outer join 
               (select distinct mbl_no
                from warehouse_data_user_review_info a
                where product_name = '优智借'
			      and data_source = 'xyqb') a3
         on a1.mbl_no = a3.mbl_no

where a1.data_source = 'xyqb'
  and a1.product_name = '现金分期-招联'
  and a1.extractday between '2019-07-01' and '2019-08-04'
  and a2.mbl_no is null
  and a3.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');