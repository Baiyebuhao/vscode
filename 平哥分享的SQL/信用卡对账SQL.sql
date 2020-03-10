二、渠道对账规则建议：
    1、返数有【未加密手机号码】情况：
        通过【未加密手机号码】匹配系统中用户注册信息，成功匹配则计算为用户对应渠道或合伙人的发展量；如遇匹配上多个用户注册信息，则取注册时间最早的记录。
    2、返数无【未加密手机号码】情况：
       1）通过【加密手机号码】+【未加密客户姓名】匹配系统中用户注册信息，成功匹配则计算为用户对应渠道或合伙人的发展量；
       如遇匹配上多个用户注册信息，则取注册时间最早的记录。
       2）通过【加密手机号码】匹配系统中用户注册信息，成功匹配唯一记录则计算为用户对应渠道或合伙人的发展量；
   上述规则按照先后顺序执行优先级，如优先级靠前匹配成功则不参与后续规则。
##上海和交通银行  明文手机号码方式
##号码先转换成MD5方式   
select b.mbl_no_md5
       ,b.mbl_no
       ,b.name
       ,b.chan_no 
       ,b.chan_no_desc
       ,b.isp
       ,b.province_desc
       ,b.city_desc
	   ,b.data_source
  from warehouse_atomic_user_info as b 
  where b.mbl_no_md5 in(
	  '678affd11560b2874142d69b9f8f2c92',
      'e3839fc3c1f1efcfd57789ca97eeca60')
   and b.data_source='sjd';


##兴业银行信用卡  带*加密手机号码方式
##将加密的手机号码、姓名导入hive
DROP TABLE zjp_xyk_mbl;
CREATE TEMPORARY TABLE zjp_xyk_mbl(
mbl_no VARCHAR(32),
name VARCHAR(32)
);
--TRUNCATE table zjp_xyk_mbl;

insert into zjp_xyk_mbl values
('133****3628 ','孙立新'),
('133****3628 ','孙立新');

SELECT a.*,
       concat(a.mbl_no_un,'_',a.name) AS keyword,
       'BOTH' AS TYPE
FROM
  (SELECT a.mbl_no AS mbl_no_un,
          a.name,
          b.mbl_no,
          b.mbl_no_md5,
          b.cus_no,
          b.chan_no_desc,
          b.province_desc,
          b.city_desc,
          b.isp,
          b.invent_mbl,
          row_number() over (partition BY a.mbl_no,a.name
                             ORDER BY cus_no) AS num
   FROM zjp_xyk_mbl AS a
   JOIN warehouse_atomic_user_info b ON trim(a.mbl_no)=b.mbl_no_un
   AND a.name=b.name
   WHERE b.data_source='sjd') AS a
WHERE a.num=1
UNION ALL
SELECT a.*,
       concat(a.mbl_no_un,'_',a.name) AS keyword,
       'PHONE' AS TYPE
FROM
  (SELECT a.mbl_no AS mbl_no_un,
          a.name,
          b.mbl_no,
          b.mbl_no_md5,
          b.cus_no,
          b.chan_no_desc,
          b.province_desc,
          b.city_desc,
          b.isp,
          b.invent_mbl,
          row_number() over (partition BY a.mbl_no,a.name
                             ORDER BY cus_no) AS num
   FROM zjp_xyk_mbl AS a
   JOIN warehouse_atomic_user_info b ON trim(a.mbl_no)=b.mbl_no_un
   WHERE b.data_source='sjd') AS a
LEFT JOIN
  (SELECT a.*,
          b.cus_no,
          b.mbl_no,
          row_number() over (partition BY a.mbl_no,a.name
                             ORDER BY cus_no) AS num
   FROM zjp_xyk_mbl AS a
   JOIN warehouse_atomic_user_info b ON trim(a.mbl_no)=b.mbl_no_un
   WHERE b.data_source='sjd') AS b ON a.mbl_no=b.mbl_no
AND b.num=2
LEFT JOIN
  (SELECT a.mbl_no AS mbl_no_un,
          a.name,
          b.mbl_no,
          b.mbl_no_md5,
          b.cus_no,
          b.chan_no_desc,
          b.province_desc,
          b.city_desc,
          b.isp,
          b.invent_mbl,
          row_number() over (partition BY a.mbl_no,a.name
                             ORDER BY cus_no) AS num
   FROM zjp_xyk_mbl AS a
   JOIN warehouse_atomic_user_info b ON trim(a.mbl_no)=b.mbl_no_un
   AND a.name=b.name
   WHERE b.data_source='sjd') AS c ON a.mbl_no_un=c.mbl_no_un
AND c.num=1
WHERE a.num=1
  AND b.mbl_no IS NULL
  AND c.mbl_no_un IS NULL;


