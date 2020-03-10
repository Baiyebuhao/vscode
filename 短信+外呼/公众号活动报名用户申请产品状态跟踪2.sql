319	统计需求  徐超  1、紧急且重要	2019.5.28	纪春艳	享宇钱包	
每周二下午	固定需求	全产品	享宇钱包	享宇钱包	公众号活动报名用户申请产品状态跟踪		
根据所提供的用户的手机号，匹配用户的注册时间、申请时间、申请产品、授信额度、提现金额、提现时间
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
  and a1.mbl_no_md5 IN ('9363803e847dd4ab38e8046cbf8c84da',
                        '8cae82f237d500b41ca21adb593bb036',
                        '9dc97090060ee20bc00d85916244ab39',
                        '8bc184e8e7eba43e9d94be59084bfddf',
                        '5130c6e7f8d0a720977f9690a3f6d63d',
                        'dd8106afec008ed7202600b2fd777f15',
                        'cc295d40469ce354db59d3207cbe7209',
                        '9705585c062a9de04a84a1cf8abadf33',
                        '3ca8c77c89d5825aa60fc91027ffd7e1',
                        '1d8c37b79f1f3faf1f53783c2898957d',
                        '895ad13de05e7e5aadcc100a0b30c440',
                        '80c0cb17418c4b8e07ae2eda08173af5',
                        '895ad13de05e7e5aadcc100a0b30c440',
                        '96c849f81777bda2bd678db37b8b39c0',
                        '3ecefeeff9cecd01e4261230230e47c8',
                        'd26dce9e6fc41f2a483ce114991934d2',
                        '8a5a7bac808a83196d376a175f108ee6')

