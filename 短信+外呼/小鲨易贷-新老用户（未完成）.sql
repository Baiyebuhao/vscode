小鲨易贷-新老用户（未完成）
申请授信表 warehouse_atomic_xsyd_review_result_info
mbl_no	string	手机号码
resultcode	string	申请结果：返回如下值：'SUCCESS' 申请成功：'PROCESSING' 申请处理中 'FAIL'申请失败 'NOTSUBMIT' 未提交申请
limittype	string	额度类型 
fixedlimit	string	审批额度大小 2000000 单位：分
expiredate	string	额度到期日期 2019-01-12
cycleflag	string	是否可循环  循环:r一次性：O（大写字母O,不是数字0）
installtotalcnt	string	贷款期数
approvetime	string	额度申请通过时间 2018-11-08
data_source	string	数据业务系统渠道(sjd – 手机贷 xyqb-享宇钱包)

提现成功：用期数
未提现：用额度到期时间

(select a.*
       ,'N' as is_old
   from(select a.*,
			 date(if(length(a.approvetime)>0,substr(a.approvetime,1,10))) as apply_date
             from default.warehouse_atomic_xsyd_review_result_info as a) as a
where not exists 
      (select * from 
       (select mbl_no,
	           approvetime,
               date(if(length(approvetime)>0,substr(approvetime,1,10))) + interval '1' day as credit_date,
               date(if(length(approvetime)>0,substr(approvetime,1,10))) + interval '12' month as credit_end_date	
        from default.warehouse_atomic_xsyd_review_result_info) as b	
    where a.mbl_no=b.mbl_no
    and date(a.apply_date) between b.credit_date and b.credit_end_date)
union all
select a.*
       ,'Y' as is_old
	from(select a.*,
			 date(if(length(a.approvetime)>0,substr(a.approvetime,1,10))) as apply_date
             from default.warehouse_atomic_xsyd_review_result_info as a) as a
where exists 
      (select * from 
       (select mbl_no,
	           approvetime,
               date(if(length(approvetime)>0,substr(approvetime,1,10))) + interval '1' day as credit_date,
               date(if(length(approvetime)>0,substr(approvetime,1,10))) + interval '12' month as credit_end_date	
        from default.warehouse_atomic_xsyd_review_result_info) as b	
    where a.mbl_no=b.mbl_no
    and date(a.apply_date) between b.credit_date and b.credit_end_date)
	
	)

增加条件：1.授信未提现：在提现表中不存在而在申请表中授信通过的号码

select a.*
       ,'N' as is_old
   from(select a.*,
			 date(if(length(a.approvetime)>0,substr(a.approvetime,1,10))) as apply_date
             from default.warehouse_atomic_xsyd_review_result_info as a) as a
where not exists 
      (select * from 
       (select mbl_no,
	           approvetime,
               date(if(length(approvetime)>0,substr(approvetime,1,10))) + interval '1' day as credit_date,
               date(if(length(approvetime)>0,substr(approvetime,1,10))) + interval '12' month as credit_end_date	
        from default.warehouse_atomic_xsyd_review_result_info
		where mbl_no in (select mbl_no from warehouse_atomic_xsyd_withdrawals_result_info)) as b	------------提现表中存在的号码
    where a.mbl_no=b.mbl_no
    and date(a.apply_date) between b.credit_date and b.credit_end_date)
union all	
select a.*
       ,'SN' as is_old
   from(select a.*,
			 date(if(length(a.approvetime)>0,substr(a.approvetime,1,10))) as apply_date
             from default.warehouse_atomic_xsyd_review_result_info as a) as a
where not exists 
      (select * from 
       (select mbl_no,
	           approvetime,
               date(if(length(approvetime)>0,substr(approvetime,1,10))) + interval '1' day as credit_date,
               date(if(length(expiredate)>0,substr(expiredate,1,10))) as credit_end_date	
        from default.warehouse_atomic_xsyd_review_result_info
		where resultcode = 'SUCCESS'
		and mbl_no not in (select mbl_no from warehouse_atomic_xsyd_withdrawals_result_info)) as b	------------提现表中不存在且授信的号码
    where a.mbl_no=b.mbl_no
    and date(a.apply_date) between b.credit_date and b.credit_end_date)
union all
select a.*
       ,'Y' as is_old
   from(select a.*,
			 date(if(length(a.approvetime)>0,substr(a.approvetime,1,10))) as apply_date
             from default.warehouse_atomic_xsyd_review_result_info as a) as a
where exists 
      (select * from 
       (select mbl_no,
	           approvetime,
               date(if(length(approvetime)>0,substr(approvetime,1,10))) + interval '1' day as credit_date,
               date(if(length(approvetime)>0,substr(approvetime,1,10))) + interval '12' month as credit_end_date	
        from default.warehouse_atomic_xsyd_review_result_info
		where mbl_no in (select mbl_no from warehouse_atomic_xsyd_withdrawals_result_info)) as b	------------提现表中存在的号码
    where a.mbl_no=b.mbl_no
    and date(a.apply_date) between b.credit_date and b.credit_end_date)
union all
select a.*
       ,'SY' as is_old
   from(select a.*,
			 date(if(length(a.approvetime)>0,substr(a.approvetime,1,10))) as apply_date
             from default.warehouse_atomic_xsyd_review_result_info as a) as a
where exists 
      (select * from 
       (select mbl_no,
	           approvetime,
               date(if(length(approvetime)>0,substr(approvetime,1,10))) + interval '1' day as credit_date,
               date(if(length(expiredate)>0,substr(expiredate,1,10))) as credit_end_date	
        from default.warehouse_atomic_xsyd_review_result_info
		where resultcode = 'SUCCESS'
		and mbl_no not in (select mbl_no from warehouse_atomic_xsyd_withdrawals_result_info)) as b	------------提现表中不存在且授信的号码
    where a.mbl_no=b.mbl_no
    and date(a.apply_date) between b.credit_date and b.credit_end_date)
