mbl_no	string	手机号
2	appl_status	string	完成资料申请状态
3	refuse_desc	string	授信未通过原因
4	appral_res	string	授信结果
5	acc_lim	double	授信额度(分)
6	loan_term	int	授信期限
7	inst_rate	double	利率 
8	fee_amt	double	费率 
9	appl_time	string	申请时间
10	credit_time	string	授信时间
11	bind_card_time	string	成功绑卡时间
12	bind_card_res	string	绑卡结果
13	org_id	string	机构标号
14	prod_id	string	产品编号
15	msd_return_time	string	马上返回时间
16	upd_time	string	本地修改时间
17	is_flag	string	是否显示提现
18	tm_smp	string	时间戳
19	contact_no	string	合同号
20	data_source	string	数据业务系统渠道(sjd – 手机贷 xyqb-享宇钱包)
21	product_name	string	产品名称(5104,4104)
22	data_extract_time	string	数据提取日期(运行批量任务的前一天日期，格式为yyyy-MM-dd)
23	extractday	string	
24		NULL	NULL
25	# Partition Information	NULL	NULL
26	# col_name            	data_type           	comment       


马上
select a.*
       ,'N' as is_old
   from (select a.*
                ,date(if(length(a.appl_time)>0,substr(a.appl_time,1,10))) as appl_date
             from default.warehouse_atomic_msd_review_result_info as a) as a
    where not exists(select *
                      from (select contact_no
                                   ,mbl_no
                                   ,appl_time
                                   ,credit_time
                                   ,date(if(length(b.credit_time)>0,substr(b.credit_time,1,10))) + interval '1' day as credit_date
                                   ,date(if(length(b.credit_time)>0,substr(b.credit_time,1,10))) + interval '1' year as credit_end_date
                              from default.warehouse_atomic_msd_withdrawals_result_info as b) as b
                 where a.mbl_no=b.mbl_no
                   and a.appl_date between credit_date and credit_end_date)
union all
select a.*
       ,'Y' as is_old
   from (select a.*
                ,date(if(length(a.appl_time)>0,substr(a.appl_time,1,10))) as appl_date
             from default.warehouse_atomic_msd_review_result_info as a) as a
    where exists(select *
                      from (select contact_no
                                   ,mbl_no
                                   ,appl_time
                                   ,credit_time
                                   ,date(if(length(b.credit_time)>0,substr(b.credit_time,1,10))) + interval '1' day as credit_date
                                   ,date(if(length(b.credit_time)>0,substr(b.credit_time,1,10))) + interval '1' year as credit_end_date
                              from default.warehouse_atomic_msd_withdrawals_result_info as b) as b
                 where a.mbl_no=b.mbl_no
                   and a.appl_date between credit_date and credit_end_date)
				   
				   
				   
				   
马上提现
select mbl_no
       ,data_source
       ,min(register_date) as register_date
     from default.warehouse_atomic_register_process_info as a
     group by mbl_no
       ,data_source
	   
	   
