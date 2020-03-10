603 push需求  徐超     重要不紧急 纪春艳 平台运营 2019.9.17 2019.9.18 
一次性需求 业主贷 移动手机贷 移动手机贷 push营销 
按序号分包，包与包之间去重
1、2019年已实名用户中，用户测评填写有房信息的用户；
2、点击业主贷未提交申请用户 


(--用户测评填写有房信息的用户
select distinct mbl_no
from warehouse_atomic_evaluation_process_info a
where que_id = '2015070612070004'
  and TRIM(OPT_SEQ) = '1'
  and data_source = 'sjd')
(---验证
SELECT distinct B.mbl_no,
       A.QUE_ID AS que_id,
       A.QUE_SEQ AS que_seq,
       A.QUE_TIT AS que_tit,
       TRIM(B.OPT_SEQ) AS ans_seq,
       C.OPT_SEQ AS opt_seq,
       C.OPT_CONT AS opt_cont
FROM warehouse_atomic_evaluation_quest A
JOIN warehouse_atomic_evaluation_process_info B ON A.QUE_ID = B.QUE_ID
                                               AND A.QUE_STS = '1'
JOIN warehouse_atomic_evaluation_answer C ON B.QUE_ID = C.QUE_ID
                                         AND b.opt_seq=c.opt_seq
WHERE A.QUE_ID = '2015070612070004'
ORDER BY QUE_ID,
         OPT_SEQ
limit 10
)
--2019年已实名用户中，用户测评填写有房信息的用户,近三月有点击
select a1.mbl_no,
       a1.data_source        
from warehouse_atomic_user_info a1

join warehouse_atomic_all_process_info a2
  on a1.mbl_no = a2.mbl_no 
 and a1.data_source = a2.data_source
join (select distinct mbl_no
      from warehouse_atomic_evaluation_process_info a
      where que_id = '2015070612070004'
        and TRIM(OPT_SEQ) = '1'
        and data_source = 'sjd') a3
  on a1.mbl_no = a3.mbl_no
join (select distinct mbl_no
      from warehouse_data_user_action_day a
      where extractday between '2019-06-17' and '2019-09-17'
	    and data_source = 'sjd') a4
		on a1.mbl_no = a4.mbl_no
where a1.data_source = 'sjd'
  and a2.action_name = '实名'
  and a2.action_date between '2019-01-01' and '2019-09-20'

--点击业主贷未提交申请用户（申请是线下返数）
select distinct a1.mbl_no
from warehouse_data_user_action_day a1
left outer join(select a.mbl_no_encode as mbl_no
                from warehouse_data_push_user a
				where a.data_code = 'SJD_RN292_001'
                )a2
				on a1.mbl_no = a2.mbl_no
where a1.product_name = '业主贷-招联'
  and a1.data_source = 'sjd'
  and a2.mbl_no is null
---入库1
(
INSERT INTO warehouse_data_push_user (mbl_no_encode,data_source,cus_no,data_code,marketting_type,rk_date)

SELECT DISTINCT c.mbl_no, 
                'sjd' as data_source, 
                a.cus_no,
                'SJD_RN292_001',
                "PS",
				'2019-09-18' as rk_date
FROM warehouse_atomic_user_info a

inner JOIN (
             ) AS c
             ON a.mbl_no = c.mbl_no  
               
WHERE a.data_source='sjd'  and length(c.mbl_no) > 4
)

(
---PUSH取数
select cus_no,data_code from warehouse_data_push_user a
where data_code = 'SJD_RN292_001'
)