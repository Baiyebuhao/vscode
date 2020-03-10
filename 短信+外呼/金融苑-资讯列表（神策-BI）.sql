1.资讯（热门资讯）
select extractday,info_name,
count (distinct case 
                            when (button_enname = 'news')
              then mbl_no end) as zx,
       count (distinct case 
                            when (button_enname = 'more_news')
              then mbl_no end) as gdzx
from warehouse_newtrace_click_record a
where platform = 'jry'
and page_enname = 'supermarket'
and page_name = '首页'
and extractday = date_sub(current_date(),1)
group by extractday,info_name

2.资讯（资讯频道-首页）（TAB栏）
select extractday,page_name,tab_val,
count(distinct mbl_no) as rs,
count(mbl_no) as cs
from warehouse_newtrace_click_record        
where extractday = date_sub(current_date(),1)
and page_enname = 'news_channel'
and button_enname = 'table'
group by extractday,page_name,tab_val
3.资讯（资讯列表）
select extractday,page_name,tab_val,info_name,
count(distinct mbl_no) as rs,
count(mbl_no) as cs
from warehouse_newtrace_click_record        
where extractday = date_sub(current_date(),1)
and page_enname = 'news_channel'
and button_enname = 'loan'
group by extractday,page_name,tab_val,info_name
4.资讯（资讯广告详情）
select page_name,product_name,button_enname,
count(distinct mbl_no) as rs,
count(mbl_no) as cs
from warehouse_newtrace_click_record        
where extractday = date_sub(current_date(),1)
and page_enname = 'news_detail'
group by page_name,product_name,button_enname

