��ʵ©������û���

select extractday,product_name,data_source,count(distinct mbl_no)
from 
   (select mbl_no,data_source,register_date,extractday,applypv,product_name 
    from 
     (select b.mbl_no,b.data_source,b.register_date,a.extractday,a.applypv,a.product_name 
	    from default.warehouse_data_user_action_day a
		 left join 
		 (select mbl_no,data_source,min(register_date) as register_date
			from default.warehouse_atomic_register_process_info 
			group by mbl_no,data_source) b                                                     ---------------��Сע������
		on a.mbl_no=b.mbl_no and a.data_source = b.data_source and a.mbl_no != '')c
	where extractday = register_date) d
WHERE applypv > 0
and extractday = '2018-12-24'
and product_name in ('����滹-����','�ֽ����-����','�ֽ����-����','�ֽ����-����ջ�','�ֽ����-��ҵ����','�ֽ����-С���')
group by extractday,product_name,data_source



(
= '2018-12-24'
between '2018-12-21' and '2018-12-23'
)
-------------------   '�ֽ����-���'
(
���ԭ���Ƿ�������
select * from warehouse_data_user_action_day                                  -------------------------����9�����
where extractday = '2018-12-24'
)
(
����Ƿ�������
select * from warehouse_atomic_user_action
where extractday = '2018-12-24'
)

(
select extractday,product_name,data_source,count(distinct mbl_no)
from 
   (select mbl_no,data_source,register_date,extractday,event_id,product_name 
    from 
	 (select b.mbl_no,b.data_source,b.register_date,a.extractday,a.event_id,a.product_name 
	    from default.warehouse_atomic_user_action a
		 left join 
		 (select mbl_no,data_source,min(register_date) as register_date
			from default.warehouse_atomic_register_process_info 
			group by mbl_no,data_source) b                                                     ---------------��Сע������
		on a.mbl_no=b.mbl_no and a.sys_id = b.data_source and a.mbl_no != '')c
		

	where extractday = register_date) d


where extractday = '2018-11-15'

and event_id = 'apply' 

and product_name in ('����滹','�ƶ�����-����','�ֽ����','�ֽ����-����',
'����','�ֽ����-����','����С���','�ֽ����-С���','���С��','�ֽ����-����ջ�')

group by extractday,product_name,data_source

)

