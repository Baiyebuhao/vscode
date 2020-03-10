---over函数讲解（SQL）
(
SELECT a.*,
       row_number() over(partition BY platform,
                                      device_id,
                                      extractday
                         ORDER BY date_time) AS num
FROM
  (SELECT a.*,
          first_value(page_enname) over(partition BY platform,device_id,extractday
                                    ORDER BY date_time ROWS BETWEEN 1 preceding AND 1 preceding) AS first_page_enname
   FROM warehouse_newtrace_click_record AS a
   WHERE device_id IS NOT NULL
     AND device_id NOT IN('',
                          'nosign') ) AS a
WHERE page_enname != first_page_enname
  OR first_page_enname IS NULL;
)
  
  
解析：
1 preceding = 本行之前的1行
1 following = 本行之后的1行


关键是明白窗口在哪里控制。
over()的括号里面的都是窗口控制的内容。
partition BY 控制窗口的分组依据，
ORDER BY 控制窗口里面的顺序，
ROWS 控制分组后的前后几行