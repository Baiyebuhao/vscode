742 短信需求  徐超     3、重要不紧急 纪春艳 平台运营 2019.11.19 2019.11.20 
一次性需求 万达普惠 移动手机贷 移动手机贷 短信营销 

1、本月已实名未申请万达普惠的联通用户； SJD_AN433_001
2、RFM模型中，F值为1、2的联通用户；剔除已申请万达普惠的用户  SJD_AN433_002
3、马上随借随还多次提现的联通用户，且近2个月无提现行为的用户，剔除已申请万达普惠的用户  SJD_AN433_003

-- SJD_AN433_001
select distinct a1.mbl_no,
       a1.data_source
from (select mbl_no,data_source
      from warehouse_atomic_user_info a
	  where a.data_source = 'sjd'
        and a.isp = '联通')a1
join (select * 
      from warehouse_atomic_all_process_info a
	  where a.action_name = '实名'
	    and a.data_source = 'sjd'
        and a.action_date between '2019-11-01' and '2019-11-30') a2
  on a1.mbl_no = a2.mbl_no 
LEFT OUTER JOIN (SELECT distinct mbl_no
                 FROM warehouse_data_user_review_info a
                 WHERE product_name = '现金分期-万达普惠') a3 
       ON a1.mbl_no = a3.mbl_no

where a3.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');

-- SJD_AN433_002
select distinct a1.mbl_no as mbl_no,
       a1.data_source as data_source
from (select distinct mbl_no,data_source
      from warehouse_data_user_channel_info a
	  where a.ftype in ('1','2')
        and a.data_source = 'sjd'
        and a.mbl_no like 'MT%'
        and a.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
      WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
      WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX')) a1

join (select mbl_no,data_source
      from warehouse_atomic_user_info a
	  where a.data_source = 'sjd'
        and a.isp = '联通') a2
	on a1.mbl_no = a2.mbl_no
left outer join(select distinct mbl_no 
                from warehouse_data_user_review_info a
			    where product_name = '现金分期-万达普惠')a3
	on a1.mbl_no = a3.mbl_no
where a3.mbl_no is null


-- SJD_AN433_003
select a1.mbl_no as mbl_no,
       'sjd' as data_source
from
(SELECT a.mbl_no,
        count(a.msd_return_time) AS n
FROM warehouse_atomic_msd_withdrawals_result_info a
WHERE a.total_amount >0
  and a.paid_out_time > '2019-11-20'
  AND a.data_source = 'sjd'
group by a.mbl_no) a1

join (select mbl_no,data_source
      from warehouse_atomic_user_info a
	  where a.data_source = 'sjd'
        and a.isp = '联通')a2
on a1.mbl_no = a2.mbl_no

left outer join 
      (select distinct mbl_no
	   from warehouse_data_user_withdrawals_info a
	   WHERE a.cash_amount >0
	     and product_name = '随借随还-马上'
         and a.cash_time > '2019-09-20'
         AND a.data_source = 'sjd') a3
on a1.mbl_no = a3.mbl_no

left outer join
       (select distinct mbl_no 
        from warehouse_data_user_review_info a
		where product_name = '现金分期-万达普惠')a4
on a1.mbl_no = a4.mbl_no

where a1.n > 1 
  and a3.mbl_no is null
  and a4.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');

