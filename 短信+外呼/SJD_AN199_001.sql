-----取随机
----

select * from tmp_waihu0521_xc
distribute by rand()
sort by rand()
limit 800;

-----在2019年4月1日前，在（移动手机贷平台）（授信通过）的安卓用户，且近3天有登录行为（'2019-05-18' and '2019-05-20'）
-----（保留用户姓名、手机号、最近的授信时间、授信额度及授信产品）
----外呼表tmp_waihu0521_xc
create table tmp_waihu0521_xc
as
select a1.mbl_no,
       a2.name,
       a1.credit_time,
       a1.amount,
       a1.product_name
from 
(
select mbl_no,
       credit_time,
       product_name,
       amount,
       Row_Number() OVER (partition by mbl_no ORDER BY credit_time desc) rank   
from warehouse_data_user_review_info a
where status = '通过'
  and data_source = 'sjd'
  and credit_time < '2019-04-01'
  and amount > '0'
) a1

join warehouse_atomic_user_info a2
   on a1.mbl_no = a2.mbl_no
join (select distinct mbl_no
           from warehouse_newtrace_click_record b1
           where extractday between '2019-05-18' and '2019-05-20'
           and platform = 'sjd'
           UNION
           select distinct mbl_no
           from warehouse_atomic_user_action b2
           where sys_id = 'sjd'
           and extractday between '2019-05-18' and '2019-05-20') a3 
   on a1.mbl_no = a3.mbl_no
where a1.rank = '1'
  and a2.os_type = '01'
  and a2.data_source = 'sjd'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe WHERE eff_flg = '1')