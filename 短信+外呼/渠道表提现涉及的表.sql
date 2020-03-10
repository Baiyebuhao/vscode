渠道表提现制作涉及的表

desc warehouse_atomic_msd_cashord_result_info                              loan_amount  分
desc warehouse_atomic_msd_withdrawals_result_info                          放款额total_amount 分
desc warehouse_atomic_zhongyou_withdrawals_result_info                     loan_amount 元
desc warehouse_atomic_zhaolian_withdrawals_result_info                     总金额install_total_amt  （分）
desc warehouse_atomic_qianbao_withdrawals_result_info                      提现额total_amount = 提现金额cash_amount	string	（分）


select * from warehouse_atomic_msd_cashord_result_info a

select * from warehouse_atomic_msd_withdrawals_result_info b

select * from warehouse_atomic_zhongyou_withdrawals_result_info c

select * from warehouse_atomic_zhaolian_withdrawals_result_info d

select * from warehouse_atomic_qianbao_withdrawals_result_info e