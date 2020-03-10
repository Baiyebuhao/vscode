----------外呼XYQB_AN192_001
select a.data_source, 
       a.registe_date,
       a.mbl_no,
	   a.name
from warehouse_atomic_user_info a   
 left join warehouse_atomic_all_process_info c
    on a.mbl_no = c.mbl_no 
   and a.data_source = c.data_source
 left outer join warehouse_data_user_review_info b
     on a.mbl_no = b.mbl_no 
   and a.data_source = b.data_source      
 where a.registe_date between '2019-05-06' and '2019-05-08'                  ---------选择注册时间维度
   and c.action_name = '实名'
   and c.action_date between '2019-05-06' and '2019-05-08'                   ------------选择实名时间维度
   and a.data_source = 'xyqb'
   and b.mbl_no is null
   and a.mbl_no not in (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe WHERE eff_flg = '1') 