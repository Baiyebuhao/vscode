(0.全流程

select a.extractday,
       a.province_name,
       sum(a.apply_num) as apply_num,
	   sum(a.credit_num) as credit_num,
	   sum(a.order_num) as order_num,
	   sum(a.order_num_e) as order_num_e,
	   sum(a.loan_num) as loan_num,
	   sum(a.loan_num_e) as loan_num_e,
	   sum(a.loan_amount) as loan_amount,
	   sum(a.loan_amount_e) as loan_amount_e
from
(select substr(a1.create_time,1,10) as extractday,
       b1.province_name,
       count(distinct a1.hb_usr_no) as apply_num,
       count(distinct case when a1.credit_result = '1' then a1.hb_usr_no end) as credit_num,
	   0 as order_num,
	   0 as order_num_e,
	   0 as loan_num,
	   0 as loan_num_e,
	   0 as loan_amount,
	   0 as loan_amount_e
from default.warehouse_hebao_credit_apply_status a1   
join default.warehouse_hebao_credit_apply_user_inf a2 
  on a1.qry_credit_id = a2.qry_creditId
join default.warehouse_hebao_credit_apply_user_ext_inf a3 
  on a1.qry_credit_id = a3.qry_credit_id
left join (select distinct province_code,
                  province_name
           from default.warehouse_hebao_prov_city_info a) b1
  on a2.usr_prov_no = b1.province_code
group by substr(a1.create_time,1,10),
         b1.province_name
union all
select substr(a1.create_time,1,10) as extractday,
       b1.province_name,
       0 as apply_num,
	   0 as credit_num,
       count(distinct a1.brw_ord_no) as order_num,
	   count(distinct case when a1.brw_ord_sts like 'S%' then a1.brw_ord_no end) as order_num_e,
	   count(distinct a2.hb_usr_no) as loan_num,
	   count(distinct case when a1.brw_ord_sts like 'S%' then a2.hb_usr_no end) as loan_num_e,
	   sum(a2.loan_amt) as loan_amount,
	   sum(case when a1.brw_ord_sts like 'S%' then a2.loan_amt end) as loan_amount_e
from default.warehouse_hebao_loan_apply_status a1
join default.warehouse_hebao_loan_apply_info a2
  on a1.brw_ord_no = a2.brw_ord_no
left join default.warehouse_hebao_prov_city_info b1
       on a2.dep_prov_no = b1.province_code
	  and a2.dep_city_no = b1.city_code
	  and a2.dep_reg_no = b1.region_code
group by substr(a1.create_time,1,10),
         b1.province_name) a
group by a.extractday,
         a.province_name

)

(1.申请授信明细数据
select b1.province_name,
       a1.qry_creditId,
       a1.hb_usr_no,
       a1.mbl_no,
	   a1.usr_id_name,
	   a1.usr_Id_card,
	   CASE
              WHEN a2.credit_result =0 THEN '授信中'
              WHEN a2.credit_result =1 THEN '授信成功'
              WHEN a2.credit_result =2 THEN '失败'
              ELSE '未归类'
       END AS credit_result,
	   a2.credit_ret_msg,
	   a2.credit_amt,
	   a2.create_time
from default.warehouse_hebao_credit_apply_user_inf a1
join default.warehouse_hebao_credit_apply_status a2 
  on a1.qry_creditId = a2.qry_credit_id
join default.warehouse_hebao_credit_apply_user_ext_inf a3 
  on a1.qry_creditId = a3.qry_credit_id
left join (select distinct province_code,
                  province_name
           from default.warehouse_hebao_prov_city_info a)b1
  on a1.usr_prov_no = b1.province_code
)
(2.放款明细数据

select b1.province_name,
	   b1.city_name,
	   b1.region_name,
	   '享宇' as channl,
	   a1.merc_id,
	   a1.merc_nm,
	   a1.dep_id,
	   a1.dep_nm,
	   a1.opr_id,
	   a1.opr_mbl_no,
	   a1.hb_usr_no,
	   b2.usr_id_name,
	   a1.product_id,
	   a1.product_nm,
	   a2.brw_ord_sts,
	   a2.brw_ord_msg,
	   b2.credit_date,
	   substr(a2.create_time,1,10) as r_date,
	   a1.loan_amt,
	   substr(a1.credit_time,1,10) as c_date
	   
from default.warehouse_hebao_loan_apply_info a1          ---借款申请信息表
left join default.warehouse_hebao_prov_city_info b1
       on a1.dep_prov_no = b1.province_code
	  and a1.dep_city_no = b1.city_code
	  and a1.dep_reg_no = b1.region_code
	  
---授信时间+用户姓名
left join(select a.hb_usr_no,
                 b.usr_id_name,
          	     substr(a.create_time,1,10) as credit_date
          from default.warehouse_hebao_credit_apply_status a      ---申请授信表
		  join default.warehouse_hebao_credit_apply_user_inf b
		    on a.qry_credit_id = b.qry_creditId
          where a.credit_result = '1') b2
	   on a1.hb_usr_no = b2.hb_usr_no


left join default.warehouse_hebao_loan_apply_status a2        ---借款申请状态表
  on a1.brw_ord_no = a2.brw_ord_no
  
where a1.dep_nm <> '%测试门店%'

)


3.退货+提前清贷
 ---rpy_mod '1：还某期2：提前清贷3：退货\r\n    ---is_overdue  '0：未逾期  1:逾期\r\n  
select * 
from warehouse_hebao_repayment_record a
where rpy_mod in ('2','3')

