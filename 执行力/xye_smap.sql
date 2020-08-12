/*
Navicat MySQL Data Transfer

Source Server         : 华为云重构mysql
Source Server Version : 50641
Source Host           : 10.200.1.4:3306
Source Database       : xye_smap

Target Server Type    : MYSQL
Target Server Version : 50641
File Encoding         : 65001

Date: 2020-07-27 10:36:39
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for entity
-- ----------------------------
DROP TABLE IF EXISTS `entity`;
CREATE TABLE `entity` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `service_id` varchar(6) COLLATE utf8_bin DEFAULT NULL COMMENT 'service的唯一标识',
  `entity_name` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT 'entity的唯一标识',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `modify_time` datetime DEFAULT NULL COMMENT '修改时间',
  `entity_desc` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT 'entity描述',
  `is_delete` varchar(1) COLLATE utf8_bin DEFAULT NULL COMMENT '0-未删除  1-已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for fence_district
-- ----------------------------
DROP TABLE IF EXISTS `fence_district`;
CREATE TABLE `fence_district` (
  `id` bigint(255) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `gengraphical_id` varchar(40) COLLATE utf8_bin DEFAULT NULL COMMENT '围栏id列表',
  `keyword` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '行政区划',
  `fence_id` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '百度围栏的唯一标识',
  `district` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '行政区划描述',
  `is_delete` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT '0-未删除  1-已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for geographical_fence
-- ----------------------------
DROP TABLE IF EXISTS `geographical_fence`;
CREATE TABLE `geographical_fence` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `service_id` varchar(6) DEFAULT NULL COMMENT 'service的唯一标识',
  `fence_name` varchar(128) DEFAULT NULL COMMENT '围栏名称',
  `monitored_person` varchar(255) DEFAULT NULL COMMENT '监控对象的entity_name',
  `vertexes` text COMMENT '经纬度顺序为：纬度,经度；',
  `coord_type` varchar(6) DEFAULT NULL COMMENT '坐标类型',
  `denoise` varchar(20) DEFAULT NULL COMMENT '围栏去噪 单位米',
  `fence_id` varchar(255) DEFAULT NULL COMMENT '围栏的唯一标识',
  `district` varchar(255) DEFAULT NULL COMMENT '行政区划描述',
  `create_time` datetime DEFAULT NULL COMMENT '围栏创建时间',
  `modify_time` datetime DEFAULT NULL COMMENT '围栏修改时间',
  `shape` varchar(10) DEFAULT NULL COMMENT '围栏形状',
  `offset` varchar(20) DEFAULT NULL COMMENT '偏移距离 单位米',
  `latitude` varchar(255) DEFAULT NULL COMMENT '纬度',
  `longitude` varchar(255) DEFAULT NULL COMMENT '纬度',
  `radius` varchar(255) DEFAULT NULL COMMENT '半径  米',
  `keyword` varchar(255) DEFAULT NULL COMMENT '行政区划',
  `is_delete` char(3) DEFAULT NULL COMMENT '判断是否删除 0-未删除 1-已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_administrative_division
-- ----------------------------
DROP TABLE IF EXISTS `s_administrative_division`;
CREATE TABLE `s_administrative_division` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL COMMENT '名称',
  `code` varchar(100) DEFAULT NULL COMMENT '编码',
  `provinceCode` varchar(100) DEFAULT NULL COMMENT '省级编码',
  `cityCode` varchar(100) DEFAULT NULL COMMENT '市级编码',
  `areaCode` varchar(100) DEFAULT NULL COMMENT '区县代码',
  `streetCode` varchar(100) DEFAULT NULL COMMENT '乡镇代码',
  `parentid` bigint(20) DEFAULT NULL COMMENT '父级ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  UNIQUE KEY `code` (`code`) USING BTREE,
  KEY `parentid` (`parentid`) USING BTREE,
  KEY `provinceCode` (`provinceCode`) USING BTREE,
  KEY `cityCode` (`cityCode`) USING BTREE,
  KEY `areaCode` (`areaCode`) USING BTREE,
  KEY `streetCode` (`streetCode`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1515137 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_administrative_latlng
-- ----------------------------
DROP TABLE IF EXISTS `s_administrative_latlng`;
CREATE TABLE `s_administrative_latlng` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `adid` bigint(20) DEFAULT NULL COMMENT '行政区域ID',
  `latlng` longtext COMMENT '经纬度数据',
  `createtime` datetime DEFAULT CURRENT_TIMESTAMP,
  `adname` varchar(4000) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  UNIQUE KEY `adid` (`adid`) USING BTREE,
  CONSTRAINT `s_administrative_latlng_ibfk_1` FOREIGN KEY (`adid`) REFERENCES `s_administrative_division` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_app_agreement
-- ----------------------------
DROP TABLE IF EXISTS `s_app_agreement`;
CREATE TABLE `s_app_agreement` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type` varchar(100) DEFAULT NULL COMMENT 'agreement\n\n_type 数据字典类型',
  `paths` varchar(500) DEFAULT NULL COMMENT '协议地址',
  `createtime` datetime DEFAULT CURRENT_TIMESTAMP,
  `name` varchar(100) DEFAULT NULL COMMENT '协议名称',
  `filename` varchar(100) DEFAULT NULL COMMENT '文件 名称',
  `bankid` bigint(20) DEFAULT NULL COMMENT '组织机构ID',
  `status` int(11) DEFAULT '0' COMMENT '协议状态0 正常 1 废弃',
  `userid` bigint(20) DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `bankid` (`bankid`) USING BTREE,
  KEY `userid` (`userid`) USING BTREE,
  CONSTRAINT `s_app_agreement_ibfk_1` FOREIGN KEY (`bankid`) REFERENCES `s_banks` (`id`),
  CONSTRAINT `s_app_agreement_ibfk_2` FOREIGN KEY (`userid`) REFERENCES `s_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_banks
-- ----------------------------
DROP TABLE IF EXISTS `s_banks`;
CREATE TABLE `s_banks` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT COMMENT '唯一标识符',
  `name` varchar(100) COLLATE utf8mb4_bin NOT NULL COMMENT '名称',
  `linkman` varchar(100) COLLATE utf8mb4_bin NOT NULL COMMENT '联系人',
  `pics` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '形象照',
  `phone` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '联系电话',
  `address` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '地址',
  `createtime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `parentid` bigint(11) DEFAULT NULL COMMENT '父ID',
  `type` int(255) DEFAULT '1' COMMENT '类型0 顶级总行 1下级机构',
  `status` int(255) DEFAULT '0' COMMENT '网点状态 0正常  1删除',
  `lng` decimal(14,10) DEFAULT NULL COMMENT '经纬度',
  `lat` decimal(14,10) DEFAULT NULL COMMENT '经纬度',
  `companyname` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '上级公司名称',
  `validtime` datetime DEFAULT NULL COMMENT '有效期，总行的时候要',
  `topid` bigint(20) DEFAULT NULL COMMENT '最顶级总行机构的ID',
  `poscanrepeat` int(11) DEFAULT '0' COMMENT '是否允许点重复标记客户 0不可以 1可以',
  `userid` bigint(20) DEFAULT NULL COMMENT '创建人iD',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `parentid` (`parentid`) USING BTREE,
  CONSTRAINT `s_banks_ibfk_1` FOREIGN KEY (`parentid`) REFERENCES `s_banks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_banks_config
-- ----------------------------
DROP TABLE IF EXISTS `s_banks_config`;
CREATE TABLE `s_banks_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `bankid` bigint(20) DEFAULT NULL COMMENT '银行机构ID',
  `mapstyle` text COMMENT '地图样式',
  `centerpoint` varchar(255) DEFAULT NULL COMMENT '默认中心点',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_case_flags
-- ----------------------------
DROP TABLE IF EXISTS `s_case_flags`;
CREATE TABLE `s_case_flags` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `flagname` varchar(100) DEFAULT NULL COMMENT '标记名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_clues
-- ----------------------------
DROP TABLE IF EXISTS `s_clues`;
CREATE TABLE `s_clues` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL COMMENT '客户姓名',
  `phone` varchar(100) DEFAULT NULL COMMENT '联系方式',
  `userid` bigint(20) DEFAULT NULL COMMENT '归属业务经理',
  `bankid` bigint(20) NOT NULL COMMENT '网点ID',
  `sceneid` bigint(20) NOT NULL COMMENT '场景来源iD',
  `tempid` bigint(20) NOT NULL COMMENT '线索模板ID',
  `address` varchar(100) DEFAULT NULL COMMENT '详细地址',
  `lat` decimal(20,15) NOT NULL COMMENT '经纬度',
  `lng` decimal(20,15) NOT NULL COMMENT '经纬度',
  `createtime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '新增时间',
  `lasttime` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `status` int(10) DEFAULT '0' COMMENT '状态 0 未跟进 1跟进中 2已作废',
  `provincescode` varchar(100) DEFAULT NULL COMMENT '省份code',
  `provincesname` varchar(100) DEFAULT NULL COMMENT '省份名称',
  `citycode` varchar(100) DEFAULT NULL COMMENT '城市code',
  `cityname` varchar(100) DEFAULT NULL COMMENT '城市名称',
  `areacode` varchar(100) DEFAULT NULL COMMENT '区县code',
  `areaname` varchar(100) DEFAULT NULL COMMENT '区县名称',
  `fenceid` bigint(20) DEFAULT NULL COMMENT '区划ID',
  `wangji` varchar(255) DEFAULT NULL COMMENT '旺季月份',
  `flagnames` varchar(255) DEFAULT NULL COMMENT '客户标签',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `phone` (`phone`) USING BTREE,
  KEY `name` (`name`) USING BTREE,
  KEY `userid_2` (`userid`,`bankid`) USING BTREE,
  KEY `userid` (`userid`,`bankid`,`sceneid`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `bankid` (`bankid`) USING BTREE,
  KEY `userid_3` (`userid`) USING BTREE,
  KEY `sceneid` (`sceneid`) USING BTREE,
  KEY `tempid` (`tempid`) USING BTREE,
  KEY `createtime` (`createtime`) USING BTREE,
  KEY `homegets` (`bankid`,`lat`,`lng`),
  CONSTRAINT `s_clues_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `s_user` (`id`),
  CONSTRAINT `s_clues_ibfk_2` FOREIGN KEY (`bankid`) REFERENCES `s_banks` (`id`),
  CONSTRAINT `s_clues_ibfk_3` FOREIGN KEY (`sceneid`) REFERENCES `s_scene` (`id`),
  CONSTRAINT `s_clues_ibfk_4` FOREIGN KEY (`tempid`) REFERENCES `s_scene_template` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=560 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_clues_flags
-- ----------------------------
DROP TABLE IF EXISTS `s_clues_flags`;
CREATE TABLE `s_clues_flags` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `clueid` bigint(20) NOT NULL COMMENT '客户ID',
  `flagid` bigint(20) DEFAULT NULL COMMENT '标签ID',
  `createtime` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `clueid` (`clueid`) USING BTREE,
  KEY `flagid` (`flagid`) USING BTREE,
  CONSTRAINT `s_clues_flags_ibfk_1` FOREIGN KEY (`clueid`) REFERENCES `s_clues` (`id`),
  CONSTRAINT `s_clues_flags_ibfk_2` FOREIGN KEY (`flagid`) REFERENCES `s_flags` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=119 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_clues_val
-- ----------------------------
DROP TABLE IF EXISTS `s_clues_val`;
CREATE TABLE `s_clues_val` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ident` varchar(100) NOT NULL COMMENT 'case题目唯一标识',
  `caseid` bigint(20) NOT NULL COMMENT '题目ID',
  `val` text COMMENT '内容',
  `clueid` bigint(20) DEFAULT NULL COMMENT '客户ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `clueid` (`clueid`) USING BTREE,
  KEY `caseid` (`caseid`) USING BTREE,
  CONSTRAINT `s_clues_val_ibfk_1` FOREIGN KEY (`clueid`) REFERENCES `s_clues` (`id`),
  CONSTRAINT `s_clues_val_ibfk_2` FOREIGN KEY (`caseid`) REFERENCES `s_scene_template_cases` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5525 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_clue_tracking
-- ----------------------------
DROP TABLE IF EXISTS `s_clue_tracking`;
CREATE TABLE `s_clue_tracking` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `texts` varchar(2000) DEFAULT NULL COMMENT '跟进文字',
  `pics` text COMMENT '跟进图片的地址，多个逗号分隔',
  `clueid` bigint(20) DEFAULT NULL COMMENT '客户ID',
  `createtime` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `clueid` (`clueid`) USING BTREE,
  CONSTRAINT `s_clue_tracking_ibfk_1` FOREIGN KEY (`clueid`) REFERENCES `s_clues` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_data_dictionary
-- ----------------------------
DROP TABLE IF EXISTS `s_data_dictionary`;
CREATE TABLE `s_data_dictionary` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `skey` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '键值对',
  `val` text COLLATE utf8mb4_bin COMMENT '键值对',
  `createtime` datetime DEFAULT CURRENT_TIMESTAMP,
  `name` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '字典名称',
  `remark` varchar(100) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '备注信息',
  `parentid` int(11) DEFAULT NULL COMMENT '上级ID',
  `status` int(11) DEFAULT '0' COMMENT '使用状态 0正常 1禁用',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `skey` (`skey`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_electronic_fence
-- ----------------------------
DROP TABLE IF EXISTS `s_electronic_fence`;
CREATE TABLE `s_electronic_fence` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '区域名称',
  `type` int(11) NOT NULL COMMENT '区域类型 0多边形 1行政区域',
  `datas` text NOT NULL COMMENT '区域数据',
  `bankid` bigint(20) DEFAULT NULL COMMENT '机构ID',
  `createtime` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` int(10) DEFAULT '0' COMMENT '状态 0 正常1废弃',
  `mapsfenceid` bigint(20) NOT NULL COMMENT ' 地图服务围栏ID',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `bankid` (`bankid`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  CONSTRAINT `s_electronic_fence_ibfk_1` FOREIGN KEY (`bankid`) REFERENCES `s_banks` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_electronic_fence_latlng
-- ----------------------------
DROP TABLE IF EXISTS `s_electronic_fence_latlng`;
CREATE TABLE `s_electronic_fence_latlng` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `fenceid` bigint(20) NOT NULL COMMENT '围栏ID',
  `latlngid` bigint(20) NOT NULL COMMENT '经纬度ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `fenceid` (`fenceid`) USING BTREE,
  KEY `latlngid` (`latlngid`) USING BTREE,
  CONSTRAINT `s_electronic_fence_latlng_ibfk_1` FOREIGN KEY (`fenceid`) REFERENCES `s_electronic_fence` (`id`),
  CONSTRAINT `s_electronic_fence_latlng_ibfk_2` FOREIGN KEY (`latlngid`) REFERENCES `s_administrative_latlng` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_electronic_fence_user
-- ----------------------------
DROP TABLE IF EXISTS `s_electronic_fence_user`;
CREATE TABLE `s_electronic_fence_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `fenceid` bigint(20) NOT NULL COMMENT '电子围栏区域ID',
  `userid` bigint(20) NOT NULL COMMENT '业务经理ID',
  `createtime` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` int(11) DEFAULT '0' COMMENT '状态 0 正常 1删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `userid` (`userid`) USING BTREE,
  KEY `fenceid` (`fenceid`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  CONSTRAINT `s_electronic_fence_user_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `s_user` (`id`),
  CONSTRAINT `s_electronic_fence_user_ibfk_2` FOREIGN KEY (`fenceid`) REFERENCES `s_electronic_fence` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_flags
-- ----------------------------
DROP TABLE IF EXISTS `s_flags`;
CREATE TABLE `s_flags` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL COMMENT '标签名称',
  `status` int(11) DEFAULT '0' COMMENT '状态 0 正常 1废弃',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_permissions
-- ----------------------------
DROP TABLE IF EXISTS `s_permissions`;
CREATE TABLE `s_permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '权限名称',
  `type` int(1) DEFAULT NULL COMMENT '权限类型，1为菜单，2为功能',
  `pident` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '上级ident',
  `ident` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '权限标识',
  `createtime` datetime DEFAULT CURRENT_TIMESTAMP,
  `icon` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '菜单图片',
  `jump` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '菜单跳转',
  `sort` int(11) NOT NULL COMMENT '排序',
  `roletype` int(11) DEFAULT '0' COMMENT '资源角色类型0不限制 1平台独有',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  UNIQUE KEY `ident` (`ident`) USING BTREE,
  KEY `id_2` (`id`,`pident`) USING BTREE,
  KEY `pident` (`pident`) USING BTREE,
  CONSTRAINT `s_permissions_ibfk_1` FOREIGN KEY (`pident`) REFERENCES `s_permissions` (`ident`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=376 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_role
-- ----------------------------
DROP TABLE IF EXISTS `s_role`;
CREATE TABLE `s_role` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  `createtime` datetime DEFAULT CURRENT_TIMESTAMP,
  `ident` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色标识',
  `bankid` bigint(20) DEFAULT NULL COMMENT '角色所属机构ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_role_permissions
-- ----------------------------
DROP TABLE IF EXISTS `s_role_permissions`;
CREATE TABLE `s_role_permissions` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `roleid` bigint(11) DEFAULT NULL COMMENT '角色id',
  `permissionsid` bigint(11) DEFAULT NULL COMMENT '权限id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `roleid` (`roleid`) USING BTREE,
  KEY `permissionsid` (`permissionsid`) USING BTREE,
  CONSTRAINT `s_role_permissions_ibfk_1` FOREIGN KEY (`roleid`) REFERENCES `s_role` (`id`),
  CONSTRAINT `s_role_permissions_ibfk_2` FOREIGN KEY (`permissionsid`) REFERENCES `s_permissions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10750 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_scene
-- ----------------------------
DROP TABLE IF EXISTS `s_scene`;
CREATE TABLE `s_scene` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '场景名称',
  `sort` int(11) DEFAULT '0' COMMENT '排序',
  `status` int(11) DEFAULT '0' COMMENT '0正常 1废除',
  `bankid` bigint(20) DEFAULT NULL COMMENT '银行iD',
  `createtime` datetime DEFAULT CURRENT_TIMESTAMP,
  `parentid` bigint(20) DEFAULT NULL COMMENT '母ID',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `bankid` (`bankid`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  CONSTRAINT `s_scene_ibfk_1` FOREIGN KEY (`bankid`) REFERENCES `s_banks` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_scene_template
-- ----------------------------
DROP TABLE IF EXISTS `s_scene_template`;
CREATE TABLE `s_scene_template` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '模板名称',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '模板装填 0正常 1禁用',
  `sceneid` bigint(20) NOT NULL COMMENT '场景ID',
  `createtime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `lasttime` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `bankid` bigint(20) DEFAULT NULL COMMENT '模板所属机构',
  `userid` bigint(20) DEFAULT NULL,
  `parentid` bigint(20) DEFAULT NULL COMMENT '母版ID',
  `validtime` datetime DEFAULT NULL COMMENT '有效期',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `sceneid` (`sceneid`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `bankid` (`bankid`) USING BTREE,
  KEY `userid` (`userid`) USING BTREE,
  KEY `parentid` (`parentid`) USING BTREE,
  CONSTRAINT `s_scene_template_ibfk_1` FOREIGN KEY (`sceneid`) REFERENCES `s_scene` (`id`),
  CONSTRAINT `s_scene_template_ibfk_2` FOREIGN KEY (`bankid`) REFERENCES `s_banks` (`id`),
  CONSTRAINT `s_scene_template_ibfk_3` FOREIGN KEY (`userid`) REFERENCES `s_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_scene_template_cases
-- ----------------------------
DROP TABLE IF EXISTS `s_scene_template_cases`;
CREATE TABLE `s_scene_template_cases` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL COMMENT '题目',
  `descs` varchar(100) DEFAULT NULL COMMENT '提示',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '题目类型0填空 1单选 2多选 3图片',
  `ismust` int(11) NOT NULL DEFAULT '0' COMMENT '是否必须 0 不是  1是',
  `createtime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `tempid` bigint(20) DEFAULT NULL COMMENT '模板ID',
  `sort` int(11) DEFAULT '0' COMMENT '排序',
  `datas` varchar(100) DEFAULT NULL COMMENT '答题选项内容，多个选项逗号分隔',
  `status` int(11) DEFAULT '0' COMMENT '删除 0 正常 1 伪删除',
  `ident` varchar(100) NOT NULL COMMENT '题目标识',
  `caseflagid` bigint(20) DEFAULT NULL COMMENT '题目标记',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `tempid` (`tempid`) USING BTREE,
  KEY `caseflagid` (`caseflagid`) USING BTREE,
  KEY `ident` (`ident`) USING BTREE,
  CONSTRAINT `s_scene_template_cases_ibfk_1` FOREIGN KEY (`tempid`) REFERENCES `s_scene_template` (`id`),
  CONSTRAINT `s_scene_template_cases_ibfk_2` FOREIGN KEY (`caseflagid`) REFERENCES `s_case_flags` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=167 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_scene_template_common_cases
-- ----------------------------
DROP TABLE IF EXISTS `s_scene_template_common_cases`;
CREATE TABLE `s_scene_template_common_cases` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL COMMENT '题目',
  `descs` varchar(100) DEFAULT NULL COMMENT '提示',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '题目类型0填空 1单选 2多选',
  `ismust` int(11) NOT NULL DEFAULT '0' COMMENT '是否必须 0 不是  1是',
  `createtime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `tempid` bigint(20) DEFAULT NULL COMMENT '模板ID',
  `sort` int(11) DEFAULT '0' COMMENT '排序',
  `datas` varchar(100) DEFAULT NULL COMMENT '答题选项内容，多个选项逗号分隔',
  `status` int(11) DEFAULT '0' COMMENT '删除 0 正常 1 伪删除',
  `ident` varchar(100) NOT NULL COMMENT '题目标识',
  `caseflagid` bigint(20) DEFAULT NULL COMMENT '题目标记',
  `bankid` bigint(20) DEFAULT NULL COMMENT '银行',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `tempid` (`tempid`) USING BTREE,
  KEY `ident` (`ident`) USING BTREE,
  CONSTRAINT `s_scene_template_common_cases_ibfk_1` FOREIGN KEY (`tempid`) REFERENCES `s_scene_template` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_sms_message
-- ----------------------------
DROP TABLE IF EXISTS `s_sms_message`;
CREATE TABLE `s_sms_message` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '名称',
  `flagid` bigint(20) DEFAULT NULL COMMENT '客户标签',
  `sendtype` int(11) DEFAULT '0' COMMENT '发送方式 0单次立即 1定时循环',
  `timetype` int(11) DEFAULT NULL COMMENT '发送周期 0 每日 1每周 2 每月',
  `times` varchar(100) DEFAULT NULL COMMENT '具体时间,如果是每日这里没用处，如果是每周，这里周一到周五，如果每月，这里是每月多少号',
  `status` int(11) DEFAULT '0' COMMENT '状态  0正常 1禁用 ',
  `createtime` datetime DEFAULT CURRENT_TIMESTAMP,
  `bankid` bigint(20) NOT NULL COMMENT '组织机构ID',
  `smstemp` varchar(5000) DEFAULT NULL COMMENT '短信模板',
  `sendsize` int(11) DEFAULT '0' COMMENT '已发送次数',
  `shours` datetime DEFAULT NULL COMMENT '发送的确切时分秒，只会区后面的时分秒数据',
  `lastsendtime` datetime DEFAULT NULL COMMENT '最后一次发送时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `flagid` (`flagid`) USING BTREE,
  KEY `bankid` (`bankid`) USING BTREE,
  CONSTRAINT `s_sms_message_ibfk_1` FOREIGN KEY (`flagid`) REFERENCES `s_flags` (`id`),
  CONSTRAINT `s_sms_message_ibfk_2` FOREIGN KEY (`bankid`) REFERENCES `s_banks` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_user
-- ----------------------------
DROP TABLE IF EXISTS `s_user`;
CREATE TABLE `s_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '登录账户（手机号码）',
  `password` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '登录密码',
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '用户姓名',
  `descs` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '备注信息',
  `createtime` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` int(11) DEFAULT '0' COMMENT '用户状态 0正常 1禁用  2删除',
  `bankid` bigint(20) DEFAULT NULL COMMENT '机构ID',
  `emails` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱信息',
  `topid` bigint(20) DEFAULT NULL COMMENT '最顶级的银行ID',
  `isinit` int(11) DEFAULT '0' COMMENT '是否初次登陆 0 初次，1不是',
  `showinitpwd` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '明文的初始密码',
  `entityid` bigint(20) DEFAULT NULL COMMENT '地图服务的entityID',
  `lasttime` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `bankid` (`bankid`) USING BTREE,
  KEY `username` (`username`,`password`) USING BTREE,
  KEY `username_2` (`username`,`password`,`status`) USING BTREE,
  CONSTRAINT `s_user_ibfk_1` FOREIGN KEY (`bankid`) REFERENCES `s_banks` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=591 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_user_app_config
-- ----------------------------
DROP TABLE IF EXISTS `s_user_app_config`;
CREATE TABLE `s_user_app_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `userid` bigint(20) DEFAULT NULL COMMENT '用户ID',
  `posopen` int(11) DEFAULT NULL COMMENT 'APP定位采集开关  0 关闭  1开',
  `posstarttime` datetime DEFAULT NULL COMMENT '定位开始时间',
  `posendtime` datetime DEFAULT NULL COMMENT '定位结束时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  UNIQUE KEY `userid` (`userid`) USING BTREE,
  CONSTRAINT `s_user_app_config_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `s_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=575 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_user_maps_paragraph
-- ----------------------------
DROP TABLE IF EXISTS `s_user_maps_paragraph`;
CREATE TABLE `s_user_maps_paragraph` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `userid` bigint(20) NOT NULL COMMENT '轨迹的用户',
  `starttime` datetime DEFAULT NULL COMMENT '轨迹开始时间',
  `endtime` datetime DEFAULT NULL COMMENT '轨迹结束时间',
  `distances` decimal(20,2) DEFAULT NULL COMMENT '本段轨迹里程',
  `slat` decimal(20,15) DEFAULT NULL COMMENT '开始经纬度点',
  `slng` decimal(20,15) DEFAULT NULL COMMENT '开始经纬度',
  `elat` decimal(20,15) DEFAULT NULL COMMENT '结束经纬度',
  `elng` decimal(20,15) DEFAULT NULL COMMENT '结束经纬度',
  `createtime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `total` int(10) DEFAULT NULL COMMENT '轨迹点总数',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `userid` (`userid`) USING BTREE,
  KEY `starttime` (`starttime`,`endtime`) USING BTREE,
  CONSTRAINT `s_user_maps_paragraph_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `s_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=381 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_user_maps_paragraph_track_point
-- ----------------------------
DROP TABLE IF EXISTS `s_user_maps_paragraph_track_point`;
CREATE TABLE `s_user_maps_paragraph_track_point` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` bigint(20) NOT NULL COMMENT '用户ID',
  `paragraphid` bigint(20) NOT NULL COMMENT '段落ID ',
  `lat` decimal(20,15) NOT NULL COMMENT '经纬度',
  `lng` decimal(20,15) NOT NULL COMMENT '经纬度',
  `locatime` datetime NOT NULL COMMENT '轨迹点时间',
  `createtime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `address` text COMMENT '详细地址',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `createtime` (`createtime`) USING BTREE,
  KEY `userid` (`userid`) USING BTREE,
  KEY `paragraphid` (`paragraphid`) USING BTREE,
  CONSTRAINT `s_user_maps_paragraph_track_point_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `s_user` (`id`),
  CONSTRAINT `s_user_maps_paragraph_track_point_ibfk_2` FOREIGN KEY (`paragraphid`) REFERENCES `s_user_maps_paragraph` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1399 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_user_map_track_address
-- ----------------------------
DROP TABLE IF EXISTS `s_user_map_track_address`;
CREATE TABLE `s_user_map_track_address` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `userid` bigint(20) NOT NULL COMMENT '客户ID',
  `lat` decimal(20,15) NOT NULL COMMENT '经纬度',
  `lng` decimal(20,15) DEFAULT NULL COMMENT '经纬度',
  `createtime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '采集时间',
  `address` varchar(5000) DEFAULT NULL COMMENT '语义化描述',
  `ismaps` int(10) DEFAULT '0' COMMENT '是否同步百度，1是0 不是',
  `speed` decimal(20,5) DEFAULT NULL COMMENT '速度',
  `accuracy` decimal(20,5) DEFAULT NULL COMMENT '精度',
  `altitude` decimal(20,5) DEFAULT NULL COMMENT '高度',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `userid` (`userid`) USING BTREE,
  KEY `createtime` (`createtime`) USING BTREE,
  CONSTRAINT `s_user_map_track_address_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `s_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1651 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_user_ranking
-- ----------------------------
DROP TABLE IF EXISTS `s_user_ranking`;
CREATE TABLE `s_user_ranking` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `userid` bigint(20) NOT NULL COMMENT '用户ID',
  `bankid` bigint(20) NOT NULL COMMENT '银行ID',
  `distances` decimal(20,0) DEFAULT '0' COMMENT '里程',
  `starttime` datetime DEFAULT NULL COMMENT '开始时间',
  `endtime` datetime DEFAULT NULL COMMENT '结束时间',
  `clues` int(10) DEFAULT '0' COMMENT '客户数量',
  `ranks` int(11) DEFAULT '0' COMMENT '本期排名',
  `chargeranks` int(11) DEFAULT '0' COMMENT '本期排名升降',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `userid` (`userid`) USING BTREE,
  KEY `bankid` (`bankid`) USING BTREE,
  CONSTRAINT `s_user_ranking_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `s_user` (`id`),
  CONSTRAINT `s_user_ranking_ibfk_2` FOREIGN KEY (`bankid`) REFERENCES `s_banks` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for s_user_role
-- ----------------------------
DROP TABLE IF EXISTS `s_user_role`;
CREATE TABLE `s_user_role` (
  `id` bigint(11) NOT NULL AUTO_INCREMENT,
  `userid` bigint(11) DEFAULT NULL COMMENT '用户id',
  `roleid` bigint(11) DEFAULT NULL COMMENT '角色id',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE,
  KEY `userid` (`userid`) USING BTREE,
  KEY `roleid` (`roleid`) USING BTREE,
  CONSTRAINT `s_user_role_ibfk_1` FOREIGN KEY (`userid`) REFERENCES `s_user` (`id`),
  CONSTRAINT `s_user_role_ibfk_2` FOREIGN KEY (`roleid`) REFERENCES `s_role` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=592 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Table structure for track_point
-- ----------------------------
DROP TABLE IF EXISTS `track_point`;
CREATE TABLE `track_point` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `service_id` varchar(8) COLLATE utf8_bin DEFAULT NULL COMMENT 'service的唯一标识',
  `entity_name` varchar(255) COLLATE utf8_bin DEFAULT NULL COMMENT 'entity唯一标识',
  `coord_type_input` varchar(10) COLLATE utf8_bin DEFAULT NULL COMMENT '坐标类型',
  `latitude` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '纬度',
  `longitude` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '经度',
  `loc_time` datetime DEFAULT NULL COMMENT '定位时设备的时间',
  `speed` varchar(10) COLLATE utf8_bin DEFAULT NULL COMMENT '千米/h',
  `direction` varchar(7) COLLATE utf8_bin DEFAULT NULL COMMENT '方向[0,359]',
  `height` varchar(10) COLLATE utf8_bin DEFAULT NULL COMMENT '高度',
  `object_name` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '通过鹰眼 SDK 上传的图像文件名称',
  `radius` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '定位精度，GPS或定位SDK返回的值  单位：米',
  `is_delete` varchar(1) COLLATE utf8_bin DEFAULT NULL COMMENT '0 -未删除 ||  1-已删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=546 DEFAULT CHARSET=utf8 COLLATE=utf8_bin ROW_FORMAT=DYNAMIC;
