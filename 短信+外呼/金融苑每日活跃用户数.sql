300	统计需求		徐超	3、重要不紧急	
2019.5.20	秦练	金融苑	2019.5.20	一次性需求	全平台	金融苑	验证标准H5埋点是否同步		

5.13-5.19日，每天在金融苑APP内活跃用户数 和 在金融苑标准H5活跃人数（按点击行为）


--------新埋点表-金融苑APP活跃用户数
select extractday,count(distinct mbl_no)
from warehouse_newtrace_click_record a
where extractday between '2019-05-13' and '2019-05-19'
  and platform = 'jry'
  and page_enname not in ('H5identify','H5login','H5productdetail','H5supermarket')
group by extractday

--------新埋点表-金融苑H5活跃用户数
select extractday,count(distinct mbl_no)
from warehouse_newtrace_click_record a
where extractday between '2019-05-13' and '2019-05-19'
  and platform = 'jry'
  and page_enname in ('H5identify','H5login','H5productdetail','H5supermarket')
group by extractday

-----汇总
select extractday,
       count(DISTINCT CASE
                          WHEN (page_enname in ('H5identify','H5login','H5productdetail','H5supermarket')) THEN mbl_no
                      END) AS H5_rs,
       count(DISTINCT CASE
                          WHEN (page_enname not in ('H5identify','H5login','H5productdetail','H5supermarket')) THEN mbl_no
                      END) AS app_rs,
	   count(DISTINCT mbl_no) AS rs
from warehouse_newtrace_click_record a
where extractday between '2019-05-13' and '2019-05-19'
  and platform = 'jry'
group by extractday






--------老埋点表-金融苑APP活跃用户数（无数据）
select distinct mbl_no
from warehouse_atomic_user_action b2
where sys_id = 'jry'
and extractday = '2019-05-13'