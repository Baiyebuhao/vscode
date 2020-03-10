新老页面活跃用户对比（手机贷）（安卓）
（4月1日-4月20日）'2019-04-01' and '2019-04-20'
（5月1日-5月20日）'2019-05-01' and '2019-05-20'
------
------1.汇总1
1.1总
select count(distinct a1.mbl_no)
from
(select distinct mbl_no
from warehouse_newtrace_click_record b1
where platform = 'sjd'
  and extractday between '2019-04-01' and '2019-04-20'
  and os = 'Android'
UNION
select distinct mbl_no
from warehouse_atomic_user_action b2
where sys_id = 'sjd'
  and extractday between '2019-04-01' and '2019-04-20'
  and chan_no <> '000'
) a1

1.2总（新用户）
select count(distinct a1.mbl_no)
from
(select distinct mbl_no
from warehouse_newtrace_click_record b1
where platform = 'sjd'
  and extractday between '2019-04-01' and '2019-04-20'
  and os = 'Android'
UNION
select distinct mbl_no
from warehouse_atomic_user_action b2
where sys_id = 'sjd'
  and extractday between '2019-04-01' and '2019-04-20'
  and chan_no <> '000'
) a1
join warehouse_atomic_user_info a2
on a1.mbl_no =a2.mbl_no
where a2.registe_date between '2019-04-01' and '2019-04-20'
  and a2.data_source = 'sjd'
  

------
------1.细分2
1.3细分
select count(distinct a1.mbl_no),a1.page_enname,a1.button_enname
from
(select distinct mbl_no,page_enname,button_enname
from warehouse_newtrace_click_record b1
where platform = 'sjd'
  and extractday between '2019-04-01' and '2019-04-20'
  and os = 'Android'
UNION
select distinct mbl_no,page_id as page_enname,event_id as button_enname
from warehouse_atomic_user_action b2
where sys_id = 'sjd'
  and extractday between '2019-04-01' and '2019-04-20'
  and chan_no <> '000'
) a1
group by a1.page_enname,a1.button_enname

1.4细分（新用户）
select count(distinct a1.mbl_no),a1.page_enname,a1.button_enname
from
(select distinct mbl_no,page_enname,button_enname
from warehouse_newtrace_click_record b1
where platform = 'sjd'
  and extractday between '2019-04-01' and '2019-04-20'
  and os = 'Android'
UNION
select distinct mbl_no,page_id as page_enname,event_id as button_enname
from warehouse_atomic_user_action b2
where sys_id = 'sjd'
  and extractday between '2019-04-01' and '2019-04-20'
  and chan_no <> '000'
) a1
join warehouse_atomic_user_info a2
on a1.mbl_no =a2.mbl_no
where a2.registe_date between '2019-04-01' and '2019-04-20'
  and a2.data_source = 'sjd'
group by a1.page_enname,a1.button_enname
------
------2.每日汇总
2.1每日汇总
select count(distinct a1.mbl_no),a1.extractday
from
(select distinct mbl_no,extractday
from warehouse_newtrace_click_record b1
where platform = 'sjd'
  and extractday between '2019-04-01' and '2019-04-20'
  and os = 'Android'
UNION
select distinct mbl_no,extractday
from warehouse_atomic_user_action b2
where sys_id = 'sjd'
  and extractday between '2019-04-01' and '2019-04-20'
  and chan_no <> '000'
) a1
group by a1.extractday

2.2每日汇总（新用户）
select count(distinct a1.mbl_no),a1.extractday
from
(select distinct mbl_no,extractday
from warehouse_newtrace_click_record b1
where platform = 'sjd'
  and extractday between '2019-04-01' and '2019-04-20'
  and os = 'Android'
UNION
select distinct mbl_no,extractday
from warehouse_atomic_user_action b2
where sys_id = 'sjd'
  and extractday between '2019-04-01' and '2019-04-20'
  and chan_no <> '000'
) a1
join warehouse_atomic_user_info a2
on a1.mbl_no =a2.mbl_no
where a2.registe_date between '2019-04-01' and '2019-04-20'
  and a2.data_source = 'sjd'
group by a1.extractday

------
------2.每日细分
2.3每日细分
select count(distinct a1.mbl_no),a1.page_enname,a1.button_enname,a1.extractday
from
(select distinct mbl_no,page_enname,button_enname,extractday
from warehouse_newtrace_click_record b1
where platform = 'sjd'
  and extractday between '2019-04-01' and '2019-04-20'
  and os = 'Android'
UNION
select distinct mbl_no,page_id as page_enname,event_id as button_enname,extractday
from warehouse_atomic_user_action b2
where sys_id = 'sjd'
  and extractday between '2019-04-01' and '2019-04-20'
  and chan_no <> '000'
) a1
group by a1.page_enname,a1.button_enname,a1.extractday

2.4每日细分（新用户）
select count(distinct a1.mbl_no),a1.page_enname,a1.button_enname,a1.extractday
from
(select distinct mbl_no,page_enname,button_enname,extractday
from warehouse_newtrace_click_record b1
where platform = 'sjd'
  and extractday between '2019-04-01' and '2019-04-20'
  and os = 'Android'
UNION
select distinct mbl_no,page_id as page_enname,event_id as button_enname,extractday
from warehouse_atomic_user_action b2
where sys_id = 'sjd'
  and extractday between '2019-04-01' and '2019-04-20'
  and chan_no <> '000'
) a1
join warehouse_atomic_user_info a2
on a1.mbl_no =a2.mbl_no
where a2.registe_date between '2019-04-01' and '2019-04-20'
  and a2.data_source = 'sjd'
group by a1.page_enname,a1.button_enname,a1.extractday

