0301-0319新注册用户数据+点击申请产品数
select * from warehouse_atomic_user_info

where registe_date > '2019-03-01'
and data_source = 'sjd'

3月1日-3月19日注册用户
1	mbl_no	string	联系手机号
2	sex_code	string	性别
3	sex_desc	string	性别描述
4	age	int	客户年龄
5   chan_no	string	渠道编号
6	chan_no_desc	string	渠道名称
7 	child_chan	string	子渠道
8 	os_type	string	系统类型
9 	os_version	string	系统版本
10	mbl_type	string	注册手机类型
11	imei	string	手机设备号

            12 对应设备手机号数量   ----（用户表关联，分组汇总）
			(select imei,count(mbl_no)
			from warehouse_atomic_user_info
			where registe_date > '2019-03-01'
            and data_source = 'sjd'
			and imei <> 'NULL'
			group by imei)
			
13	province_code	string	省份代码
14	province_desc	string	省份名称描述
15	city_code	string	城市代码
16	city_desc	string	城市名称描述
            17 经度/维度；         -----（用户点击表）
			
			(select mbl_no,min(extractday),min(longitude),min(latitude)
            from warehouse_newtrace_click_record a5
            where platform = 'sjd'
            and extractday >= '2019-03-01'
            group by mbl_no)
									
      ----- 4.12.网络类型；          （未入库，无法取出）
      ----- 4.13.网络名称；
18  registe_date	string	注册时间

            19 注册时点：      -----（all_process表，取注册时点）    
			(select mbl_no,action_date,action_time
			from warehouse_atomic_all_process_info
			where action_name = '注册'
			and data_source = 'sjd'
			and action_date > '2019-03-01')

			
20	edu_level_code	string	教育程度
21	edu_level_desc	string	教育程度描述			
22	nation	string	民族
23	emp_code	string	职业编码
24	emp_desc	string	职业描述
            25 注册当日，申请的产品数（点击立即申请）；   ----（用户申请表-分组汇总）
			(select extractday,mbl_no,
            count (distinct product_name) as cs
            from warehouse_data_user_action_day a
            where applypv > '0'
            and extractday >= '2019-03-01'
            and product_name <> 'NULL'
			and mbl_no <> 'NULL'
            group by extractday,mbl_no)
						
26	isp	string	运营商





点击申请产品数


select extractday,mbl_no,
       count (distinct product_name) as cs
from warehouse_data_user_action_day a
where applypv > '0'
and extractday >= '2019-03-01'
and product_name <> 'NULL'
group by extractday,mbl_no