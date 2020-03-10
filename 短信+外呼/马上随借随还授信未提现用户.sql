目标产品——马上随借随还
      1、提数平台：双平台（分开）
      2、分包规则：区分双平台，申请日期由近往后各取300名用户
      3、数据时间段：2018年1月1日至2018年6月30日
      4、提数规则：双平台马上随借随还授信未提现且后期无任何申请行为用户，保留客户姓名、申请日期、审批额度

##SJD平台
select distinct
       a.data_source
       ,a.mbl_no
       ,b.name
       ,a.appl_time
       ,a.acc_lim/100 as acc_lim
  from default.warehouse_atomic_msd_review_result_info as a
  join default.warehouse_atomic_user_info as b
  on a.mbl_no=b.mbl_no and a.data_source=b.data_source
  left join default.warehouse_atomic_msd_withdrawals_result_info as d
  on a.mbl_no=d.mbl_no and a.data_source=d.data_source and a.contact_no=d.contact_no and d.ltd_lend_amt>0
  left join(select mbl_no
       ,data_source
       ,substr(appl_time,1,10) as apply_time
       ,'钱包易贷' product_name
       ,case when status in('apply_success','block_up') then cast(acc_lim as double) end cash
  from default.warehouse_atomic_qianbao_review_result_info
  union all
  select mbl_no
         ,data_source
         ,apply_time
         ,'中邮现金分期' product_name
         ,case when approve_status='审批通过' then approve_amount*100 end cash
    from default.warehouse_atomic_zhongyou_review_result_info
  union all 
  select mbl_no
         ,data_source
         ,lending_time
         ,'小雨点' product_name
         ,case when status='success' then applyamount*100 end applyamount
    from default.warehouse_atomic_xiaoyudian_withdrawals_result_info
  union all
  select mbl_no
         ,data_source
         ,substr(apply_time,1,10) as apply_time
         ,'拉卡拉' product_name
         ,case when contract_status='申请成功' then cast(loan_amount as double) *100 end cash
    from default.warehouse_atomic_lkl_withdrawals_result_info
  union all
  select mbl_no
         ,data_source
         ,substr(appl_time,1,10) as apply_time
         ,'马上随借随还' product_name
         ,case when appral_res='通过' then acc_lim end acc_lim
    from default.warehouse_atomic_msd_review_result_info
  union all
  select mbl_no
         ,data_source
         ,apply_time
         ,'马上现金分期' product_name
         ,case when approval_status in('A','N') then approval_amount end cash
    from default.warehouse_atomic_msd_cashord_result_info
  union all
  select mbl_no
         ,data_source
         ,apply_time
         ,'点点现金分期' product_name
         ,case when status_code='0' then total_limit end total_limit
    from default.warehouse_atomic_diandian_review_result_info
  union all
  select mbl_no
         ,data_source
         ,concat(substr(apply_time,1,4),'-',substr(apply_time,5,2),'-',substr(apply_time,7,2)) as apply_time
         ,case when product_code='XJXE001' then '招联好期贷'
         when product_code='XJBL001' then '招联白领贷'
         when product_code='XJDQ001' then '招联大期贷'
         when product_code='XJYZ001' then '招联业主贷'
         when product_code='XJGJJ001' then '招联公积金社保贷' end product_name
         ,case when result_desc='申请成功' then credit_limit end cash
    from default.warehouse_atomic_zhaolian_review_result_info
  union all
  select apply_mobile
         ,data_source
         ,substr(limit_apply_time,1,10) as apply_time
         ,'众安花豹' product_name
         ,cast(credit_amount as double) as credit_amount
    from default.warehouse_atomic_zhongan_review_result_info) as c
  on a.mbl_no=c.mbl_no and a.data_source=c.data_source and substr(a.credit_time,1,10)<c.apply_time
  where substr(a.appl_time,1,10) between '2018-01-01' and '2018-06-30'
    and a.appral_res='通过' 
    and a.appl_status='签署'
    and a.data_source='sjd'
    and c.mbl_no is null
    and d.mbl_no is null
   order by a.appl_time desc limit 300

##XYQB平台
select distinct
       a.data_source
       ,a.mbl_no
       ,b.name
       ,a.appl_time
       ,a.acc_lim/100 as acc_lim
  from default.warehouse_atomic_msd_review_result_info as a
  join default.warehouse_atomic_user_info as b
  on a.mbl_no=b.mbl_no and a.data_source=b.data_source
  left join default.warehouse_atomic_msd_withdrawals_result_info as d
  on a.mbl_no=d.mbl_no and a.data_source=d.data_source and a.contact_no=d.contact_no and d.ltd_lend_amt>0
  left join(select mbl_no
       ,data_source
       ,substr(appl_time,1,10) as apply_time
       ,'钱包易贷' product_name
       ,case when status in('apply_success','block_up') then cast(acc_lim as double) end cash
  from default.warehouse_atomic_qianbao_review_result_info
  union all
  select mbl_no
         ,data_source
         ,apply_time
         ,'中邮现金分期' product_name
         ,case when approve_status='审批通过' then approve_amount*100 end cash
    from default.warehouse_atomic_zhongyou_review_result_info
  union all 
  select mbl_no
         ,data_source
         ,lending_time
         ,'小雨点' product_name
         ,case when status='success' then applyamount*100 end applyamount
    from default.warehouse_atomic_xiaoyudian_withdrawals_result_info
  union all
  select mbl_no
         ,data_source
         ,substr(apply_time,1,10) as apply_time
         ,'拉卡拉' product_name
         ,case when contract_status='申请成功' then cast(loan_amount as double) *100 end cash
    from default.warehouse_atomic_lkl_withdrawals_result_info
  union all
  select mbl_no
         ,data_source
         ,substr(appl_time,1,10) as apply_time
         ,'马上随借随还' product_name
         ,case when appral_res='通过' then acc_lim end acc_lim
    from default.warehouse_atomic_msd_review_result_info
  union all
  select mbl_no
         ,data_source
         ,apply_time
         ,'马上现金分期' product_name
         ,case when approval_status in('A','N') then approval_amount end cash
    from default.warehouse_atomic_msd_cashord_result_info
  union all
  select mbl_no
         ,data_source
         ,apply_time
         ,'点点现金分期' product_name
         ,case when status_code='0' then total_limit end total_limit
    from default.warehouse_atomic_diandian_review_result_info
  union all
  select mbl_no
         ,data_source
         ,concat(substr(apply_time,1,4),'-',substr(apply_time,5,2),'-',substr(apply_time,7,2)) as apply_time
         ,case when product_code='XJXE001' then '招联好期贷'
         when product_code='XJBL001' then '招联白领贷'
         when product_code='XJDQ001' then '招联大期贷'
         when product_code='XJYZ001' then '招联业主贷'
         when product_code='XJGJJ001' then '招联公积金社保贷' end product_name
         ,case when result_desc='申请成功' then credit_limit end cash
    from default.warehouse_atomic_zhaolian_review_result_info
  union all
  select apply_mobile
         ,data_source
         ,substr(limit_apply_time,1,10) as apply_time
         ,'众安花豹' product_name
         ,cast(credit_amount as double) as credit_amount
    from default.warehouse_atomic_zhongan_review_result_info) as c
  on a.mbl_no=c.mbl_no and a.data_source=c.data_source and substr(a.credit_time,1,10)<c.apply_time
  where substr(a.appl_time,1,10) between '2018-01-01' and '2018-06-30'
    and a.appral_res='通过' 
    and a.appl_status='签署'
    and a.data_source='xyqb'
    and c.mbl_no is null
    and d.mbl_no is null
   order by a.appl_time desc limit 300
