(SELECT data_source,
       count(CASE
                 WHEN substr(finish_time, 1,10) = date_sub(current_date(),1) THEN  
             END) AS credit_cus,
       count(CASE
                 WHEN substr(loan_date, 1,10) = date_sub(current_date(),1) THEN mbl_no
             END)AS withdraw,
       sum(CASE
               WHEN substr(loan_date, 1,10) = date_sub(current_date(),1) THEN loan_amt
           END) AS amount
FROM warehouse_atomic_wanda_loan_info
GROUP BY data_source )                           
							 
万达
warehouse_atomic_wanda_loan_info
mbl_no	string	用户手机号码
create_time	string	注册时间 2018-08-02 17:31:38	
apply_time	string	授信申请时间 2018-08-02 18:10:52
finish_time	string	授信通过时间 2018-08-02
loan_date	string	放款日期 2018-08-03
repay_num	string	放款期数 6 12
loan_amt	double	放款金额 6000元
							 

select a.*
       ,'N' as is_old
   from (select a.*,
			 date(if(length(a.apply_time)>0,substr(a.apply_time,1,10))) as apply_date
             from default.warehouse_atomic_wanda_loan_info as a) as a
where not exists 
      (select * from 
       (select mbl_no,
               apply_time,
               finish_time,
               date(if(length(finish_time)>0,substr(finish_time,1,10))) + interval '1' day as credit_date,
               case when repay_num='6' then date(if(length(finish_time)>0,substr(finish_time,1,10))) + interval '6' month
			   when repay_num='9' then date(if(length(finish_time)>0,substr(finish_time,1,10))) + interval '9' month
               when repay_num='12' then date(if(length(finish_time)>0,substr(finish_time,1,10))) + interval '12' month end as credit_end_date	
        from default.warehouse_atomic_wanda_loan_info) as b
where a.mbl_no=b.mbl_no
and date(a.apply_date) between b.credit_date and b.credit_end_date)
union all
select a.*
       ,'Y' as is_old
   from (select a.*,
             date(if(length(a.apply_time)>0,substr(a.apply_time,1,10))) as apply_date
             from default.warehouse_atomic_wanda_loan_info as a) as a
where exists 
      (select * from 
       (select mbl_no,
               apply_time,
               finish_time,
               date(if(length(finish_time)>0,substr(finish_time,1,10))) + interval '1' day as credit_date,
               case when repay_num='6' then date(if(length(finish_time)>0,substr(finish_time,1,10))) + interval '6' month
			   when repay_num='9' then date(if(length(finish_time)>0,substr(finish_time,1,10))) + interval '9' month
               when repay_num='12' then date(if(length(finish_time)>0,substr(finish_time,1,10))) + interval '12' month end as credit_end_date	
        from default.warehouse_atomic_wanda_loan_info) as b
where a.mbl_no=b.mbl_no
and date(a.apply_date) between b.credit_date and b.credit_end_date)