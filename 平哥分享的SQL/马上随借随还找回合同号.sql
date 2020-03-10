###目的：马上随借随还的提现记录无合同号，需要通过授信表及提现表找回合同号
#找回逻辑：
##1、通过提现表的平台、手机号码、申请时间匹配申请记录的合同号（申请时间因存储关系可能误差1S）
##2、通过提现表的平台、手机号码、申请时间匹配放款表记录的合同号（同条记录部分有合同号）
##3、通过提现表的平台、手机号码匹配申请表中记录的合同号（多个取其中一个合同号）
##优先级从上到下
CREATE TABLE tmp_zjp_msd_contact AS
SELECT a.data_source,
       a.mbl_no,
       a.total_amount,
       a.contact_no,
       a.msd_return_time,
       a.appl_time,
       b.contact_no contact_nob,
       d.contact_no contact_nod,
       e.contact_no contact_noe,
       c.contact_no contact_noc,
       CASE
           WHEN length(a.contact_no)>0 THEN a.contact_no
           WHEN length(b.contact_no)>0 THEN b.contact_no
           WHEN length(d.contact_no)>0 THEN d.contact_no
           WHEN length(e.contact_no)>0 THEN e.contact_no
           WHEN length(f.contact_no)>0 THEN f.contact_no
           WHEN length(c.contact_no)>0 THEN c.contact_no
           ELSE a.contact_no
       END contact_no_end  ##按优先级取合同号
FROM default.warehouse_atomic_msd_withdrawals_result_info AS a
LEFT JOIN
  (SELECT DISTINCT a.data_source,
                   a.mbl_no,
                   a.contact_no,
                   a.appl_time
   FROM default.warehouse_atomic_msd_review_result_info AS a
   WHERE length(a.contact_no)>0)AS b ON a.data_source=b.data_source
AND a.mbl_no=b.mbl_no
AND unix_timestamp(a.appl_time,
                   'yyyy-MM-dd hh:mm:ss') = unix_timestamp(b.appl_time,
                                                           'yyyy-MM-dd hh:mm:ss')
LEFT JOIN
  (SELECT DISTINCT a.data_source,
                   a.mbl_no,
                   a.contact_no,
                   a.appl_time
   FROM default.warehouse_atomic_msd_review_result_info AS a
   WHERE length(a.contact_no)>0)AS d ON a.data_source=d.data_source
AND a.mbl_no=d.mbl_no
AND unix_timestamp(a.appl_time,
                   'yyyy-MM-dd hh:mm:ss') = unix_timestamp(d.appl_time,
                                                           'yyyy-MM-dd hh:mm:ss')+1
LEFT JOIN
  (SELECT DISTINCT a.data_source,
                   a.mbl_no,
                   a.contact_no,
                   a.appl_time
   FROM default.warehouse_atomic_msd_review_result_info AS a
   WHERE length(a.contact_no)>0)AS e ON a.data_source=e.data_source
AND a.mbl_no=e.mbl_no
AND unix_timestamp(a.appl_time,
                   'yyyy-MM-dd hh:mm:ss') = unix_timestamp(e.appl_time,
                                                           'yyyy-MM-dd hh:mm:ss')-1
LEFT JOIN
  (SELECT a.data_source,
                   a.mbl_no,
                   max(a.contact_no) AS contact_no
   FROM default.warehouse_atomic_msd_review_result_info AS a
   WHERE length(a.contact_no)>0
   GROUP BY a.data_source,
            a.mbl_no)AS f ON a.data_source=f.data_source
AND a.mbl_no=f.mbl_no
LEFT JOIN
  (SELECT DISTINCT a.data_source,
                   a.mbl_no,
                   a.contact_no,
                   a.appl_time
   FROM default.warehouse_atomic_msd_withdrawals_result_info AS a
   WHERE a.total_amount >0
     AND length(a.contact_no)>0) AS c ON a.data_source=c.data_source
AND a.mbl_no=c.mbl_no
AND a.appl_time=c.appl_time
WHERE a.total_amount >0
  AND a.msd_return_time BETWEEN '2016-10-01' AND '2017-09-30';
  

SELECT count(1),
       sum(total_amount)
FROM tmp_zjp_msd_contact;
--250276	119513001349

SELECT count(1),sum(total_amount)
FROM warehouse_atomic_msd_withdrawals_result_info AS a
WHERE msd_return_time BETWEEN '2016-10-01' AND '2017-09-30'
  AND total_amount >0;
--250276	119513001349

select * from tmp_zjp_msd_contact as a where a.contact_no_end is null or contact_no_end ='';

