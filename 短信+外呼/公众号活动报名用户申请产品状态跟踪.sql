--------295	ͳ������		����				3����Ҫ������	2019.5.17	�ʹ���	
--------����Ǯ��	ÿ�ܶ�����	�̶�����	ȫ��Ʒ	����Ǯ��	���ںŻ�����û������Ʒ״̬����	
--------�������ṩ���û����ֻ��ţ�ƥ���û���ע��ʱ�䡢����ʱ�䡢�����Ʒ�����Ŷ�ȡ����ֽ�����ʱ��
SELECT a1.mbl_no_md5,
       a1.mbl_no,
       a1.registe_date,
       a2.product_name,
       a2.apply_time,
       a2.credit_time,
       a2.amount,
       a3.cash_time,
       a3.cash_amount     
FROM warehouse_atomic_user_info a1
left join warehouse_data_user_review_info a2
  on a1.mbl_no = a2.mbl_no
 and a1.data_source = a2.data_source
left join warehouse_data_user_withdrawals_info a3
  on a1.mbl_no = a3.mbl_no
 and a1.data_source = a3.data_source
 and a2.product_name = a3.product_name
WHERE a1.data_source = 'xyqb'
  and a1.mbl_no_md5 IN ('8e89812b6f116d959ddfea03cfa766f7',
                        'a428c9747493395603c90ef3b0f90096',
                        'ac1692a6df83ae18c12d5c68b9106742',
                        '1222d4d14d28e1f9c2cb8764df4071bb',
                        'c7e0652b24048821031f2ebcef9358a8',
                        '955970cc3e2f918cdc578d5918dbcc78',
                        'a428c9747493395603c90ef3b0f90096',
                        '5653c5fb306aabd300a97fd367d8d5d9',
                        'cf36c0478c0917338966153dc7af1174',
                        'eda8aaec12d7a272ff54c76cfbb44815',
                        '95a9e17bc7114cd1872373a5f472f665',
                        '269661790b94c4e09b005da52864cddf',
                        'bfd5018ef14f74a416605620ebc5cb6f',
                        '953b35c674bd1248742e1e454554958b',
                        '8bc184e8e7eba43e9d94be59084bfddf')