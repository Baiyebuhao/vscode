--每日分时
CREATE TABLE warehouse_data_hour_mail_report 
(is_new_jry  string comment '是否金融苑',
 data_time string comment '数据时间',
 the_2nd_level  string comment '二级渠道',
 the_3rd_level  string comment '三级渠道',
 merger_chan  string comment '渠道名称',
 regdnum  bigint comment '注册数量',
 authdnum  bigint comment '实名数量' )comment '每日分时数据表' 
 PARTITIONED by(data_source string comment '数据平台',
                elt_date string comment '数据日期');

onehourago=$(date +%y-%m-%d -d '-1 hours')

--初始化数据
INSERT overwrite TABLE warehouse_data_hour_mail_report partition(data_source,elt_date)
SELECT a.is_new_jry,
       a.data_time,
       if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level) AS the_2nd_level,
       if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level) AS the_3rd_level,
       if(b.merger_chan IS NULL,'空白',b.merger_chan) AS merger_chan,
       count(DISTINCT CASE
                          WHEN code='reg' THEN mbl_no
                      END) AS regdnum,
       count(DISTINCT CASE
                          WHEN code='auth' THEN mbl_no
                      END) AS authdnum,
       a.data_source,
       substr(data_time,1,10) AS elt_date
FROM
  (SELECT 'reg' AS code,
          mbl_no,
          if(a.registe_date IS NULL,'1970-01-01 00:00:00',concat(substr(a.registe_date,1,13),':00:00')) AS data_time,
          chan_no,
          a.child_chan,
          data_source,
          CASE
              WHEN data_source ='xyqb'
                   AND (app_version='1.0.0'
                        OR app_version>='8.0.0')
                   AND chan_no='appStore'
                   AND registe_date>='2018-09-20' THEN '是'
              WHEN data_source ='xyqb'
                   AND app_version BETWEEN '1.2.0' AND '7.9.9'
                   AND chan_no!='appStore' THEN '是'
              ELSE '否'
          END is_new_jry
   FROM warehouse_atomic_time_user AS a
   WHERE if(a.registe_date IS NULL,'1970-01-01',substr(a.registe_date,1,7)) = '2018-01'
     AND if(a.registe_date IS NULL,'00',substr(a.registe_date,12,2))!=substr(from_unixtime(unix_timestamp()),12,2)
   UNION ALL SELECT 'auth' AS code,
                    mbl_no,
                    concat(substr(a.authentication_date,1,13),':00:00') AS auth_date,
                    chan_no,
                    a.child_chan,
                    data_source,
                    CASE
                        WHEN data_source ='xyqb'
                             AND (app_version='1.0.0'
                                  OR app_version>='8.0.0')
                             AND chan_no='appStore'
                             AND registe_date>='2018-09-20' THEN '是'
                        WHEN data_source ='xyqb'
                             AND app_version BETWEEN '1.2.0' AND '7.9.9'
                             AND chan_no!='appStore' THEN '是'
                        ELSE '否'
                    END is_new_jry
   FROM warehouse_atomic_time_user AS a
   WHERE substr(a.authentication_date,1,7) ='2018-01'
     AND substr(a.authentication_date,12,2)=substr(from_unixtime(unix_timestamp()),12,2) ) AS a
LEFT JOIN warehouse_data_chan_info AS b ON a.data_source=b.data_source
AND a.chan_no=b.chan_no
AND a.child_chan = b.child_chan
GROUP BY a.data_source,
         a.data_time,
         a.is_new_jry,
         if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level),
         if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level),
         if(b.merger_chan IS NULL,'空白',b.merger_chan);

--手机贷平台 按时更新数据 add 2018-12-11
INSERT overwrite TABLE warehouse_data_hour_mail_report partition(data_source='sjd',elt_date='$onehourago')
SELECT a.is_new_jry,
       a.data_time,
       if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level) AS the_2nd_level,
       if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level) AS the_3rd_level,
       if(b.merger_chan IS NULL,'空白',b.merger_chan) AS merger_chan,
       count(DISTINCT CASE
                          WHEN code='reg' THEN mbl_no
                      END) AS regdnum,
       count(DISTINCT CASE
                          WHEN code='auth' THEN mbl_no
                      END) AS authdnum
FROM
  (SELECT 'reg' AS code,
          mbl_no,
          if(a.registe_date IS NULL,'1970-01-01 00:00:00',concat(substr(a.registe_date,1,13),':00:00')) AS data_time,
          chan_no,
          a.child_chan,
          data_source,
          '否' AS is_new_jry
   FROM warehouse_atomic_time_user AS a
   WHERE data_source ='sjd'
     AND if(a.registe_date IS NULL,'1970-01-01',substr(a.registe_date,1,10))=substr(from_unixtime(unix_timestamp()-3600),1,10)
     AND if(a.registe_date IS NULL,'00',substr(a.registe_date,12,2))!=substr(from_unixtime(unix_timestamp()),12,2)
   UNION ALL SELECT 'auth' AS code,
                    mbl_no,
                    concat(substr(a.authentication_date,1,13),':00:00') AS auth_date,
                    chan_no,
                    a.child_chan,
                    data_source,
                    '否' AS is_new_jry
   FROM warehouse_atomic_time_user AS a
   WHERE data_source ='sjd'
     AND substr(a.authentication_date,1,10)=substr(from_unixtime(unix_timestamp()-3600),1,10)
     AND substr(a.authentication_date,12,2)=substr(from_unixtime(unix_timestamp()),12,2)) AS a
LEFT JOIN warehouse_data_chan_info AS b ON a.data_source=b.data_source
AND a.chan_no=b.chan_no
AND a.child_chan = b.child_chan
GROUP BY a.data_source,
         a.data_time,
         a.is_new_jry,
         if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level),
         if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level),
         if(b.merger_chan IS NULL,'空白',b.merger_chan);

--享宇钱包平台 按时更新数据 add 2018-12-11
INSERT overwrite TABLE warehouse_data_hour_mail_report partition(data_source='xyqb',elt_date='$onehourago')
SELECT a.is_new_jry,
       a.data_time,
       if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level) AS the_2nd_level,
       if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level) AS the_3rd_level,
       if(b.merger_chan IS NULL,'空白',b.merger_chan) AS merger_chan,
       count(DISTINCT CASE
                          WHEN code='reg' THEN mbl_no
                      END) AS regdnum,
       count(DISTINCT CASE
                          WHEN code='auth' THEN mbl_no
                      END) AS authdnum
FROM
  (SELECT 'reg' AS code,
          mbl_no,
          if(a.registe_date IS NULL,'1970-01-01 00:00:00',concat(substr(a.registe_date,1,13),':00:00')) AS data_time,
          chan_no,
          a.child_chan,
          data_source,
          CASE
              WHEN data_source ='xyqb'
                   AND (app_version='1.0.0'
                        OR app_version>='8.0.0')
                   AND chan_no='appStore'
                   AND registe_date>='2018-09-20' THEN '是'
              WHEN data_source ='xyqb'
                   AND app_version BETWEEN '1.2.0' AND '7.9.9'
                   AND chan_no!='appStore' THEN '是'
              ELSE '否'
          END is_new_jry
   FROM warehouse_atomic_time_user AS a
   WHERE data_source ='xyqb'
     AND if(a.registe_date IS NULL,'1970-01-01',substr(a.registe_date,1,10))=substr(from_unixtime(unix_timestamp()-3600),1,10)
     AND if(a.registe_date IS NULL,'00',substr(a.registe_date,12,2))!=substr(from_unixtime(unix_timestamp()),12,2)
   UNION ALL SELECT 'auth' AS code,
                    mbl_no,
                    concat(substr(a.authentication_date,1,13),':00:00') AS auth_date,
                    chan_no,
                    a.child_chan,
                    data_source,
                    CASE
                        WHEN data_source ='xyqb'
                             AND (app_version='1.0.0'
                                  OR app_version>='8.0.0')
                             AND chan_no='appStore'
                             AND registe_date>='2018-09-20' THEN '是'
                        WHEN data_source ='xyqb'
                             AND app_version BETWEEN '1.2.0' AND '7.9.9'
                             AND chan_no!='appStore' THEN '是'
                        ELSE '否'
                    END is_new_jry
   FROM warehouse_atomic_time_user AS a
   WHERE data_source ='xyqb'
     AND substr(a.authentication_date,1,10)=substr(from_unixtime(unix_timestamp()-3600),1,10)
     AND substr(a.authentication_date,12,2)=substr(from_unixtime(unix_timestamp()),12,2)) AS a
LEFT JOIN warehouse_data_chan_info AS b ON a.data_source=b.data_source
AND a.chan_no=b.chan_no
AND a.child_chan = b.child_chan
GROUP BY a.data_source,
         a.data_time,
         a.is_new_jry,
         if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level),
         if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level),
         if(b.merger_chan IS NULL,'空白',b.merger_chan);
         

--每日初始化 手机贷平台 按时更新数据 add 2019-01-31
INSERT overwrite TABLE warehouse_data_hour_mail_report partition(data_source='sjd',elt_date)
SELECT a.is_new_jry,
       a.data_time,
       if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level) AS the_2nd_level,
       if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level) AS the_3rd_level,
       if(b.merger_chan IS NULL,'空白',b.merger_chan) AS merger_chan,
       count(DISTINCT CASE
                          WHEN code='reg' THEN mbl_no
                      END) AS regdnum,
       count(DISTINCT CASE
                          WHEN code='auth' THEN mbl_no
                      END) AS authdnum,
       elt_date                      
FROM
  (SELECT 'reg' AS code,
          mbl_no,
          if(a.registe_date IS NULL,'1970-01-01 00:00:00',concat(substr(a.registe_date,1,13),':00:00')) AS data_time,
          chan_no,
          a.child_chan,
          data_source,
          '否' AS is_new_jry,
          date_sub(current_date(),1) as elt_date
   FROM warehouse_atomic_time_user AS a
   WHERE data_source ='sjd'
     AND if(a.registe_date IS NULL,'1970-01-01',substr(a.registe_date,1,10))=date_sub(current_date(),1)
   UNION ALL SELECT 'auth' AS code,
                    mbl_no,
                    concat(substr(a.authentication_date,1,13),':00:00') AS auth_date,
                    chan_no,
                    a.child_chan,
                    data_source,
                    '否' AS is_new_jry,
                    date_sub(current_date(),1) as elt_date
   FROM warehouse_atomic_time_user AS a
   WHERE data_source ='sjd'
     AND substr(a.authentication_date,1,10)= date_sub(current_date(),1)) AS a
LEFT JOIN warehouse_data_chan_info AS b ON a.data_source=b.data_source
AND a.chan_no=b.chan_no
AND a.child_chan = b.child_chan
GROUP BY a.data_source,
         a.data_time,
         a.is_new_jry,
         if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level),
         if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level),
         if(b.merger_chan IS NULL,'空白',b.merger_chan),
         elt_date;

--每日初始化 享宇钱包平台 按时更新数据 add 2019-01-31
INSERT overwrite TABLE warehouse_data_hour_mail_report partition(data_source='xyqb',elt_date)
SELECT a.is_new_jry,
       a.data_time,
       if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level) AS the_2nd_level,
       if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level) AS the_3rd_level,
       if(b.merger_chan IS NULL,'空白',b.merger_chan) AS merger_chan,
       count(DISTINCT CASE
                          WHEN code='reg' THEN mbl_no
                      END) AS regdnum,
       count(DISTINCT CASE
                          WHEN code='auth' THEN mbl_no
                      END) AS authdnum,
       elt_date                      
FROM
  (SELECT 'reg' AS code,
          mbl_no,
          if(a.registe_date IS NULL,'1970-01-01 00:00:00',concat(substr(a.registe_date,1,13),':00:00')) AS data_time,
          chan_no,
          a.child_chan,
          data_source,
          CASE
              WHEN data_source ='xyqb'
                   AND (app_version='1.0.0'
                        OR app_version>='8.0.0')
                   AND chan_no='appStore'
                   AND registe_date>='2018-09-20' THEN '是'
              WHEN data_source ='xyqb'
                   AND app_version BETWEEN '1.2.0' AND '7.9.9'
                   AND chan_no!='appStore' THEN '是'
              ELSE '否'
          END is_new_jry,
          date_sub(current_date(),1) as elt_date
   FROM warehouse_atomic_time_user AS a
   WHERE data_source ='xyqb'
     AND if(a.registe_date IS NULL,'1970-01-01',substr(a.registe_date,1,10))=date_sub(current_date(),1)
   UNION ALL SELECT 'auth' AS code,
                    mbl_no,
                    concat(substr(a.authentication_date,1,13),':00:00') AS auth_date,
                    chan_no,
                    a.child_chan,
                    data_source,
                    CASE
                        WHEN data_source ='xyqb'
                             AND (app_version='1.0.0'
                                  OR app_version>='8.0.0')
                             AND chan_no='appStore'
                             AND registe_date>='2018-09-20' THEN '是'
                        WHEN data_source ='xyqb'
                             AND app_version BETWEEN '1.2.0' AND '7.9.9'
                             AND chan_no!='appStore' THEN '是'
                        ELSE '否'
                    END is_new_jry,
                    date_sub(current_date(),1) as elt_date
   FROM warehouse_atomic_time_user AS a
   WHERE data_source ='xyqb'
     AND substr(a.authentication_date,1,10)=date_sub(current_date(),1)) AS a
LEFT JOIN warehouse_data_chan_info AS b ON a.data_source=b.data_source
AND a.chan_no=b.chan_no
AND a.child_chan = b.child_chan
GROUP BY a.data_source,
         a.data_time,
         a.is_new_jry,
         if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level),
         if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level),
         if(b.merger_chan IS NULL,'空白',b.merger_chan),
         elt_date;

INSERT overwrite TABLE warehouse_data_hour_mail_report partition(data_source='jry',elt_date)
SELECT a.is_new_jry,
       a.data_time,
       if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level) AS the_2nd_level,
       if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level) AS the_3rd_level,
       if(b.merger_chan IS NULL,'空白',b.merger_chan) AS merger_chan,
       count(DISTINCT CASE
                          WHEN code='reg' THEN mbl_no
                      END) AS regdnum,
       count(DISTINCT CASE
                          WHEN code='auth' THEN mbl_no
                      END) AS authdnum,
       elt_date
FROM
  (SELECT 'reg' AS code,
          mbl_no,
          if(a.registe_date IS NULL,'1970-01-01 00:00:00',concat(substr(a.registe_date,1,13),':00:00')) AS data_time,
          chan_no,
          a.child_chan,
          data_source,
          CASE
              WHEN data_source ='xyqb'
                   AND (app_version='1.0.0'
                        OR app_version>='8.0.0')
                   AND chan_no='appStore'
                   AND registe_date>='2018-09-20' THEN '是'
              WHEN data_source ='xyqb'
                   AND app_version BETWEEN '1.2.0' AND '7.9.9'
                   AND chan_no!='appStore' THEN '是'
              ELSE '否'
          END is_new_jry,
          if(a.registe_date IS NULL,'1970-01-01',substr(a.registe_date,1,10)) AS elt_date
   FROM warehouse_atomic_time_user AS a
   WHERE data_source ='jry'
     AND if(a.registe_date IS NULL,'1970-01-01',substr(a.registe_date,1,10))>='2019-03-01'
   UNION ALL SELECT 'auth' AS code,
                    mbl_no,
                    concat(substr(a.authentication_date,1,13),':00:00') AS auth_date,
                    chan_no,
                    a.child_chan,
                    data_source,
                    CASE
                        WHEN data_source ='xyqb'
                             AND (app_version='1.0.0'
                                  OR app_version>='8.0.0')
                             AND chan_no='appStore'
                             AND registe_date>='2018-09-20' THEN '是'
                        WHEN data_source ='xyqb'
                             AND app_version BETWEEN '1.2.0' AND '7.9.9'
                             AND chan_no!='appStore' THEN '是'
                        ELSE '否'
                    END is_new_jry,
                    substr(a.authentication_date,1,10) AS elt_date
   FROM warehouse_atomic_time_user AS a
   WHERE data_source ='jry'
     AND substr(a.authentication_date,1,10)>='2019-03-01') AS a
LEFT JOIN warehouse_data_chan_info AS b ON a.data_source=b.data_source
AND a.chan_no=b.chan_no
AND a.child_chan = b.child_chan
GROUP BY a.data_source,
         a.data_time,
         a.is_new_jry,
         if(b.the_2nd_level IS NULL,'空白',b.the_2nd_level),
         if(b.the_3rd_level IS NULL,'空白',b.the_3rd_level),
         if(b.merger_chan IS NULL,'空白',b.merger_chan),
         elt_date;         