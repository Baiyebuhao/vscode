--BI 重构2
--分时注册，实名

registe_date	registe_time	data_source	chan_no	chan_name	mbl_mount	mbl_mount2

注册日期 注册小时 平台	
registe_date
registe_time
data_source
chan_no
chan_name
promoter_name
promoter_type
mall_code
mall_name
mbl_mount
mbl_mount2

select substr(registe_date,1,10) as registe_date,
       substr(registe_date,12,2) as registe_time,
	   data_source,
       chan_no,
	   promoter_name,
	   CASE WHEN promoter_type ='1' THEN 'android'
            WHEN promoter_type ='2' THEN 'ios'
            WHEN promoter_type ='3' THEN 'h5'
	   ELSE 'other' END promoter_type,
	   mall_code,
	   mall_name,
	   contact_name,
	   count(distinct mbl_no) as reg_mbl_mount,
	   count(distinct case when auth_state = '实名' then mbl_no end) as aut_mbl_mount
from
(
select a1.*,
       a2.promoter_code,  ---渠道编码
	   a2.promoter_name,  ---渠道名称
	   a2.promoter_type,  ---渠道类型
	   a2.mall_code,      ---商城编码(通用编码)
	   a2.mall_name,      ---商城名
	   a2.mall_name_en,   ---商城英文
	   a2.contact_name    ---联系人（商城管理员）
	   
FROM
  (SELECT a.mbl_no ,
          a.data_source,
          a.registe_date,               ---注册时间（年月日+时分秒）
          a.chan_no,
          a.app_code,                   ---商城编码(通用编码)
          a.authentication_date,        ---实名日期（年月日）
          substr(a.registe_date,1,10) AS dt,
          substr(a.registe_date,12,2) AS hr,
          if(a.registe_date IS NOT NULL,'注册','未注册') AS reg_state,
          if(a.authentication_date IS NOT NULL,'实名','未实名') AS auth_state
   FROM warehouse_atomic_time_user a
   WHERE a.registe_date>='2020-01-01') a1

LEFT JOIN
   (SELECT * 
    FROM warehouse_jry_business_promoter a --渠道
    LEFT JOIN warehouse_all_platform_mall_info b   --商城
           ON a.general_code = b.mall_code) a2
		      
ON a1.chan_no = a2.promoter_code   --渠道号
AND a1.app_code=a2.mall_code       --商城号
) a
where substr(registe_date,1,10) >= date_sub(date(current_date()),1)
group by substr(registe_date,1,10),
         substr(registe_date,12,2),
		 data_source,
		 chan_no,
		 promoter_name,
		 CASE WHEN promoter_type ='1' THEN 'android'
		      WHEN promoter_type ='2' THEN 'ios'
              WHEN promoter_type ='3' THEN 'h5'
		 ELSE 'other' END,
		 mall_code,
		 mall_name,
		 contact_name