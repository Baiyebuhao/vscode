------点击金币-点击实名
select count(distinct mbl_no) as num1,
       count(mbl_no) as num2
from warehouse_newtrace_click_record a1
where page_enname = 'gold'
  and button_enname = 'mission'
  and task_name = 'cscs'
  and extractday between '2019-02-15' and '2019-03-15'
  and a1.mbl_no in
      (select distinct a.mbl_no from warehouse_atomic_user_info a
       where a.registe_date between '2019-02-15' and '2019-03-15')