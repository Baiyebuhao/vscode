现金分期-马上
表warehouse_atomic_msd_cashord_result_info
mbl_no	手机号码
apply_time	申请时间
approval_time	审批时间
approval_status	审批状态    U:正在处理（审核中）R:拒绝（审核未通过）A:通过（审核通过待确认合同）C:风控取消（审核未通过）
							N:签署（合同已签署）J:放弃（已取消）Q:客户主动取消（已取消）B:被驳回（资料重传）
approval_amount	放款金额
msd_return_time	马上返回时间
data_source	数据业务系统渠道


申请-授信-提现
SELECT a.mbl_no,
       a.data_source,
       a.min_date,
       a.approval_time,
       a.approval_status,
       a.approval_amount,
       a.msd_return_time,
       d.os_type
FROM
  (SELECT mbl_no,
          data_source,
          min(substring(apply_time,1,10)) AS min_date,
          approval_time,
          approval_status,
          approval_amount,
          msd_return_time
   FROM warehouse_atomic_msd_cashord_result_info
   GROUP BY mbl_no,
            data_source,
            approval_time,
            approval_status,
            approval_amount,
            msd_return_time) a,
     warehouse_atomic_user_info d
WHERE a.mbl_no = d.mbl_no
  AND substring(min_date,1,10) BETWEEN '2018-08-22' AND '2018-08-28'
GROUP BY a.mbl_no,
         a.data_source,
         a.min_date,
         a.approval_time,
         a.approval_status,
         a.approval_amount,
         a.msd_return_time,
         d.os_type

		 
二

SELECT a.mbl_no,
       a.data_source,
       a.min_date,
       a.sp_time,
       a.approval_status,
       a.approval_amount,
       a.msd_return_time,
       d.os_type
FROM
  (SELECT mbl_no,
          data_source,
          min(substring(apply_time,1,10)) AS min_date,
          substring(approval_time,1,10) AS sp_time,
          approval_status,
          approval_amount,
          msd_return_time
   FROM warehouse_atomic_msd_cashord_result_info
   GROUP BY mbl_no,
            data_source,
            approval_status,
            approval_amount,
			substring(apply_time,1,10),
			substring(approval_time,1,10),
            msd_return_time) a,
     warehouse_atomic_user_info d
WHERE a.mbl_no = d.mbl_no
  AND substring(min_date,1,10) BETWEEN '2018-08-22' AND '2018-08-28'
GROUP BY a.mbl_no,
         a.data_source,
         a.min_date,
         a.sp_time,
         a.approval_status,
         a.approval_amount,
         a.msd_return_time,
         d.os_type