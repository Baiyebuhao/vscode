##调查问题完成度的计算
select ts.research_apply_id,
       count(DISTINCT t.xy_id) AS all_count,
	   count(DISTINCT r.r_id) AS result_count
from warehouse_atomic_hzx_research_task as ts         ---营销调查人员单次任务表
join warehouse_atomic_hzx_b_loan_research_group_relate g on ts.version_id=g.version_id      ----银行产品调查页签与产品关系表
join warehouse_atomic_hzx_b_research_content_templet t on g.group_id= t.g_id               ----银行产品调查问题表
LEFT JOIN  
         (SELECT r_id,research_id 
		  from warehouse_atomic_hzx_l_research_result                ---标准调查结果记录表
          UNION ALL 
		  SELECT question_id,research_id 
		  from warehouse_atomic_hzx_l_research_apply_photo) r        ----标准调查拍照
	 on t.xy_id = r.r_id and r.research_id = ts.research_apply_id

LEFT JOIN warehouse_atomic_hzx_l_cust_level_research_show s on s.task_id = ts.id and s.xy_id = t.xy_id       ----客户分层调查问题不显示记录表
LEFT JOIN warehouse_atomic_hzx_l_cust_group_research_show gs on gs.task_id = ts.id and gs.group_id = g.group_id       -----根据前置条件判断不显示的页签存储表

where t.version_id = g.version_id 
  and g.enable = True
  and t.enable= 1 
  and t.is_required = True 
  and t.is_entry = True 
  and t.statement_type = 0  
  and s.id is null 
  and gs.id is null
  and ts.research_apply_time>='2019-09-20'
group by ts.research_apply_id