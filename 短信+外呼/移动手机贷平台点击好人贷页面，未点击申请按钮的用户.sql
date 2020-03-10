2019.1.1至今，移动手机贷平台点击好人贷页面，未点击申请按钮的用户
desc warehouse_newtrace_click_record

1.点击产品人数
select count (distinct a4.mbl_no)
from
(
------------banner位置（新埋点）
select extractday,mbl_no
from warehouse_newtrace_click_record a1
where button_enname = 'banner'
and extractday >= '2019-01-01'
and ad_name = '好人贷'
and platform = 'sjd'

UNION ALL
------------产品列表位置（新埋点）
select extractday,mbl_no
from warehouse_newtrace_click_record a2
where extractday >= '2019-01-01'
and product_id in ('2019010300000000','40000043')
and platform = 'sjd'
and page_enname = 'supermarket'

UNION ALL
-----------产品点击（老埋点）
select extractday,mbl_no
from warehouse_atomic_user_action a3
where sys_id = 'sjd'
  and extractday >= '2019-01-01'
  and page_id = 'supermarket'
  and event_id in ('banner','product')
  and product_id = '2019010300000000'
) a4
2.点击申请人数
select count(distinct b3.mbl_no)
from
(select extractday,mbl_no
from warehouse_newtrace_click_record b1
where extractday >= '2019-01-01'
and product_id in ('2019010300000000','40000043')
and platform = 'sjd'
and page_enname = 'product_detail'
and button_enname = 'apply'
UNION
select extractday,mbl_no
from warehouse_atomic_user_action b2
where sys_id = 'sjd'
and extractday >= '2019-01-01'
and product_id = '2019010300000000'
and event_id = 'apply'
) b3
3.点击产品但是未点击申请的人数
select count (distinct a4.mbl_no)
from
(
------------banner位置（新埋点）
select extractday,mbl_no
from warehouse_newtrace_click_record a1
where button_enname = 'banner'
and extractday >= '2019-01-01'
and ad_name = '好人贷'
and platform = 'sjd'

UNION ALL
------------产品列表位置（新埋点）
select extractday,mbl_no
from warehouse_newtrace_click_record a2
where extractday >= '2019-01-01'
and product_id in ('2019010300000000','40000043')
and platform = 'sjd'
and page_enname = 'supermarket'

UNION ALL
-----------产品点击（老埋点）
select extractday,mbl_no
from warehouse_atomic_user_action a3
where sys_id = 'sjd'
  and extractday >= '2019-01-01'
  and page_id = 'supermarket'
  and event_id in ('banner','product')
  and product_id = '2019010300000000'
) a4
left outer join
------------排除点击申请
(select distinct mbl_no
from warehouse_newtrace_click_record b1
where extractday >= '2019-01-01'
and product_id in ('2019010300000000','40000043')
and platform = 'sjd'
and page_enname = 'product_detail'
and button_enname = 'apply'
UNION
select distinct mbl_no
from warehouse_atomic_user_action b2
where sys_id = 'sjd'
and extractday >= '2019-01-01'
and product_id = '2019010300000000'
and event_id = 'apply'
) b3
on a4.mbl_no = b3.mbl_no where b3.mbl_no is null;

