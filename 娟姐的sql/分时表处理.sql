
insert overwrite table warehouse_atomic_time_user partition(data_source='sjd')
select
a.cus_no,
base64(encode(a.mbl_no,'utf8')),
md5(mbl_no),
concat(substr(a.mbl_no,1,3),'****',substr(a.mbl_no,8,4)),
from_unixtime(unix_timestamp(concat(e.reg_dt,e.reg_tm),'yyyyMMddHHmmss'),'yyyy-MM-dd HH:mm:ss'),
from_unixtime(unix_timestamp(b.tm_smp,'yyyyMMddHHmmss'),'yyyy-MM-dd HH:mm:ss'),
CASE WHEN APP_CHAN = 9 THEN chan_no ELSE APP_CHAN END chan_no,
a.child_chan,
a.app_ver,
from_unixtime(unix_timestamp(), 'yyyy-MM-dd HH:mm:ss')
from time_original_sjd_custpinf a
left join time_original_sjd_custiden b on a.cus_no = b.cus_no
left join time_original_sjd_custusrinf e on a.mbl_no = e.usr_no;

insert overwrite table warehouse_atomic_time_user partition(data_source)
select
a.user_code,
base64(encode(a.mobile,'utf8')),
md5(a.mobile),
concat(substr(a.mobile,1,3),'****',substr(a.mobile,8,4)),
a.reg_date,
if(c.create_date is not null,substr(c.create_date,1,10),null),
a.chan_code,
'1' as child_chan,
'' as app_version,
from_unixtime(unix_timestamp(), 'yyyy-MM-dd HH:mm:ss'),
b.mall_name_en
from time_original_jry_user_info a
left join warehouse_jry_mall_info b on a.app_code = b.mall_code
left join original_jry_user_auth c on a.user_code = c.user_code;

insert overwrite table warehouse_atomic_time_user partition(data_source='sjd')
select
a.cus_no,
base64(encode(a.mbl_no,'utf8')),
md5(mbl_no),
concat(substr(a.mbl_no,1,3),'****',substr(a.mbl_no,8,4)),
from_unixtime(unix_timestamp(concat(e.reg_dt,e.reg_tm),'yyyyMMddHHmmss'),'yyyy-MM-dd HH:mm:ss'),
from_unixtime(unix_timestamp(b.tm_smp,'yyyyMMddHHmmss'),'yyyy-MM-dd HH:mm:ss'),
CASE WHEN APP_CHAN = 9 THEN chan_no ELSE APP_CHAN END chan_no,
a.child_chan,
a.app_ver,
from_unixtime(unix_timestamp(), 'yyyy-MM-dd HH:mm:ss')
from time_original_sjd_custpinf a
left join time_original_sjd_custiden b on a.cus_no = b.cus_no
left join time_original_sjd_custusrinf e on a.mbl_no = e.usr_no;