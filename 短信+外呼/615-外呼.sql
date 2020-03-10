615 外呼需求  徐超     1、紧急且重要 何渝宏 客服部 2019.9.27 2019.9.27 
一次性需求 优卡贷、万达普惠 移动手机贷 移动手机贷 外呼营销 取1700名用户 
移动手机贷平台，在9月1日-9月27日有过登录行为，且马上随借随还授信额度在5000-10000，但可用额度小于1000的用户

（保留用户姓名、申请号码、最近一次提现时间、剩余额度）
(
(--登录时间为9月1日-9月27日
select distinct mbl_no
from warehouse_data_user_action_day a
where allpv > '0'
  and extractday between '2019-09-01' and '2019-09-27'
  and data_source = 'sjd')


(--授信额度为5000-10000
select mbl_no,num1
from(select distinct mbl_no,
            acc_lim/100 as num1,
            Row_Number() OVER (partition by mbl_no ORDER BY credit_time desc) rank
     from warehouse_atomic_msd_review_result_info a
     where appral_res = '通过'
     and mbl_no is not null
     and data_source = 'sjd') b
     where b.rank = '1'
	   and b.num1 between '5000' and '10000'
)
(--可用额度小于1000
     select distinct a3.mbl_no,
            a3.num1-a4.num2 as mum3
     from
          (select mbl_no,num1
          from
              (select distinct mbl_no,
                     acc_lim/100 as num1,
              	   Row_Number() OVER (partition by mbl_no ORDER BY credit_time desc) rank
              from warehouse_atomic_msd_review_result_info a
              where appral_res = '通过'
              and mbl_no is not null
              and data_source = 'sjd') b
              where b.rank = '1'
			    and b.num1 between '5000' and '10000') a3
          ----授信用户+授信额
          left join 
          (select mbl_no,num2
          from 
              (select distinct mbl_no,
                     prin_bal/100 as num2,
              	   Row_Number() OVER (partition by mbl_no ORDER BY msd_return_time desc) rank     
              from warehouse_atomic_msd_withdrawals_result_info a
              where mbl_no is not null
              and data_source = 'sjd'
			  and paid_out_time > '2019-09-12') b
          where b.rank = '1') a4
          on a3.mbl_no = a4.mbl_no
          ----提现用户+用信额

)
)
--在9月1日-9月27日有过登录行为，且马上随借随还授信额度在5000-10000，但可用额度小于1000的用户
create table tmp_20190927_xc
as 
select a1.mbl_no,
       a1.data_source,
	   a7.name,
	   a5.mum3,
	   a6.extractday,
	   max(a1.cash_time)
from warehouse_data_user_withdrawals_info a1
join warehouse_atomic_user_info a7
       on a1.mbl_no = a7.mbl_no
join
    (select distinct a3.mbl_no,
            a3.num1-a4.num2 as mum3
     from
          (select mbl_no,num1
          from
              (select distinct mbl_no,
                     acc_lim/100 as num1,
              	   Row_Number() OVER (partition by mbl_no ORDER BY credit_time desc) rank
              from warehouse_atomic_msd_review_result_info a
              where appral_res = '通过'
              and mbl_no is not null
              and data_source = 'sjd') b
              where b.rank = '1'
			    and b.num1 between '5000' and '10000') a3
          ----授信用户+授信额
          left join 
          (select mbl_no,num2
          from 
              (select distinct mbl_no,
                     prin_bal/100 as num2,
              	   Row_Number() OVER (partition by mbl_no ORDER BY msd_return_time desc) rank     
              from warehouse_atomic_msd_withdrawals_result_info a
              where mbl_no is not null
              and data_source = 'sjd'
			  and paid_out_time > '2019-09-12') b
          where b.rank = '1') a4
          on a3.mbl_no = a4.mbl_no
          ----提现用户+用信额
    ) a5
    on a1.mbl_no = a5.mbl_no

join (select mbl_no,
             max(extractday) as extractday
      from warehouse_data_user_action_day a
      where allpv > '0'
        and extractday between '2019-09-01' and '2019-09-27'
        and data_source = 'sjd'
	  group by mbl_no
	  ) a6
      on a1.mbl_no = a6.mbl_no

where a1.data_source = 'sjd'
  and a1.product_name = '随借随还-马上'
  and a1.cash_amount > 0
  and a5.mum3 < '1000'
  and a1.mbl_no NOT IN (SELECT mbl_no FROM warehouse_atomic_smstunsubscribe WHERE eff_flg = '1')
group by a1.mbl_no,
         a1.data_source,
	     a7.name,
	     a5.mum3,
	     a6.extractday
		 
		 
(
--取1700名用户
create table tmp_20190929_xc
as 
select * from tmp_20190927_xc a
where a.mum3 >= '0'
order by a.extractday desc
limit 1700
---取随机1
create table tmp_20190929_1_xc
as 
select * from tmp_20190929_xc
distribute by rand()
sort by rand()
limit 200;

select * from tmp_20190929_1_xc a;

--取随机2
create table tmp_20190929_2_xc
as 
select a1.* from tmp_20190929_xc a1
left outer join (select mbl_no from tmp_20190929_1_xc) a2
on a1.mbl_no = a2.mbl_no
where a2.mbl_no is null
distribute by rand()
sort by rand()
limit 750;

select * from tmp_20190929_2_xc a;

--取随机3
select a1.* from tmp_20190929_xc a1
left outer join (select mbl_no from tmp_20190929_1_xc) a2
on a1.mbl_no = a2.mbl_no
left outer join (select mbl_no from tmp_20190929_2_xc) a3
on a1.mbl_no = a3.mbl_no
where a2.mbl_no is null
  and a3.mbl_no is null
distribute by rand()
sort by rand()
limit 750;
)