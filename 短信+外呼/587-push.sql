587 push需求  徐超 已编码    重要不紧急 纪春艳 平台运营 2019.9.9 2019.9.10 
一次性需求 钱伴 移动手机贷 移动手机贷 push营销 按序号分包，包与包之间去重
1、马上随借随还已授信用户且近半年有点击行为用户，剔除已申请钱伴和信用钱包产品用户
2、优智借产品已授信用户，剔除已申请钱伴产品用户
3、马上随借随还已提现用户中，剩余额度小于500的用户，剔除已申请钱伴和信用钱包产品用户

--1马上随借随还已授信用户且近半年有点击行为用户，剔除已申请钱伴和信用钱包产品用户
select distinct a1.mbl_no,a1.data_source
from warehouse_data_user_review_info a1
left outer join (select distinct mbl_no
                 from warehouse_data_user_review_info a
                 where product_name in('现金分期-钱伴','信用钱包')
				 ) a2
         on a1.mbl_no = a2.mbl_no
join (select distinct mbl_no
      from warehouse_data_user_action_day a
      where extractday between '2019-03-11' and '2019-09-11'
	    and data_source = 'sjd') a3
   on a1.mbl_no = a3.mbl_no
where a1.data_source = 'sjd'
  and a1.product_name = '随借随还-马上'
  and a1.status = '通过'
  and a1.mbl_no <> 'NULL'
  and a2.mbl_no is null
--
--2优智借产品已授信用户，剔除已申请钱伴产品用户
select distinct a1.mbl_no,
       a1.data_source
from warehouse_data_user_review_info a1

left outer join (select distinct mbl_no
                 from warehouse_data_user_review_info a
                 where product_name = '现金分期-钱伴'
				 ) a2
         on a1.mbl_no = a2.mbl_no
where a1.data_source = 'sjd'
  and a1.product_name = '优智借'
  and a1.status = '通过'
  and a1.mbl_no <> 'NULL'
  and a2.mbl_no is null
--
--3马上随借随还已提现用户中，剩余额度小于500的用户，剔除已申请钱伴和信用钱包产品用户
select distinct a1.mbl_no,
       a1.data_source
from warehouse_data_user_withdrawals_info a1

join
    (select distinct a3.mbl_no,
            a3.num1-a4.num2 as mum3
     from
          (select mbl_no,num1
          from
              (select distinct mbl_no,
                     acc_lim/100 as num1,
              	   Row_Number() OVER (partition by mbl_no ORDER BY credit_time desc) rank
              from warehouse_atomic_msd_review_result_info a
              where appral_res = '通过'
              and mbl_no is not null
              and data_source = 'sjd') b
              where b.rank = '1') a3
          ----授信用户+授信额
          left join 
          (select mbl_no,num2
          from 
              (select distinct mbl_no,
                     prin_bal/100 as num2,
              	   Row_Number() OVER (partition by mbl_no ORDER BY msd_return_time desc) rank     
              from warehouse_atomic_msd_withdrawals_result_info a
              where mbl_no is not null
              and data_source = 'sjd'
			  and paid_out_time > '2019-09-12') b
          where b.rank = '1') a4
          on a3.mbl_no = a4.mbl_no
          ----提现用户+用信额
    ) a5
    on a1.mbl_no = a5.mbl_no

left outer join (select distinct mbl_no
                 from warehouse_data_user_review_info a
                 where product_name in('现金分期-钱伴','信用钱包')
				 ) a6
         on a1.mbl_no = a6.mbl_no

where a1.data_source = 'sjd'
  and a1.product_name = '随借随还-马上'
  and a1.cash_amount > 0
  and a5.mum3 <= '500'
  and a6.mbl_no is null

---入库
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN283_001',
                "PS",
				'2019-09-11' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (
			) AS c
             ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
)
(
---PUSH取数
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN283_001'
)