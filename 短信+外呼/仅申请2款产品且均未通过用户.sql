------1、2018年1.1日-2018年12.31日注册、仅申请2款产品且均未通过用户；
select distinct a2.mbl_no from 
(select d.* from 
(select mbl_no,count(distinct product_name) as product_num

from 
(select c.* from warehouse_data_user_review_info c
left outer join 
(select b.mbl_no from warehouse_data_user_review_info b
where b.status = '通过'
and b.data_source = 'sjd') a
on c.mbl_no = a.mbl_no where a.mbl_no is null

and c.mbl_no is not null
and c.data_source = 'sjd') a1

group by mbl_no) d
where d.product_num = '2') a2
left join warehouse_atomic_user_info e
on a2.mbl_no = e.mbl_no
where e.data_source = 'sjd'
and e.registe_date between '2018-01-01' and '2018-12-31'



------2、2019年1月1日-2019年3月24日注册、仅申请2款产品且均未通过用户，剔除申请马上随借随还未通过用户
select a2.mbl_no from 
(select d.* from 
(select mbl_no,count(distinct product_name) as product_num

from 
(select c.* from warehouse_data_user_review_info c
left outer join 
(select b.mbl_no from warehouse_data_user_review_info b
where b.status = '通过'
and b.data_source = 'sjd') a
on c.mbl_no = a.mbl_no where a.mbl_no is null

and c.mbl_no is not null
and c.data_source = 'sjd'
and c.product_name <> '随借随还-马上') a1

group by mbl_no) d
where d.product_num = '2') a2
left join warehouse_atomic_user_info e
on a2.mbl_no = e.mbl_no
where e.data_source = 'sjd'
and e.registe_date between '2019-01-01' and '2019-03-24'