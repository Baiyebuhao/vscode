--创建晋商商户明细表（数据来源-石墨表）
drop table warehouse_data_jinshang_detailed_info;

CREATE TABLE warehouse_data_jinshang_detailed_info 
(store string COMMENT '门店名称',
district string COMMENT '所属区域',
address string COMMENT '门店地址',
xs_code string COMMENT '销售人员代码',
name string COMMENT '姓名',
ID_card string COMMENT '证件号码',
mbl_no string COMMENT '手机号',
apply_date date COMMENT '申请时间',
credit_time date COMMENT '通过时间',
status string COMMENT '状态',
bandan_st string COMMENT '是否可以办单',
remarks string COMMENT '备注',
duration string COMMENT '审批消耗时长（工作日）',
is_list_exist COMMENT '提数清单是否存在') COMMENT '晋商商户明细表' row format delimited fields terminated by ',';

load data local inpath '/root/tmp.csv' into table warehouse_data_jinshang_detailed_info;

grant select on table warehouse_data_jinshang_detailed_info to user zhangjianping;
grant select on table warehouse_data_jinshang_detailed_info to user liyong;
grant select on table warehouse_data_jinshang_detailed_info to user herong;
grant select on table warehouse_data_jinshang_detailed_info to user tangyuhang;
grant select on table warehouse_data_jinshang_detailed_info to user tianting;
grant select on table warehouse_data_jinshang_detailed_info to user wujialin;
grant select on table warehouse_data_jinshang_detailed_info to user xuchao;
grant select on table warehouse_data_jinshang_detailed_info to user yechuan;
grant select on table warehouse_data_jinshang_detailed_info to user hue;

--晋商商户办单数据（prsto+BI展现）
select year(date(a.apply_time)) AS YEAR,
       date_trunc('week',date(a.apply_time)) AS weekday,
       a.apply_time AS extractday,
       b.district,
	   a.store,
       count(distinct a.customer_phone) as sq,
       count(distinct case when a.apply_state in ('已放款','审批通过，等待放款') then a.customer_phone end) as sx,
       count(distinct case when a.apply_state = '贷款被拒绝' then a.customer_phone end) as bj,
       sum(case when a.apply_state  in ('已放款','审批通过，等待放款') then cast(a.approval_amount AS double) end) as je1,
       sum(case when a.apply_state = '已放款' then cast(a.approval_amount AS double) end) as je2
from default.warehouse_atomic_new_dis_order a
left join default.warehouse_data_jinshang_detailed_info b
on a.store = b.store

group by year(date(a.apply_time)),
       date_trunc('week',date(a.apply_time)),
	   a.apply_time,
	   b.district,
	   a.store

--晋商新增商户数据（prsto+BI展现）
select year(date(a.extractday)) AS YEAR,
       date_trunc('week',date(a.extractday)) AS weekday,
	   extractday,
	   district,
	   sum(sq) as sq,
	   sum(tg) as tg
from
(select a1.apply_date as extractday,district,
       count(distinct a1.store) as sq,
       0 as tg
from default.warehouse_data_jinshang_detailed_info a1
group by a1.apply_date,district

union all

select a1.credit_time as extractday,district,
       0 as sq,
       count(distinct a1.store) as tg
from default.warehouse_data_jinshang_detailed_info a1
group by a1.credit_time,district) a
group by year(date(a.extractday)),
       date_trunc('week',date(a.extractday)),
	   extractday,
	   district
