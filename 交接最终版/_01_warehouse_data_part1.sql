-- 切换用户
set role admin;

-- 汇智信汇总数据更新 update 2018-12-26
INSERT OVERWRITE TABLE warehouse_data_hzx_bank_view
SELECT BankName,
       pro_type,
       product_id,
       product_name,
       data_date,
       sum(applyOver)AS applyOver,
       sum(applyNotOver) AS applyNotOver,
       sum(waitDistribution) AS waitDistribution,
       sum(distribution) AS distribution,
       sum(researchOver) AS researchOver,
       sum(researchOverHaveAmount) AS researchOverHaveAmount,
       sum(totalAmount) AS totalAmount
FROM
  (SELECT b.name AS BankName,
          CASE
              WHEN p.pro_type =1 THEN '信易贷'
              WHEN p.pro_type =2 THEN '信福时贷'
              WHEN p.pro_type =3 THEN '精细化'
              WHEN p.pro_type =4 THEN '银行产品'
              ELSE '未归类'
          END AS pro_type,
          p.id AS product_id,
          p.name AS product_name,
          substr(t.loan_apply_time,1,10) AS data_date,
          count(DISTINCT CASE
                             WHEN t.m_state = 5 THEN t.id
                         END) AS applyOver,
          count(DISTINCT CASE
                             WHEN t.m_state != 5 THEN t.id
                         END) AS applyNotOver,
          count(DISTINCT CASE
                             WHEN t.m_state = 5
                                  AND distribution = 0 THEN t.id
                         END) AS waitDistribution,
          count(DISTINCT CASE
                             WHEN t.m_state = 5
                                  AND distribution = 1 THEN t.id
                         END) AS distribution,
          0 AS researchOver,
          0 AS researchOverHaveAmount,
          0 AS totalAmount
   FROM warehouse_atomic_hzx_xy_product_info AS st
   JOIN warehouse_atomic_hzx_bank_product_info p ON st.id = p.t_id
   JOIN warehouse_atomic_hzx_research_task AS t ON t.bank_pro_id = p.id
   JOIN warehouse_atomic_hzx_b_bank_base_info AS b ON b.id = t.bank_id
   WHERE p.id IS NOT NULL
     AND p.bank_id NOT IN(1011607210000337,
                          1011609230000007,
                          1011705260000101,
                          1011806250000203,
                          1011808220000244,
                          1011808270000246)
   GROUP BY b.name,
            CASE
                WHEN p.pro_type =1 THEN '信易贷'
                WHEN p.pro_type =2 THEN '信福时贷'
                WHEN p.pro_type =3 THEN '精细化'
                WHEN p.pro_type =4 THEN '银行产品'
                ELSE '未归类'
            END,
            p.id,
            p.name,
            substr(t.loan_apply_time,1,10)
   UNION ALL SELECT b.name AS BankName,
                    CASE
                        WHEN p.pro_type =1 THEN '信易贷'
                        WHEN p.pro_type =2 THEN '信福时贷'
                        WHEN p.pro_type =3 THEN '精细化'
                        WHEN p.pro_type =4 THEN '银行产品'
                        ELSE '未归类'
                    END AS pro_type,
                    p.id AS product_id,
                    p.name AS product_name,
                    substr(t.research_over_time,1,10) AS data_date,
                    0 AS applyOver,
                    0 AS applyNotOver,
                    0 AS waitDistribution,
                    0 AS distribution,
                    count(DISTINCT CASE
                                       WHEN t.m_state = 5
                                            AND t.research_status IN (4, 5) THEN t.id
                                   END) AS researchOver,
                    count(DISTINCT CASE
                                       WHEN t.m_state = 5
                                            AND t.research_status IN (4, 5)
                                            AND t.rec_amount > 0 THEN t.id
                                   END) AS researchOverHaveAmount,
                    sum(CASE
                            WHEN t.m_state = 5
                                 AND t.research_status IN (4, 5)
                                 AND t.rec_amount > 0 THEN rec_amount
                        END)AS totalAmount
   FROM warehouse_atomic_hzx_xy_product_info AS st
   JOIN warehouse_atomic_hzx_bank_product_info p ON st.id = p.t_id
   JOIN warehouse_atomic_hzx_research_task AS t ON t.bank_pro_id = p.id
   JOIN warehouse_atomic_hzx_b_bank_base_info AS b ON b.id = t.bank_id
   WHERE p.id IS NOT NULL
     AND p.bank_id NOT IN(1011607210000337,
                          1011609230000007,
                          1011705260000101,
                          1011806250000203,
                          1011808220000244,
                          1011808270000246)
   GROUP BY b.name,
            CASE
                WHEN p.pro_type =1 THEN '信易贷'
                WHEN p.pro_type =2 THEN '信福时贷'
                WHEN p.pro_type =3 THEN '精细化'
                WHEN p.pro_type =4 THEN '银行产品'
                ELSE '未归类'
            END,
            p.id,
            p.name,
            substr(t.research_over_time,1,10)) AS a
GROUP BY bankName,
         pro_type,
         product_id,
         product_name,
         data_date;

-- 渠道基础数据合并 add 2018-11-06
INSERT overwrite TABLE warehouse_data_chan_info
SELECT a.plat_no AS data_source,
       if(length(if(the_2nd_level IS NULL,'',the_2nd_level))>0, the_2nd_level, a.2nd_level) AS the_2nd_level,
       if(length(if(the_3rd_level IS NULL,'',the_3rd_level))>0, the_3rd_level, a.3rd_level) AS the_3rd_level,
       a.chan_no,
       if(length(if(b.chan_no_desc IS NULL,'',b.chan_no_desc))>0, b.chan_no_desc, a.3rd_level) AS chan_no_desc,
       a.4th_level AS child_chan,
       concat(if(length(if(the_2nd_level IS NULL,'',the_2nd_level))>0,the_2nd_level,a.2nd_level), a.4th_level) AS merger_chan
FROM warehouse_atomic_channel_category_info AS a
LEFT JOIN warehouse_data_chan_level_info AS b ON a.plat_no=b.data_source
AND a.chan_no=b.chan_no
AND b.child_chan=a.4th_level
WHERE length(if(a.chan_no IS NULL,'',a.chan_no))>0;

-- 渠道发展用户明细 UPDATE 2019-05-28
INSERT overwrite TABLE warehouse_data_user_channel_info
SELECT if(b.registe_date is null,'1970-01-01',b.registe_date) as registe_date,
       b.authentication_date,
       if(b.data_source IS NULL,'空白',b.data_source) AS data_source,
       NULL AS is_new_jry,
       if(c.the_2nd_level IS NULL,'空白',c.the_2nd_level) AS the_2nd_level,
       if(c.the_3rd_level IS NULL,'空白',c.the_3rd_level) AS the_3rd_level,
       c.merger_chan,
       b.chan_no,
       b.chan_no_desc,
       b.child_chan,
       b.isp,
       b.province_desc,
       b.city_desc,
       b.mbl_no,
       1 AS pre,
       d.rtype,
       d.ftype,
       d.mtype,
       concat(d.rtype,d.ftype,d.mtype) AS rfmvalue,
       current_date()
FROM warehouse_atomic_user_info AS b
LEFT JOIN warehouse_data_chan_info AS c ON b.chan_no=c.chan_no
AND b.child_chan = c.child_chan
AND b.data_source= c.data_source
left join warehouse_data_user_info_rfm as d on b.data_source= d.data_source
and b.mbl_no=d.mbl_no;

-- 渠道发展用户汇总 2018-10-25
INSERT overwrite TABLE warehouse_data_channel_user_sum
SELECT if(register_date is null,'1970-01-01',register_date),
       data_source,
       is_new_jry,
       the_2nd_level,
       the_3rd_level,
       count(mbl_no) AS num
FROM warehouse_data_user_channel_info AS a
WHERE if(register_date is null,'1970-01-01',register_date) <= date_sub(current_date(),1)
GROUP BY if(register_date is null,'1970-01-01',register_date),
         data_source,
         is_new_jry,
         the_2nd_level,
         the_3rd_level;

-- 新产品信息合并 add 20181203
INSERT INTO TABLE warehouse_data_product_info_new
SELECT a.data_source,
       prod_no,
       prod_name,
       prod_name,
       NULL AS product_no
FROM warehouse_atomic_product_info AS a
LEFT JOIN warehouse_data_product_info_new AS b ON a.data_source=b.data_source
AND a.prod_no=b.product_id
WHERE b.product_id IS NULL;

-- 每日点击数据按mbl_no汇总，加新注册用户标示 update 20181114
INSERT overwrite TABLE warehouse_data_user_action_day PARTITION(extractday)
SELECT a.sys_id AS data_source,
       CASE
           WHEN event_id='bxyk' THEN '信用卡'
           WHEN d.product_name_new IS NOT NULL THEN d.product_name_new
           ELSE a.product_name
       END product_name,
       a.mbl_no,
       CASE
           WHEN a.extractday=b.registe_date THEN '是'
           ELSE '否'
       END AS is_new,
       count(1) AS allpv,
       count(CASE
                 WHEN page_id='supermarket' THEN 1
             END) AS marketpv,
       count(CASE
                 WHEN page_id='product_detail' THEN 1
             END) AS detailpv,
       count(CASE
                 WHEN event_id='apply' THEN 1
             END) AS applypv,
       count(CASE
                 WHEN page_id='institution_page' THEN 1
             END) AS institupv,
       count(CASE
                 WHEN page_id='supermarket'
                      AND event_id='banner' THEN 1
             END) AS bannerpv,
       a.extractday
FROM warehouse_atomic_user_action AS a
LEFT JOIN warehouse_atomic_user_info AS b ON a.sys_id=b.data_source
AND a.mbl_no=b.mbl_no
LEFT JOIN warehouse_data_product_info_new AS d ON a.sys_id=d.data_source
AND a.product_id=d.product_id
AND a.product_id IS NOT NULL
WHERE a.extractday = date_sub(date(current_date()),1)
GROUP BY a.extractday,
         a.sys_id,
         CASE
             WHEN event_id='bxyk' THEN '信用卡'
             WHEN d.product_name_new IS NOT NULL THEN d.product_name_new
             ELSE a.product_name
         END,
         a.mbl_no,
         CASE
             WHEN a.extractday=b.registe_date THEN '是'
             ELSE '否'
         END;

-- 增加新金融苑埋点数据 add 20181113
INSERT INTO table warehouse_data_user_action_day PARTITION(extractday)
SELECT a.platform AS data_source,
       CASE
           WHEN substr(page_enname,1,6) ='credit' THEN '信用卡'
           WHEN substr(page_enname,1,9) ='insurance' THEN '保险'
           WHEN d.product_name_new IS NOT NULL THEN d.product_name_new
           ELSE a.product_name
       END product_name,
       a.mbl_no,
       CASE
           WHEN a.extractday=b.registe_date THEN '是'
           ELSE '否'
       END AS is_new,
       count(1) AS allpv,
       count(CASE
                 WHEN page_enname='supermarket' THEN 1
             END) AS marketpv,
       count(CASE
                 WHEN page_enname='product_detail' THEN 1
             END) AS detailpv,
       count(CASE
                 WHEN button_enname='apply' THEN 1
             END) AS applypv,
       count(CASE
                 WHEN page_enname='product_detail' THEN 1
             END) AS institupv,
       count(CASE
                 WHEN button_enname='banner' THEN 1
             END) AS bannerpv,
       a.extractday
FROM warehouse_newtrace_click_record AS a
LEFT JOIN warehouse_atomic_user_info AS b ON a.platform = b.data_source
AND a.mbl_no=b.mbl_no
LEFT JOIN warehouse_data_product_info_new AS d ON a.platform = d.data_source
AND a.product_id=d.product_id
AND a.product_id IS NOT NULL
WHERE a.extractday = date_sub(date(current_date()),1)
GROUP BY a.extractday,
         a.platform,
         CASE
             WHEN substr(page_enname,1,6) ='credit' THEN '信用卡'
             WHEN substr(page_enname,1,9) ='insurance' THEN '保险'
             WHEN d.product_name_new IS NOT NULL THEN d.product_name_new
             ELSE a.product_name
         END,
         a.mbl_no,
         CASE
             WHEN a.extractday=b.registe_date THEN '是'
             ELSE '否'
         END;

-- 增加新架构埋点数据 add 20191110
INSERT INTO TABLE warehouse_data_user_action_day PARTITION(extractday)
SELECT CASE
           WHEN a.platform='金融苑' THEN 'jry'
           WHEN a.platform='享宇钱包' THEN 'xyqb'
           WHEN a.platform='移动手机贷' THEN 'sjd'
           ELSE a.platform
       END AS platform,
       d.goods_name AS product_name,
       c.mbl_no,
       CASE
           WHEN a.extractday=c.registe_date THEN '是'
           ELSE '否'
       END AS is_new,
       count(1) AS allpv,
       count(CASE
                 WHEN pagenamecn='首页' THEN 1
             END) AS marketpv,
       count(CASE
                 WHEN pagenamecn='产品详情' THEN 1
             END) AS detailpv,
       count(CASE
                 WHEN click_name IN('apply_limit','apply') THEN 1
             END) AS applypv,
       0 AS institupv,
       count(CASE
                 WHEN click_name='banner' THEN 1
             END) AS bannerpv,
       a.extractday
FROM warehouse_atomic_newframe_burypoint_baseoperations AS a
JOIN warehouse_atomic_newframe_burypoint_buttonoperations AS b ON a.start_id=b.start_id
LEFT JOIN warehouse_atomic_user_info AS c ON b.cus_no=c.cus_no
LEFT JOIN warehouse_jry_goods_info AS d ON b.product_id=d.id
AND b.product_id IS NOT NULL
WHERE a.extractday = date_sub(date(current_date()),1)
  AND b.extractday = date_sub(date(current_date()),1)
GROUP BY a.extractday,
         CASE
             WHEN a.platform='金融苑' THEN 'jry'
             WHEN a.platform='享宇钱包' THEN 'xyqb'
             WHEN a.platform='移动手机贷' THEN 'sjd'
             ELSE a.platform
         END,
         d.goods_name,
         c.mbl_no,
         CASE
             WHEN a.extractday=c.registe_date THEN '是'
             ELSE '否'
         END;

--  每日邮件分日报盘数据(三平台)Part01 add 2019-02-21
INSERT overwrite TABLE warehouse_data_daliy_report_new PARTITION(extractday)
SELECT data_source,
       sum(regnum) regnum,
       sum(chknum) AS chknum,
       sum(regallnum) AS regallnum,
       sum(chkallnum) AS chkallnum,
       extractday
FROM
  (SELECT data_source,
          count(DISTINCT mbl_no) regnum,
          0 AS chknum,
          0 AS regallnum,
          0 AS chkallnum,
          register_date AS extractday
   FROM warehouse_data_user_channel_info AS a
   WHERE register_date = date_sub(date(current_date()),1)
   GROUP BY data_source,
            register_date
   UNION ALL SELECT data_source,
                    0 AS regnum,
                    count(DISTINCT mbl_no) AS chknum,
                    0 AS regallnum,
                    0 AS chkallnum,
                    chk_date AS extractday
   FROM warehouse_data_user_channel_info AS a
   WHERE chk_date = date_sub(date(current_date()),1)
   GROUP BY data_source,
            chk_date) AS a
GROUP BY data_source,
         extractday;

--  每日邮件分日报盘数据(三平台)Part02   add 2019-02-21
INSERT overwrite TABLE warehouse_data_daliy_report_new PARTITION(extractday)
SELECT *
FROM
  (SELECT data_source,
          regnum,
          chknum,
          sum(regnum) over(partition BY data_source
                           ORDER BY extractday DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS regalldnum,
          sum(chknum) over(partition BY data_source
                           ORDER BY extractday DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS chkalldnum,
          extractday
   FROM warehouse_data_daliy_report_new) AS a
WHERE extractday=date_sub(date(current_date()),1);

-- 每日邮件分时报盘数据 add 2018-11-21 &&
INSERT overwrite TABLE warehouse_data_hour_report PARTITION(extractday)
SELECT data_source,
       concat(action_date,' ',substr(action_time,1,2),':00:00') AS action_datetime,
       count(DISTINCT CASE
                          WHEN action_name='注册' THEN mbl_no
                      END) regnum,
       count(DISTINCT CASE
                          WHEN action_name='实名'
                               AND status_code IN('Y','Z') THEN mbl_no
                      END) chknum,
       count(DISTINCT CASE
                          WHEN action_name='用户测评' THEN mbl_no
                      END) testnum,
       count(DISTINCT CASE
                          WHEN action_name='申请' THEN mbl_no
                      END) applynum,
       action_date AS extractday
FROM warehouse_atomic_all_process_info AS a
WHERE action_date = date_sub(date(current_date()),1)
GROUP BY data_source,
         concat(action_date,' ',substr(action_time,1,2),':00:00'),
         action_date;

-- 用户日活跃数据汇总
INSERT overwrite TABLE warehouse_data_user_action_daysum PARTITION(extractday)
SELECT a.data_source,
       sum(regallnum) AS regallnum,
       sum(regnum) AS regnum,
       sum(allpv) AS allpv,
       sum(dnum) AS dnum,
       sum(applypv) AS applypv,
       sum(applydnum) AS applydnum,
       sum(newnum)AS newnum,
       sum(newdnum)AS newdnum,
       sum(newapplypv) AS newapplypv,
       sum(newapplydnum) AS newapplydnum,
       sum(marketpv) AS marketpv,
       sum(marketuv) AS marketuv,
       sum(bannerpv) AS bannerpv,
       sum(banneruv) AS banneruv,
       a.extractday
FROM
  (SELECT a.extractday,
          a.data_source,
          0 AS regallnum,
          0 AS regnum,
          sum(allpv) AS allpv,
          count(DISTINCT mbl_no) AS dnum,
          sum(applypv) AS applypv,
          count(DISTINCT CASE
                             WHEN applypv>0 THEN mbl_no
                         END) AS applydnum,
          sum(CASE
                  WHEN is_new='是' THEN allpv
              END) AS newnum,
          count(DISTINCT CASE
                             WHEN is_new='是' THEN mbl_no
                         END) AS newdnum,
          sum(CASE
                  WHEN is_new='是' THEN applypv
              END) AS newapplypv,
          count(DISTINCT CASE
                             WHEN is_new='是'
                                  AND applypv>0 THEN mbl_no
                         END) AS newapplydnum,
          sum(CASE
                  WHEN marketpv>0 THEN marketpv
              END) AS marketpv,
          count(DISTINCT CASE
                             WHEN marketpv>0 THEN mbl_no
                         END) AS marketuv,
          sum(CASE
                  WHEN bannerpv>0 THEN bannerpv
              END) AS bannerpv,
          count(DISTINCT CASE
                             WHEN bannerpv>0 THEN mbl_no
                         END) AS banneruv
   FROM warehouse_data_user_action_day AS a
   WHERE extractday = date_sub(current_date(),1)
   GROUP BY a.extractday,
            a.data_source
   UNION ALL SELECT extractday,
                    data_source,
                    regalldnum,
                    regnum,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0
   FROM warehouse_data_daliy_report_new AS a
   WHERE extractday = date_sub(current_date(),1)) AS a
GROUP BY a.extractday,
         a.data_source;

-- 用户月浏览活跃数据汇总
INSERT overwrite TABLE warehouse_data_user_action_monthsum PARTITION(extractday)
SELECT a.data_source,
       a.allpv,
       a.dnum,
       a.applypv,
       a.applydnum,
       a.newnum,
       a.newdnum,
       a.newapplypv,
       a.newapplydnum,
       b.regalldnum,
       b.regnum,
       a.marketpv,
       a.marketuv,
       a.bannerpv,
       a.banneruv,
       concat(substr(a.extractday,1,7),'-01') as extractday
FROM
  (SELECT substr(a.extractday,1,7) AS extractday,
          a.data_source,
          sum(allpv) AS allpv,
          count(DISTINCT mbl_no) AS dnum,
          sum(applypv) AS applypv,
          count(DISTINCT CASE
                             WHEN applypv>0 THEN mbl_no
                         END) AS applydnum,
          sum(CASE
                  WHEN is_new='是' THEN allpv
              END) AS newnum,
          count(DISTINCT CASE
                             WHEN is_new='是' THEN mbl_no
                         END) AS newdnum,
          sum(CASE
                  WHEN is_new='是' THEN applypv
              END) AS newapplypv,
          count(DISTINCT CASE
                             WHEN is_new='是'
                                  AND applypv>0 THEN mbl_no
                         END) AS newapplydnum,
          sum(CASE
                  WHEN marketpv>0 THEN marketpv
              END) AS marketpv,
          count(DISTINCT CASE
                             WHEN marketpv>0 THEN mbl_no
                         END) AS marketuv,
          sum(CASE
                  WHEN bannerpv>0 THEN bannerpv
              END) AS bannerpv,
          count(DISTINCT CASE
                             WHEN bannerpv>0 THEN mbl_no
                         END) AS banneruv
   FROM warehouse_data_user_action_day AS a
   GROUP BY substr(a.extractday,1,7),
            a.data_source) AS a
JOIN
  (SELECT substr(extractday,1,7) AS extractday,
          data_source,
          max(regalldnum) AS regalldnum,
          sum(regnum) AS regnum
   FROM warehouse_data_daliy_report_new AS a
   GROUP BY substr(extractday,1,7),
            data_source) AS b ON a.data_source=b.data_source
AND substr(a.extractday,1,7)=b.extractday;

-- 老埋点数据
INSERT overwrite TABLE warehouse_data_user_page_action PARTITION(extractday)
SELECT b.sys_id,
       b.page_type,
       b.page_subtype,
       b.level_01,
       b.level_02,
       b.level_03,
       b.page_name,
       b.button_name,
       CASE
           WHEN b.page_type IN('保险频道',
                               '信用卡频道') THEN b.page_type
           WHEN d.product_name_new IS NOT NULL THEN d.product_name_new
           ELSE a.product_name
       END product_name,
       a.mbl_no,
       count(1) AS pv,
       '' as is_new,
       extractday
FROM warehouse_atomic_user_action AS a
JOIN warehouse_data_action_info AS b ON a.sys_id=b.sys_id
AND a.page_id=b.page_id
AND a.event_id=b.button_id
LEFT JOIN warehouse_data_product_info_new AS d ON a.sys_id=d.data_source
AND a.product_id=d.product_id
AND a.product_id IS NOT NULL
WHERE extractday = date_sub(date(current_date()),1)
GROUP BY b.sys_id,
         b.page_type,
         b.page_subtype,
         b.level_01,
         b.level_02,
         b.level_03,
         b.page_name,
         b.button_name,
         CASE
             WHEN b.page_type IN('保险频道',
                                 '信用卡频道') THEN b.page_type
             WHEN d.product_name_new IS NOT NULL THEN d.product_name_new
             ELSE a.product_name
         END,
         a.mbl_no,
         extractday;

-- 新埋点数据
INSERT INTO TABLE warehouse_data_user_page_action PARTITION(extractday)
SELECT b.sys_id,
       b.page_type,
       b.page_subtype,
       b.level_01,
       b.level_02,
       b.level_03,
       b.page_name,
       b.button_name,
       CASE
           WHEN b.page_type IN('保险频道',
                               '信用卡频道') THEN b.page_type
           WHEN d.product_name_new IS NOT NULL THEN d.product_name_new
           ELSE a.product_name
       END product_name,
       a.mbl_no,
       count(1) AS pv,
       '' as is_new,
       extractday
FROM warehouse_newtrace_click_record AS a
JOIN warehouse_data_action_info AS b ON a.platform=b.sys_id
AND a.page_enname=b.page_id
AND a.button_enname=b.button_id
LEFT JOIN warehouse_data_product_info_new AS d ON a.platform=d.data_source
AND a.product_id=d.product_id
AND a.product_id IS NOT NULL
WHERE extractday = date_sub(date(current_date()),1)
GROUP BY b.sys_id,
         b.page_type,
         b.page_subtype,
         b.level_01,
         b.level_02,
         b.level_03,
         b.page_name,
         b.button_name,
         CASE
             WHEN b.page_type IN('保险频道',
                                 '信用卡频道') THEN b.page_type
             WHEN d.product_name_new IS NOT NULL THEN d.product_name_new
             ELSE a.product_name
         END,
         a.mbl_no,
         extractday;
         
-- 用户页面行为，增加新注册用户标识 add 20190116
INSERT overwrite TABLE warehouse_data_user_page_action PARTITION(extractday)
SELECT sys_id,
       page_type,
       page_subtype,
       level_01,
       level_02,
       level_03,
       page_name,
       button_name,
       product_name,
       a.mbl_no,
       pv,
       CASE
           WHEN a.extractday=b.register_date THEN '是'
           WHEN a.extractday>b.register_date THEN '否'
       END is_new,
       extractday
FROM warehouse_data_user_page_action AS a
LEFT JOIN warehouse_data_user_channel_info AS b ON a.mbl_no=b.mbl_no
AND a.sys_id = b.data_source
WHERE extractday=date_sub(date(current_date()),1);

-- 每日页面位置分析数据 add 2019-03-28
INSERT overwrite TABLE warehouse_data_user_order_action PARTITION(extractday)
SELECT a.platform,
       b.postion,
       a.page_enname,
       b.page_name,
       a.button_enname,
       b.button_name,
       device_id,
       mbl_no,
       date_time,
       channel,
       if(childchan = 'NULL',channel,childchan) AS childchan,
       province,
       country,
       product_id,
       product_name,
       SOURCE,
       CASE
           WHEN ad_order IS NOT NULL and ad_order !='NULL'  THEN '广告'
           WHEN product_order IS NOT NULL and product_order !='NULL' THEN '产品'           
           WHEN info_order IS NOT NULL and info_order !='NULL' THEN '资讯'
           WHEN game_order IS NOT NULL and game_order !='NULL' THEN '游戏'
       END ordertype,
       CASE
           WHEN ad_order IS NOT NULL and ad_order !='NULL' THEN ad_id
           WHEN product_order IS NOT NULL and product_order !='NULL' THEN product_id           
           WHEN info_order IS NOT NULL and info_order !='NULL' THEN info_id
           WHEN game_order IS NOT NULL and game_order !='NULL' THEN game_id
       END typeid,
       CASE
           WHEN ad_order IS NOT NULL and ad_order !='NULL' THEN ad_name
           WHEN product_order IS NOT NULL and product_order !='NULL' THEN product_name           
           WHEN info_order IS NOT NULL and info_order !='NULL' THEN info_name
           WHEN game_order IS NOT NULL and game_order !='NULL' THEN game_name
       END typename,
       cast(CASE
                WHEN ad_order IS NOT NULL and ad_order !='NULL'  THEN ad_order
                WHEN product_order IS NOT NULL and product_order !='NULL' THEN product_order                
                WHEN info_order IS NOT NULL and info_order !='NULL' THEN info_order
                WHEN game_order IS NOT NULL and game_order !='NULL' THEN game_order
            END AS int) typeorder,
       a.extractday
FROM warehouse_newtrace_click_record AS a
JOIN warehouse_data_action_info AS b ON a.platform=b.sys_id
AND a.page_enname=b.page_id
AND a.button_enname=b.button_id
WHERE a.extractday = date_sub(date(current_date()),1)
  AND b.postion IS NOT NULL;

-- 每日点击数据按device_id汇总 add 20181127
INSERT overwrite TABLE warehouse_data_device_action_day PARTITION(extractday)
SELECT a.sys_id AS data_source,
       a.device_id,
       NULL AS is_new,
       count(1) AS allpv,
       count(CASE
                 WHEN page_id='supermarket' THEN 1
             END) AS marketpv,
       count(CASE
                 WHEN page_id='product_detail' THEN 1
             END) AS detailpv,
       count(CASE
                 WHEN event_id='apply' THEN 1
             END) AS applypv,
       count(CASE
                 WHEN event_id='apply' THEN product_id
             END) AS applyprod,
       count(CASE
                 WHEN page_id='institution_page' THEN 1
             END) AS institupv,
       count(CASE
                 WHEN page_id='supermarket'
                      AND event_id='banner' THEN 1
             END) AS bannerpv,
       a.extractday
FROM warehouse_atomic_user_action AS a
WHERE a.extractday = date_sub(date(current_date()),1)
GROUP BY a.extractday,
         a.sys_id,
         a.device_id;

-- 每日点击数据按device_id汇总，增加新金融苑埋点 add 20181127
INSERT INTO table warehouse_data_device_action_day PARTITION(extractday)
SELECT a.platform AS data_source,
       a.device_id,
       NULL AS is_new,
       count(1) AS allpv,
       count(CASE
                 WHEN page_enname='supermarket' THEN 1
             END) AS marketpv,
       count(CASE
                 WHEN page_enname='product_detail' THEN 1
             END) AS detailpv,
       count(CASE
                 WHEN button_enname='apply' THEN 1
             END) AS applypv,
       count(CASE
                 WHEN button_enname='apply' THEN product_id
             END) AS applyprod,
       count(CASE
                 WHEN page_enname='product_detail' THEN 1
             END) AS institupv,
       count(CASE
                 WHEN button_enname='banner' THEN 1
             END) AS bannerpv,
       a.extractday
FROM warehouse_newtrace_click_record AS a
WHERE a.extractday = date_sub(date(current_date()),1)
GROUP BY a.extractday,
         a.platform,
         a.device_id;
         
-- 每日点击数据按device_id汇总，增加新新架构埋点数据 add 20181113
INSERT INTO TABLE warehouse_data_device_action_day PARTITION(extractday)
SELECT CASE
           WHEN a.platform='金融苑' THEN 'jry'
           WHEN a.platform='享宇钱包' THEN 'xyqb'
           WHEN a.platform='移动手机贷' THEN 'sjd'
           ELSE a.platform
       END AS platform,
       a.device_id,
       NULL AS is_new,
       count(1) AS allpv,
       count(CASE
                 WHEN pagenamecn='首页' THEN 1
             END) AS marketpv,
       count(CASE
                 WHEN pagenamecn='产品详情' THEN 1
             END) AS detailpv,
       count(CASE
                 WHEN click_name IN('apply_limit','apply') THEN 1
             END) AS applypv,
       count(CASE
                 WHEN click_name IN('apply_limit','apply') THEN product_id
             END) AS applyprod,             
       0 AS institupv,
       count(CASE
                 WHEN click_name='banner' THEN 1
             END) AS bannerpv,
       a.extractday
FROM warehouse_atomic_newframe_burypoint_baseoperations AS a
JOIN warehouse_atomic_newframe_burypoint_buttonoperations AS b ON a.start_id=b.start_id
WHERE a.extractday = date_sub(date(current_date()),1)
and b.extractday = date_sub(date(current_date()),1)
GROUP BY a.extractday,
         CASE
             WHEN a.platform='金融苑' THEN 'jry'
             WHEN a.platform='享宇钱包' THEN 'xyqb'
             WHEN a.platform='移动手机贷' THEN 'sjd'
             ELSE a.platform
         END,
         a.device_id;         

-- 设备日活跃数据  add 20181127
INSERT overwrite TABLE warehouse_data_device_action_daysum PARTITION(extractday)
SELECT a.data_source,
       sum(allpv) AS allpv,
       count(DISTINCT device_id) AS dnum,
       sum(applypv) AS applypv,
       count(DISTINCT CASE
                          WHEN applypv>0 THEN device_id
                      END) AS applydnum,
       avg(CASE
               WHEN applypv>0 THEN applyprod
           END) AS avgapplyprod,
       a.extractday
FROM warehouse_data_device_action_day AS a
WHERE extractday = date_sub(current_date(),1)
GROUP BY a.extractday,
         a.data_source;

-- 设备月活跃数据  add 20181127
INSERT overwrite TABLE warehouse_data_device_action_monthsum PARTITION(extractday)
SELECT a.data_source,
       sum(allpv) AS allpv,
       count(DISTINCT device_id) AS dnum,
       sum(applypv) AS applypv,
       count(DISTINCT CASE
                          WHEN applypv>0 THEN device_id
                      END) AS applydnum,
       avg(CASE
               WHEN applypv>0 THEN applyprod
           END) AS avgapplyprod,
       concat(substr(a.extractday,1,7),'-01') AS extractday
FROM warehouse_data_device_action_day AS a
WHERE substr(extractday,1,7) <= substr(date_sub(current_date(),1),1,7)
GROUP BY concat(substr(a.extractday,1,7),'-01'),
         a.data_source;

-- 免息券活动 add 2019-05-24
INSERT overwrite TABLE warehouse_data_mxqzx_info
SELECT b1.data_source,
       b1.extractday,
       b1.channel,
       b1.childchan,
       b1.button_enname,
       b1.game_name,
       sum(b1.cs) AS cs,
       sum(b1.sbs) AS sbs,
       sum(b1.rs) AS rs
FROM
  (SELECT a.platform AS data_source,
          a.extractday,
          'mxqzx' AS channel,
          '001' AS childchan,
          '弹窗' AS button_enname,
          a.ad_name AS game_name,
          count(extractday) AS cs,
          count(DISTINCT a.device_id) AS sbs,
          count(DISTINCT a.mbl_no) AS rs
   FROM default.warehouse_newtrace_click_record a
   WHERE a.platform = 'sjd'
     AND a.extractday > '2019-05-01'
     AND a.page_enname = 'ad_tc'
     AND a.button_enname = 'ad_tc'
     AND a.ad_name = '免息券'
   GROUP BY a.platform,
            a.extractday,
            a.ad_name
   UNION ALL SELECT a.platform AS data_source,
                    a.extractday,
                    'mxqzx' AS channel,
                    '001' AS childchan,
                    '开屏' AS button_enname,
                    '免息券' AS game_name,
                    count(extractday) AS cs,
                    count(DISTINCT a.device_id) AS sbs,
                    count(DISTINCT a.mbl_no) AS rs
   FROM default.warehouse_newtrace_click_record a
   WHERE a.platform = 'jry'
     AND a.extractday > '2019-05-21'
     AND a.page_enname = 'ad_kp'
     AND a.button_enname = 'ad_kp'
     AND a.ad_id = '267'
   GROUP BY a.platform,
            a.extractday
   UNION ALL SELECT a.platform AS data_source,
                    a.extractday,
                    'mxqzx' AS channel,
                    '002' AS childchan,
                    '弹窗' AS button_enname,
                    '免息券' AS game_name,
                    count(extractday) AS cs,
                    count(DISTINCT a.device_id) AS sbs,
                    count(DISTINCT a.mbl_no) AS rs
   FROM default.warehouse_newtrace_click_record a
   WHERE a.platform = 'jry'
     AND a.extractday > '2019-05-23'
     AND a.page_enname = 'ad_tc'
     AND a.button_enname = 'ad_tc'
     AND a.ad_name = '免息券'
   GROUP BY a.platform,
            a.extractday
   UNION ALL SELECT a.platform AS data_source,
                    a.extractday,
                    'mxqzx' AS channel,
                    '003' AS childchan,
                    'banner' AS button_enname,
                    '免息券' AS game_name,
                    count(extractday) AS cs,
                    count(DISTINCT a.device_id) AS sbs,
                    count(DISTINCT a.mbl_no) AS rs
   FROM default.warehouse_newtrace_click_record a
   WHERE a.platform = 'jry'
     AND a.extractday > '2019-05-21'
     AND a.page_enname = 'supermarket'
     AND a.button_enname = 'banner'
     AND a.ad_name = '免息券活动'
   GROUP BY a.platform,
            a.extractday
   UNION ALL SELECT a.platform AS data_source,
                    a.extractday,
                    'mxqzx' AS channel,
                    '004' AS childchan,
                    '活动专区' AS button_enname,
                    '免息券' AS game_name,
                    count(extractday) AS cs,
                    count(DISTINCT a.device_id) AS sbs,
                    count(DISTINCT a.mbl_no) AS rs
   FROM default.warehouse_newtrace_click_record a
   WHERE a.platform = 'jry'
     AND a.extractday > '2019-05-21'
     AND a.page_enname = 'supermarket'
     AND a.button_enname = 'activity'
   GROUP BY a.platform,
            a.extractday
   UNION ALL SELECT a.platform AS data_source,
                    a.extractday,
                    a.channel,
                    a.childchan,
                    a.button_enname,
                    '免息券' AS game_name,
                    count(extractday) AS cs,
                    count(DISTINCT a.device_id) AS sbs,
                    count(DISTINCT a.mbl_no) AS rs
   FROM default.warehouse_newtrace_click_record a
   WHERE a.extractday > '2019-05-09'
     AND a.page_enname = 'activities'
     AND a.game_name = '免息券专享'
     AND a.button_enname IN ('GO',
                             'lottery',
                             'get verification code',
                             'use immediately')
   GROUP BY a.platform,
            a.extractday,
            a.channel,
            a.childchan,
            a.button_enname
   UNION ALL SELECT a1.data_source,
                    a1.extractday,
                    a1.channel,
                    a1.childchan,
                    a1.button_enname,
                    a1.game_name,
                    '0' AS cs,
                    '0' AS sbs,
                    count(DISTINCT a1.mbl_no)
   FROM
     (SELECT a.sys_type AS data_source,
             CONCAT_WS('-',substring(a.tm_smp,1,4),substring(a.tm_smp,5,2),substring(a.tm_smp,7,2)) AS extractday,
             'mxqzx' AS channel,
             '0' AS childchan,
             '免息券领取' AS button_enname,
             '免息券' AS game_name,
             a.phone_number AS mbl_no
      FROM default.warehouse_atomic_coupon_code a
      LEFT JOIN default.warehouse_atomic_user_info b ON a.phone_number=b.mbl_no
      WHERE a.coupon_type='2'
        AND substring(a.tm_smp,1,8) > '20190509') a1
   GROUP BY a1.data_source,
            a1.extractday,
            a1.channel,
            a1.childchan,
            a1.button_enname,
            a1.game_name) b1
GROUP BY b1.data_source,
         b1.extractday,
         b1.channel,
         b1.childchan,
         b1.button_enname,
         b1.game_name;
