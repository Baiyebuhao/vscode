----------点击申请 马上-随借随还
select extractday,count(distinct b3.mbl_no)
from
(select extractday,mbl_no
from warehouse_newtrace_click_record b1
where extractday >= '2019-04-19'
and product_id in ('2015070216330003','2017061510060016','40000001')
and page_enname = 'product_detail'
and button_enname = 'apply'
and 
UNION
select extractday,mbl_no
from warehouse_atomic_user_action b2
where extractday >= '2019-04-19'
and product_id in ('2015070216330003','2017061510060016','40000001')
and event_id = 'apply'
) b3
group by extractday

-----金融苑微信链接（埋点不全）
select extractday,count(distinct mbl_no)
from warehouse_newtrace_click_record a
where extractday >= '2019-04-19'
and channel = 'jrywxlj'
group by extractday

select distinct chan_no,chan_no_desc,channel
from warehouse_atomic_user_action a
where extractday >= '2019-04-19'
and channel = 'jrywxlj'
distinct data_channel,childchan,channel

select distinct data_channel,childchan,channel
from warehouse_newtrace_click_record a
where extractday >= '2019-04-19'
