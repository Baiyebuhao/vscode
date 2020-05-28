台账验证问题： 2020.05.13
40000044


一、申请表  warehouse_ledger_l_application_inf
（1）5.10-5.12期间，jry无数据，xyqb每天都少一人
(
SELECT count(distinct mbl_no) as apply_nums,      --申请人数
       substr(applytime,1,10) AS applytime,      --数据更新时间
	   data_source,           				      --数据平台
	   '信用钱包' AS product_name                --产品名称
FROM warehouse_atomic_lhp_review_result_info
where substr(applytime,1,10) between '2020-05-10' and '2020-05-12'
group by data_source,
         substr(applytime,1,10)

union all

select count(distinct a.mbl_no) as apply_nums,
       substr(a.apply_time,1,10) as apply_time,
       data_source,
       '40000044' AS product_name 
from warehouse_ledger_l_application_inf as a 
where substr(a.apply_time,1,10) between '2020-05-10' and '2020-05-12'
      and a.product_no = '40000044'
group by a.data_source,
         substr(a.apply_time,1,10)
         
--查明细
SELECT mbl_no,      --申请人数
       substr(applytime,1,10) AS applytime,      --数据更新时间
	   data_source,           				      --数据平台
	   '信用钱包' AS product_name                --产品名称
FROM warehouse_atomic_lhp_review_result_info
where substr(applytime,1,10) between '2020-05-10' and '2020-05-12'
      and data_source = 'xyqb'

union all

select mbl_no,
       substr(a.apply_time,1,10) as apply_time,
       data_source,
       '40000044' AS product_name 
from warehouse_ledger_l_application_inf as a 
where substr(a.apply_time,1,10) between '2020-05-10' and '2020-05-12'
      and a.product_no = '40000044'
      and data_source = 'xyqb'
)


二、授信表  warehouse_ledger_l_application_inf
（1）授信status的几个状态分别表示什么？为什么还有NULL和空值
(
select distinct status
from warehouse_ledger_l_application_inf
)

（2）5.11 xyqb的放款额统计到了jry，同时xyqb少统计一个放款人数
(
select count(distinct mbl_no),
       substr(creattime,1,10) as credit_time,       --授信时间
	   sum(approvalamount) as credit_amount,  --审批金额
	   data_source,     --数据平台
	   '信用钱包' AS product_name
	   --loanstatus as status      --订单状态
from  warehouse_atomic_lhp_review_result_info
where substr(creattime,1,10) BETWEEN '2020-05-10' and '2020-05-13'
      and approvalamount > 0
group by substr(creattime,1,10),data_source

union all

select count(distinct mbl_no),
       substr(credit_time,1,10) as credit_time,       --授信时间
	   sum(credit_amount),  --审批金额
	   data_source,     --数据平台
	   '40000044' AS product_name
	   --status       --订单状态
from warehouse_ledger_l_application_inf
where substr(credit_time,1,10) BETWEEN '2020-05-10' and '2020-05-13'
      and credit_amount > 0 
      and product_no = '40000044'
group by substr(credit_time,1,10),data_source

--查明细
select mbl_no,
       substr(creattime,1,10) as credit_time,       --授信时间
	   approvalamount as credit_amount,  --审批金额
	   data_source,     --数据平台
	   '信用钱包' AS product_name

from  warehouse_atomic_lhp_review_result_info
where substr(creattime,1,10) = '2020-05-11'
      and approvalamount > 0
      and data_source in ('jry','xyqb')


union all

select mbl_no,
       substr(credit_time,1,10) as credit_time,       --授信时间
	   credit_amount,  --审批金额
	   data_source,     --数据平台
	   '40000044' AS product_name

from warehouse_ledger_l_application_inf
where substr(credit_time,1,10) = '2020-05-11' 
      and credit_amount > 0 
      and product_no = '40000044'
      and data_source in ('jry','xyqb')
)


三、放款表  warehouse_ledger_l_payment_inf
（1）5.11-5.12期间，存在放款人数 平台、日期错位情况(xyqb-jry,11号放款人数据跑到12号)。初步核查是mbl_no和loan_amount 存在空的情况
(
--数据汇总
SELECT count(mbl_no)as renshu,
       sum(loanamount)as jine,
       loanstatustime as loan_time ,
       data_source,
       '信用钱包' as prodouct_name
FROM warehouse_atomic_lhp_withdrawals_result_info 

WHERE substr(loanstatustime,1,10) BETWEEN '2020-05-10' and '2020-05-12'
  AND loanamount > 0
group by loanstatustime,data_source

union all

select count(distinct mbl_no) as renshu ,
       sum(loan_amount) as jine ,
       substr(loan_time,1,10)as loan_time,
       data_source,
       product_no as prodouct_name
from warehouse_ledger_l_payment_inf
where substr(loan_time,1,10) BETWEEN '2020-05-10' and '2020-05-12'
and data_source <> 'unknow'
group by substr(loan_time,1,10),
         data_source,
         product_no


--查明细
select mbl_no ,
       loan_amount as jine ,
       substr(loan_time,1,10)as loan_time,
       data_source,
       product_no as prodouct_name
from warehouse_ledger_l_payment_inf
where substr(loan_time,1,10) BETWEEN '2020-05-11' and '2020-05-12'
and data_source <> 'unknow'
)

（2）4.28，助立贷bhd平台数据同样错位，初步核查是mbl_no和loan_amount 存在空的情况
           同时，data_source中，存在xyqb_jry这个名称，实际上是不存在的，从放款数据看，应该是助立贷（bhd）平台，关注下其他节点数据是否也存在这个情况
(
select substr(loan_time,1,10),
       data_source,
       product_no, 
       count(distinct mbl_no),
       sum(loan_amount) 
from warehouse_ledger_l_payment_inf
where substr(loan_time,1,10) = '2020-04-28'
and data_source <> 'unknow'
group by substr(loan_time,1,10),
         data_source,
         product_no
--查明细
select substr(loan_time,1,10),
       data_source,
       product_no, 
       mbl_no,
       loan_amount
from warehouse_ledger_l_payment_inf
where substr(loan_time,1,10) = '2020-04-28'
and data_source <> 'unknow'
)






























