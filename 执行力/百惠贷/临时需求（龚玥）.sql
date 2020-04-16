线上运营
1.3月抚宁注册用户，当天注册当天申请占比  %，当天注册当天未申请占比  %；
2.3月各产品申请次数
3.3月 注册用户数、点击申请用户数（新架构的）、填写资料申请数（4.5）、完成申请用户数（5）、完成调查用户数（4.5）、调查成功用户数（出额）

--1.1 注册 270人
select substr(a.registe_date,1,7) as registe_date,
	   ---authentication_date,
	   data_source,
	   count(distinct mbl_no) as num1
from default.warehouse_atomic_time_user a
WHERE a.data_source in ('bhh','bhd')
  AND substr(a.registe_date,1,10) between '2020-03-01' and '2020-03-31'
group by substr(a.registe_date,1,7),
	     ---authentication_date,
	     data_source

--1.2 注册当天申请  117人
select bank_name,
       count(distinct mobile) as num
from 
(select c.name AS bank_name,                                      --银行名称
       a.loan_apply_id AS loan_apply_id,                         --申请ID
       substr(a.loan_apply_time,1,10) AS loan_apply_time,        --申请时间
       a.m_state AS m_state,                                     --申请状态
	   d.mobile AS mobile,                                       --建档客户号码
       d.id_card AS id_card                                      --建档客户身份证号
	   
FROM warehouse_atomic_hzx_research_task AS a 
LEFT JOIN warehouse_atomic_hzx_b_bank_qr_code AS b  ON a.qrcode=b.id 
LEFT JOIN warehouse_atomic_hzx_b_bank_base_info AS c  ON a.bank_id=c.id 
LEFT JOIN warehouse_atomic_hzx_c_customer AS d  ON a.customer_id=d.id

join (select * from default.warehouse_atomic_time_user a
           WHERE a.data_source in ('bhh','bhd')
		   AND substr(a.registe_date,1,10) between '2020-03-01' and '2020-03-31') e
		   on d.mobile = e.mbl_no
		  and substr(a.loan_apply_time,1,10) = substr(e.registe_date,1,10)
		  

WHERE substr(a.loan_apply_time,1,10) between '2020-03-01' and '2020-03-31'
  AND d.name NOT LIKE '%测试%'
  and c.name NOT LIKE '%测试%'
  and c.name NOT LIKE '%演示%'
  and c.name NOT LIKE '%废弃%') a
group by bank_name


--2.1 3月各产品申请次数
select b1.product_name,
       count(loan_apply_id) as num1,
	   count(distinct loan_apply_id) as num2,
	   count(distinct mobile) as num3
       
from  
(
SELECT a.bank_id AS bank_id,                                    --银行ID
       c.name AS bank_name,                                      --银行名称
	   a.pro_id AS pro_id,                                       --申请产品id
	   f.name AS product_name,                                   --申请产品名
       a.loan_apply_id AS loan_apply_id,                         --申请ID
       a.loan_apply_time AS loan_apply_time,                     --申请时间
	   d.mobile AS mobile,                                       --建档客户号码
       d.id_card AS id_card                                      --建档客户身份证号
	   
FROM warehouse_atomic_hzx_research_task AS a 
LEFT JOIN warehouse_atomic_hzx_b_bank_qr_code AS b  ON a.qrcode=b.id 
LEFT JOIN warehouse_atomic_hzx_b_bank_base_info AS c  ON a.bank_id=c.id 
LEFT JOIN warehouse_atomic_hzx_c_customer AS d  ON a.customer_id=d.id
left join (select * from default.warehouse_atomic_time_user a
           WHERE a.data_source in ('bhh','bhd')
		   AND substr(a.registe_date,1,10) between '2020-03-01' and '2020-03-31') e
		   on d.mobile = e.mbl_no
left join warehouse_atomic_hzx_bank_product_info f 
       ON a.bank_pro_id=f.id and c.id = f.bank_id

WHERE substr(a.loan_apply_time,1,10) between '2020-03-01' and '2020-03-31'
  AND d.name NOT LIKE '%测试%'
  and c.name NOT LIKE '%测试%'
  and c.name NOT LIKE '%演示%'
  and c.name NOT LIKE '%废弃%') b1

where b1.bank_name like '%抚宁%'
group by b1.product_name



-- 3月 注册用户数、点击申请用户数（新架构的）、填写资料申请数（4.5）、完成申请用户数（5）、完成调查用户数（4.5）、调查成功用户数（出额）


--点击申请  815次数-244人数
select --a1.extractday,
       --a1.pagename,
       --a1.pagenamecn,
       --a1.click_name,
	   --a4.goods_name,
	   count(a1.extractday) AS cs,
       count(DISTINCT a1.phone_number) AS rs  
	   
from default.warehouse_atomic_newframe_burypoint_buttonoperations a1   ---按钮
left join (select distinct start_id,
             page_id,
			 goods_id
      from default.warehouse_atomic_newframe_burypoint_pageoperations) a2  ---页面
  on a1.start_id = a2.start_id
 and a1.page_id = a2.page_id
join (select distinct start_id
      from default.warehouse_atomic_newframe_burypoint_baseoperations     
      where platform in('抚宁百惠贷','助立贷'))a3                                      --基础
  on a1.start_id = a3.start_id
left join default.warehouse_mall_goods_product a4                           --产品
  on a1.goods_id = a4.goods_id
  
where a1.click_name = 'order_promptly'
  and a1.extractday between '2020-03-01' and '2020-03-31'
--GROUP BY a1.extractday,
--         a1.pagename,
--         a1.pagenamecn,
--         a1.click_name,
--		   a4.goods_name

--填写资料申请数 179
select count(distinct mobile) as num
from
(
SELECT a.bank_id AS bank_id,                                    --银行ID
       c.name AS bank_name,                                      --银行名称
	   a.pro_id AS pro_id,                                       --申请产品id
	   f.name AS product_name,                                   --申请产品名
       a.loan_apply_id AS loan_apply_id,                         --申请ID
       a.loan_apply_time AS loan_apply_time,                     --申请时间
	   a.m_state,                                                --申请状态
	   d.mobile AS mobile,                                       --建档客户号码
       d.id_card AS id_card                                      --建档客户身份证号
	   
FROM warehouse_atomic_hzx_research_task AS a 
LEFT JOIN warehouse_atomic_hzx_b_bank_qr_code AS b  ON a.qrcode=b.id 
LEFT JOIN warehouse_atomic_hzx_b_bank_base_info AS c  ON a.bank_id=c.id 
LEFT JOIN warehouse_atomic_hzx_c_customer AS d  ON a.customer_id=d.id
left join (select * from default.warehouse_atomic_time_user a   ---判断是否线上
           WHERE a.data_source in ('bhh','bhd')
		   AND substr(a.registe_date,1,10) between '2020-03-01' and '2020-03-31') e
		   on d.mobile = e.mbl_no
left join warehouse_atomic_hzx_bank_product_info f 
       ON a.bank_pro_id=f.id and c.id = f.bank_id

WHERE substr(a.loan_apply_time,1,10) between '2020-03-01' and '2020-03-31'
  AND d.name NOT LIKE '%测试%'
  and c.name NOT LIKE '%测试%'
  and c.name NOT LIKE '%演示%'
  and c.name NOT LIKE '%废弃%') b1

where b1.bank_name like '%抚宁%'
  and b1.m_state IN('4','5')
  
--完成申请用户数（5） 126
select count(distinct mobile) as num
from
(
SELECT a.bank_id AS bank_id,                                    --银行ID
       c.name AS bank_name,                                      --银行名称
	   a.pro_id AS pro_id,                                       --申请产品id
	   f.name AS product_name,                                   --申请产品名
       a.loan_apply_id AS loan_apply_id,                         --申请ID
       a.loan_apply_time AS loan_apply_time,                     --申请时间
	   a.m_state,                                                --申请状态
	   d.mobile AS mobile,                                       --建档客户号码
       d.id_card AS id_card                                      --建档客户身份证号
	   
FROM warehouse_atomic_hzx_research_task AS a 
LEFT JOIN warehouse_atomic_hzx_b_bank_qr_code AS b  ON a.qrcode=b.id 
LEFT JOIN warehouse_atomic_hzx_b_bank_base_info AS c  ON a.bank_id=c.id 
LEFT JOIN warehouse_atomic_hzx_c_customer AS d  ON a.customer_id=d.id
left join (select * from default.warehouse_atomic_time_user a
           WHERE a.data_source in ('bhh','bhd')
		   AND substr(a.registe_date,1,10) between '2020-03-01' and '2020-03-31') e
		   on d.mobile = e.mbl_no
left join warehouse_atomic_hzx_bank_product_info f 
       ON a.bank_pro_id=f.id and c.id = f.bank_id

WHERE substr(a.loan_apply_time,1,10) between '2020-03-01' and '2020-03-31'
  AND d.name NOT LIKE '%测试%'
  and c.name NOT LIKE '%测试%'
  and c.name NOT LIKE '%演示%'
  and c.name NOT LIKE '%废弃%') b1

where b1.bank_name like '%抚宁%'
  and b1.m_state = '5'
  

--完成调查用户数（4.5）105

select count(distinct mobile) as num
from
(
SELECT a.bank_id AS bank_id,                                    --银行ID
       c.name AS bank_name,                                      --银行名称
	   a.pro_id AS pro_id,                                       --申请产品id
	   f.name AS product_name,                                   --申请产品名
       a.loan_apply_id AS loan_apply_id,                         --申请ID
       a.loan_apply_time AS loan_apply_time,                     --申请时间
	   a.m_state,                                                --申请状态
	   d.mobile AS mobile,                                       --建档客户号码
       d.id_card AS id_card,                                     --建档客户身份证号
	   
	   a.a_user_id AS a_user_id,                                 --调查客户经理ID
       a.research_apply_time AS research_apply_time,		     --调查开始时间
       a.research_over_time AS research_over_time,               --调查完成时间
       a.research_apply_id AS research_apply_id,                 --调查ID
       a.research_status AS research_status                      --'未调查-1,待预约1,待调查2,调查中3,调查完成4,拒绝本次申请5'
	   
	   
FROM warehouse_atomic_hzx_research_task AS a 
LEFT JOIN warehouse_atomic_hzx_b_bank_qr_code AS b  ON a.qrcode=b.id 
LEFT JOIN warehouse_atomic_hzx_b_bank_base_info AS c  ON a.bank_id=c.id 
LEFT JOIN warehouse_atomic_hzx_c_customer AS d  ON a.customer_id=d.id
left join (select * from default.warehouse_atomic_time_user a
           WHERE a.data_source in ('bhh','bhd')
		   AND substr(a.registe_date,1,10) between '2020-03-01' and '2020-03-31') e
		   on d.mobile = e.mbl_no
left join warehouse_atomic_hzx_bank_product_info f 
       ON a.bank_pro_id=f.id and c.id = f.bank_id

WHERE substr(a.loan_apply_time,1,10) between '2020-03-01' and '2020-03-31'
  AND d.name NOT LIKE '%测试%'
  and c.name NOT LIKE '%测试%'
  and c.name NOT LIKE '%演示%'
  and c.name NOT LIKE '%废弃%') b1

where b1.bank_name like '%抚宁%'
  and b1.research_status IN('4','5')


---调查成功用户数（出额） 11  2140000

select count(distinct mobile) as num,
       sum(rec_amount) as re_amount
from
(
SELECT a.bank_id AS bank_id,                                    --银行ID
       c.name AS bank_name,                                      --银行名称
	   a.pro_id AS pro_id,                                       --申请产品id
	   f.name AS product_name,                                   --申请产品名
       a.loan_apply_id AS loan_apply_id,                         --申请ID
       a.loan_apply_time AS loan_apply_time,                     --申请时间
	   a.m_state,                                                --申请状态
	   d.mobile AS mobile,                                       --建档客户号码
       d.id_card AS id_card,                                     --建档客户身份证号
	   
	   a.a_user_id AS a_user_id,                                 --调查客户经理ID
       a.research_apply_time AS research_apply_time,		     --调查开始时间
       a.research_over_time AS research_over_time,               --调查完成时间
       a.research_apply_id AS research_apply_id,                 --调查ID
       a.research_status AS research_status,                     --'未调查-1,待预约1,待调查2,调查中3,调查完成4,拒绝本次申请5'
	   a.rec_amount                                              --建议额度
	   
FROM warehouse_atomic_hzx_research_task AS a 
LEFT JOIN warehouse_atomic_hzx_b_bank_qr_code AS b  ON a.qrcode=b.id 
LEFT JOIN warehouse_atomic_hzx_b_bank_base_info AS c  ON a.bank_id=c.id 
LEFT JOIN warehouse_atomic_hzx_c_customer AS d  ON a.customer_id=d.id
left join (select * from default.warehouse_atomic_time_user a
           WHERE a.data_source in ('bhh','bhd')
		   AND substr(a.registe_date,1,10) between '2020-03-01' and '2020-03-31') e
		   on d.mobile = e.mbl_no
left join warehouse_atomic_hzx_bank_product_info f 
       ON a.bank_pro_id=f.id and c.id = f.bank_id

WHERE substr(a.loan_apply_time,1,10) between '2020-03-01' and '2020-03-31'
  AND d.name NOT LIKE '%测试%'
  and c.name NOT LIKE '%测试%'
  and c.name NOT LIKE '%演示%'
  and c.name NOT LIKE '%废弃%') b1

where b1.bank_name like '%抚宁%'
  and b1.research_status IN('4')
  and b1.rec_amount > 0