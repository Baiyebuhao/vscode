597 外呼需求  徐超     3、重要不紧急 何渝宏 客服部 2019.9.16 2019.9.17 
一次性需求 好借钱 移动手机贷 移动手机贷 外呼营销 随机平均分成两个包 

2019年7月1日-7月31日好借钱授信成功，但未发起过提现的用户(现金分期-招联)
（保留用户姓名、申请号码、授信时间、授信额度）
create table tmp_20190916_xc
as
select a1.mbl_no,
       a1.data_source,
	   a3.name,
	   a1.credit_time,
	   a1.amount
from warehouse_data_user_review_info a1
left outer join (select distinct mbl_no,data_source
                 from warehouse_data_user_withdrawals_info a
				 where data_source = 'sjd'
				   and product_name = '现金分期-招联'
				   and cash_time >= '2019-07-01') a2
             on a1.mbl_no = a2.mbl_no
            and a1.data_source = a2.data_source
left join warehouse_atomic_user_info a3
       on a1.mbl_no = a3.mbl_no
      and a1.data_source = a3.data_source
where a1.data_source = 'sjd'
  and a1.credit_time between '2019-07-01' and '2019-07-31'
  and a1.product_name = '现金分期-招联'
  and a1.status = '通过'
  and a2.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe WHERE eff_flg = '1')
  
---取随机
select * from tmp_20190916_xc
distribute by rand()
sort by rand()
limit 223;