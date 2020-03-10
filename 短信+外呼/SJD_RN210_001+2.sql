358	Push需求  徐超  3、重要不紧急 2019.6.10 纪春艳 享宇钱包 
2019.6.11 一次性需求 优智借、钱伴 移动手机贷 享宇钱包 push营销 CURRENT_DATE

1、历史手机贷平台申请兴业未授信用户，且最近3个月有登陆行为用户；剔除申请优智借产品不通过用户；SJD_RN210_001
2、历史手机贷平台申请钱包易贷授信未提现用户，且最近3个月有登陆行为用户；剔除申请优智借产品不通过用户； SJD_RN210_002
---结果SJD_RN210_001
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_review_info a1
left outer 
join (select mbl_no from warehouse_data_user_review_info
      where product_name = '现金分期-兴业消费'
	    and status = '通过'
		and data_source = 'sjd') a2
  on a1.mbl_no = a2.mbl_no

join (select distinct mbl_no
      from warehouse_newtrace_click_record b1
      where platform = 'sjd'
        and extractday between '2019-03-01' and '2019-06-31'
     UNION
      select distinct mbl_no
      from warehouse_atomic_user_action b2
      where sys_id = 'sjd'
        and extractday between '2019-03-01' and '2019-06-31') a3
  on a1.mbl_no = a3.mbl_no
left outer 
join (select mbl_no from warehouse_data_user_review_info
      where product_name = '优智借'
	    and status <> '通过') a4
where a1.product_name = '现金分期-兴业消费'
  and a1.data_source = 'sjd'
  and a2.mbl_no is null
  and a4.mbl_no is null
---结果SJD_RN210_002
---2、历史手机贷平台申请钱包易贷授信未提现用户，且最近3个月有登陆行为用户；剔除申请优智借产品不通过用户
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_review_info a1
left outer 
join (select mbl_no from warehouse_data_user_withdrawals_info
      where product_name = '随借随还-钱包易贷'
	    and cash_amount > '0') a2
  on a1.mbl_no = a2.mbl_no
join (select distinct mbl_no
      from warehouse_newtrace_click_record b1
      where platform = 'sjd'
        and extractday between '2019-03-01' and '2019-06-31'
     UNION
      select distinct mbl_no
      from warehouse_atomic_user_action b2
      where sys_id = 'sjd'
        and extractday between '2019-03-01' and '2019-06-31') a3
  on a1.mbl_no = a3.mbl_no  
left outer 
join (select mbl_no from warehouse_data_user_review_info
      where product_name = '优智借'
	    and status <> '通过') a4
where a1.product_name = '随借随还-钱包易贷'
  and a1.data_source = 'sjd'
  and a1.status = '通过'
  and a2.mbl_no is null
  and a4.mbl_no is null 
  
  
  
(INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                a.data_source, 
                a.cus_no,
                'XYQB_RN210_001',
                "PS",
				'2019-06-12' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (select distinct a1.mbl_no,a1.data_source
            from warehouse_data_user_review_info a1
            left outer 
            join (select mbl_no from warehouse_data_user_review_info
                  where product_name = '现金分期-兴业消费'
            	    and status = '通过'
            		and data_source = 'sjd') a2
              on a1.mbl_no = a2.mbl_no
            
            join (select distinct mbl_no
                  from warehouse_newtrace_click_record b1
                  where platform = 'sjd'
                    and extractday between '2019-03-01' and '2019-06-31'
                 UNION
                  select distinct mbl_no
                  from warehouse_atomic_user_action b2
                  where sys_id = 'sjd'
                    and extractday between '2019-03-01' and '2019-06-31') a3
              on a1.mbl_no = a3.mbl_no
            left outer 
            join (select mbl_no from warehouse_data_user_review_info
                  where product_name = '优智借'
            	    and status <> '通过') a4
            where a1.product_name = '现金分期-兴业消费'
              and a1.data_source = 'sjd'
              and a2.mbl_no is null
              and a4.mbl_no is null) AS c
 ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='xyqb'  and length(c.mbl_no) > 4)

(INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                a.data_source, 
                a.cus_no,
                'XYQB_RN210_002',
                "PS",
				'2019-06-12' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (select distinct a1.mbl_no,a1.data_source
            from warehouse_data_user_review_info a1
            left outer 
            join (select mbl_no from warehouse_data_user_withdrawals_info
                  where product_name = '随借随还-钱包易贷'
            	    and cash_amount > '0') a2
              on a1.mbl_no = a2.mbl_no
            join (select distinct mbl_no
                  from warehouse_newtrace_click_record b1
                  where platform = 'sjd'
                    and extractday between '2019-03-01' and '2019-06-31'
                 UNION
                  select distinct mbl_no
                  from warehouse_atomic_user_action b2
                  where sys_id = 'sjd'
                    and extractday between '2019-03-01' and '2019-06-31') a3
              on a1.mbl_no = a3.mbl_no  
            left outer 
            join (select mbl_no from warehouse_data_user_review_info
                  where product_name = '优智借'
            	    and status <> '通过') a4
            where a1.product_name = '随借随还-钱包易贷'
              and a1.data_source = 'sjd'
              and a1.status = '通过'
              and a2.mbl_no is null
              and a4.mbl_no is null ) AS c
 ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='xyqb'  and length(c.mbl_no) > 4)