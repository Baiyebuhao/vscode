--需验证1数据与2.1+2.2数据是否吻合
--需验证是否有重复数据

--1.总体数据

SELECT b.data_source,
       b.dt,
       b.hr,
       sum(b.reg_num) AS reg_num,
       sum(b.auth_num) AS auth_num
FROM
  (SELECT a.data_source,
          a.registe_date,
          a.authentication_date,
          substr(a.registe_date,1,10) AS dt,
          substr(a.registe_date,12,2) AS hr,
          if(a.registe_date IS NOT NULL,1,0) AS reg_num,
          if(a.authentication_date IS NOT NULL,1,0) AS auth_num
   FROM warehouse_atomic_time_user a
   WHERE a.registe_date>='2020-01-01') b
GROUP BY b.data_source,
         b.dt,
         b.hr 
order BY b.data_source,
         b.dt,
         b.hr          


;
--2.1手机贷、享宇钱包
SELECT x.*,y.2_level,y.3_level as chan_name
FROM
  (SELECT a.mbl_no ,
          a.data_source,
          a.registe_date,
          a.chan_no,
          a.child_chan,
          a.authentication_date,                         ----实名时间和注册时间一模一样
          substr(a.registe_date,1,10) AS dt,   ---日期
          substr(a.registe_date,12,2) AS hr,   ---小时
          if(a.registe_date IS NOT NULL,'注册','未注册') AS reg_state,         ---未注册的用户都没有注册时间
          if(a.authentication_date IS NOT NULL,'实名','未实名') AS auth_state  ---
   FROM warehouse_atomic_time_user a
   WHERE a.registe_date>='2020-01-01'
     AND a.data_source IN ('sjd',
                           'xyqb')) x
LEFT JOIN
  (SELECT DISTINCT b.plat_no data_source,
                   b.chan_no,
				   b.`2nd_level` 2_level,
				   b.`3rd_level` 3_level,
                   b.`4th_level` 4_level
   FROM warehouse_atomic_channel_category_info b
   WHERE b.plat_no IN ('sjd',
                       'xyqb')) y
WHERE x.data_source=y.data_source
  AND x.chan_no=y.chan_no
  AND x.child_chan=y.4_level
  ;
  
  
--2.2金融苑、百惠贷  
SELECT x.*,y.2_level,y.4_level as chan_name
FROM
  (SELECT a.mbl_no ,
          a.data_source,
          a.registe_date,               ---注册时间（年月日+时分秒）
          a.chan_no,
          a.child_chan,                 ---子渠道均为 1
          a.authentication_date,        ---实名日期（年月日）
          substr(a.registe_date,1,10) AS dt,
          substr(a.registe_date,12,2) AS hr,
          if(a.registe_date IS NOT NULL,'注册','未注册') AS reg_state,
          if(a.authentication_date IS NOT NULL,'实名','未实名') AS auth_state
   FROM warehouse_atomic_time_user a
   WHERE a.registe_date>='2020-01-01'
     AND a.data_source IN ('jry',
                           'bhd')) x
LEFT JOIN
  ( SELECT if(c.mall_name='金融苑','jry','bhd') AS data_source ,
       b.promoter_code as chan_no,
       case b.promoter_type when 1 then '安卓' when 2 then 'IOS' when 3 then 'H5' end 2_level,
       case b.promoter_type when 3 then '其它渠道' end 3_level,    ---没必要
       b.promoter_name as 4_level 
FROM warehouse_jry_business_promoter b
LEFT JOIN warehouse_jry_mall_info c
WHERE b.general_code=c.mall_code
  AND c.mall_name IN ('金融苑',
                      '百惠贷')
 ) y
WHERE x.data_source=y.data_source
  AND x.chan_no=y.chan_no


--合并
--2.1手机贷、享宇钱包
select substr(registe_date,1,13) as registe_date,
	   data_source,
       chan_no,
	   child_chan,
	   2_level,
	   chan_name,
	   count(distinct mbl_no) as mbl_mount,
	   count(distinct case when auth_state = '实名' then mbl_no end) as mbl_mount2
from 
(SELECT x.*,y.2_level,y.3_level as chan_name
FROM
  (SELECT a.mbl_no ,
          a.data_source,
          a.registe_date,
          a.chan_no,
          a.child_chan,
          a.authentication_date,                         ----实名时间和注册时间一模一样
          substr(a.registe_date,1,10) AS dt,   ---日期
          substr(a.registe_date,12,2) AS hr,   ---小时
          if(a.registe_date IS NOT NULL,'注册','未注册') AS reg_state,         ---未注册的用户都没有注册时间
          if(a.authentication_date IS NOT NULL,'实名','未实名') AS auth_state  ---
   FROM warehouse_atomic_time_user a
   WHERE a.registe_date>='2020-01-01'
     AND a.data_source IN ('sjd',
                           'xyqb')) x
LEFT JOIN
  (SELECT DISTINCT b.plat_no data_source,
                   b.chan_no,
				   b.`2nd_level` 2_level,
				   b.`3rd_level` 3_level,
                   b.`4th_level` 4_level
   FROM warehouse_atomic_channel_category_info b
   WHERE b.plat_no IN ('sjd',
                       'xyqb')) y
WHERE x.data_source=y.data_source
  AND x.chan_no=y.chan_no
  AND x.child_chan=y.4_level
UNION ALL
SELECT x.*,y.2_level,y.4_level as chan_name
FROM
  (SELECT a.mbl_no ,
          a.data_source,
          a.registe_date,               ---注册时间（年月日+时分秒）
          a.chan_no,
          a.child_chan,                 ---子渠道均为 1
          a.authentication_date,        ---实名日期（年月日）
          substr(a.registe_date,1,10) AS dt,
          substr(a.registe_date,12,2) AS hr,
          if(a.registe_date IS NOT NULL,'注册','未注册') AS reg_state,
          if(a.authentication_date IS NOT NULL,'实名','未实名') AS auth_state
   FROM warehouse_atomic_time_user a
   WHERE a.registe_date>='2020-01-01'
     AND a.data_source IN ('jry',
                           'bhd')) x
LEFT JOIN
  ( SELECT if(c.mall_name='金融苑','jry','bhd') AS data_source ,
       b.promoter_code as chan_no,
       case b.promoter_type when 1 then '安卓' when 2 then 'IOS' when 3 then 'H5' end 2_level,
       case b.promoter_type when 3 then '其它渠道' end 3_level,    ---没必要
       b.promoter_name as 4_level 
FROM warehouse_jry_business_promoter b
LEFT JOIN warehouse_jry_mall_info c
WHERE b.general_code=c.mall_code
  AND c.mall_name IN ('金融苑',
                      '百惠贷')
 ) y
WHERE x.data_source=y.data_source
  AND x.chan_no=y.chan_no) e
group by substr(registe_date,1,13),
	     data_source,
         chan_no,
	     child_chan,
	     2_level,
	     chan_name