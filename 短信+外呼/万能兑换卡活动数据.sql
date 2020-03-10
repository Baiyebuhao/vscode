347	统计需求  徐超、田婷    1、紧急且重要 2019.6.4 夏玮扬 金融苑 2019.6.5 
一次性需求 好借钱、马上随借随还 金融苑  活动数据统计  
万能兑换卡活动数据监测统计（上到BI上），活动点击-立即兑换-立即提现，链接单独发送

----金融苑开屏
select a.platform as data_source,
       a.extractday,
       'xnhd' AS channel,
       '001' AS childchan,
       '开屏' AS button_enname,
       '万能兑换卡' AS game_name,       
	   count(extractday) as cs,
       count(distinct a.device_id) as sbs,
       count(distinct a.mbl_no) as rs
from warehouse_newtrace_click_record a
where a.platform = 'jry'
and a.extractday >= '2019-06-04'
and a.page_enname = 'ad_kp'
and a.button_enname = 'ad_kp'
and a.ad_url = 'https://activity.xycredit.com.cn/activityProject/januaryNewYear/initialization?activityCode=xnhd&platform=jry&envm=1&channel=xnhd&childchan=001'
group by a.platform,a.extractday

UNION ALL
-----金融苑banner
select a.platform as data_source,
       a.extractday,
       'xnhd' AS channel,
       '003' AS childchan,
       'banner' AS button_enname,
       '万能兑换卡' AS game_name,       
	   count(extractday) as cs,
       count(distinct a.device_id) as sbs,
       count(distinct a.mbl_no) as rs
from warehouse_newtrace_click_record a
where a.platform = 'jry'
and a.extractday >= '2019-06-04'
and a.page_enname = 'supermarket'
and a.button_enname = 'banner'
and a.ad_name = '万能兑换卡'
group by a.platform,a.extractday

UNION ALL
----2.各按钮点击人数
------次数，设备数，人数
select a.platform as data_source,
       a.extractday,
       a.channel,
       a.childchan,
       a.button_enname,
       '万能兑换卡' AS game_name,
	   count(extractday) as cs,
       count(distinct a.device_id) as sbs,
       count(distinct a.mbl_no) as rs
from warehouse_newtrace_click_record a
where a.extractday >= '2019-06-04'
and a.page_enname = 'activities'
and a.game_name = '奖品兑换'
and a.channel = 'xnhd'
group by a.platform,a.extractday,a.channel,a.childchan,a.page_name,a.button_enname
		 
