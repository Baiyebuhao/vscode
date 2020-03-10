点击申请（推送）
点击表warehouse_atomic_user_action
event_id	事件id   apply
product_name	产品名称  
extractday	数据提取日期  
sys_id	系统名称		xyqb | sjd


正式的点击申请代码
SELECT a.mbl_no,
       a.sys_id,
       min(substring(a.extractday,1,10)) AS min_date,
       a.product_name,
       d.os_type
FROM warehouse_atomic_user_action a
LEFT JOIN warehouse_atomic_user_info d ON a.mbl_no = d.mbl_no
WHERE substring(extractday,1,10) BETWEEN '2018-09-08' AND '2018-09-14'
  AND product_name = '移动白条-马上'
GROUP BY a.mbl_no,
         a.sys_id,
         a.product_name,
         d.os_type
         

创建首次申请通过人表 tmp_MSSCSQ（电话号码，平台，申请时间，手机系统）
create table tmp_MSSCSQ 
as
SELECT a.mbl_no,
       a.data_source,
       a.min_date,
       d.os_type
       
FROM
  (SELECT mbl_no,
          data_source,
          min(substring(appl_time,1,10)) AS min_date
   FROM warehouse_atomic_msd_review_result_info
 
   GROUP BY mbl_no,data_source) a,
     warehouse_atomic_user_info d
WHERE a.mbl_no = d.mbl_no 
      and substring(min_date,1,10) BETWEEN '2018-09-08' AND '2018-09-14'
GROUP BY a.mbl_no,
         a.data_source,
         a.min_date,
         d.os_type
马上授信通过 
select * from tmp_MSSCSQ
where mbl_no in 
               (select mbl_no 
			    from warehouse_atomic_msd_review_result_info
			    where appral_res = '通过'
				and substr(credit_time,1,10) BETWEEN '2018-09-08' AND '2018-09-14')
  
				
马上提现（包含空值）
select a.mbl_no,
       a.data_source,
       a.total_amount,
       a.msd_return_time,
       b.min_date,
       b.os_type
from warehouse_atomic_msd_withdrawals_result_info a,tmp_MSSCSQ b
where a.mbl_no = b.mbl_no
group by  a.mbl_no,
       a.data_source,
       a.total_amount,
       a.msd_return_time,
       b.min_date,
       b.os_type

马上提现（金额大于0）	   
select a.mbl_no,
       a.data_source,
       a.total_amount,
       a.msd_return_time,
       b.min_date,
       b.os_type
from warehouse_atomic_msd_withdrawals_result_info a,tmp_MSSCSQ b
where a.mbl_no = b.mbl_no
  and a.total_amount > 0
group by  a.mbl_no,
       a.data_source,
       a.total_amount,
       a.msd_return_time,
       b.min_date,
       b.os_type