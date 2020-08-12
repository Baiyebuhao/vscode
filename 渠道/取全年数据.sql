--取全年数据
--注册
select the_3rd_level,
       chan_no,
       child_chan,
       count(DISTINCT CASE
                          WHEN a.isp = '移动' and a.province_desc = '四川' THEN mbl_no
                      END) AS sy_regnum,
	   count(DISTINCT CASE
                          WHEN a.isp <> '移动' and a.province_desc <> '四川' THEN mbl_no
                      END) AS nsy_regnum		  
from
(               
--------新注册用户注册
select a.data_source,
       a.registe_date AS extractday,
       b.the_2nd_level,
       b.the_3rd_level,
       a.chan_no,
       a.child_chan,
       a.mbl_no,
	   a.isp,
	   a.province_desc
from warehouse_atomic_user_info a   
     left join warehouse_data_chan_info b 
         on a.data_source = b.data_source 
         and a.chan_no = b.chan_no 
         and a.child_chan = b.child_chan
where a.registe_date between '2019-01-01' and '2019-12-31'                   ---------选择注册时间维度
  and a.data_source in ('sjd','xyqb','jry')
) a
group by the_3rd_level,
       chan_no,
       child_chan


--申请授信  warehouse_data_user_review_info
SELECT a3.the_3rd_level,
       a2.chan_no,
       a2.child_chan,
       count(distinct case when a2.isp = '移动' and a2.province_desc = '四川' then a1.mbl_no end) as sy_apllynum,
       count(distinct case when a2.isp <> '移动' and a2.province_desc <> '四川' then a1.mbl_no end) as nsy_apllynum,
       count(distinct case when a2.isp = '移动' and a2.province_desc = '四川' and a1.status = '通过' then a1.mbl_no end) as sy_creditnum,
       count(distinct case when a2.isp <> '移动' and a2.province_desc <> '四川' and a1.status = '通过' then a1.mbl_no end) as nsy_creditnum,
       sum(case when a2.isp = '移动' and a2.province_desc = '四川' and a1.status = '通过' then a1.amount end) as sy_cre_amount,
       sum(case when a2.isp <> '移动' and a2.province_desc <> '四川' and a1.status = '通过' then a1.amount end) as nsy_cre_amount
from warehouse_data_user_review_info a1
LEFT JOIN warehouse_atomic_user_info a2
       on a1.mbl_no = a2.mbl_no 
      and a1.data_source = a2.data_source
      
left join warehouse_data_chan_info a3 
         on a1.data_source = a3.data_source 
        and a2.chan_no = a3.chan_no 
        and a2.child_chan = a3.child_chan
      
where a1.credit_time between '2019-01-01' and '2019-12-31'
group BY a3.the_3rd_level,
         a2.chan_no,
         a2.child_chan
		 
--提现放款  warehouse_data_user_withdrawals_info
SELECT a3.the_3rd_level,
       a2.chan_no,
       a2.child_chan,
       count(distinct case when a2.isp = '移动' and a2.province_desc = '四川' then a1.mbl_no end) as sy_cash,
       count(distinct case when a2.isp <> '移动' and a2.province_desc <> '四川' then a1.mbl_no end) as nsy_cash,
	   sum(case when a2.isp = '移动' and a2.province_desc = '四川'  then a1.cash_amount end) as sy_cash_amount,
       sum(case when a2.isp <> '移动' and a2.province_desc <> '四川'  then a1.cash_amount end) as nsy_cash_amount

from warehouse_data_user_withdrawals_info a1
LEFT JOIN warehouse_atomic_user_info a2
       on a1.mbl_no = a2.mbl_no 
      and a1.data_source = a2.data_source
      
left join warehouse_data_chan_info a3 
         on a1.data_source = a3.data_source 
        and a2.chan_no = a3.chan_no 
        and a2.child_chan = a3.child_chan
      
where a1.cash_time between '2019-01-01' and '2019-12-31'
group BY a3.the_3rd_level,
         a2.chan_no,
         a2.child_chan