619 短信需求  徐超   3、重要不紧急 纪春艳 平台运营 2019.9.29 2019.9.30 
一次性需求 优卡贷 移动手机贷 移动手机贷 短信营销 按序号分包 
1、好借钱、优智借已授信用户且额度过期的移动用户；
2、R值为3，且M值为1,2,3的移动用户；
3、2019年有提现行为的用户且近3个月有产品点击行为的移动用户；
4、2019年已实名用户中，用户测评填写有房信息的用户，且近3个月有点击行为的移动用户；
5、2019年1.1-2019.5.31 双平台申请且审批通过了新网好人贷的移动用户；
6、历史累计申请且审批通过了招联-公积金贷/白领贷/大期贷/业主贷的移动用户（双平台）；
7、历史累计申请且审批通过了北银、锦程的移动用户；

(---好借钱、优智借已授信用户且额度过期的移动用户；SJD_AN360_001
select distinct a1.mbl_no as mbl_no,
       a1.data_source as data_source
from warehouse_atomic_user_info a1
join (select distinct a.mbl_no
      from warehouse_atomic_zhaolian_review_result_info a
      where a.apply_status_desc = '申请成功'
        and a.data_source = 'sjd'
        and a.apply_time <= '20180929'
      union 
      select distinct a.mbl_no
      from warehouse_atomic_yzj_review_result_info a
      where a.credit_status = '3'
        and substring(a.credit_time,1,10) <= '2019-08-29'
        and a.data_source = 'sjd'
        and a.credit_amt > '0') a2
      on a1.mbl_no = a2.mbl_no
where a1.data_source = 'sjd'
  and a1.isp LIKE '%移动%'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');
)

(---R值为3，且M值为1,2,3的移动用户；SJD_AN360_002
select distinct a1.mbl_no as mbl_no,
       a1.data_source as data_source
from warehouse_data_user_channel_info a1
join warehouse_atomic_user_info a2
  on a1.mbl_no = a2.mbl_no
 and a1.data_source = a2.data_source
where a1.rtype in ('3')
  and a1.mtype in ('1','2','3')
  and a1.data_source = 'sjd'
  and a1.mbl_no like 'MT%'
  and a2.isp LIKE '%移动%'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');
)

(---2019年有提现行为的用户且近3个月有产品点击行为的移动用户；SJD_AN360_003
select distinct a1.mbl_no as mbl_no,
       a1.data_source as data_source
from warehouse_data_user_withdrawals_info a1

join (select distinct mbl_no
      from warehouse_data_user_action_day a
	  where product_name is not null
	    and extractday between '2019-07-01' and '2019-09-28'
		and data_source = 'sjd')a2
  on a1.mbl_no = a2.mbl_no

join (select distinct mbl_no
      from warehouse_atomic_user_info a
	  where isp LIKE '%移动%'
	    and data_source = 'sjd')a3
  on a1.mbl_no = a3.mbl_no

where a1.data_source = 'sjd'
  and a1.cash_time >= '2019-01-01'
  and a1.cash_amount > '0'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');
)

(---2019年已实名用户中，用户测评填写有房信息的用户，且近3个月有点击行为的移动用户；SJD_AN360_004
select distinct a1.mbl_no as mbl_no,
       a1.data_source as data_source       
from warehouse_atomic_user_info a1

join warehouse_atomic_all_process_info a2
  on a1.mbl_no = a2.mbl_no 
 and a1.data_source = a2.data_source

join (select distinct mbl_no
      from warehouse_atomic_evaluation_process_info a
      where que_id = '2015070612070004'
        and TRIM(OPT_SEQ) = '1'
        and data_source = 'sjd') a3
      on a1.mbl_no = a3.mbl_no

join (select distinct mbl_no
      from warehouse_data_user_action_day a
      where extractday between '2019-07-01' and '2019-09-29'
	    and data_source = 'sjd') a4
	  on a1.mbl_no = a4.mbl_no
where a1.data_source = 'sjd'
  and a1.isp LIKE '%移动%'
  and a2.action_name = '实名'
  and a2.action_date between '2019-01-01' and '2019-09-29'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');
)

(---2019年1.1-2019.5.31 双平台申请且审批通过了新网好人贷的移动用户；SJD_AN360_005  无数据
select distinct a1.mbl_no as mbl_no,
       a1.data_source as data_source
from warehouse_data_user_review_info a1
join warehouse_atomic_user_info a2
  on a1.mbl_no = a2.mbl_no
 and a1.data_source = a2.data_source
where a1.product_name = '好人贷'
  and a1.status = '通过'
  and a1.apply_time between '2019-01-01' and '2019-05-31'
  and a2..isp LIKE '%移动%'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');
)

(--历史累计申请且审批通过了招联-公积金贷/白领贷/大期贷/业主贷的移动用户（双平台）；SJD_AN360_006
---('公积金社保贷-招联','白领贷-招联','大期贷-招联','业主贷-招联')
select distinct a1.mbl_no as mbl_no,
       a1.data_source as data_source
from warehouse_data_user_review_info a1
join warehouse_atomic_user_info a2
  on a1.mbl_no = a2.mbl_no
 and a1.data_source = a2.data_source
where a1.product_name in ('公积金社保贷-招联','白领贷-招联','大期贷-招联','业主贷-招联')
  and a1.status = '通过'
  and a2.isp LIKE '%移动%'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');
)

























