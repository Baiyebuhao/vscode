--BI重建-分时注册实名
--每日分时注册2

select substr(registe_date,1,13) as registe_date_time,
       substr(registe_date,1,10) as registe_date,
       substr(registe_date,12,2) as registe_time,
	   data_source,
	   mall_name,
	   chan_no,
	   promoter_name,
	   case promoter_type when 1 then '安卓' when 2 then 'IOS' when 3 then 'H5' end promoter_type,
	   
	   count(distinct mbl_no) as mbl_mount,
	   count(distinct case when auth_state = '实名' then mbl_no end) as mbl_mount2

FROM
  (SELECT a1.mbl_no ,
          a1.data_source,
		  
		  a2.mall_code,       ---商城编码
		  a2.mall_name,       ---商城名
		  
          a1.chan_no,
		  a2.promoter_name,    ---渠道名称
		  a2.promoter_type,    ---渠道类型
		  
          a1.registe_date,               ---注册时间（年月日+时分秒）
          a1.authentication_date,        ---实名日期（年月日）

          if(a1.registe_date IS NOT NULL,'注册','未注册') AS reg_state,
          if(a1.authentication_date IS NOT NULL,'实名','未实名') AS auth_state
   FROM warehouse_atomic_time_user a1
   
   LEFT JOIN

     (SELECT a.promoter_code,
	         a.promoter_name,
			 a.promoter_type,
			 b.mall_code,
			 b.mall_name
      from warehouse_jry_business_promoter a --渠道
      LEFT JOIN warehouse_all_platform_mall_info b
      	   on a.general_code = b.mall_code) a2
		   
     on a1.chan_no = a2.promoter_code
    and a1.app_code=a2.mall_code
   WHERE a1.registe_date>=date_sub(current_date(),90)
     and a1.app_code is not null
   ) x

group by substr(registe_date,1,13),
         substr(registe_date,1,10),
         substr(registe_date,12,2),
	     data_source,
		 mall_name,
         chan_no,
	     promoter_name,
		 promoter_type
order by substr(registe_date,1,13) desc