产品每日报盘
--分平台注册实名：
SELECT action_date,data_source,action_name,COUNT(DISTINCT  MBL_NO) 
FROM warehouse_atomic_all_process_info A 
WHERE action_name in('注册','实名')
and action_date = '2019-10-12'
group by action_date,data_source,action_name
order by action_date,data_source

--金融苑注册
select substr(registe_date,1,10),
count(distinct mbl_no)
from warehouse_atomic_time_user a
where data_source = 'jry'
  and registe_date > '2019-10-12'
group by substr(registe_date,1,10)

--分平台登录数据：
SELECT extractday,data_source,count(distinct mbl_no)
FROM warehouse_data_user_action_day 
where extractday = '2019-10-12'
GROUP BY extractday,data_source


--产品推送数据：
SELECT data_source,
       extractday,
       product_name,
       count(DISTINCT mbl_no)
FROM warehouse_data_user_action_day AS a
WHERE applypv>0
and product_name in ('现金分期-点点','现金分期-钱伴','现金分期-中邮','优卡贷')
  AND extractday = '2019-10-12'
GROUP BY extractday,product_name,data_source
order by product_name;data_source;extractday


--合计注册实名：
SELECT action_date,action_name,COUNT(DISTINCT  MBL_NO) 
FROM warehouse_atomic_all_process_info A 
WHERE action_name in('注册','实名')
and action_date = '2019-10-12'
group by action_date,action_name