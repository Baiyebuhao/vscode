--抚宁申请授信明细数据提取
select b1.*,
       a1.user_name,                                          --营销客户经理
	   a2.dot_name,                                           --网点名
	   
	   a3.user_name,                                          --二维码客户经理
	   a4.user_name as use_name                               --调查客户经理

from
(SELECT a.bank_id AS bank_id,                                    --银行ID
       c.name AS bank_name,                                      --银行名称
       a.dot_id AS dot_id,                                       --网点ID
       a.user_id,                                                ----营销人员id
       b.user_id as use_id,                                      ----营销人员id(二维码）
	   if(e.data_source is not NULL,'线上','线下') as data_source,  --用户来源
       a.qrcode AS qrcode,                                       --二维码ID
       b.c_time AS c_time,                                       --二维码创建时间
       b.label AS label,                                         --二维码标签	   
	   b.name as qrcode_name,                                    --二维码名称
	   
       a.pro_id AS pro_id,                                       --申请产品id
	   f.name AS product_name,                                   --申请产品名
       a.loan_apply_id AS loan_apply_id,                         --申请ID
       a.loan_apply_time AS loan_apply_time,                     --申请时间
       a.m_state AS m_state,                                     --'开始营销-1,完成调研问卷-2,创建客户资料完成-3,开始填写贷款申请书-4,
	                                                             --营销完成-5,无申请模式营销完成-6,猪宝宝贷提交申请-7

       a.a_user_id AS a_user_id,                                 --调查客户经理ID
       a.dis_time as dis_time,                                   --调查任务分配时间
       a.research_apply_time AS research_apply_time,		     --调查开始时间
       a.research_over_time AS research_over_time,               --调查完成时间
       a.research_apply_id AS research_apply_id,                 --调查ID
       a.research_status AS research_status,                     --'未调查-1,待预约1,待调查2,调查中3,调查完成4,拒绝本次申请5'
	   a.rec_amount,                                             --建议额度
       a.refuse,                                                 --拒绝原因

       d.mobile AS mobile,                                       --建档客户号码
       d.id_card AS id_card                                      --建档客户身份证号
	   
FROM warehouse_atomic_hzx_research_task AS a 
LEFT JOIN warehouse_atomic_hzx_b_bank_qr_code AS b  ON a.qrcode=b.id 
LEFT JOIN warehouse_atomic_hzx_b_bank_base_info AS c  ON a.bank_id=c.id 
LEFT JOIN warehouse_atomic_hzx_c_customer AS d  ON a.customer_id=d.id

left join (select * from default.warehouse_atomic_time_user a
           WHERE a.data_source in ('bhh','bhd')
		   AND substr(a.registe_date,1,10) >= '2020-02-01') e
		   on d.mobile = e.mbl_no
left join warehouse_atomic_hzx_bank_product_info f 
       ON a.bank_pro_id=f.id and c.id = f.bank_id
   
WHERE substr(a.loan_apply_time,1,10) >= '2020-02-01'
  AND d.name NOT LIKE '%测试%'
  and c.name NOT LIKE '%测试%'
  and c.name NOT LIKE '%演示%'
  and c.name NOT LIKE '%废弃%') b1
left join warehouse_atomic_hzx_b_bank_user a1
       on b1.user_id = a1.id
left join warehouse_atomic_hzx_b_dot a2
       on b1.bank_id = a2.bank_id
	  and b1.dot_id = a2.id
left join warehouse_atomic_hzx_b_bank_user a3
       on b1.use_id = a3.id
	   
left join warehouse_atomic_hzx_b_bank_user a4
       on b1.a_user_id = a4.id
where b1.bank_name like '%抚宁%'





