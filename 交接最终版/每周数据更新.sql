-- RFM历史数据 add 20190529
INSERT overwrite TABLE warehouse_data_user_info_rfm_history PARTITION(extractday)
SELECT a.data_source,
       a.mbl_no,
       Rtype,
       Ftype,
       Mtype,
       concat(rtype,ftype,mtype) AS rfmvalue,
       current_date() AS etlday,
       date_sub(etlday,1) AS extractday
FROM warehouse_data_user_info_rfm AS a;

-- RFM趋势转化数据 add 20190529
INSERT overwrite TABLE warehouse_data_user_info_rfm_sum PARTITION(extractday)
SELECT data_source,
       rfmvalue,
       lastrfmvalue,
       count(DISTINCT mbl_no) AS usernum,
       extractday
FROM
  (SELECT a.data_source,
          a.mbl_no,
          a.rfmvalue,
          b.rfmvalue AS lastrfmvalue,
          a.extractday
   FROM warehouse_data_user_info_rfm_history AS a
   FULL JOIN warehouse_data_user_info_rfm_history AS b ON a.data_source=b.data_source
   AND a.mbl_no=b.mbl_no
   AND b.extractday =date_sub(current_date(),8)
   WHERE a.extractday =date_sub(current_date(),1)) AS a
GROUP BY data_source,
         rfmvalue,
         lastrfmvalue,
         extractday;