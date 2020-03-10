579 短信需求  徐超 已编码    重要不紧急 纪春艳 平台运营 2019.9.4 2019.9.5 
一次性需求 好借钱 移动手机贷 移动手机贷 短信营销 按序号分包
1、R值为3、4，M值为123的联通用户，剔除已申请好借钱产品用户
2、8.1-9.3日点击好借钱产品未提交申请的联通用户
3、8.1-9.3日注册未申请好借钱产品的联通用户
--1.R值为3、4，M值为123的联通用户，剔除已申请好借钱产品用户
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_channel_info a1
left outer join(select distinct mbl_no 
                from warehouse_data_user_review_info a
			    where product_name = '现金分期-招联'
				  and data_source = 'sjd')a2
		on a1.mbl_no = a2.mbl_no
join warehouse_atomic_user_info a3
 on a1.mbl_no = a3.mbl_no
and a1.data_source = a3.data_source
where a1.rtype in ('3','4')
  and a1.mtype in ('1','2','3')
  and a1.data_source = 'sjd'
  and a1.mbl_no like 'MT%'
  and a2.mbl_no is null
  and a3.isp LIKE '%联通%'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');

--8.1-9.3日点击好借钱产品未提交申请的联通用户
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_action_day a1
left outer join 
               (select distinct mbl_no
                from warehouse_data_user_review_info a
                where product_name = '现金分期-招联'
			      and data_source = 'sjd') a2
         on a1.mbl_no = a2.mbl_no
join warehouse_atomic_user_info a3
 on a1.mbl_no = a3.mbl_no
and a1.data_source = a3.data_source
where a1.data_source = 'sjd'
  and a1.product_name = '现金分期-招联'
  and a1.extractday between '2019-08-01' and '2019-09-03' 
  and a2.mbl_no is null
  and a3.isp LIKE '%联通%'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');

--8.1-9.3日注册未申请好借钱产品的联通用户
select distinct a1.mbl_no,
       a1.data_source
from warehouse_atomic_user_info a1
left outer join (select distinct mbl_no
                 from warehouse_data_user_review_info a
                 where product_name = '现金分期-招联'
				   and data_source = 'sjd'
				 ) a2
         on a1.mbl_no = a2.mbl_no
where a1.data_source = 'sjd'
  and a1.registe_date between '2019-08-01' and '2019-09-03'
  and a1.isp LIKE '%联通%'
  and a2.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');