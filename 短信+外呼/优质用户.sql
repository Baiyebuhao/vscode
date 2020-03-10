取三万个优质用户，规则：放款时间在2019年1月-6月，还款最后一个月在2019年10月-12月，且无逾期，年龄22~50岁@徐超

--3万优质用户
create table tmp_20191218_yz_xc
as
select distinct a1.mbl_no,
       a2.card_no
from (select distinct mbl_no,data_source
      from warehouse_data_user_withdrawals_info a
      where cash_time between '2017-10-01' and '2019-10-31'
        and product_name in('优智借','随借随还-钱包易贷','随借随还-马上')) a1
join warehouse_atomic_user_info a2
	  on a1.mbl_no = a2.mbl_no
	 and a1.data_source = a2.data_source

join (--优智借还款时间 
      select distinct mbl_no
      from warehouse_atomic_yzj_repay_result_info a
	  where substr(repay_time,1,10) between '2019-10-01' and '2019-12-31'
	  union
	  --钱包还款时间 
	  select distinct mbl_no
      from warehouse_atomic_qianbao_repayment_info a
	  where substr(repay_time,1,10) between '2019-10-01' and '2019-12-31'
	  union
	  --马上取还款+非逾期
	  select distinct b1.mbl_no 
      from warehouse_atomic_msd_withdrawals_result_info b1
      
      left outer join (select distinct mbl_no
                       from warehouse_atomic_msd_withdrawals_result_info a
      				 where is_overdue = 'Y') b2
      				 on b1.mbl_no = b2.mbl_no
      left outer join (select distinct mbl_no
                       from warehouse_atomic_msd_withdrawals_result_info a
      				 where is_settle = 'Y') b3
      				 on b1.mbl_no = b3.mbl_no
      where b2.mbl_no is null
        and b3.mbl_no is null
        and b1.is_overdue = 'N'
        and b1.is_settle = 'N') a3
	  on a1.mbl_no = a3.mbl_no
---8000个逾期
left outer join (select distinct mbl_no
                 from warehouse_atomic_qianbao_withdrawals_result_info a
				 where is_overdue = '1'
                 ) a6
				 on a1.mbl_no = a6.mbl_no
where a2.age between '22' and '50'
  and a6.mbl_no is null


--放款表整理
1   优智借                 --warehouse_atomic_yzj_withdrawals_result_info        （warehouse_atomic_yzj_review_result_info）
2	信用钱包               --warehouse_atomic_lhp_withdrawals_result_info        （warehouse_atomic_lhp_review_result_info）
3	好期贷-招联            --warehouse_atomic_zhaolian_withdrawals_result_info   （warehouse_atomic_zhaolian_review_result_info）
4	现金分期-万达普惠      --warehouse_atomic_wanda_loan_info
5	现金分期-兴业消费      --warehouse_atomic_xsyd_withdrawals_result_info       （warehouse_atomic_xsyd_review_result_info）
6	现金分期-招联          --warehouse_atomic_zhaolian_withdrawals_result_info   （warehouse_atomic_zhaolian_review_result_info）
7	现金分期-点点          --warehouse_atomic_diandian_withdrawals_result_info   （warehouse_atomic_diandian_review_result_info）（描述错误）
8	现金分期-钱伴          --warehouse_atomic_wacai_loan_info
9	现金分期-马上          --warehouse_atomic_msd_cashord_result_info （权限）
10	白领贷-招联            --
11	随借随还-钱包易贷      --warehouse_atomic_qianbao_withdrawals_result_info    （warehouse_atomic_qianbao_review_result_info）
12	随借随还-马上          --warehouse_atomic_msd_withdrawals_result_info        （warehouse_atomic_msd_review_result_info）


--还款表整理
1   优智借                 --warehouse_atomic_yzj_repay_result_info      repay_time  还款时间；时间戳   repay_status = '2'  (逾期）
0	信用钱包               --
2	好期贷-招联            --
0	现金分期-万达普惠      --
2	现金分期-兴业消费      --warehouse_atomic_xsyd_repayment_info              repaymenttype = 'PRE'  ??
0	现金分期-招联          --
0	现金分期-点点          --
0	现金分期-钱伴          --
0	现金分期-马上          --
0	白领贷-招联            --
1	随借随还-钱包易贷      --warehouse_atomic_qianbao_repayment_info           repay_time  还款时间 a.status 还款明细 pay_penalty  应还违约金   pay_late_fee 应还滞纳金     warehouse_atomic_qianbao_withdrawals_result_info  is_overdue 是否逾期
1	随借随还-马上          --warehouse_atomic_msd_withdrawals_result_info      is_overdue  是否逾期


select * 
from warehouse_atomic_msd_withdrawals_result_info a1
where 

1.优智借 warehouse_atomic_yzj_repay_result_info   	repay_status状态是上次的状态还是本次还款后更新的状态
2.信用钱包，招联，万达普惠，点点，钱伴等产品是否有还款数据
3.随借随还-马上 warehouse_atomic_msd_withdrawals_result_info 如何找到还款时间

select distinct b1.mbl_no 
      from warehouse_atomic_msd_withdrawals_result_info b1
      
      left outer join (select distinct mbl_no
                       from warehouse_atomic_msd_withdrawals_result_info a
      				 where is_overdue = 'Y') b2
      				 on b1.mbl_no = b2.mbl_no
      left outer join (select distinct mbl_no
                       from warehouse_atomic_msd_withdrawals_result_info a
      				 where is_settle = 'Y') b3
      				 on b1.mbl_no = b3.mbl_no
      where b2.mbl_no is null
        and b3.mbl_no is null
        and b1.is_overdue = 'N'
        and b1.is_settle = 'N'
		
		
		
		
(
select * from tmp_20191218_yz_xc

---取优质随机20000
create table tmp_20191218_yz1_xc
as
select * from tmp_20191218_yz_xc
distribute by rand()
sort by rand()
limit 20000;
---取优质随机10000
create table tmp_20191218_yz2_xc
as
select * from tmp_20191218_yz_xc
distribute by rand()
sort by rand()
limit 10000;
----取非优质10000人
create table tmp_20191218_fyz2_xc
as
select b1.mbl_no,b1.card_no
from warehouse_atomic_user_info b1
left outer join tmp_20191218_yz_xc b2
  on b1.mbl_no = b2.mbl_no
where b2.mbl_no is null
  and b1.card_no is not null
distribute by rand()
sort by rand()
limit 10100;

---取20000人+10000人
select a1.mbl_no,a1.card_no
from tmp_20191218_yz1_xc a1
union all
select a.mbl_no,a.card_no
from tmp_20191218_fyz3_xc a

---取30000人
create table tmp_20191218_jg_xc
as
select distinct b.mbl_no,b.card_no
from 
(select a.mbl_no,a.card_no
from tmp_20191218_yz1_xc a
union all
select a.mbl_no,a.card_no
from tmp_20191218_fyz3_xc a) b

where b.mbl_no is not null
  and b.card_no is not null
limit 30000
)		
		