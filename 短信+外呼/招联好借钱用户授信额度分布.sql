315	统计需求 徐超	1、紧急且重要	2019.5.28	李薇薇	金融苑	
一次性需求	招联好借钱	金融苑	金融苑	用户授信额度分布
	
金融苑招联好借钱用户授信额度分布（每1000块为一个区间）	文件单独发送

select mbl_no,
       data_source,
	   product_name,
	   amount
from warehouse_data_user_review_info a1
where product_name = '现金分期-招联'
  and status = '通过'
  and amount > '0'
------------
select data_source,
	   product_name,
       count(DISTINCT CASE
                          WHEN amount <= '1000' THEN mbl_no
                      END) AS dnum1,
       count(DISTINCT CASE
                          WHEN amount > '1000' and amount <= '2000' THEN mbl_no
                      END) AS dnum2,
       count(DISTINCT CASE
                          WHEN amount > '2000' and amount <= '3000' THEN mbl_no
                      END) AS dnum3,
       count(DISTINCT CASE
                          WHEN amount > '3000' and amount <= '4000' THEN mbl_no
                      END) AS dnum4,	
       count(DISTINCT CASE
                          WHEN amount > '4000' and amount <= '5000' THEN mbl_no
                      END) AS dnum5,  
       count(DISTINCT CASE
                          WHEN amount > '5000' and amount <= '6000' THEN mbl_no
                      END) AS dnum6,	
       count(DISTINCT CASE
                          WHEN amount > '6000' and amount <= '7000' THEN mbl_no
                      END) AS dnum7,
       count(DISTINCT CASE
                          WHEN amount > '7000' and amount <= '8000' THEN mbl_no
                      END) AS dnum8,					  
       count(DISTINCT CASE
                          WHEN amount > '8000' and amount <= '9000' THEN mbl_no
                      END) AS dnum9,					  
       count(DISTINCT CASE
                          WHEN amount > '9000' and amount <= '10000' THEN mbl_no
                      END) AS dnum10,
       count(DISTINCT CASE
                          WHEN amount > '10000' and amount <= '15000' THEN mbl_no
                      END) AS dnum11,	
       count(DISTINCT CASE
                          WHEN amount > '15000' and amount <= '20000' THEN mbl_no
                      END) AS dnum12,  
       count(DISTINCT CASE
                          WHEN amount > '20000' and amount <= '30000' THEN mbl_no
                      END) AS dnum13,	
       count(DISTINCT CASE
                          WHEN amount > '30000' and amount <= '40000' THEN mbl_no
                      END) AS dnum14,
       count(DISTINCT CASE
                          WHEN amount > '40000' and amount <= '50000' THEN mbl_no
                      END) AS dnum15,					  
       count(DISTINCT CASE
                          WHEN amount > '50000' and amount <= '60000' THEN mbl_no
                      END) AS dnum16,					  
       count(DISTINCT CASE
                          WHEN amount > '60000' and amount <= '70000' THEN mbl_no
                      END) AS dnum17,
       count(DISTINCT CASE
                          WHEN amount > '70000' and amount <= '80000' THEN mbl_no
                      END) AS dnum18
from warehouse_data_user_review_info a1
where product_name = '现金分期-招联'
  and status = '通过'
  and amount > '0'
group by data_source,product_name				  