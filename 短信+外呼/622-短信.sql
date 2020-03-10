622 短信需求  赵小庆 已编码    3、重要不紧急 纪春艳 平台运营 2019.9.29 2019.9.30 
一次性需求 马上随借随还 移动手机贷 移动手机贷 短信营销 按序号分包
1、移动手机贷平台，马上随借随还已授信未提现且授信额度大于5000的移动用户（额度在有效期内）；
2、移动手机贷平台，提取额度有效期内，马上随借随还仅提现一次用户且授信额度大于5000的移动用户 
--2、移动手机贷平台，提取额度有效期内，马上随借随还仅提现一次用户且授信额度大于5000的移动用户

(--仅提现一次的马上随借随还用户
select mbl_no,
       count(mbl_no) as tx_cs
from warehouse_data_user_withdrawals_info a
where data_source = 'sjd'
  and product_name = '随借随还-马上'
  and cash_amount > '0'
group by mbl_no
having count(mbl_no) = 1
)


--授信额度大于5000
select a1.mbl_no as mbl_no,
       'sjd' as data_source
from(--取授信额度
     select distinct mbl_no,
            acc_lim/100 as num1,
            Row_Number() OVER (partition by mbl_no ORDER BY credit_time desc) rank
     from warehouse_atomic_msd_review_result_info a
     where appral_res = '通过'
       and mbl_no is not null
       and data_source = 'sjd') a1
join (--仅提现一次的马上随借随还用户
      select mbl_no,
             count(mbl_no) as tx_cs
      from warehouse_data_user_withdrawals_info a
      where data_source = 'sjd'
        and product_name = '随借随还-马上'
        and cash_amount > '0'
      group by mbl_no
      having count(mbl_no) = 1
      )a2
	  on a1.mbl_no = a2.mbl_no
join (--取移动用户
      select distinct mbl_no 
      from warehouse_atomic_user_info a
	  where isp LIKE '%移动%'
	    and data_source = 'sjd'
      )a3
  on a1.mbl_no = a3.mbl_no
where a1.rank = '1'
  and a1.num1 > '5000'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');



