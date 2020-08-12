新埋点表数据验证
基础表：
warehouse_atomic_newframe_burypoint_baseoperations 
页面表：
warehouse_atomic_newframe_burypoint_pageoperations
按键表：
warehouse_atomic_newframe_burypoint_buttonoperations

--start_id
--逻辑：base = page >= button
--base表:65517
select count(distinct start_id)
from warehouse_atomic_newframe_burypoint_baseoperations a
where extractday between '2020-04-15' and '2020-06-15'
--page表:72260
select count(distinct start_id)
from warehouse_atomic_newframe_burypoint_pageoperations a
where extractday between '2020-04-15' and '2020-06-15'
--button表:80365
select count(distinct start_id)
from warehouse_atomic_newframe_burypoint_buttonoperations a
where extractday between '2020-04-15' and '2020-06-15'


--phonenumber
--page表:24581
select count(distinct phone_number)
from warehouse_atomic_newframe_burypoint_pageoperations a
where extractday between '2020-04-15' and '2020-06-15'
--button表:24216
select count(distinct phone_number)
from warehouse_atomic_newframe_burypoint_buttonoperations a
where extractday between '2020-04-15' and '2020-06-15'


--button表点击申请:10313
select count(distinct phone_number)
from warehouse_atomic_newframe_burypoint_buttonoperations a
where extractday between '2020-04-15' and '2020-06-15'
  and a.click_name = 'order_promptly'

--新台账表申请：19812
SELECT count(distinct a.mbl_no)
from warehouse_ledger_l_application_inf a
where substr(apply_time,1,10) between '2020-04-15' and '2020-06-15'

--关联新台账申请和点击表申请1：3487
SELECT count(DISTINCT a.mbl_no)
   FROM warehouse_ledger_l_application_inf a
   WHERE substr(apply_time,1,10) BETWEEN '2020-04-15' AND '2020-06-15'
     and a.mbl_no in 
     (SELECT DISTINCT phone_number as mbl_no
      FROM warehouse_atomic_newframe_burypoint_buttonoperations a
      WHERE extractday BETWEEN '2020-04-15' AND '2020-06-15'
        AND a.click_name = 'order_promptly') 
		
--关联新台账申请和点击表申请: 3487
     SELECT count(DISTINCT a.phone_number)
      FROM warehouse_atomic_newframe_burypoint_buttonoperations a
      WHERE extractday BETWEEN '2020-04-15' AND '2020-06-15'
        AND a.click_name = 'order_promptly'
        and a.phone_number in 
        (SELECT DISTINCT a.mbl_no as phone_number
         FROM warehouse_ledger_l_application_inf a
         WHERE substr(apply_time,1,10) BETWEEN '2020-04-15' AND '2020-06-15')

--