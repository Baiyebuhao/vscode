--周报脚本汇总2020.06.22

------01分平台各产品的 申请 点击数据：
SELECT 
        data_source,
	    case product_name
			when '招联好借钱' then '现金分期-招联'
			when '钱伴' then '现金分期-钱伴'
			when '中邮' then '现金分期-中邮'
			when '万达小贷' then '现金分期-万达普惠'
			else product_name
			end,
		count(DISTINCT mbl_no) as click
FROM warehouse_data_user_action_day AS a
WHERE applypv>0
AND extractday between '2020-07-13' and '2020-07-19' 
and a.product_name not like '%万达%' 
and a.product_name not like '%中邮%' 
and a.data_source in ('sjd','xyqb','jry') 
and a.product_name is not null 
and a.product_name <> 'NULL'
GROUP BY data_source,product_name
order by data_source


------02汇总各产品总 申请 点击
SELECT 	case product_name
		    when '招联好借钱' then '现金分期-招联'
		    when '钱伴' then '现金分期-钱伴'
			when '中邮' then '现金分期-中邮'
			when '万达小贷' then '现金分期-万达普惠'
			else product_name
			end,
		count(DISTINCT mbl_no) as z_click
FROM warehouse_data_user_action_day AS a
WHERE applypv>0
AND extractday between '2020-07-13' and '2020-07-19' 
and a.product_name not like '%万达%' and a.product_name not like '%中邮%' and a.product_name <> 'NULL'
and a.data_source in ('sjd','xyqb','jry')
GROUP BY product_name


-------03新用户数据--分产品>>>如果有问题，则JRY用最后的新架构数据取newdnum >>>  SJD+XYQB用最后的脚本取newdnum 
select data_source, 
	   case product_name
		    when '招联好借钱' then '现金分期-招联'
		    when '钱伴' then '现金分期-钱伴'
			when '中邮' then '现金分期-中邮'
			when '万达小贷' then '现金分期-万达普惠'
			else product_name
			end,
sum(newdnum)as newdnum, 
sum(applynum)as applynum, 
sum(creditnum)as creditnum, 
sum(cashnum)as cashnum, 
sum(cast(cash_amount as decimal(9,2))/10000) as amount
from warehouse_data_product_newuser_weekly_analysis
where extractday between '2020-07-13' and '2020-07-19' 
and product_name not like '%万达%' 
and product_name not like '%中邮%' 
and product_name not like '%助粒贷%'
and data_source in ('sjd','xyqb','jry')
group by data_source,product_name
order by data_source

--03-1
----新用户放款

SELECT a1.data_source,
       a1.product_name,
       count(DISTINCT a1.mbl_no) AS cash,
       sum(cast(a1.cash_amount AS decimal(9,2)))/10000
FROM warehouse_data_user_withdrawals_info a1
join warehouse_atomic_user_info a2
  on a1.mbl_no = a2.mbl_no
 and a1.data_source = a2.data_source
WHERE a1.cash_amount>0
  AND a1.cash_time between '2020-07-13' and '2020-07-19' 
  AND a1.product_name = '信用钱包'
  and a2.registe_date between '2020-07-13' and '2020-07-19' 
GROUP BY a1.data_source,
         a1.product_name
--3-2
--新用户申请授信

SELECT a1.data_source,
       a1.product_name,
       count(DISTINCT a1.mbl_no) AS apply_num,
       count(DISTINCT case when a1.amount>0 then a1.mbl_no end) as cre_num,
       sum(a1.amount)/10000
FROM warehouse_data_user_review_info a1
join warehouse_atomic_user_info a2
  on a1.mbl_no = a2.mbl_no
 and a1.data_source = a2.data_source
WHERE a1.apply_time between '2020-07-13' and '2020-07-19' 
  AND a1.product_name = '信用钱包'
  and a2.registe_date between '2020-07-13' and '2020-07-19' 
GROUP BY a1.data_source,
         a1.product_name

-----04三平台的 申请 点击数据 >>> JRY用最后新架构的数据
SELECT 
count( distinct mbl_no ) as `总点击量`,
count( distinct case when data_source='sjd' then mbl_no end) as `sjd点击量`,
count( distinct case when data_source='jry' then mbl_no end) as `jry点击量`,
count( distinct case when data_source='xyqb' then mbl_no end) as `xyqb点击量`
FROM warehouse_data_user_action_day AS a
WHERE applypv>0
AND extractday between '2020-07-13' and '2020-07-19' 
and product_name not like '%万达%' and product_name not like '%中邮%'



------05合计去重提现人数：
select count(distinct mbl_no)
from warehouse_data_user_withdrawals_info
where cash_time   between '2020-07-13' and '2020-07-19' 
and product_name <> '及贷'   and product_name not like '%万达%' and product_name not like '%中邮%' and product_name not like '%助粒贷%'


------06各产品申请数据：
SELECT data_source,product_name,count(distinct mbl_no) as apply
from warehouse_data_user_review_info
where apply_time  between '2020-07-13' and '2020-07-19' 
and product_name <> '及贷'   and product_name not like '%万达%' and product_name not like '%中邮%' and product_name not like '%助粒贷%'
GROUP BY data_source,product_name
order by data_source


-------07分平台申请授信数据：
select data_source,
count(distinct case when apply_time between '2020-07-13' and '2020-07-19'          then mbl_no end) as `申请`,
count(distinct case when credit_time between '2020-07-13' and '2020-07-19'         and status = '通过' then mbl_no end) as `授信`
from warehouse_data_user_review_info
where  product_name <> '及贷'   and product_name not like '%万达%' and product_name not like '%中邮%' and product_name not like '%助粒贷%'
group by data_source


------08分平台提现放款数据：
select data_source,
count(distinct case when cash_amount>0 then mbl_no end) as `提现`,
sum(cast(cash_amount as decimal(9,2)))/10000 as `金额`
from warehouse_data_user_withdrawals_info
where cash_time between '2020-07-13' and '2020-07-19' 
and product_name <> '及贷'  
and product_name not like '%万达%' 
and product_name not like '%中邮%' 
and product_name not like '%助粒贷%'
group by data_source


------09各产品授信数据：
SELECT data_source,product_name,count(distinct mbl_no) as credit
from warehouse_data_user_review_info
where credit_time  between '2020-07-13' and '2020-07-19' 
and product_name <> '及贷'   
and product_name not like '%万达%' 
and product_name not like '%中邮%' 
and product_name not like '%助粒贷%'
and status='通过'
GROUP BY data_source,product_name
order by data_source


------10各产品提现放款数据：
select data_source,product_name, count(DISTINCT mbl_no) as cash,sum(cast(cash_amount as decimal(9,2)))/10000
from warehouse_data_user_withdrawals_info
where cash_amount>0 
and cash_time between '2020-07-13' and '2020-07-19' 
and product_name <> '及贷'   and product_name not like '%万达%' and product_name not like '%中邮%' and product_name not like '%助粒贷%'
GROUP BY data_source,product_name
order by data_source


------11新用户去重总 申请 点击量：
select count(distinct mbl_no) as `新总点击`,
count( distinct case when data_source='sjd' then mbl_no end) as `sjd新点击量`,
count( distinct case when data_source='jry' then mbl_no end) as `jry新点击量`,
count( distinct case when data_source='xyqb' then mbl_no end) as `xyqb新点击量`
from warehouse_data_user_action_day
where is_new='是' and applypv>0
and extractday between '2020-07-13' and '2020-07-19' 
and product_name not like '%万达%' and product_name not like '%中邮%'



















