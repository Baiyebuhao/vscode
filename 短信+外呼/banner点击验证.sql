1.banner点击
select platform,ad_name,
count(distinct mbl_no) as rs
from warehouse_newtrace_click_record a
where extractday = '2019-04-16'
and button_enname = 'banner'
and page_enname = 'supermarket'
group by platform,ad_name


-------------------------------总埋点表
desc warehouse_data_user_page_action

select sys_id,product_name,
count(distinct mbl_no) as rs
from warehouse_data_user_page_action a
where button_name = 'banner'
and extractday = '2019-04-15'
group by sys_id,product_name

-------------------------------新埋点表
desc warehouse_newtrace_click_record
select * from warehouse_newtrace_click_record a
where extractday = '2019-04-15'
and button_enname = 'banner'
and page_enname = 'supermarket'

---------------------每个banner点击人数（新埋点表）
select platform,ad_name,
count(distinct mbl_no) as rs
from warehouse_newtrace_click_record a
where extractday = '2019-04-15'
and button_enname = 'banner'
and page_enname = 'supermarket'
group by platform,ad_name
----------------------每个平台banner点击总人数（新埋点表）（可区分banner位置）
select platform,
count(distinct mbl_no) as rs
from warehouse_newtrace_click_record a
where extractday = '2019-04-15'
and button_enname = 'banner'
and page_enname = 'supermarket'
and ad_name <> 'NULL'
group by platform
----------------------每个平台banner点击总人数（总点击表）
select sys_id,
count(distinct mbl_no) as rs
from warehouse_data_user_page_action a
where button_name = 'banner'
and extractday = '2019-04-15'
group by sys_id




