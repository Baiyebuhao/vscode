556 短信需求  徐超 已编码    3、重要不紧急 纪春艳 平台运营 2019.8.27 2019.8.28 
一次性需求 好借钱 移动手机贷 移动手机贷 短信营销 按序号分包

1、手机贷平台，历史钱包易贷授信通过用户，且2019年有点击行为用户，剔除已申请好借钱产品用户；
2、手机贷平台，8.1-8.26日注册未申请好借钱产品用户；
3、手机贷平台，RFM模型中，R值为1、2，且M值为1、2、3的用户，剔除已申请好借钱产品用户

--1手机贷平台，历史钱包易贷授信通过用户，且2019年有点击行为用户，剔除已申请好借钱产品用户
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_review_info a1
left outer join (select distinct mbl_no
                 from warehouse_data_user_review_info a
                 where product_name = '现金分期-招联'
				 and data_source = 'sjd'
				 ) a2
         on a1.mbl_no = a2.mbl_no
join (select distinct mbl_no
      from warehouse_data_user_action_day a
      where extractday >= '2019-01-01'
	    and data_source = 'sjd') a3
		on a1.mbl_no = a3.mbl_no		
where a1.product_name = '随借随还-钱包易贷'
  and a1.status = '通过'
  and a1.data_source = 'sjd'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');

--2手机贷平台，8.1-8.26日注册未申请好借钱产品用户
select a1.mbl_no,
       a1.data_source
from warehouse_atomic_user_info a1
left outer join (select distinct mbl_no
                 from warehouse_data_user_review_info a
                 where product_name = '现金分期-招联'
				   and data_source = 'sjd'
				 ) a2
         on a1.mbl_no = a2.mbl_no
where a1.data_source = 'sjd'
  and a1.registe_date between '2019-08-01' and '2019-08-26'
  and a2.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');

--3 手机贷平台，RFM模型中，R值为1、2，且M值为1、2、3的用户，剔除已申请好借钱产品用户
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_channel_info a1
left outer join(select distinct mbl_no 
                from warehouse_data_user_review_info a
			    where product_name = '现金分期-招联'
				  and data_source = 'sjd')a2
		on a1.mbl_no = a2.mbl_no
where a1.rtype in ('1','2')
  and a1.mtype in ('1','2','3')
  and a1.data_source = 'sjd'
  and a2.mbl_no is null
  and a1.mbl_no like 'MT%'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');

