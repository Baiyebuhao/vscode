招联授信用户与马上-随借随还授信用户重合度
1.取招联授信用户
法一：
select count(distinct mbl_no) 
from warehouse_atomic_zhaolian_review_result_info a
where apply_status_desc = '申请成功'
法二：
select count(distinct mbl_no)  
from warehouse_data_user_review_info a
where product_name in ('业主贷-招联','大期贷-招联','白领贷-招联','公积金社保贷-招联','好期贷-招联')
and status = '通过'

2.取马上-随借随还授信用户
法一：
select count(distinct mbl_no)  
from warehouse_atomic_msd_review_result_info a
where appral_res = '通过'
法二：
select count(distinct mbl_no)  
from warehouse_data_user_review_info a
where product_name in ('随借随还-马上')
and status = '通过'
3.取招联中马上用户
select count(distinct mbl_no) 
from warehouse_atomic_zhaolian_review_result_info b
where apply_status_desc = '申请成功'
and mbl_no in (select distinct mbl_no  
               from warehouse_data_user_review_info a
               where product_name in ('随借随还-马上')
               and status = '通过')
			   
4.看3中用户的提现数据
create table tmp_zhaolian_msd_xc
as
SELECT d.*
FROM warehouse_data_withdrawals_info d
right join 
    (SELECT DISTINCT b.mbl_no
     FROM warehouse_atomic_zhaolian_review_result_info b
     WHERE b.apply_status_desc = '申请成功'
       AND b.mbl_no IN
         (SELECT DISTINCT a.mbl_no
          FROM warehouse_data_user_review_info a
          WHERE a.product_name IN ('随借随还-马上')
            AND a.status = '通过')) a1
on d.mbl_no = a1.mbl_no

5.3中用户活跃
select distinct d.mbl_no,d.extractday
from (
select a.mbl_no, b.extractday 
from tmp_zhaolian_msd_xc a
left join warehouse_data_user_action_day b
on a.mbl_no = b.mbl_no
where b.allpv > '0') d

               
