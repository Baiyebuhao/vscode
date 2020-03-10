真实漏斗


是否注册当日授信
CASE [finish_time]=[register_date] 
WHEN TRUE THEN '是' ELSE '否' END
是否注册当日申请
CASE [appl_time - 拆分 1]=[register_date] 
WHEN TRUE THEN '是' ELSE '否' END