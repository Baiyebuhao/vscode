--测评表
---调查问卷
warehouse_atomic_evaluation_quest
warehouse_atomic_evaluation_answer
warehouse_atomic_evaluation_process_info

SELECT B.JRN_NO,
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
WHERE B.JRN_NO = '142331901244005985'
ORDER BY QUE_ID,
         OPT_SEQ;
@所有人 这个是问卷调查的问题和答案的关联关系，如果要取最新的，需要取 warehouse_atomic_evaluation_process_info 最大的JRN_NO

