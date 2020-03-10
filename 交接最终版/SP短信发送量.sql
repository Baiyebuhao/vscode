CREATE TABLE warehouse_data_sp_send_data
(corpid string comment '�˺�ID',
 num  bigint comment '������ ',
)comment 'SP���ŷ�������'
PARTITIONED BY (extractday string comment '����') ;

INSERT overwrite TABLE warehouse_data_sp_send_data partition (extractday)
SELECT a.corpid,
       count(1) AS num,
       substr(a.senddate,1,10) AS extractday
FROM warehouse_atomic_sp_vpx_senda_all AS a
WHERE a.isfinish='1'
GROUP BY a.corpid,
         substr(a.senddate,1,10);
            
INSERT overwrite TABLE warehouse_data_sp_send_data partition (extractday)
SELECT a.corpid,
       count(1) AS num,
       substr(a.senddate,1,10) AS extractday
FROM warehouse_atomic_sp_send_a_b AS a
WHERE a.isfinish='1'
GROUP BY a.corpid,
         substr(a.senddate,1,10);
	