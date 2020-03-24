 金融电子商城-订单明细
 各位同事，我们看到后台数据显示，交子普惠和金融电子商城均有下单，所以想了解一下订单情况，
 1.包括客户类型（如中小微企业？农户？零售老板？普通个人？）、
 2.具体申请了哪一款产品、什么时候下单，从申请到下款，有哪些流程；
 3.以及交子普惠和金融电子商城这一块，有多少人申请、主要申请哪些产品，烦请告知我们一下。
 
2.订单明细
select a4.manager_name,
       a1.order_code,           ---varchar(50) comment '订单号',
       a1.user_code,            ---varchar(50) comment '用户code',
       a1.user_account,         ---varchar(50),
       a1.mobile,               ---varchar(45) comment '手机',
       a1.store_code,           ---varchar(50) comment '店铺编码',
       a1.store_name,           ---varchar(200) comment '店铺名称',
       a1.mall_code,            ---varchar(50) comment '商城编码',
       a1.mall_name,            ---varchar(200) comment '商城名称',
       a1.goods_id,             ---varchar(50) comment '商品id',
       a1.goods_name,           ---varchar(50) comment '商品名称',
	   a1.create_date

FROM warehouse_credit_core_order a1

JOIN(SELECT a.manager_name,
            b.mall_name,
            b.mall_name_en,
            b.create_date AS mall_cre_time,
            b.mall_code
     FROM newframe_sys_manager a --商户
     LEFT JOIN warehouse_all_platform_mall_info b --商城
            ON a.belong_code = b.mall_code
     WHERE (a.manager_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行','石家庄新华恒升村镇银行')
     or b.mall_name in ('万全家银村镇银行','围场华商村镇银行','宣化家银村镇银行','成都享宇新派科技有限公司','豫丰银行小微贷','鹿泉恒升村镇银行','石家庄新华恒升村镇银行'))) a4
     ON a1.mall_code = a4.mall_code

3.申请明细
credit_apply_info