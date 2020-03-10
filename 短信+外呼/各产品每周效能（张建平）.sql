---各产品每周效能（张建平）
SELECT a.data_source,
       a.year,
       a.week,
       min(a.extractday) AS extractday,
       a.product_name,
       sum(regnum) AS regnum,
       sum(chknum) AS chknum,
       sum(newdnum) AS newdnum,
       sum(applynum) AS applynum,
       sum(creditnum) AS creditnum,
       sum(credit_amount) AS credit_amount,
       sum(cashnum) AS cashnum,
       sum(cash_amount) AS cash_amount,
       sum(cash_amount*if(b.pre is null,0,b.pre/100)) AS income_amount
FROM
  (SELECT a.data_source,
          a.year,
          a.week,
          a.extractday,
          a.product_name,
          regnum,
          chknum,
          newdnum,
          0 AS applynum,
          0 AS creditnum,
          0 AS credit_amount,
          0 AS cashnum,
          0 AS cash_amount
   FROM warehouse_data_user_action_end_weekly AS a
   JOIN
     (SELECT data_source,
             year(action_date) AS YEAR,
             weekofyear(action_date) AS week,
             sum(regnum) AS regnum,
             sum(chknum) AS chknum
      FROM warehouse_data_daliy_report
      GROUP BY data_source,
               year(action_date),
               weekofyear(action_date)) AS b 
   ON a.data_source=b.data_source
   AND a.YEAR=b.YEAR
   AND a.week=b.week
   WHERE a.product_name IS NOT NULL
    
   UNION ALL 
   
   SELECT a.data_source,
                    year(a.extractday),
                    weekofyear(a.extractday),
                    min(a.extractday) AS extractday,
                    a.product_name,                    
                    0 AS regnum,
                    0 AS chknum,
                    0 AS newdnum,
                    sum(cast(a.applydnum AS decimal(12,2))/a.num1*a.pre) AS applynum,
                    sum(cast(a.creditdnum AS decimal(12,2))/a.num2*a.pre) AS creditnum,
                    sum(a.creditamount*a.pre) AS credit_amount,
                    sum(cast(a.cashdnum AS decimal(12,2))/a.num3*a.pre) AS cashnum,
                    sum(a.cashamount*a.pre) AS cash_amount
   FROM
     (SELECT sum(if(applynum>0,1,0)) over(partition BY data_source,year(extractday),weekofyear(extractday),mbl_no,product_name) AS num1,
             sum(if(creditnum>0,1,0)) over(partition BY data_source,year(extractday),weekofyear(extractday),mbl_no,product_name) AS num2,
             sum(if(cashnum>0,1,0)) over(partition BY data_source,year(extractday),weekofyear(extractday),mbl_no,product_name) AS num3,
             *
      FROM warehouse_data_user_review_withdrawals_info AS a
      WHERE pre>0) AS a
   JOIN warehouse_data_user_channel_info AS b 
   ON a.data_source=b.data_source
   AND a.mbl_no=b.mbl_no
   AND year(a.extractday)=year(b.register_date)
   AND weekofyear(a.extractday)=weekofyear(b.register_date)
   WHERE a.extractday <= date_sub(current_date(),1)
     AND a.product_name IS NOT NULL
   GROUP BY a.data_source,
            a.product_name,
            year(a.extractday),
            weekofyear(a.extractday)) AS a
left join warehouse_data_product_income_pre as b on a.product_name=b.product_name
GROUP BY a.data_source,
         a.year,
         a.week,
         a.product_name;