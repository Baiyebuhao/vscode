---------0301-0319
select distinct a2.mbl_no,a2.sex_desc,a2.age,a2.chan_no,a2.chan_no_desc,a2.child_chan,
       a2.os_type,a2.os_version,a2.mbl_type,a2.imei,
       b1.mbl_num,
	   a2.province_desc,a2.city_code,a2.city_desc,
	   b4.longitude,b4.latitude,
	   a2.registe_date,
	   b2.action_date,b2.action_time,
	   a2.edu_level_code,a2.edu_level_desc,a2.nation,a2.emp_code,a2.emp_desc,
	   b3.product_num,
	   a2.isp
from warehouse_atomic_user_info a2
left join 
    (select imei,count(mbl_no) as mbl_num
			from warehouse_atomic_user_info a1
			where data_source = 'sjd'
			and imei <> 'NULL'
			group by imei) b1       ----------对应设备手机号数量   ----（用户表关联，分组汇总，全量表）
on a2.imei = b1.imei
left join 
    (select mbl_no,action_date,action_time
			from warehouse_atomic_all_process_info a3
			where action_name = '注册'
			and data_source = 'sjd'
			and action_date >= '2019-03-01') b2         -----（all_process表，取注册时点）   
on a2.mbl_no = b2.mbl_no and a2.registe_date = b2.action_date
left join
    (select extractday,mbl_no,
            count (distinct product_name) as product_num
            from warehouse_data_user_action_day a4
            where applypv > '0'
            and extractday >= '2019-03-01'
            and product_name <> 'NULL'
			and mbl_no <> 'NULL'
            group by extractday,mbl_no) b3             -------注册当日，申请的产品数（点击立即申请）
on a2.mbl_no = b3.mbl_no and a2.registe_date = b3.extractday
left join
    (select mbl_no,min(extractday) as extractday,
	        min(longitude) as longitude,
			min(latitude) as latitude
            from warehouse_newtrace_click_record a5
            where platform = 'sjd'
            and extractday >= '2019-03-01'
            group by mbl_no) b4                        -------经纬度（用户点击表）
on a2.mbl_no = b4.mbl_no and a2.registe_date = b4.extractday
where registe_date >= '2019-03-01'
and data_source = 'sjd'