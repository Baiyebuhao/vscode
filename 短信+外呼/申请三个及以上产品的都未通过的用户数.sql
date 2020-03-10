申请三个及以上产品的都未通过的用户数（错误）

select * from 
(select a.*,b.mbl_no as mbl_no_tg 
 from 
	  (select *,row_number() OVER(PARTITION BY mbl_no
       ORDER BY product_name DESC) AS rownum 
	    from warehouse_data_user_review_info 
		where substr(apply_time,1,4) = '2019')  a  ----所有申请用户

      left join 
      (select mbl_no 
       from warehouse_data_user_review_info          
       where status = '通过' and substr(apply_time,1,4) = '2019') b  ----所有申请通过用户

on a.mbl_no = b.mbl_no ) c

where mbl_no_tg is null and rownum >2





select distinct d.mbl_no_md5 from 

(select a.*,b.mbl_no as mbl_no_tg 
 from 
	  (select *,row_number() OVER(PARTITION BY mbl_no
       ORDER BY product_name DESC) AS rownum 
	    from warehouse_data_user_review_info 
		where apply_time between '2019-01-01' and '2019-03-04')  a  ----所有申请用户

      left join 
      (select mbl_no 
       from warehouse_data_user_review_info          
       where status = '通过'
       and apply_time between '2019-01-01' and '2019-03-04') b  ----所有申请通过用户

on a.mbl_no = b.mbl_no ) c
left join warehouse_atomic_user_info d
on c.mbl_no = d.mbl_no

where mbl_no_tg is null and rownum >2






select distinct d.mbl_no_md5 from 

(select a.*,b.mbl_no as mbl_no_tg 
 from 
	  (select *,row_number() OVER(PARTITION BY mbl_no
       ORDER BY product_name DESC) AS rownum 
	    from warehouse_data_user_review_info 
		where substr(apply_time,1,4) = '2018')  a  ----所有申请用户

      left join 
      (select mbl_no 
       from warehouse_data_user_review_info          
       where status = '通过'
       and substr(apply_time,1,4) = '2018') b  ----所有申请通过用户

on a.mbl_no = b.mbl_no ) c
left join warehouse_atomic_user_info d
on c.mbl_no = d.mbl_no

where mbl_no_tg is null and rownum >2
