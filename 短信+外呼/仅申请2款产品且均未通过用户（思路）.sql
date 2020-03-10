------1、2018年1.1日-2018年12.31日注册、仅申请2款产品且均未通过用户；
------2、2019年1月1日-2019年3月24日注册、仅申请2款产品且均未通过用户，剔除申请马上随借随还未通过用户

1.取申请通过用户
(select b.mbl_no from warehouse_data_user_review_info b
where b.status = '通过') a

2.取申请都未通过用户
(select c.* from warehouse_data_user_review_info c
left outer join 
(select b.mbl_no from warehouse_data_user_review_info b
where b.status = '通过'
and b.data_source = 'sjd') a
on c.mbl_no = a.mbl_no where a.mbl_no is null

and c.mbl_no is not null
and c.data_source = 'sjd') a1

3.计算每个用户申请产品数，取出申请产品数为2的用户

(select d.* from 
(select mbl_no,count(distinct product_name) as product_num

from tmp_sqsb_xc

group by mbl_no
-----------where product_name <> '随借随还-马上'
) d
where d.product_num = '2') a2

4.对照用户表，取其注册时间
select * from a2
left join warehouse_atomic_user_info e
on a2.mbl_no = e.mbl_no
where e.data_source = 'sjd'
and registe_date between '2018-01-01' and '2018-12-31'











