统计需求	2019.5.23	4、不紧急不重要	2019.5.22	王欣	享宇钱包	2019.5.23	一次性需求
享宇钱包	看IOS下架后用户和安卓用户的活跃情况	
5月13-5月22日（IOS下架后），与4月8日-4月17号（IOS未下架\非节庆期间\非广告投放期间）,
看两个时间段安卓用户和IOS用户分别活跃用户是多少

----安卓活跃用户
select count(distinct a1.device_id) as sbs,
       count(distinct a1.mbl_no) as rs
from
(select distinct mbl_no,device_id
from warehouse_newtrace_click_record b1
where platform = 'xyqb'
  and extractday between '2019-04-08' and '2019-04-17'
  and os = 'Android'
UNION
select distinct mbl_no,device_id
from warehouse_atomic_user_action b2
where sys_id = 'xyqb'
  and extractday between '2019-04-08' and '2019-04-17'
  and chan_no <> 'appStore'
) a1

---苹果活跃用户
select count(distinct a1.device_id) as sbs,
       count(distinct a1.mbl_no) as rs
from
(select distinct mbl_no,device_id
from warehouse_newtrace_click_record b1
where platform = 'xyqb'
  and extractday between '2019-04-08' and '2019-04-17'
  and os = 'IOS'
UNION
select distinct mbl_no,device_id
from warehouse_atomic_user_action b2
where sys_id = 'xyqb'
  and extractday between '2019-04-08' and '2019-04-17'
  and chan_no = 'appStore'
) a1