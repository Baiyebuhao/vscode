491 外呼需求  李勇     1、紧急且重要 2019.8.2 何渝宏 客服部 2019.8.5 
一次性需求 优智借 移动手机贷 移动手机贷 外呼营销 所有用户 

移动手机贷历史以来优智借授信成功的用户，剔除借款成功和借款失败的用户（保留用户姓名、手机号、授信时间、授信额度）
select distinct a1.mbl_no,
                a1.data_source,
				a3.name,
				a1.credit_time,
				a1.amount
from warehouse_data_user_review_info a1
left join warehouse_atomic_user_info a3
 on a1.mbl_no = a3.mbl_no
and a1.data_source = a3.data_source

left outer join (select  distinct mbl_no,data_source
                 from warehouse_atomic_yzj_withdrawals_result_info a
				 where data_source = 'sjd') a2
            on a1.mbl_no = a2.mbl_no
           and a1.data_source = a2.data_source
		   
where a1.product_name = '优智借'
   and a1.data_source = 'sjd'
   and a1.status = '通过'
   and a2.mbl_no is null
   and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe WHERE eff_flg = '1')