2.执行力BI
  增加月度数据
  
  分开建档和申请调查
  建档增加 二维码
  申请调查增加 产品分类

2.执行力BI-建档增加二维码
--1.汇智信建档
SELECT a1.c_date as c_date,                        --建档时间
       a2.name as bank_name,                       --银行名称
	   a1.dot_id,                                  --网点ID
	   a4.dot_name,                                -- 网点名
	   a1.c_user as c_user,                        --客户经理ID
	   a3.user_name as user_name,                  --客户经理
	   a1.customer_owner_id as customer_owner_id,  --客户归属ID
       a1.id as id,                                --客户建档ID 
       if(a1.extentive52 is not null,a1.extentive52,a1.mobile_phone) as mobile_phone, --客户建档号码
	   a1.id_card as id_card                       --客户身份证号
	   
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
  and a1.mobile_phone is not null