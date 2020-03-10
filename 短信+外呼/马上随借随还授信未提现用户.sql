Ŀ���Ʒ������������滹
      1������ƽ̨��˫ƽ̨���ֿ���
      2���ְ���������˫ƽ̨�����������ɽ������ȡ300���û�
      3������ʱ��Σ�2018��1��1����2018��6��30��
      4����������˫ƽ̨��������滹����δ�����Һ������κ�������Ϊ�û��������ͻ��������������ڡ��������

##SJDƽ̨
select distinct
       a.data_source
       ,a.mbl_no
       ,b.name
       ,a.appl_time
       ,a.acc_lim/100 as acc_lim
  from default.warehouse_atomic_msd_review_result_info as a
  join default.warehouse_atomic_user_info as b
  on a.mbl_no=b.mbl_no and a.data_source=b.data_source
  left join default.warehouse_atomic_msd_withdrawals_result_info as d
  on a.mbl_no=d.mbl_no and a.data_source=d.data_source and a.contact_no=d.contact_no and d.ltd_lend_amt>0
  left join(select mbl_no
       ,data_source
       ,substr(appl_time,1,10) as apply_time
       ,'Ǯ���״�' product_name
       ,case when status in('apply_success','block_up') then cast(acc_lim as double) end cash
  from default.warehouse_atomic_qianbao_review_result_info
  union all
  select mbl_no
         ,data_source
         ,apply_time
         ,'�����ֽ����' product_name
         ,case when approve_status='����ͨ��' then approve_amount*100 end cash
    from default.warehouse_atomic_zhongyou_review_result_info
  union all 
  select mbl_no
         ,data_source
         ,lending_time
         ,'С���' product_name
         ,case when status='success' then applyamount*100 end applyamount
    from default.warehouse_atomic_xiaoyudian_withdrawals_result_info
  union all
  select mbl_no
         ,data_source
         ,substr(apply_time,1,10) as apply_time
         ,'������' product_name
         ,case when contract_status='����ɹ�' then cast(loan_amount as double) *100 end cash
    from default.warehouse_atomic_lkl_withdrawals_result_info
  union all
  select mbl_no
         ,data_source
         ,substr(appl_time,1,10) as apply_time
         ,'��������滹' product_name
         ,case when appral_res='ͨ��' then acc_lim end acc_lim
    from default.warehouse_atomic_msd_review_result_info
  union all
  select mbl_no
         ,data_source
         ,apply_time
         ,'�����ֽ����' product_name
         ,case when approval_status in('A','N') then approval_amount end cash
    from default.warehouse_atomic_msd_cashord_result_info
  union all
  select mbl_no
         ,data_source
         ,apply_time
         ,'����ֽ����' product_name
         ,case when status_code='0' then total_limit end total_limit
    from default.warehouse_atomic_diandian_review_result_info
  union all
  select mbl_no
         ,data_source
         ,concat(substr(apply_time,1,4),'-',substr(apply_time,5,2),'-',substr(apply_time,7,2)) as apply_time
         ,case when product_code='XJXE001' then '�������ڴ�'
         when product_code='XJBL001' then '���������'
         when product_code='XJDQ001' then '�������ڴ�'
         when product_code='XJYZ001' then '����ҵ����'
         when product_code='XJGJJ001' then '�����������籣��' end product_name
         ,case when result_desc='����ɹ�' then credit_limit end cash
    from default.warehouse_atomic_zhaolian_review_result_info
  union all
  select apply_mobile
         ,data_source
         ,substr(limit_apply_time,1,10) as apply_time
         ,'�ڰ�����' product_name
         ,cast(credit_amount as double) as credit_amount
    from default.warehouse_atomic_zhongan_review_result_info) as c
  on a.mbl_no=c.mbl_no and a.data_source=c.data_source and substr(a.credit_time,1,10)<c.apply_time
  where substr(a.appl_time,1,10) between '2018-01-01' and '2018-06-30'
    and a.appral_res='ͨ��' 
    and a.appl_status='ǩ��'
    and a.data_source='sjd'
    and c.mbl_no is null
    and d.mbl_no is null
   order by a.appl_time desc limit 300

##XYQBƽ̨
select distinct
       a.data_source
       ,a.mbl_no
       ,b.name
       ,a.appl_time
       ,a.acc_lim/100 as acc_lim
  from default.warehouse_atomic_msd_review_result_info as a
  join default.warehouse_atomic_user_info as b
  on a.mbl_no=b.mbl_no and a.data_source=b.data_source
  left join default.warehouse_atomic_msd_withdrawals_result_info as d
  on a.mbl_no=d.mbl_no and a.data_source=d.data_source and a.contact_no=d.contact_no and d.ltd_lend_amt>0
  left join(select mbl_no
       ,data_source
       ,substr(appl_time,1,10) as apply_time
       ,'Ǯ���״�' product_name
       ,case when status in('apply_success','block_up') then cast(acc_lim as double) end cash
  from default.warehouse_atomic_qianbao_review_result_info
  union all
  select mbl_no
         ,data_source
         ,apply_time
         ,'�����ֽ����' product_name
         ,case when approve_status='����ͨ��' then approve_amount*100 end cash
    from default.warehouse_atomic_zhongyou_review_result_info
  union all 
  select mbl_no
         ,data_source
         ,lending_time
         ,'С���' product_name
         ,case when status='success' then applyamount*100 end applyamount
    from default.warehouse_atomic_xiaoyudian_withdrawals_result_info
  union all
  select mbl_no
         ,data_source
         ,substr(apply_time,1,10) as apply_time
         ,'������' product_name
         ,case when contract_status='����ɹ�' then cast(loan_amount as double) *100 end cash
    from default.warehouse_atomic_lkl_withdrawals_result_info
  union all
  select mbl_no
         ,data_source
         ,substr(appl_time,1,10) as apply_time
         ,'��������滹' product_name
         ,case when appral_res='ͨ��' then acc_lim end acc_lim
    from default.warehouse_atomic_msd_review_result_info
  union all
  select mbl_no
         ,data_source
         ,apply_time
         ,'�����ֽ����' product_name
         ,case when approval_status in('A','N') then approval_amount end cash
    from default.warehouse_atomic_msd_cashord_result_info
  union all
  select mbl_no
         ,data_source
         ,apply_time
         ,'����ֽ����' product_name
         ,case when status_code='0' then total_limit end total_limit
    from default.warehouse_atomic_diandian_review_result_info
  union all
  select mbl_no
         ,data_source
         ,concat(substr(apply_time,1,4),'-',substr(apply_time,5,2),'-',substr(apply_time,7,2)) as apply_time
         ,case when product_code='XJXE001' then '�������ڴ�'
         when product_code='XJBL001' then '���������'
         when product_code='XJDQ001' then '�������ڴ�'
         when product_code='XJYZ001' then '����ҵ����'
         when product_code='XJGJJ001' then '�����������籣��' end product_name
         ,case when result_desc='����ɹ�' then credit_limit end cash
    from default.warehouse_atomic_zhaolian_review_result_info
  union all
  select apply_mobile
         ,data_source
         ,substr(limit_apply_time,1,10) as apply_time
         ,'�ڰ�����' product_name
         ,cast(credit_amount as double) as credit_amount
    from default.warehouse_atomic_zhongan_review_result_info) as c
  on a.mbl_no=c.mbl_no and a.data_source=c.data_source and substr(a.credit_time,1,10)<c.apply_time
  where substr(a.appl_time,1,10) between '2018-01-01' and '2018-06-30'
    and a.appral_res='ͨ��' 
    and a.appl_status='ǩ��'
    and a.data_source='xyqb'
    and c.mbl_no is null
    and d.mbl_no is null
   order by a.appl_time desc limit 300
