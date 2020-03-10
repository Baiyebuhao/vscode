--执行力每月汇总
select extractmonth,
       bank_name,
	   dot_id,
	   dot_name,
	   c_user,
	   user_name,
	   data_source,
	   sum(c_mount) as c_mount,
	   sum(mbl_mount) as mbl_mount,
	   sum(app_mount) as app_mount,
	   sum(app_over_mount) as app_over_mount,
	   sum(app_over_mount2) as app_over_mount2,
	   sum(research_mount) as research_mount,
	   sum(research_over_mount) as research_over_mount,
	   sum(research_wwc_mount) as research_wwc_mount,
	   sum(research_tg_mount) as research_tg_mount,
	   sum(research_jj_mount) as research_jj_mount,
	   sum(res_amount) as res_amount
from 
(--1.注册
select substr(c_date,1,7) as extractmonth,  
       bank_name,
	   dot_id,                                       --网点ID
	   dot_name,                                     --网点名
	   c_user,                                       --建档客户经理id
	   user_name,                                    --建档客户经理
	   '线下' as data_source,                        --用户来源
	   count(distinct id) as c_mount,                --建档ID数
	   count(distinct mobile_phone) as mbl_mount,    --建档号码数
	   0 as app_mount,                                 --申请人数
	   0 as app_over_mount,                            --申请完成人数
	   0 as app_over_mount2,                           --无申请模式营销完成人数
	   0 as research_mount,              --调查人数
	   0 as research_over_mount,  --调查完成人数
	   0 as research_wwc_mount,    --调查未完成人数
	   0 as research_tg_mount,  --调查通过人数
	   0 as research_jj_mount,    --调查拒绝人数
	   0 as res_amount   --调查通过金额
from
(
SELECT a1.c_date as c_date,
       a2.name as bank_name,
	   a1.dot_id,
	   a4.dot_name,
	   a1.c_user as c_user,  --客户经理
	   a3.user_name as user_name,
	   a1.customer_owner_id as customer_owner_id,  --客户归属ID
       a1.id as id,   --客户建档ID 
       if(a1.extentive52 is not null,a1.extentive52,a1.mobile_phone) as mobile_phone, --客户建档号码
	   a1.id_card as id_card
FROM warehouse_atomic_hzx_custmanage_c_customer AS a1
left join warehouse_atomic_hzx_b_bank_base_info a2  
       on a1.bank_id = a2.id
left join warehouse_atomic_hzx_b_bank_user a3
       on a1.c_user = a3.id
	  and a2.id = a3.bank_id
	  
left join warehouse_atomic_hzx_b_dot a4
       on a1.bank_id = a4.bank_id
	  and a1.dot_id = a4.id
	  
where a1.data_source='0'
  and a1.id is not null
  and a1.mobile_phone is not null) a
group by substr(c_date,1,7),
         bank_name,
		 dot_id,
		 dot_name,
		 c_user,
		 user_name
union all

--2.申请
select substr(a.loan_apply_time,1,7) as extractmonth,
       a.bank_name,
	   a.dot_id,                                                --网点ID
	   a.dot_name,
	   a.user_id as c_user,                                     --营销客户经理id
	   a1.user_name as user_name,                               --营销客户经理
	   a.data_source as data_source,                            --用户来源
	   0 as c_mount,                        --建档ID数
	   0 as mbl_mount,                      --建档号码数
	   count(distinct a.mobile) as app_mount,                   --申请人数
	   count(distinct case when a.m_state = '5' then a.mobile end) as app_over_mount,  --申请完成人数
	   count(distinct case when a.m_state = '6' then a.mobile end) as app_over_mount2,  --无申请模式营销完成
	   0 as research_mount,              --调查人数
	   0 as research_over_mount,  --调查完成人数
	   0 as research_wwc_mount,    --调查未完成人数
	   0 as research_tg_mount,  --调查通过人数
	   0 as research_jj_mount,    --调查拒绝人数
	   0 as res_amount   --调查通过金额
from (SELECT a.bank_id AS bank_id,                               --银行ID
       c.name AS bank_name,                                      --银行名称
       a.dot_id AS dot_id,                                       --网点ID
	   f.dot_name,
       if(a.qrcode IS NOT NULL,b.user_id,a.user_id) AS user_id,  --营销人员id 
	   if(e.data_source is not NULL,'代运营','线下') as data_source,  --用户来源
       a.qrcode AS qrcode,                                       --二维码ID
       b.c_time AS c_time,                                       --二维码创建时间
       b.label AS label,                                         --二维码标签	
	   
       a.pro_id AS pro_id,                                       --申请产品id
       a.loan_apply_id AS loan_apply_id,                         --申请ID
       a.loan_apply_time AS loan_apply_time,                     --申请时间
       a.m_state AS m_state,                                     --'开始营销-1,完成调研问卷-2,创建客户资料完成-3,开始填写贷款申请书-4,
	                                                             --营销完成-5,无申请模式营销完成-6,猪宝宝贷提交申请-7
       d.mobile AS mobile,                                       --建档客户号码
       d.id_card AS id_card                                      --建档客户身份证号
	   
FROM warehouse_atomic_hzx_research_task AS a 
LEFT JOIN warehouse_atomic_hzx_b_bank_qr_code AS b  ON a.qrcode=b.id 
LEFT JOIN warehouse_atomic_hzx_b_bank_base_info AS c  ON a.bank_id=c.id 
LEFT JOIN warehouse_atomic_hzx_c_customer AS d  ON a.customer_id=d.id 
left join (select * from default.warehouse_atomic_time_user a
           WHERE a.data_source in ('bhh','bhd')
		   AND substr(a.registe_date,1,10) >= '2019-09-27') e
		   on d.mobile = e.mbl_no
left join warehouse_atomic_hzx_b_dot f
       on a.bank_id = f.bank_id
	  and a.dot_id = f.id

WHERE substr(a.loan_apply_time,1,10) >= '2019-09-01'
  AND c.name LIKE '%村镇银行%'
  AND d.name NOT LIKE '%测试%') a
left join warehouse_atomic_hzx_b_bank_user a1
       on a.user_id = a1.id
	  and a.bank_id = a1.bank_id
group by substr(a.loan_apply_time,1,7),
         a.bank_name,
		 a.dot_id,
		 a.dot_name,
		 a.user_id,
		 a1.user_name,
		 a.data_source
union all

--调查
select substr(a.research_apply_time,1,7) as extractmonth,
       a.bank_name,
	   a.dot_id,                                                --网点ID
	   a.dot_name,
	   a.a_user_id as c_user,                                     --调查客户经理id
	   a1.user_name,
	   a.data_source,                                           --用户来源
	   0 as c_mount,                        --建档ID数
	   0 as mbl_mount,                      --建档号码数
	   0 as app_mount,                                          --申请人数
	   0 as app_over_mount,                                     --申请完成人数
	   0 as app_over_mount2,                                    --无申请模式营销完成
	   count(distinct a.mobile) as research_mount,              --调查人数
	   count(distinct case when a.research_status = '4' then a.mobile end) as research_over_mount,  --调查完成人数
	   count(distinct case when a.research_status in ('-1','1','2','3') then a.mobile end) as research_wwc_mount,    --调查未完成人数
	   count(distinct case when a.research_status = '4' and rec_amount > '0' then a.mobile end) as research_tg_mount,  --调查通过人数
	   count(distinct case when a.research_status = '5' then a.mobile end) as research_jj_mount,    --调查拒绝人数
	   sum(case when a.research_status = '4' and rec_amount > '0' and rec_amount is not NULL then rec_amount end) as res_amount   --调查通过金额
from
(SELECT a.bank_id AS bank_id,                                     --银行ID
       c.name AS bank_name,                                      --银行名称
       a.dot_id AS dot_id,                                       --网点ID
	   f.dot_name,
       if(a.qrcode IS NOT NULL,b.user_id,a.user_id) AS user_id,  --营销人员id 
	   if(e.data_source is not NULL,'代运营','线下') as data_source,  --用户来源
       a.qrcode AS qrcode,                                       --二维码ID
       b.c_time AS c_time,                                       --二维码创建时间
       b.label AS label,                                         --二维码标签	
       a.a_user_id AS a_user_id,                                 --调查客户经理ID
       a.research_apply_time AS research_apply_time,		     --调查开始时间
       a.research_over_time AS research_over_time,               --调查完成时间
       a.research_apply_id AS research_apply_id,                 --调查ID
       a.research_status AS research_status,                     --'未调查-1,待预约1,待调查2,调查中3,调查完成4,拒绝本次申请5'
	   a.rec_amount,                                             --调查额度
       d.mobile AS mobile,                                       --建档客户号码
       d.id_card AS id_card                                      --建档客户身份证号
	   
FROM warehouse_atomic_hzx_research_task AS a 
LEFT JOIN warehouse_atomic_hzx_b_bank_qr_code AS b  ON a.qrcode=b.id 
LEFT JOIN warehouse_atomic_hzx_b_bank_base_info AS c  ON a.bank_id=c.id 
LEFT JOIN warehouse_atomic_hzx_c_customer AS d  ON a.customer_id=d.id

left join (select * from default.warehouse_atomic_time_user a
           WHERE a.data_source in ('bhh','bhd')
		   AND substr(a.registe_date,1,10) >= '2019-09-27') e
		   on d.mobile = e.mbl_no
left join warehouse_atomic_hzx_b_dot f
       on a.bank_id = f.bank_id
	  and a.dot_id = f.id

WHERE substr(a.loan_apply_time,1,10) >= '2019-09-01'
  and substr(a.research_apply_time,1,10) >= '2019-09-01'
  AND c.name LIKE '%村镇银行%'
  AND d.name NOT LIKE '%测试%') a
left join warehouse_atomic_hzx_b_bank_user a1
       on a.user_id = a1.id
	  and a.bank_id = a1.bank_id
group by substr(a.research_apply_time,1,7),
         a.bank_name,
	     a.dot_id,                                                --网点ID
		 a.dot_name,
	     a.a_user_id,                                     --调查客户经理
		 a1.user_name,
	     a.data_source) a
where a.bank_name NOT LIKE '%测试%'
  and a.bank_name NOT LIKE '%演示%'
  and a.bank_name NOT LIKE '%废弃%'
group by extractmonth,
         bank_name,
	     dot_id,
		 dot_name,
	     c_user,
	     user_name,
	     data_source