#!/bin/sh

#今天

echo "-----------------------------------------------------同步数据开始------------------------------------------------------------"

#数据库连接地址
url='jdbc:mysql://10.200.1.4:3306/xye_core_user?zeroDateTimeBehavior=convertToNull&autoReconnect=true&failOverReadOnly=false'
#数据库连接用户名
username='zhougang'
#数据库连接密码
password='Abcd!234'


#前一天日期
yestoday=$(date +"%Y-%m-%d" -d "-1days")

hive -e "
CREATE TABLE if not exists warehouse_credit_core_order (
  id string COMMENT 'id',
  order_code string COMMENT '订单号',
  product_type string COMMENT '产品类型（随借随还，现金分期）',
  order_type string COMMENT '类型,信贷or分期',
  order_status string COMMENT '父状态',
  sub_order_status string COMMENT '订单子状态',
  channel_code string COMMENT '订单来源渠道',
  user_code string COMMENT '用户code',
  user_account string,
  mobile string COMMENT '手机',
  store_code string COMMENT '店铺编码',
  store_name string COMMENT '店铺名称',
  mall_code string COMMENT '商城编码',
  mall_name string COMMENT '商城名称',
  goods_id string COMMENT '商品id',
  goods_name string COMMENT '商品名称',
  goods_pic string COMMENT '图片地址',
  product_id string COMMENT '产品id',
  comments string COMMENT '备注1',
  create_date string COMMENT '创建时间',
  create_by string COMMENT '创建人',
  update_date string COMMENT '修改时间',
  update_by string COMMENT '修改人',
  state string COMMENT '状态',
  add_params string COMMENT '附加参数',
  etl_time string,
  etl_source string,
  valid_day string,
  repay_type string COMMENT '还款方式',
  fang_pic string COMMENT '方形图片',
  org_id string COMMENT '机构id',
  promote_sales_code string COMMENT '推广码'
) COMMENT '信贷订单' row format delimited fields terminated by '\t';
"

echo '开始导入user_info'
sqoop import --connect $url --username $username --password $password --m 1 --query "SELECT user_code,chan_code,authorize_date,reg_date,invest_code,is_cert,is_eval,app_code,to_base64(mobile) as mobile,create_date FROM user_info WHERE \$CONDITIONS" --hive-import --hive-overwrite --hive-table original_all_platform_user_info  --fields-terminated-by '\t' --lines-terminated-by "\n"  --target-dir /sqoop/temp_newframe_jry   --delete-target-dir --null-string '\\N' --null-non-string '\\N' --hive-drop-import-delims 
echo '导入user_info成功'

echo '开始导入user_auth'
sqoop import --connect $url --username $username --password $password --m 1 --query "SELECT user_code,user_name,sex,brithday,create_date FROM user_auth WHERE \$CONDITIONS" --hive-import --hive-overwrite --hive-table original_jry_user_auth  --fields-terminated-by '\t' --lines-terminated-by "\n"  --target-dir /sqoop/temp_newframe_jry   --delete-target-dir --null-string '\\N' --null-non-string '\\N' --hive-drop-import-delims 
echo '导入user_auth成功'

echo '开始导入user_log'
sqoop import --connect $url --username $username --password $password --m 1 --query "SELECT user_code,term_code,imei FROM user_log WHERE (term_code IS NOT NULL AND LENGTH(term_code) > 0 ) OR ( imei IS NOT NULL AND LENGTH(imei) > 0) and \$CONDITIONS" --hive-import --hive-overwrite --hive-table original_jry_user_log  --fields-terminated-by '\t' --lines-terminated-by "\n"  --target-dir /sqoop/temp_newframe_jry   --delete-target-dir --null-string '\\N' --null-non-string '\\N' --hive-drop-import-delims 
echo '导入user_log成功'

url='jdbc:mysql://10.200.1.4:3306/xye_core_platform?zeroDateTimeBehavior=convertToNull&autoReconnect=true&failOverReadOnly=false'

echo '开始导入mall_info'
sqoop import --connect $url --username $username --password $password --m 1 --query "SELECT t.* FROM mall_info t where \$CONDITIONS" --hive-import --hive-overwrite  --hive-table warehouse_all_platform_mall_info  --fields-terminated-by '\t' --lines-terminated-by "\n"  --target-dir /sqoop/temp_newframe_jry --delete-target-dir --null-string '\\N' --null-non-string '\\N' --hive-drop-import-delims 
echo '导入mall_info成功'

url='jdbc:mysql://10.200.1.4:3306/xye_core_goods?zeroDateTimeBehavior=convertToNull&autoReconnect=true&failOverReadOnly=false'
sql="select id,goods_name,store_code,cate_id,goods_desc,mall_code,store_name,mall_name,pic,url,product_id,brande_id,status,create_date,create_by,update_date,update_by,state,comments,price_min,price_max,old_price_min,old_price_max,delivery,ready_date,is_applyable,is_splitable,rate_type,rate,max_rate,is_fixation_rate,location,loc_sel_type,periods,super_cate_id,org_id,goods_seq FROM goods_info where \$CONDITIONS"
echo '开始导入goods_info'
sqoop import --connect $url --username $username --password $password --m 1 --query "$sql" --hive-import --hive-overwrite  --hive-table warehouse_jry_goods_info  --fields-terminated-by '\t' --lines-terminated-by "\n"  --target-dir /sqoop/temp_newframe_jry --delete-target-dir --null-string '\\N' --null-non-string '\\N' --hive-drop-import-delims 
echo '导入goods_info成功'


url='jdbc:mysql://10.200.1.4:3306/xye_core_loan?zeroDateTimeBehavior=convertToNull&autoReconnect=true&failOverReadOnly=false'

echo '开始导入product_mcc_inf'
sqoop import --connect $url --username $username --password $password --m 1 --query "SELECT t.* FROM product_mcc_inf t where \$CONDITIONS" --hive-import --hive-overwrite  --hive-table warehouse_jry_product_mcc_inf  --fields-terminated-by '\t' --lines-terminated-by "\n"  --target-dir /sqoop/temp_newframe_jry --delete-target-dir --null-string '\\N' --null-non-string '\\N' --hive-drop-import-delims 
echo '导入product_mcc_inf成功'

url='jdbc:mysql://10.200.1.4:3306/xye_core_order_credit?zeroDateTimeBehavior=convertToNull&autoReconnect=true&failOverReadOnly=false'
echo '开始导入goods_info,product_info'
sqoop import --connect $url --username $username --password $password --m 1 --query "SELECT goods.mall_code,goods.mall_name,goods.id AS goods_id,goods.goods_name,goods.product_id,prd.product_name FROM xye_core_goods.goods_info AS goods,xye_core_loan.product_info AS prd WHERE goods.product_id = prd.id and \$CONDITIONS" --hive-import --hive-overwrite  --hive-table warehouse_mall_goods_product  --fields-terminated-by '\t' --lines-terminated-by "\n"  --target-dir /sqoop/temp_newframe_jry --delete-target-dir --null-string '\\N' --null-non-string '\\N' --hive-drop-import-delims 
echo '导入goods_info,product_info成功'

url='jdbc:mysql://10.200.1.4:3306/xye_core_order_credit?zeroDateTimeBehavior=convertToNull&autoReconnect=true&failOverReadOnly=false'
echo '开始导入credit_core_order'
sqoop import --connect $url --username $username --password $password --m 1 --query "SELECT t.* FROM  credit_core_order t WHERE \$CONDITIONS" --hive-import --hive-overwrite  --hive-table warehouse_credit_core_order --fields-terminated-by '\t' --lines-terminated-by "\n"  --target-dir /sqoop/temp_newframe_jry --delete-target-dir --null-string '\\N' --null-non-string '\\N' --hive-drop-import-delims 
echo '导入credit_core_order成功'



## --------------------------------------------------------------------------
url='jdbc:mysql://10.200.1.4:3306/rainbow_app?zeroDateTimeBehavior=convertToNull&autoReconnect=true&failOverReadOnly=false'
echo '开始导入s_user_inf'
sqoop import --connect $url --username $username --password $password --m 1 --query "SELECT t.*,'$yestoday' as extract_time FROM s_user_inf  t WHERE \$CONDITIONS" --hive-import   --hive-table original_jry_s_user_inf  --fields-terminated-by '\t' --lines-terminated-by "\n"  --target-dir /sqoop/temp_jry --hive-partition-key extractday --hive-partition-value $yestoday  --delete-target-dir --null-string '\\N' --null-non-string '\\N'
   
echo '导入s_user_inf成功'


echo '开始导入s_user_ext_inf'
sqoop import --connect $url --username $username --password $password --m 1 --query "SELECT t.*,'$yestoday' as extract_time FROM s_user_ext_inf  t WHERE \$CONDITIONS" --hive-import   --hive-table original_jry_s_user_ext_inf  --fields-terminated-by '\t' --lines-terminated-by "\n"  --target-dir  /sqoop/temp_jry --hive-partition-key extractday --hive-partition-value $yestoday  --delete-target-dir --null-string '\\N' --null-non-string '\\N'     
echo '导入s_user_ext_inf成功'


echo '开始导入s_chan_inf'
sqoop import --connect $url --username $username --password $password --m 1 --query "SELECT t.*,'$yestoday' as extract_time FROM s_chan_inf  t WHERE \$CONDITIONS" --hive-import  --hive-table original_jry_s_chan_inf  --fields-terminated-by '\t' --lines-terminated-by "\n"  --target-dir  /sqoop/temp_jry --hive-partition-key extractday --hive-partition-value $yestoday  --delete-target-dir --null-string '\\N' --null-non-string '\\N'
    
echo '导入s_chan_inf成功'

echo '开始导入s_client_inf'
sqoop import --connect $url --username $username --password $password --m 1 --query "SELECT t.*,'$yestoday' as extract_time FROM s_client_inf  t WHERE \$CONDITIONS" --hive-import  --hive-table original_jry_s_client_inf  --fields-terminated-by '\t' --lines-terminated-by "\n"  --target-dir  /sqoop/temp_jry --hive-partition-key extractday --hive-partition-value $yestoday  --delete-target-dir --null-string '\\N' --null-non-string '\\N' 
echo '导入s_client_inf成功'

echo '开始导入s_msd_user_order_inf_record'
sqoop import --connect $url --username $username --password $password --m 1 --query "SELECT t.*,'$yestoday' as extract_time FROM s_msd_user_order_inf_record  t WHERE \$CONDITIONS" --hive-import   --hive-table original_jry_s_msd_user_order_inf_record  --fields-terminated-by '\t' --lines-terminated-by "\n"  --target-dir  /sqoop/temp_jry --hive-partition-key extractday --hive-partition-value $yestoday  --delete-target-dir --null-string '\\N' --null-non-string '\\N'    
echo '导入s_msd_user_order_inf_record成功'


echo '开始导入s_prod_order_inf'
sqoop import --connect $url --username $username --password $password --m 1 --query "SELECT t.*,'$yestoday' as extract_time FROM s_prod_order_inf  t WHERE \$CONDITIONS" --hive-import   --hive-table original_jry_s_prod_order_inf  --fields-terminated-by '\t' --lines-terminated-by "\n"  --target-dir  /sqoop/temp_jry --hive-partition-key extractday --hive-partition-value $yestoday  --delete-target-dir --null-string '\\N' --null-non-string '\\N'    
echo '导入s_prod_order_inf成功'

echo '开始导入s_user_login_cnt_record'
sqoop import --connect $url --username $username --password $password --m 1 --query "SELECT t.*,'$yestoday' as extract_time FROM s_user_login_cnt_record  t WHERE \$CONDITIONS" --hive-import --hive-table original_jry_s_user_login_cnt_record  --fields-terminated-by '\t' --lines-terminated-by "\n"  --target-dir  /sqoop/temp_jry --hive-partition-key extractday --hive-partition-value $yestoday  --delete-target-dir --null-string '\\N' --null-non-string '\\N'    
echo '导入s_user_login_cnt_record成功'


echo '开始导入s_prod_org_inf'
sqoop import --connect $url --username $username --password $password --m 1 --query "SELECT t.*,'$yestoday' as extract_time FROM s_prod_org_inf  t WHERE \$CONDITIONS" --hive-import --hive-table original_jry_s_prod_org_inf  --fields-terminated-by '\t' --lines-terminated-by "\n"  --target-dir  /sqoop/temp_jry --hive-partition-key extractday --hive-partition-value $yestoday  --delete-target-dir --null-string '\\N' --null-non-string '\\N'    
echo '导入s_prod_org_inf成功'

echo '开始导入s_prod_inf'
sqoop import --connect $url --username $username --password $password --m 1 --query "SELECT t.*,'$yestoday' as extract_time FROM s_prod_inf  t WHERE \$CONDITIONS" --hive-import --hive-table original_jry_s_prod_inf  --fields-terminated-by '\t' --lines-terminated-by "\n"  --target-dir  /sqoop/temp_jry --hive-partition-key extractday --hive-partition-value $yestoday  --delete-target-dir --null-string '\\N' --null-non-string '\\N'    
echo '导入s_prod_inf成功'

#享宇钱包产品信息
echo '开始导入s_prod_jry_edition_inf'
sqoop import --connect $url --username $username --password $password --m 1 --query "SELECT t.*,'$yestoday' as extract_time FROM s_prod_jry_edition_inf  t WHERE \$CONDITIONS" --hive-import  --hive-table original_jry_s_prod_jry_edition_inf  --fields-terminated-by '\t' --lines-terminated-by "\n"  --target-dir  /sqoop/temp_jry --hive-partition-key extractday --hive-partition-value $yestoday  --delete-target-dir --null-string '\\N' --null-non-string '\\N'    
echo '导入s_prod_jry_edition_inf成功'

echo '开始导入s_insurance_inf'
sqoop import --connect $url --username $username --password $password --m 1 --query "SELECT t.*,'$yestoday' as extract_time FROM s_insurance_inf  t WHERE \$CONDITIONS" --hive-import  --hive-table original_jry_s_insurance_inf  --fields-terminated-by '\t' --lines-terminated-by "\n"  --target-dir  /sqoop/temp_jry --hive-partition-key extractday --hive-partition-value $yestoday  --delete-target-dir --null-string '\\N' --null-non-string '\\N'    
echo '导入s_insurance_inf成功'



echo "-----------------------------------------------------处理数据开始------------------------------------------------------------"
hive -e "
INSERT INTO TABLE warehouse_atomic_user_info(cus_no,name,age,mbl_no,mbl_no_md5,mbl_no_un,chan_no,chan_no_desc,data_source,invent_mbl,id_chk_code,id_chk_desc,registe_date,is_eva,authentication_date,imei,imsi,province_desc,city_code,city_desc,isp)
select
a.user_code as cus_no,
f.user_name as name,
floor(datediff(to_date(from_unixtime(unix_timestamp())),brithday) / 365.25) as age,
a.mobile,
md5(unbase64(a.mobile)) as mbl_no_md5,
concat(substr(decode(unbase64(a.mobile),'UTF-8'),1,3),'****',substr(decode(unbase64(a.mobile),'UTF-8'),8,4)) as mbl_no_un,
a.chan_code as chan_no,
e.promoter_name as chan_no_desc,
case when b.mall_name_en = 'ydsjd' then 'sjd' else b.mall_name_en end as data_source,
invest_code as invent_mbl,
is_cert as id_chk_code,
CASE WHEN f.user_code is null THEN '未实名' else '已实名' END as id_chk_desc,
if(a.reg_date is not null,substr(a.reg_date,1,10),null) as registe_date,
is_eval as is_eva,
if(f.create_date is not null,substr(f.create_date,1,10),null) as authentication_date,
imei as imei,
term_code as imsi,
d.province province_desc, -- 省份名称描述    
d.city_code city_code, -- 城市代码        
d.city city_desc, -- 城市名称描述    
d.isp isp -- 运营商	
from (select tmp.* from(
select user_code,mobile,chan_code,app_code,invest_code,is_cert,reg_date,is_eval,authorize_date,
row_number() over (partition by user_code order by create_date desc) rn
from original_all_platform_user_info
)tmp where tmp.rn=1) a 
left join warehouse_all_platform_mall_info b on a.app_code = b.mall_code
left join original_jry_user_log c on a.user_code = c.user_code 
left join authentication_phone_info d ON d.phone = SUBSTR(cast(unbase64(a.mobile) as string), 1, 7)
left join warehouse_jry_business_promoter e on a.chan_code = e.promoter_code
left join original_jry_user_auth f on a.user_code = f.user_code;

-- 清洗产品信息表
insert INTO table warehouse_atomic_product_info(prod_no,prod_name,enable_flag,data_source)
select product_id  prod_no,
       product_name prod_name,
       'Y' enable_flag,
       case when b.mall_name_en = 'ydsjd' then 'sjd' else b.mall_name_en end as data_source
from warehouse_mall_goods_product a left join warehouse_all_platform_mall_info b
on a.mall_code = b.mall_code ;


insert overwrite table warehouse_atomic_product_info
select 
prod_no,prod_name,enable_flag,data_source
from (SELECT *,ROW_NUMBER() over(partition BY prod_no,prod_name,enable_flag,data_source) AS num
      FROM warehouse_atomic_product_info) tmp WHERE num = 1;

-- 清洗渠道信息表
insert INTO table warehouse_atomic_channel_info
(chan_no,chan_name,chan_type,data_source)
select promoter_code,promoter_name,promoter_type,b.data_source
from warehouse_jry_business_promoter a left join warehouse_atomic_user_info b
on a.promoter_code = b.chan_no ;

insert overwrite table warehouse_atomic_channel_info
select 
chan_no,chan_name,chan_type,data_source
from (SELECT *,ROW_NUMBER() over(partition BY chan_no,chan_name,chan_type,data_source) AS num
      FROM warehouse_atomic_channel_info) tmp WHERE num = 1;

insert into table warehouse_atomic_channel_category_info
  SELECT a.promoter_code chan_no,
         '' 4th_level,
         case a.promoter_type when 3 then '其它渠道' end 3rd_level,
         case a.promoter_type when 1 then '安卓' when 2 then 'IOS' when 3 then 'H5' end 2nd_level,
         '享宇渠道' 1st_level,
         case when b.mall_name_en = 'ydsjd' then 'sjd' else b.mall_name_en end plat_no
  FROM warehouse_jry_business_promoter a
  LEFT JOIN warehouse_all_platform_mall_info b on a.general_code = b.mall_code ;


insert overwrite table warehouse_atomic_channel_category_info
select 
chan_no,4th_level,3rd_level,2nd_level,1st_level,plat_no
from (SELECT *,ROW_NUMBER() over(partition BY chan_no,4th_level,3rd_level,2nd_level,1st_level,plat_no) AS num
      FROM warehouse_atomic_channel_category_info) tmp WHERE num = 1;


-- ------------------下周做这个 这个表的sqoop要改warehouse_credit_core_order
-- insert into warehouse_data_user_withdrawals_info(
-- mbl_no,data_source,cash_time,cash_amount,product_name,etlday
-- )
-- select
-- ,mobile
-- ,mobile
-- ,mobile
-- ,mobile
-- ,mobile
-- ,mobile
-- from warehouse_credit_core_order
select '11';
"
echo "-----------------------------------------------------处理数据完成------------------------------------------------------------"


