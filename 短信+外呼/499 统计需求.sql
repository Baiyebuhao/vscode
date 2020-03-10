499 统计需求  徐超     1、紧急且重要 夏玮扬 平台运用 2019.8.6 2019.8.7 
一次性需求 - 移动手机贷、享宇钱包 - 七夕活动数据统计  

七夕活动漏斗数据搭建（BI搭建），搭建数据，单独发送
(--手机贷开屏
select a.platform as data_source,
       a.extractday,
       ---'100' AS channel,(渠道？？）
       '001' AS childchan,
       '开屏' AS button_enname,
       '七夕活动' AS game_name,       
	   count(extractday) as cs,
       count(distinct a.device_id) as sbs,
       count(distinct a.mbl_no) as rs
from warehouse_newtrace_click_record a
where a.platform = 'sjd'
and a.extractday >= '2019-08-05'
and a.page_enname = 'ad_kp'
and a.button_enname = 'ad_kp'
and a.ad_url = 'https://activity.xycredit.com.cn/qixi/?envm=1&platform=sjd&activityCode=qxhd&channel=100&childchan=001'
group by a.platform,a.extractday

--手机贷banner
select a.platform as data_source,
       a.extractday,
       '002' AS childchan,
       'banner' AS button_enname,
       '七夕活动' AS game_name,       
	   count(extractday) as cs,
       count(distinct a.device_id) as sbs,
       count(distinct a.mbl_no) as rs
from warehouse_newtrace_click_record a
where a.platform = 'sjd'
and a.extractday >= '2019-08-05'
and a.page_enname = 'supermarket'
and a.button_enname = 'banner'
and a.ad_name = '七夕活动'
group by a.platform,a.extractday

--享宇钱包开屏
select a.platform as data_source,
       a.extractday,
       '001' AS childchan,
       '开屏' AS button_enname,
       '七夕活动' AS game_name,       
	   count(extractday) as cs,
       count(distinct a.device_id) as sbs,
       count(distinct a.mbl_no) as rs
from warehouse_newtrace_click_record a
where a.platform = 'xyqb'
and a.extractday >= '2019-08-05'
and a.page_enname = 'ad_kp'
and a.button_enname = 'ad_kp'
and a.ad_url = 'https://activity.xycredit.com.cn/qixi/?envm=1&platform=xyqb&activityCode=qxhd&channel=100&childchan=001'
  
---享宇钱包banner
select a.platform as data_source,
       a.extractday,
       '002' AS childchan,
       'banner' AS button_enname,
       '七夕活动' AS game_name,       
	   count(extractday) as cs,
       count(distinct a.device_id) as sbs,
       count(distinct a.mbl_no) as rs
from warehouse_newtrace_click_record a
where a.platform = 'xyqb'
and a.extractday >= '2019-08-05'
and a.page_enname = 'supermarket'
and a.button_enname = 'banner'
and a.ad_name = '七夕活动'
group by a.platform,a.extractday)


select a.platform as data_source,
       a.extractday,
       a.childchan,
       a.button_enname,
       '七夕活动' AS game_name,
	   count(extractday) as cs,
       count(distinct a.device_id) as sbs,
       count(distinct a.mbl_no) as rs
from warehouse_newtrace_click_record a
where a.extractday >= '2019-08-05'
and a.page_enname = 'activities'
and a.game_name = '助爱七夕 提现有礼'
group by a.platform,a.extractday,a.childchan,a.page_name,a.button_enname