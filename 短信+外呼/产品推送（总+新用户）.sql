----------------24号的推送
select count(distinct a1.mbl_no)
from
(select distinct mbl_no
from warehouse_newtrace_click_record b1
where extractday = '2019-04-24'
and product_id in ('2015070216330003','2017061510060016','40000001')
and platform = 'sjd'
and page_enname = 'product_detail'
and button_enname = 'apply'
UNION
select distinct mbl_no
from warehouse_atomic_user_action b2
where sys_id = 'sjd'
and extractday = '2019-04-24'
and product_id in ('2015070216330003','2017061510060016','40000001')
and event_id = 'apply') a1

----------------24号的新用户推送
select count(distinct a1.mbl_no)
from
(select distinct mbl_no
from warehouse_newtrace_click_record b1
where extractday = '2019-04-24'
and product_id in ('2015070216330003','2017061510060016','40000001')
and platform = 'sjd'
and page_enname = 'product_detail'
and button_enname = 'apply'
UNION
select distinct mbl_no
from warehouse_atomic_user_action b2
where sys_id = 'sjd'
and extractday = '2019-04-24'
and product_id in ('2015070216330003','2017061510060016','40000001')
and event_id = 'apply') a1
where a1.mbl_no in 
(select mbl_no from warehouse_atomic_user_info a
 where registe_date = '2019-04-24'
 and data_source = 'sjd')