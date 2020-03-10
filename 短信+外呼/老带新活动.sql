老带新活动
1.1每日返回数据总计

select a.extractday,a.shu,count(a.team_id) from
(select count(open_id) as shu,team_id,extractday from original_activity_team_member

group by team_id,extractday) a
group by a.extractday,a.shu
1.2每日返回数据（分平台）
select a.extractday,a.system_type,a.shu,count(a.team_id) from
(select count(open_id) as shu,team_id,extractday,system_type from original_activity_team_member

group by team_id,extractday,system_type) a
group by a.extractday,a.system_type,a.shu

2.开团人数（分平台，分新老）
2.1取明细数据
select DISTINCT a.open_id,b.mbl_no,b.registe_date,b.data_source
from original_activity_team_member a
left join warehouse_atomic_user_info b
on a.open_id = b.user_openid
where a.is_leader = '1'
2.2数据汇总
select b.data_source,
       count(DISTINCT CASE
                          WHEN (substr(b.registe_date,1,10) > '2019-01-27') THEN b.mbl_no
                      END) AS xin,
       count(DISTINCT CASE
                          WHEN (substr(b.registe_date,1,10) < '2019-01-28') THEN b.mbl_no
                      END) AS lao,
	   count(DISTINCT b.mbl_no) AS zong
from original_activity_team_member a
left join warehouse_atomic_user_info b
on a.open_id = b.user_openid
where a.is_leader = '1'
group by  b.data_source

3.参与活动人数中申请-授信-提现数据
3.1申请
select * from warehouse_data_user_review_info
where apply_time between '2019-01-28' and '2019-02-26'
and mbl_no in
(select mbl_no from original_activity_team a
left join warehouse_atomic_user_info b
on user_openid = open_id
where extractday = '2019-02-26'
and mbl_no is not NULL)
3.2授信
select * from warehouse_data_user_review_info
where apply_time between '2019-01-28' and '2019-02-26'
and status = '通过'
and mbl_no in
(select mbl_no from original_activity_team a
left join warehouse_atomic_user_info b
on user_openid = open_id
where extractday = '2019-02-26'
and mbl_no is not NULL)

3.3提现
select * from warehouse_data_withdrawals_info
where cash_time between '2019-01-28' and '2019-02-26'
and mbl_no in
(select mbl_no from original_activity_team a
left join warehouse_atomic_user_info b
on user_openid = open_id
where extractday = '2019-02-26'
and mbl_no is not NULL)