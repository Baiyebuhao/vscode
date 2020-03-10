--额度有效期内，马上随借随还仅提现一次用户
select count(distinct a1.mbl_no)
from 
(select mbl_no 
   FROM warehouse_atomic_msd_withdrawals_result_info
   WHERE paid_out_time>='2019-08-23'
     AND data_source ='sjd' 
	 and mbl_no !='NULL' 
     and total_amount> 0) a1
join
(select * from
              (select mbl_no,count(mbl_no) as cs
                FROM warehouse_atomic_msd_withdrawals_result_info
                where total_amount> 0
                  and mbl_no !='NULL'
              	 and data_source ='sjd'
			   group by mbl_no) a
 where a.cs = 1 ) a2
on a1.mbl_no = a2.mbl_no

left outer join (SELECT mbl_no
                 FROM warehouse_atomic_smstunsubscribe 
                 WHERE eff_flg = '1'
                 UNION
                 SELECT mbl_no_encode
                 FROM warehouse_atomic_operation_promotion 
                 WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date()
                   AND marketing_type = 'DX' and data_desc  != 'SJD_AN316_001') a3
		on a1.mbl_no = a3.mbl_no
where a3.mbl_no is null
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe 
WHERE eff_flg = '1' UNION SELECT mbl_no_encode FROM warehouse_atomic_operation_promotion 
WHERE data_extract_day BETWEEN date_sub(current_date(),14) AND current_date() AND marketing_type = 'DX');
