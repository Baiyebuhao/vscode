--性别
l_research_result
r_id   1951612270008087
answer 男 女
--年龄
c_customer
age
---job
sex   '1:男,0:女'
--地域
---1951612150008012
SELECT distinct answer
FROM `l_research_result`
where r_id = '1951612260008076'
本市/县户籍  本省户籍  本市户籍，原外地户籍  外省户籍（除福建、新疆、西藏）
---逾期
--1951612150008009
--行业
--1951612150008015 
--1951612150008011
--1951612150008013

--学历
l_research_result
r_id   1951612260008072
answer  大专   高中以下   本科  高中或同等职业教育  硕士及以上
--家庭
l_research_result
r_id   1951612270008088
answer 已婚 未婚  离异 丧偶

--房产
l_research_result
r_id  1951612150008005
answer  普通住宅  有其他的按揭住房  住宅式公寓  本按揭房为唯一住房  未交房  公寓

--客户分层：优质，普通，拒绝
u_marketing_research_task
customer_level  1-优质客户，2-普通客户，3-拒绝