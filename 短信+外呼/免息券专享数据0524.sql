create table warehouse_data_mxqzx_info
(data_source string comment '平台',
 extractday string comment '日期',
 channel string comment '主渠道',
 childchan string comment '子渠道',
 button_enname string comment '按钮名称',
 game_name string comment '活动名称',
 cs string comment '次数',
 sbs string comment '设备数',
 rs string comment '人数');
insert overwrite table warehouse_data_mxqzx_info
-----免息券专享数据2
select b1.data_source,
       b1.extractday,
	   b1.channel,
	   b1.childchan,
	   b1.button_enname,
	   b1.game_name,
	   sum(b1.cs) as cs,
	   sum(b1.sbs) as sbs,
	   sum(b1.rs) as rs 
from 
---------
---1.1弹窗点击 
--次数，设备数，人数
---手机贷弹窗
(select a.platform as data_source,
       a.extractday,
       'mxqzx' AS channel,
       '001' AS childchan,
       '弹窗' AS button_enname,
       a.ad_name as game_name,
	   count(extractday) as cs,
       count(distinct a.device_id) as sbs,
       count(distinct a.mbl_no) as rs
from warehouse_newtrace_click_record a
where a.platform = 'sjd'
and a.extractday > '2019-05-01'
and a.page_enname = 'ad_tc'
and a.button_enname = 'ad_tc'
and a.ad_name = '免息券'
group by a.platform,a.extractday,a.ad_name
------手机贷开屏（暂无）

UNION ALL
----金融苑开屏
select a.platform as data_source,
       a.extractday,
       'mxqzx' AS channel,
       '001' AS childchan,
       '开屏' AS button_enname,
       '免息券' AS game_name,       
	   count(extractday) as cs,
       count(distinct a.device_id) as sbs,
       count(distinct a.mbl_no) as rs
from warehouse_newtrace_click_record a
where a.platform = 'jry'
and a.extractday > '2019-05-21'
and a.page_enname = 'ad_kp'
and a.button_enname = 'ad_kp'
and a.ad_id = '267'
group by a.platform,a.extractday

UNION ALL
----金融苑弹窗
select a.platform as data_source,
       a.extractday,
       'mxqzx' AS channel,
       '002' AS childchan,
       '弹窗' AS button_enname,
       '免息券' AS game_name,       
	   count(extractday) as cs,
       count(distinct a.device_id) as sbs,
       count(distinct a.mbl_no) as rs
from warehouse_newtrace_click_record a
where a.platform = 'jry'
and a.extractday > '2019-05-23'
and a.page_enname = 'ad_tc'
and a.button_enname = 'ad_tc'
and a.ad_name = '免息券'
group by a.platform,a.extractday

UNION ALL
-----金融苑banner
select a.platform as data_source,
       a.extractday,
       'mxqzx' AS channel,
       '003' AS childchan,
       'banner' AS button_enname,
       '免息券' AS game_name,       
	   count(extractday) as cs,
       count(distinct a.device_id) as sbs,
       count(distinct a.mbl_no) as rs
from warehouse_newtrace_click_record a
where a.platform = 'jry'
and a.extractday > '2019-05-21'
and a.page_enname = 'supermarket'
and a.button_enname = 'banner'
and a.ad_name = '免息券活动'
group by a.platform,a.extractday

UNION ALL
----金融苑活动专区
select a.platform as data_source,
       a.extractday,
       'mxqzx' AS channel,
       '004' AS childchan,
       '活动专区' AS button_enname,
       '免息券' AS game_name,       
	   count(extractday) as cs,
       count(distinct a.device_id) as sbs,
       count(distinct a.mbl_no) as rs
from warehouse_newtrace_click_record a
where a.platform = 'jry'
and a.extractday > '2019-05-21'
and a.page_enname = 'supermarket'
and a.button_enname = 'activity'
group by a.platform,a.extractday


UNION ALL
----2.各按钮点击人数
------设备数，人数
select a.platform as data_source,
       a.extractday,
       a.channel,
       a.childchan,
       a.button_enname,
       '免息券' AS game_name,
	   count(extractday) as cs,
       count(distinct a.device_id) as sbs,
       count(distinct a.mbl_no) as rs

from warehouse_newtrace_click_record a
where a.extractday > '2019-05-09'
and a.page_enname = 'activities'
and a.game_name = '免息券专享'
and a.button_enname in ('GO','lottery','get verification code','use immediately')
group by a.platform,a.extractday,a.channel,a.childchan,a.button_enname


UNION ALL
----3.免息券领取人数
----仅人数
select a1.data_source,
       a1.extractday,
       a1.channel,
       a1.childchan,
       a1.button_enname,
       a1.game_name,
       '0' as cs,
       '0' as sbs,
       count(distinct a1.mbl_no)
from
(select a.sys_type as data_source,
       CONCAT_WS('-',substring(a.tm_smp,1,4),substring(a.tm_smp,5,2),substring(a.tm_smp,7,2)) as extractday,
	   'mxqzx' AS channel,
       '0' as childchan,
       '免息券领取' as button_enname,
	   '免息券' AS game_name,
       a.phone_number as mbl_no
from warehouse_atomic_coupon_code a 
     left join warehouse_atomic_user_info b
     on a.phone_number=b.mbl_no
where a.coupon_type='2'
and substring(a.tm_smp,1,8) > '20190509') a1

group by a1.data_source,
         a1.extractday,
         a1.channel,
         a1.childchan,
         a1.button_enname,
         a1.game_name) b1
		 
GROUP BY b1.data_source,b1.extractday,b1.channel,b1.childchan,b1.button_enname,b1.game_name
