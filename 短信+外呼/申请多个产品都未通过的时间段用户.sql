1
取出申请未授信用户
create table tmp_sq_xc
as
select c.* from warehouse_data_user_review_info c
left outer join 
(select b.mbl_no from warehouse_data_user_review_info b
where b.status = '通过') a
on c.mbl_no = a.mbl_no where a.mbl_no is null

2
取出这部分用户的 号码，产品，申请时间，平台，每个产品第一次申请的时间
create table tmp_sq23_xc
as
select b.* from 
(SELECT a.mbl_no,a.data_source,a.apply_time,a.product_name,
          row_number() OVER(PARTITION BY a.mbl_no,a.product_name
                            ORDER BY a.apply_time DESC) AS rownum
   FROM tmp_sq_xc AS a
   where a.mbl_no is not NULL
   AND mbl_no like '%=%'
   and data_source = 'sjd') b
   where b.rownum = '1'
3
取号码，申请产品数
create table tmp_js_xc
as
select mbl_no,count(product_name) from tmp_sq23_xc
group by mbl_no


4.1
申请两种产品未通过的时间
create table tmp_shijian_xc
as
select a.mbl_no,a.time1,b.time2
from
(select mbl_no,min(apply_time) as time1 from tmp_sq23_xc
where mbl_no in 
(select mbl_no from tmp_js_xc
where c1 = '2')
group by mbl_no) a
left join
(select mbl_no,max(apply_time) as time2 from tmp_sq23_xc
where mbl_no in 
(select mbl_no from tmp_js_xc
where c1 = '2')
group by mbl_no) b
on a.mbl_no = b.mbl_no
4.2
申请三种产品未通过的时间
create table tmp_shijian3_xc
as
select a.mbl_no,a.time1,b.time2
from
(select mbl_no,min(apply_time) as time1 from tmp_sq23_xc
where mbl_no in 
(select mbl_no from tmp_js_xc
where c1 = '3')
group by mbl_no) a
left join
(select mbl_no,max(apply_time) as time2 from tmp_sq23_xc
where mbl_no in 
(select mbl_no from tmp_js_xc
where c1 = '3')
group by mbl_no) b
on a.mbl_no = b.mbl_no
5.1
取号码，申请第一个产品时间，第二个产品时间，时间间隔天数
select *,DATEDIFF (time2,time1) as time12 from tmp_shijian_xc;
5.1.1
建表
create table tmp_finish3_xc
as
select *,DATEDIFF ( from_unixtime(UNIX_TIMESTAMP(time2,"yyyy-MM-dd")),
                   from_unixtime(UNIX_TIMESTAMP(time1,"yyyy-MM-dd")) ) as time11  
from tmp_shijian3_xc
5.2
取号码，申请第一个产品时间，第三个产品时间，时间间隔天数
select *,DATEDIFF (time2,time1) as time13 from tmp_shijian3_xc;
5.2.1
create table tmp_finish2_xc
as
select *,DATEDIFF ( from_unixtime(UNIX_TIMESTAMP(time2,"yyyy-MM-dd")),
                   from_unixtime(UNIX_TIMESTAMP(time1,"yyyy-MM-dd")) ) as time11  
from tmp_shijian_xc
6.1
取天数，号码数（二个产品）
select time11,count(mbl_no)
from tmp_finish2_xc
group by time11
6.2
取天数，号码数（三个产品）
select time11,count(mbl_no)
from tmp_finish3_xc
group by time11

