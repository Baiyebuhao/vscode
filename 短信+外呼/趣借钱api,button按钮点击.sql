-----趣借钱api,button按钮点击

SELECT a.pagenamecn,
       a.click_namecn,
       b.product_id,
       count(a.phone_number),
       count(DISTINCT a.phone_number)
FROM
  (SELECT *
   FROM warehouse_atomic_newframe_burypoint_buttonoperations
   WHERE substr(extractday,1,10) = '2019-10-25' ) a
LEFT JOIN
  (SELECT *
   FROM warehouse_atomic_newframe_burypoint_pageoperations
   WHERE substr(extractday,1,10) = '2019-10-25') b ON a.start_id = b.start_id

   
inner join (select distinct mbl_no from warehouse_atomic_user_info
where registe_date ='2019-10-29') c  on a.phone_number = c.mbl_no

WHERE b.product_id ='60000001'
GROUP BY a.pagenamecn,
         a.click_namecn,
         b.product_id;



----
----
SELECT a.pagenamecn,
       b.product_id,
       count(a.phone_number),
       count(DISTINCT a.phone_number)
FROM
  (SELECT *
   FROM warehouse_atomic_newframe_burypoint_buttonoperations
   WHERE substr(extractday,1,10) = '2019-10-25' ) a
LEFT JOIN
  (SELECT *
   FROM warehouse_atomic_newframe_burypoint_pageoperations
   WHERE substr(extractday,1,10) = '2019-10-25') b ON a.start_id = b.start_id
WHERE b.product_id ='60000001'
GROUP BY a.pagenamecn,
         b.product_id