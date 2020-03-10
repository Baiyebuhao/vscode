CREATE TABLE warehouse_data_channel_newuser_daily
(data_source string comment '����ƽ̨',
       extractday  string comment '��������',
       the_2nd_level  string comment '��������',
       the_3rd_level  string comment '��������',
       regnum  int comment 'ע����',
       chknum int comment 'ʵ����',
       apllynum int comment '������',
       creditnum int comment '������',
       cashnum int comment '������',
       allcash double comment '���ֽ��',
       cash01 double comment '����滹-����_�ſ���',
       cash02 double comment '����滹-�ڰ�_�ſ���',
       cash03 double comment '����滹-Ǯ���״�_�ſ���',
       cash04 double comment '�ֽ����-����_�ſ���',
       cash05 double comment '�ֽ����-����_�ſ���',
       cash06 double comment '�ֽ����-����ջ�_�ſ���',
       cash07 double comment '�ֽ����-���_�ſ���',
       cash08 double comment '�ֽ����-��ҵ����_�ſ���',
       cash09 double comment '�ֽ����-С���_�ſ���',
       cash10 double comment '�ֽ����-������_�ſ���',
       cash11 double comment '���ڴ�-����_�ſ���',
       cash12 double comment '�����-����_�ſ���',
       cash13 double comment '���ڴ�-����_�ſ���',
       cash14 double comment 'ҵ����-����_�ſ���'
  );


INSERT INTO warehouse_data_channel_newuser_daily
SELECT data_source,
       extractday,
       the_2nd_level,
       the_3rd_level,
       count(DISTINCT CASE
                          WHEN code='ע��' THEN mbl_no
                      END) AS regnum,
       count(DISTINCT CASE
                          WHEN code='ʵ��' THEN mbl_no
                      END) AS chknum,
       count(DISTINCT CASE
                          WHEN code='����' THEN mbl_no
                      END) AS apllynum,
       count(DISTINCT CASE
                          WHEN code='����' THEN mbl_no
                      END) AS creditnum,
       count(DISTINCT CASE
                          WHEN code='�ſ�' THEN mbl_no
                      END) AS cashnum,
       sum(allcash) AS allcash,
       sum(cash01) AS cash01,
       sum(cash02) AS cash02,
       sum(cash03) AS cash03,
       sum(cash04) AS cash04,
       sum(cash05) AS cash05,
       sum(cash06) AS cash06,
       sum(cash07) AS cash07,
       sum(cash08) AS cash08,
       sum(cash09) AS cash09,
       sum(cash10) AS cash10,
       sum(cash11) AS cash11,
       sum(cash12) AS cash12,
       sum(cash13) AS cash13,
       sum(cash14) AS cash14
FROM
  (SELECT 'ע��' AS code,
          a.data_source,
          a.register_date AS extractday,
          a.chk_date,
          a.the_2nd_level,
          a.the_3rd_level,
          a.mbl_no,
          0 AS allcash,
          0 AS cash01,
          0 AS cash02,
          0 AS cash03,
          0 AS cash04,
          0 AS cash05,
          0 AS cash06,
          0 AS cash07,
          0 AS cash08,
          0 AS cash09,
          0 AS cash10,
          0 AS cash11,
          0 AS cash12,
          0 AS cash13,
          0 AS cash14
   FROM warehouse_data_user_channel_info AS a
   UNION ALL SELECT 'ʵ��' AS code,
                    a.data_source,
                    a.chk_date AS extractday,
                    a.chk_date,
                    a.the_2nd_level,
                    a.the_3rd_level,
                    a.mbl_no,
                    0 AS allcash,
                    0 AS cash01,
                    0 AS cash02,
                    0 AS cash03,
                    0 AS cash04,
                    0 AS cash05,
                    0 AS cash06,
                    0 AS cash07,
                    0 AS cash08,
                    0 AS cash09,
                    0 AS cash10,
                    0 AS cash11,
                    0 AS cash12,
                    0 AS cash13,
                    0 AS cash14
   FROM warehouse_data_user_channel_info AS a
   UNION ALL SELECT '����' AS code,
                    a.data_source,
                    a.register_date AS extractday,
                    a.chk_date,
                    a.the_2nd_level,
                    a.the_3rd_level,
                    b.mbl_no,
                    0 AS cash,
                    0 AS cash01,
                    0 AS cash02,
                    0 AS cash03,
                    0 AS cash04,
                    0 AS cash05,
                    0 AS cash06,
                    0 AS cash07,
                    0 AS cash08,
                    0 AS cash09,
                    0 AS cash10,
                    0 AS cash11,
                    0 AS cash12,
                    0 AS cash13,
                    0 AS cash14
   FROM warehouse_data_user_channel_info AS a
   JOIN warehouse_data_user_review_info AS b ON a.data_source=b.data_source
   AND a.mbl_no=b.mbl_no
   AND a.register_date=b.apply_time
   UNION ALL SELECT '����' AS code,
                    a.data_source,
                    a.register_date AS extractday,
                    a.chk_date,
                    a.the_2nd_level,
                    a.the_3rd_level,
                    c.mbl_no,
                    0 AS cash,
                    0 AS cash01,
                    0 AS cash02,
                    0 AS cash03,
                    0 AS cash04,
                    0 AS cash05,
                    0 AS cash06,
                    0 AS cash07,
                    0 AS cash08,
                    0 AS cash09,
                    0 AS cash10,
                    0 AS cash11,
                    0 AS cash12,
                    0 AS cash13,
                    0 AS cash14
   FROM warehouse_data_user_channel_info AS a
   JOIN warehouse_data_user_review_info AS c ON a.data_source=c.data_source
   AND a.mbl_no=c.mbl_no
   AND a.register_date=c.credit_time
   AND c.status='ͨ��'
   UNION SELECT '�ſ�' AS code,
                a.data_source,
                a.register_date AS extractday,
                a.chk_date,
                a.the_2nd_level,
                a.the_3rd_level,
                d.mbl_no,
                d.cash_amount,
                CASE
                    WHEN product_name = '����滹-����' THEN cash_amount
                END cash01,
                CASE
                    WHEN product_name = '����滹-�ڰ�' THEN cash_amount
                END cash02,
                CASE
                    WHEN product_name = '����滹-Ǯ���״�' THEN cash_amount
                END cash03,
                CASE
                    WHEN product_name = '�ֽ����-����' THEN cash_amount
                END cash04,
                CASE
                    WHEN product_name = '�ֽ����-����' THEN cash_amount
                END cash05,
                CASE
                    WHEN product_name = '�ֽ����-����ջ�' THEN cash_amount
                END cash06,
                CASE
                    WHEN product_name = '�ֽ����-���' THEN cash_amount
                END cash07,
                CASE
                    WHEN product_name = '�ֽ����-��ҵ����' THEN cash_amount
                END cash08,
                CASE
                    WHEN product_name = '�ֽ����-С���' THEN cash_amount
                END cash09,
                CASE
                    WHEN product_name = '�ֽ����-������' THEN cash_amount
                END cash10,
                CASE
                    WHEN product_name = '���ڴ�-����' THEN cash_amount
                END cash11,
                CASE
                    WHEN product_name = '�����-����' THEN cash_amount
                END cash12,
                CASE
                    WHEN product_name = '���ڴ�-����' THEN cash_amount
                END cash13,
                CASE
                    WHEN product_name = 'ҵ����-����' THEN cash_amount
                END cash14
   FROM warehouse_data_user_channel_info AS a
   JOIN warehouse_data_withdrawals_info AS d ON a.data_source=d.data_source
   AND a.mbl_no=d.mbl_no
   AND a.register_date=d.cash_time) AS a
WHERE extractday <= date_sub(date(current_date()),1)
GROUP BY data_source,
         extractday,
         the_2nd_level,
         the_3rd_level