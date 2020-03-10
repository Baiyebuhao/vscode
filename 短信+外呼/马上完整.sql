select prod_nm,substr(apply_time,1,10) as apply_time,
       count(case when data_source='sjd' then mbl_no end) as sjdnum1
       ,count(case when data_source='xyqb' then mbl_no end) as xyqbnum1
       ,count(distinct case when data_source='sjd' then mbl_no end) as sjdnum2
       ,count(distinct case when data_source='xyqb' then mbl_no end) as xyqbnum2
  from newdatahouse.theme_sjd_xyqb_prod_credit_info as a
  where substr(apply_time,1,10)>='2018-08-01'
  group by prod_nm
       ,substr(apply_time,1,10)