--切换用户
set role admin;
set io.sort.mb=70;
set hive.jobname.length=20;

-- 营销活动效果跟踪
INSERT overwrite TABLE  warehouse_data_user_marketing_effect_info  PARTITION (data_code)
SELECT 
       allsum.data_source,
       allsum.product_name,
       allsum.extractday,
       code_number.code_num as code_num,
       sum(allsum.activenum) AS activenum,
       sum(allsum.allapplyenum) AS allappenum,
       sum(allsum.appnum) AS appnum,
       sum(allsum.applynum) AS applynum,
       sum(allsum.creditnum) AS creditnum,
       sum(allsum.cashnum) AS cashnum,
       sum(allsum.cashamount) AS cashamount,
       allsum.marketting_type,
       CURRENT_DATE,
       allsum.data_code
FROM
(-- PUSH跟踪:活跃、推送
SELECT a.data_source,
       a.data_code,
       a.marketting_type,
       a.extractday,
       b.product_name,
       0 as code_num,    
       activenum,
       allapplyenum,
       appnum,
       0 AS applynum,
       0 AS creditnum,
       0 AS cashnum,
       0 AS cashamount
   FROM
     (SELECT a.data_source,
             b.data_code,
             b.marketting_type,
             a.extractday,
             count(DISTINCT b.mbl_no_encode) AS activenum,
             count(DISTINCT CASE
                                WHEN a.applypv>0 THEN b.mbl_no_encode
                            END) AS allapplyenum
      FROM warehouse_data_user_action_day AS a
      INNER JOIN
        (SELECT DISTINCT *
         FROM (select cus_no,
mbl_no_encode,
data_code,
data_source,
marketting_type,
rk_date
from warehouse_data_push_user
union all
select 0 as  cus_no,
mbl_no_encode,
data_desc as data_code,
data_source,
marketing_type,
data_extract_day as rk_date
from warehouse_atomic_operation_promotion) AS a
         WHERE rk_date >= date_sub(current_date(),7)) b ON a.mbl_no = b.mbl_no_encode
      AND a.data_source=b.data_source
      WHERE extractday between  date_sub(rk_date,3) and date_add(rk_date,6)
      GROUP BY a.data_source,
               b.data_code,
               b.marketting_type,
               a.extractday)AS a
   JOIN
     (SELECT a.data_source,
             b.data_code,
             b.marketting_type,
             a.extractday,
             a.product_name,
             count(DISTINCT b.mbl_no_encode) AS appnum
      FROM warehouse_data_user_action_day AS a
      INNER JOIN
        (SELECT DISTINCT *
         FROM (select cus_no,
mbl_no_encode,
data_code,
data_source,
marketting_type,
rk_date
from warehouse_data_push_user
union all
select 0 as  cus_no,
mbl_no_encode,
data_desc as data_code,
data_source,
marketing_type,
data_extract_day as rk_date
from warehouse_atomic_operation_promotion) AS a
         WHERE rk_date >= date_sub(current_date(),7)) b ON a.mbl_no = b.mbl_no_encode
      AND a.data_source=b.data_source
      WHERE extractday between  date_sub(rk_date,3) and date_add(rk_date,6)
        AND a.applypv>0
      GROUP BY a.data_source,
               b.data_code,
               b.marketting_type,
               a.extractday,
               a.product_name) AS b ON a.data_source=b.data_source
   AND a.data_code=b.data_code
   AND a.extractday=b.extractday
   UNION ALL -- PUSH跟踪:申请
SELECT a.data_source,
       b.data_code,
       b.marketting_type,
       a.apply_time AS extractday,
       a.product_name,
       0 as code_num,
       0 AS activenum,
       0 AS allappenum,
       0 AS appnum,
       count(DISTINCT b.mbl_no_encode) AS applynum,
       0 AS creditnum,
       0 AS cashnum,
       0 AS cashamount
   FROM warehouse_data_user_review_info AS a
   INNER JOIN
     (SELECT DISTINCT *
      FROM (select cus_no,
mbl_no_encode,
data_code,
data_source,
marketting_type,
rk_date
from warehouse_data_push_user
union all
select 0 as  cus_no,
mbl_no_encode,
data_desc as data_code,
data_source,
marketing_type,
data_extract_day as rk_date
from warehouse_atomic_operation_promotion) AS a
      WHERE rk_date >= date_sub(current_date(),7)) b ON a.mbl_no = b.mbl_no_encode
   AND a.data_source=b.data_source
   WHERE apply_time between  date_sub(rk_date,3) and date_add(rk_date,6)
   GROUP BY a.data_source,
            b.data_code,
            b.marketting_type,
            a.apply_time,
            a.product_name
   UNION ALL -- PUSH跟踪:授信
SELECT a.data_source,
       b.data_code,
       b.marketting_type,
       a.credit_time AS extractday,
       a.product_name,
       0 as code_num,    
       0 AS activenum,
       0 AS allappenum,
       0 AS appnum,
       0 AS applynum,
       count(DISTINCT b.mbl_no_encode) AS creditnum,
       0 AS cashnum,
       0 AS cashamount
   FROM warehouse_data_user_review_info AS a
   INNER JOIN
     (SELECT DISTINCT *
      FROM (select cus_no,
mbl_no_encode,
data_code,
data_source,
marketting_type,
rk_date
from warehouse_data_push_user
union all
select 0 as  cus_no,
mbl_no_encode,
data_desc as data_code,
data_source,
marketing_type,
data_extract_day as rk_date
from warehouse_atomic_operation_promotion) AS a
      WHERE rk_date >= date_sub(current_date(),7) ) b ON a.mbl_no = b.mbl_no_encode
   AND a.data_source=b.data_source
   WHERE credit_time between  date_sub(rk_date,3) and date_add(rk_date,6) and status = '通过'
   GROUP BY a.data_source,
            b.data_code,
            b.marketting_type,
            a.credit_time,
            a.product_name
   UNION ALL -- PUSH跟踪:放款
SELECT a.data_source,
       b.data_code,
       b.marketting_type,
       a.cash_time AS extractday,
       a.product_name,
       0 as code_num,
       0 AS activenum,
       0 AS allappenum,
       0 AS appnum,
       0 AS applynum,
       0 AS creditnum,
       count(DISTINCT b.mbl_no_encode) AS cashnum,
       sum(cash_amount) AS cashamount
   FROM warehouse_data_user_withdrawals_info AS a
   INNER JOIN
     (SELECT DISTINCT *
      FROM (select cus_no,
mbl_no_encode,
data_code,
data_source,
marketting_type,
rk_date
from warehouse_data_push_user
union all
select 0 as  cus_no,
mbl_no_encode,
data_desc as data_code,
data_source,
marketing_type,
data_extract_day as rk_date
from warehouse_atomic_operation_promotion) AS a
      WHERE rk_date >= date_sub(current_date(),7) ) b ON a.mbl_no = b.mbl_no_encode
   AND a.data_source=b.data_source
   WHERE cash_time between  date_sub(rk_date,3) and date_add(rk_date,6)
   GROUP BY a.data_source,
            b.data_code,
            b.marketting_type,
            a.cash_time,
            a.product_name) AS allsum
left join ---编码总量
  (select a.data_source,
       a.data_code,
       a.marketting_type,
       0 as extractday,
       0 as product_name,
       count(distinct a.mbl_no_encode) as code_num,
       0 AS activenum,
       0 AS allappenum,
       0 AS appnum,
       0 AS applynum,
       0 AS creditnum,
       0 AS cashnum,
       0 AS cashamount
   FROM (select cus_no,
mbl_no_encode,
data_code,
data_source,
marketting_type,
rk_date
from warehouse_data_push_user
union all
select 0 as  cus_no,
mbl_no_encode,
data_desc as data_code,
data_source,
marketing_type,
data_extract_day as rk_date
from warehouse_atomic_operation_promotion)  a
   group by a.data_source,
    a.data_code,
       a.marketting_type)  as code_number on allsum.data_code = code_number.data_code 
       and allsum.data_source = code_number.data_source  and allsum.marketting_type = code_number.marketting_type           
GROUP BY allsum.data_source,
         allsum.data_code,
         allsum.marketting_type,
         allsum.extractday,
         allsum.product_name,
         code_number.code_num;


-- 享宇钱包导流效果跟踪
INSERT overwrite TABLE warehouse_data_platform_drainage_info PARTITION(data_code)
SELECT a.mbl_no_encode,
       b.data_source,
       b.registe_date,
       b.authentication_date,
       b.chan_no_desc,
       b.child_chan,
       a.data_code
FROM warehouse_data_push_user AS a
INNER JOIN warehouse_atomic_user_info AS b ON a.mbl_no_encode = b.mbl_no
WHERE a.rk_date <= b.registe_date
  AND rk_date > date_sub(current_date(),15)
  AND rk_date <= date_sub(current_date(),1)
  AND a.data_source = 'sjd'
  AND (data_code LIKE '%SJD_GD001%'
       OR data_code LIKE '%SJD_RN134%'
       OR data_code LIKE '%SJD_RN200_001%')
  AND b.data_source = 'xyqb';