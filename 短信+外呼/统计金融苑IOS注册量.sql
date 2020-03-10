统计金融苑IOS注册量

select count(distinct a.mbl_no)

from warehouse_atomic_all_process_info a

left join warehouse_atomic_user_info b

on a.mbl_no = b.mbl_no and a.data_source = b.data_source

where a.action_name = '注册' and a.action_date = '2018-09-26' and a.data_source = 'xyqb' and b.app_version = '1.0.0' 