create table  tmp_a4_xc
as
select a3.mbl_no,count(a3.product_name) from 
(select a2.* from 

 (SELECT a1.mbl_no,a1.data_source,a1.apply_time,a1.product_name,

          row_number() OVER(PARTITION BY a1.mbl_no,a1.product_name
                            ORDER BY a1.apply_time DESC) AS rownum
							
  FROM 
   (select c.* from warehouse_data_user_review_info c
    left outer join 
   (select b.mbl_no from warehouse_data_user_review_info b
    where b.status = '通过') a
    on c.mbl_no = a.mbl_no where a.mbl_no is null) a1          -------取出申请未授信用户（创建表a1）
   
   
  where a1.mbl_no is not NULL
  AND mbl_no like '%=%'
  and data_source = 'sjd') a2     ----取出这部分用户的 号码，平台，产品，申请时间（创建表a2）
   
where a2.rownum = '1') a3         ----取出这部分用户的 号码，平台，产品，每个产品第一次申请的时间（创建表a3）

group by a3.mbl_no                ----取号码，申请产品数（创建表a4）




取天数，号码数（二个产品）
select time12,count(mbl_no)
from 
(select *,DATEDIFF (time2,time1) as time12 
 from 
 
(select a.mbl_no,a.time1,b.time2
from
(select mbl_no,min(apply_time) as time1 from a3
where mbl_no in 
(select mbl_no from tmp_a4_xc
where c1 = '2')
group by mbl_no) a          ----取号码，第一次申请第一个产品的时间
left join
(select mbl_no,max(apply_time) as time2 from a3
where mbl_no in 
(select mbl_no from tmp_a4_xc
where c1 = '2')
group by mbl_no) b          ----取号码，第一次申请第二个产品的时间
on a.mbl_no = b.mbl_no) b1  ----取号码，申请两种产品未通过的时间
 
 )                           -----取号码，申请第一个产品时间，第二个产品时间，时间间隔天数
group by time12



