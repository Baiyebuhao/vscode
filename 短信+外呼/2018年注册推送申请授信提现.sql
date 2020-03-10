注册
(select distinct a.mbl_no
from warehouse_atomic_all_process_info a
     
     left join warehouse_atomic_user_info c             
         on a.data_source= c.data_source and a.mbl_no = c.mbl_no
where a.action_name = '注册'and a.data_source <> 'jry'
      and a.action_date between '2018-01-01' and '2018-12-31'                  ---------选择注册时间维度
  )

推送（平哥的表取的数，不用判断是否2018年注册）
(

(-----------推送人数
SELECT count(DISTINCT CASE
                          WHEN (is_new IN ('','是')
                                OR is_new IS NULL) THEN mbl_no
                      END) AS dnum_new,
       count(DISTINCT CASE
                          WHEN is_new= '否' THEN mbl_no
                      END) AS dnum_old,
	   count(DISTINCT mbl_no) AS dnum3	  
FROM warehouse_data_user_action_sum
WHERE extractday between '2018-01-21' and '2018-12-31'
  AND applypv > 0
)

(-----------推送人数（分产品）
SELECT product_name,
       count(DISTINCT CASE
                          WHEN (is_new IN ('','是')
                                OR is_new IS NULL) THEN mbl_no
                      END) AS dnum_new,
       count(DISTINCT CASE
                          WHEN is_new= '否' THEN mbl_no
                      END) AS dnum_old,
	   count(DISTINCT mbl_no) AS dnum3	  
FROM warehouse_data_user_action_sum
WHERE extractday between '2018-01-21' and '2018-12-31'
  AND applypv > 0
GROUP BY product_name
)

(-----------推送次数（分产品）
SELECT product_name,
       count( CASE 
	               WHEN (is_new IN ('','是')
                                OR is_new IS NULL) THEN mbl_no
                      END) AS dnum_new,
       count( CASE WHEN is_new= '否' THEN mbl_no
                      END) AS dnum_old,
	   count(mbl_no) AS dnum3	  
FROM warehouse_data_user_action_sum
WHERE extractday between '2018-01-21' and '2018-12-31'
  AND applypv > 0
GROUP BY product_name
)

)

申请
(

(-----------申请人数
select     
count(distinct a.mbl_no) as sq,substring(a1.action_date,1,4) as z_time
from warehouse_data_user_review_info a
left join
(select distinct a.mbl_no,
       a.action_date,
       a.data_source
from warehouse_atomic_all_process_info a
     
     left join warehouse_atomic_user_info c             
         on a.data_source= c.data_source and a.mbl_no = c.mbl_no
where a.action_name = '注册'and a.data_source <> 'jry'
      and a.action_date between '2018-01-01' and '2018-12-31'                  ---------选择注册时间维度
  )a1                                                                ---------取出注册用户作为表a1
 on a.mbl_no = a1.mbl_no and a.data_source = a1.data_source
where a.mbl_no <> 'null'
	 and a.apply_time between '2018-01-01' and '2018-12-31'           ---------选择申请时间维度
	 and a1.action_date <> 'null'
group by substring(a1.action_date,1,4)
)

(-----------申请人数（分产品）
select     
count(distinct a.mbl_no) as sq,substring(a1.action_date,1,4) as z_time,a.product_name
from warehouse_data_user_review_info a
left join
(select distinct a.mbl_no,
       a.action_date,
       a.data_source
from warehouse_atomic_all_process_info a
     
     left join warehouse_atomic_user_info c             
         on a.data_source= c.data_source and a.mbl_no = c.mbl_no
where a.action_name = '注册'and a.data_source <> 'jry'
      and a.action_date between '2018-01-01' and '2018-12-31'                  ---------选择注册时间维度
  )a1                                                                ---------取出注册用户作为表a1
 on a.mbl_no = a1.mbl_no and a.data_source = a1.data_source
where a.mbl_no <> 'null'
	 and a.apply_time between '2018-01-01' and '2018-12-31'           ---------选择申请时间维度
	 and a1.action_date <> 'null'
group by substring(a1.action_date,1,4),a.product_name
)

(-----------申请次数（分产品）
select     
count(a.mbl_no) as sq,substring(a1.action_date,1,4) as z_time,a.product_name
from warehouse_data_user_review_info a
left join
(select distinct a.mbl_no,
       a.action_date,
       a.data_source
from warehouse_atomic_all_process_info a
     
     left join warehouse_atomic_user_info c             
         on a.data_source= c.data_source and a.mbl_no = c.mbl_no
where a.action_name = '注册'and a.data_source <> 'jry'
      and a.action_date between '2018-01-01' and '2018-12-31'                  ---------选择注册时间维度
  )a1                                                                ---------取出注册用户作为表a1
 on a.mbl_no = a1.mbl_no and a.data_source = a1.data_source
where a.mbl_no <> 'null'
	 and a.apply_time between '2018-01-01' and '2018-12-31'           ---------选择申请时间维度
	 and a1.action_date <> 'null'
group by substring(a1.action_date,1,4),a.product_name
)

)

授信
(

(------------授信人数
select     
count(distinct a.mbl_no) as sx,substring(a1.action_date,1,4) as z_time
from warehouse_data_user_review_info a
left join
(select distinct a.mbl_no,
       a.action_date,
       a.data_source
from warehouse_atomic_all_process_info a
     
     left join warehouse_atomic_user_info c             
         on a.data_source= c.data_source and a.mbl_no = c.mbl_no
where a.action_name = '注册'and a.data_source <> 'jry'
      and a.action_date between '2018-01-01' and '2018-12-31'                  ---------选择注册时间维度
)a1                                                                ---------取出注册用户作为表a1
 on a.mbl_no = a1.mbl_no and a.data_source = a1.data_source
where a.mbl_no <> 'null'
     and a.status = '通过'
	 and a.apply_time between '2018-01-01' and '2018-12-31'           ---------选择申请时间维度
	 and a1.action_date <> 'null'
group by substring(a1.action_date,1,4)
)

(----------------授信人数（分产品）
select     
count(distinct a.mbl_no) as sx,substring(a1.action_date,1,4) as z_time,a.product_name
from warehouse_data_user_review_info a
left join
(select distinct a.mbl_no,
       a.action_date,
       a.data_source
from warehouse_atomic_all_process_info a
     
     left join warehouse_atomic_user_info c             
         on a.data_source= c.data_source and a.mbl_no = c.mbl_no
where a.action_name = '注册'and a.data_source <> 'jry'
      and a.action_date between '2018-01-01' and '2018-12-31'                  ---------选择注册时间维度
  )a1                                                                ---------取出注册用户作为表a1
 on a.mbl_no = a1.mbl_no and a.data_source = a1.data_source
where a.mbl_no <> 'null'
     and a.status = '通过'
	 and a.apply_time between '2018-01-01' and '2018-12-31'           ---------选择申请时间维度
	 and a1.action_date <> 'null'
group by substring(a1.action_date,1,4),a.product_name
)
(---------------授信次数（分产品）
select     
count(a.mbl_no) as sx,substring(a1.action_date,1,4) as z_time,a.product_name
from warehouse_data_user_review_info a
left join
(select distinct a.mbl_no,
       a.action_date,
       a.data_source
from warehouse_atomic_all_process_info a
     
     left join warehouse_atomic_user_info c             
         on a.data_source= c.data_source and a.mbl_no = c.mbl_no
where a.action_name = '注册'and a.data_source <> 'jry'
      and a.action_date between '2018-01-01' and '2018-12-31'                  ---------选择注册时间维度
  )a1                                                                ---------取出注册用户作为表a1
 on a.mbl_no = a1.mbl_no and a.data_source = a1.data_source
where a.mbl_no <> 'null'
     and a.status = '通过'
	 and a.apply_time between '2018-01-01' and '2018-12-31'           ---------选择申请时间维度
	 and a1.action_date <> 'null'
group by substring(a1.action_date,1,4),a.product_name
)

)

提现
(

(-------提现人数
select  
count(distinct a.mbl_no) as tx,sum(a.cash_amount) as txe,substring(a1.action_date,1,4) as z_time
from warehouse_data_withdrawals_info a
left join 
(select distinct a.mbl_no,
       a.action_date,
       a.data_source
from warehouse_atomic_all_process_info a
     
     left join warehouse_atomic_user_info c             
         on a.data_source= c.data_source and a.mbl_no = c.mbl_no
where a.action_name = '注册'and a.data_source <> 'jry'
      and a.action_date between '2018-01-01' and '2018-12-31'                  ---------选择注册时间维度
  ) a1
on a.mbl_no = a1.mbl_no
and a.data_source = a1.data_source
where a.mbl_no <> 'null'
    and a.cash_amount > 0
	and a.cash_time between '2018-01-01' and '2018-12-31'                       ---------选择提现时间维度 
    and a1.action_date <> 'null'
group by substring(a1.action_date,1,4)
)

(-------提现人数（分产品）
select  
count(distinct a.mbl_no) as tx,sum(a.cash_amount) as txe,substring(a1.action_date,1,4) as z_time,a.product_name
from warehouse_data_withdrawals_info a
left join 
(select distinct a.mbl_no,
       a.action_date,
       a.data_source
from warehouse_atomic_all_process_info a
     
     left join warehouse_atomic_user_info c             
         on a.data_source= c.data_source and a.mbl_no = c.mbl_no
where a.action_name = '注册'and a.data_source <> 'jry'
      and a.action_date between '2018-01-01' and '2018-12-31'                  ---------选择注册时间维度
  ) a1
on a.mbl_no = a1.mbl_no
and a.data_source = a1.data_source
where a.mbl_no <> 'null'
    and a.cash_amount > 0
	and a.cash_time between '2018-01-01' and '2018-12-31'                       ---------选择提现时间维度 
    and a1.action_date <> 'null'
group by substring(a1.action_date,1,4),a.product_name
)

(-------提现次数（分产品）
select  
count(a.mbl_no) as tx,sum(a.cash_amount) as txe,substring(a1.action_date,1,4) as z_time,a.product_name
from warehouse_data_withdrawals_info a
left join 
(select distinct a.mbl_no,
       a.action_date,
       a.data_source
from warehouse_atomic_all_process_info a
     
     left join warehouse_atomic_user_info c             
         on a.data_source= c.data_source and a.mbl_no = c.mbl_no
where a.action_name = '注册'and a.data_source <> 'jry'
      and a.action_date between '2018-01-01' and '2018-12-31'                  ---------选择注册时间维度
  ) a1
on a.mbl_no = a1.mbl_no
and a.data_source = a1.data_source
where a.mbl_no <> 'null'
    and a.cash_amount > 0
	and a.cash_time between '2018-01-01' and '2018-12-31'                       ---------选择提现时间维度 
    and a1.action_date <> 'null'
group by substring(a1.action_date,1,4),a.product_name
)

)
