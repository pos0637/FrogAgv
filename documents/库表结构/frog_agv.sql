/*
SQLyog Community v13.1.5  (64 bit)
MySQL - 5.7.29 : Database - frog_agv
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`frog_agv` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;

USE `frog_agv`;

/*Table structure for table `t_agv_acceptance` */

DROP TABLE IF EXISTS `t_agv_acceptance`;

CREATE TABLE `t_agv_acceptance` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `call_material_id` bigint(20) NOT NULL COMMENT '叫料ID',
  `count` int(11) NOT NULL COMMENT '验收数量',
  `acceptance_time` datetime NOT NULL COMMENT '验收时间',
  `team_id` varchar(128) NOT NULL COMMENT '班组唯一标识',
  `team_name` varchar(64) NOT NULL COMMENT '班组名称',
  `area_id` bigint(20) DEFAULT NULL COMMENT '区域ID(产线ID)',
  `delivery_task_id` bigint(20) DEFAULT NULL COMMENT '配送任务ID',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='验收表';

/*Data for the table `t_agv_acceptance` */

/*Table structure for table `t_agv_acceptance_record` */

DROP TABLE IF EXISTS `t_agv_acceptance_record`;

CREATE TABLE `t_agv_acceptance_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `operation_time` datetime NOT NULL COMMENT '操作时间',
  `team_id` varchar(128) NOT NULL COMMENT '班组唯一标识',
  `team_name` varchar(64) NOT NULL COMMENT '班组名称',
  `source` varchar(255) DEFAULT NULL COMMENT '源数据',
  `results` varchar(255) DEFAULT NULL COMMENT '结果数据',
  `type` tinyint(4) NOT NULL COMMENT '操作类型【1：新增；2：修改；3：删除】',
  `area_id` bigint(20) DEFAULT NULL COMMENT '区域ID(产线ID)',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='验收记录表';

/*Data for the table `t_agv_acceptance_record` */

/*Table structure for table `t_agv_area` */

DROP TABLE IF EXISTS `t_agv_area`;

CREATE TABLE `t_agv_area` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `parent_id` bigint(20) NOT NULL COMMENT '父级区域ID',
  `type` tinyint(4) NOT NULL COMMENT '类型【1：生产区；2：灌装区；3：包装区；4：消毒间；5：拆包间；6：包材仓；7：生产线；8：库位区】',
  `name` varchar(128) NOT NULL COMMENT '名称',
  `code` varchar(128) NOT NULL COMMENT '编号',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='区域表{已填}';

/*Data for the table `t_agv_area` */

insert  into `t_agv_area`(`id`,`parent_id`,`type`,`name`,`code`,`enabled`,`create_user`,`create_time`,`last_modified_user`,`last_modified_time`) values 
(1,0,1,'生产区','PRODUCT',1,1,'2020-03-25 10:06:55',1,'2020-03-25 10:19:44'),
(2,1,2,'灌装区','PRODUCT_FILLING',1,1,'2020-03-25 10:08:24',1,'2020-03-25 10:19:41'),
(3,1,3,'包装区','PRODUCT_PACKAGING',1,1,'2020-03-25 10:08:53',1,'2020-03-25 10:19:41'),
(4,0,4,'消毒间','DISINFECTION',1,1,'2020-03-25 10:10:01',1,'2020-03-25 10:19:40'),
(5,0,5,'拆包间','UNPACKING',1,1,'2020-03-25 10:10:35',1,'2020-03-25 10:19:40'),
(6,0,6,'包材仓','WAREHOUSE',1,1,'2020-03-25 10:11:22',1,'2020-03-25 10:19:39'),
(7,2,7,'产线11','L11',1,1,'2020-03-25 10:17:52',1,'2020-03-25 10:19:39'),
(8,2,7,'产线12','L12',1,1,'2020-03-25 10:18:19',1,'2020-03-25 10:19:38'),
(9,2,7,'产线13','L13',1,1,'2020-03-25 10:18:48',1,'2020-03-25 10:21:49'),
(10,2,7,'产线14','L14',1,1,'2020-03-25 10:19:27',1,'2020-03-25 10:19:38'),
(11,3,7,'产线11','L11',1,1,'2020-03-25 10:21:44',1,'2020-03-25 10:21:44'),
(12,3,7,'产线12','L12',1,1,'2020-03-25 10:22:08',1,'2020-03-25 10:22:08'),
(13,3,7,'产线13','L13',1,1,'2020-03-25 10:22:29',1,'2020-03-25 10:22:29'),
(14,3,7,'产线14','L14',1,1,'2020-03-25 10:22:52',1,'2020-03-25 10:22:52'),
(15,4,8,'消毒间库位','XD_LOCATION',1,1,'2020-03-25 10:45:33',1,'2020-03-25 10:45:33'),
(16,5,8,'拆包间库位','CB_LOCATION',1,1,'2020-03-25 10:46:24',1,'2020-03-25 10:46:24'),
(17,6,8,'包材-拆包库位','BC_CB_LOCATION',1,1,'2020-03-25 10:50:12',1,'2020-03-25 10:50:12'),
(18,6,8,'包材-包装库位','BC_BZ_LOCATION',1,1,'2020-03-25 10:59:11',1,'2020-03-25 10:59:37'),
(19,7,8,'灌装产线11库位','GZ_L11_LOCATION',1,1,'2020-03-25 11:00:39',1,'2020-03-25 11:00:39'),
(20,8,8,'灌装产线12库位','GZ_L12_LOCATION',1,1,'2020-03-25 11:01:21',1,'2020-03-25 11:01:21'),
(21,9,8,'灌装产线13库位','GZ_L13_LOCATION',1,1,'2020-03-25 11:01:58',1,'2020-03-25 11:01:58'),
(22,10,8,'灌装产线14库位','GZ_L14_LOCATION',1,1,'2020-03-25 11:02:34',1,'2020-03-25 11:02:34'),
(23,11,8,'包装产线11库位','BZ_L11_LOCATION',1,1,'2020-03-25 11:03:29',1,'2020-03-25 11:03:29'),
(24,12,8,'包装产线12库位','BZ_L12_LOCATION',1,1,'2020-03-25 11:04:10',1,'2020-03-25 11:04:10'),
(25,13,8,'包装产线13库位','BZ_L13_LOCATION',1,1,'2020-03-25 11:04:58',1,'2020-03-25 11:04:58'),
(26,14,8,'包装产线14库位','BZ_L14_LOCATION',1,1,'2020-03-25 11:05:58',1,'2020-03-25 11:05:58');

/*Table structure for table `t_agv_area_site` */

DROP TABLE IF EXISTS `t_agv_area_site`;

CREATE TABLE `t_agv_area_site` (
  `area_id` bigint(20) NOT NULL COMMENT '区域ID',
  `site_id` bigint(20) NOT NULL COMMENT '站点ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='区域-站点表{已填}';

/*Data for the table `t_agv_area_site` */

insert  into `t_agv_area_site`(`area_id`,`site_id`) values 
(15,1),
(15,2),
(15,3),
(15,4),
(15,5),
(15,6),
(15,7),
(15,8),
(15,9),
(15,10),
(15,11),
(15,12),
(15,13),
(15,14),
(16,15),
(16,16),
(16,17),
(16,18),
(16,19),
(16,20),
(16,21),
(16,22),
(16,23),
(16,24),
(16,25),
(16,26),
(16,27),
(16,28),
(17,29),
(17,30),
(17,31),
(17,32),
(17,33),
(17,34),
(17,35),
(18,36),
(18,37),
(18,38),
(18,39),
(18,40),
(18,41),
(18,42),
(19,43),
(19,44),
(20,45),
(20,46),
(21,47),
(21,48),
(22,49),
(22,50),
(23,51),
(23,52),
(24,53),
(24,54),
(25,55),
(25,56),
(26,57),
(26,58);

/*Table structure for table `t_agv_bom` */

DROP TABLE IF EXISTS `t_agv_bom`;

CREATE TABLE `t_agv_bom` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `material_code` varchar(128) NOT NULL COMMENT '物料编号',
  `full_count` int(11) NOT NULL DEFAULT '650' COMMENT '满料车数量（默认650）',
  `version` varchar(128) NOT NULL DEFAULT '1.0' COMMENT '版本号',
  `enabled` tinyint(2) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='BOM表';

/*Data for the table `t_agv_bom` */

insert  into `t_agv_bom`(`id`,`material_code`,`full_count`,`version`,`enabled`,`create_user`,`create_time`,`last_modified_user`,`last_modified_time`) values 
(1,'xxxxxCP0001',650,'1.0',1,1,'2020-04-05 16:47:00',1,'2020-04-05 16:47:00'),
(2,'xxxxxCP0002',650,'1.0',1,1,'2020-04-05 16:49:19',1,'2020-04-05 16:49:19'),
(3,'xxxxxCP0003',800,'1.0',1,1,'2020-04-05 16:49:19',1,'2020-04-05 20:47:30');

/*Table structure for table `t_agv_bom_detail` */

DROP TABLE IF EXISTS `t_agv_bom_detail`;

CREATE TABLE `t_agv_bom_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `bom_id` bigint(20) NOT NULL COMMENT 'bom主键',
  `material_code` varchar(128) NOT NULL COMMENT '物料编号',
  `count` int(11) NOT NULL COMMENT '数量',
  `type` tinyint(2) NOT NULL COMMENT '类型【1：内包材；2：外包材；3：其它】',
  `enabled` tinyint(2) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='bom详情';

/*Data for the table `t_agv_bom_detail` */

insert  into `t_agv_bom_detail`(`id`,`bom_id`,`material_code`,`count`,`type`,`enabled`,`create_user`,`create_time`,`last_modified_user`,`last_modified_time`) values 
(1,1,'xxxxxYL0001',1,1,1,1,'2020-04-05 16:52:14',1,'2020-04-05 16:52:14'),
(2,1,'xxxxxYL0003',1,1,1,1,'2020-04-05 17:08:23',1,'2020-04-05 17:08:23'),
(3,1,'xxxxxYL0005',1,2,1,1,'2020-04-05 17:08:23',1,'2020-04-05 17:08:23'),
(4,2,'xxxxxYL0001',1,1,1,1,'2020-04-05 17:09:59',1,'2020-04-05 17:09:59'),
(5,2,'xxxxxYL0003',1,1,1,1,'2020-04-05 17:09:59',1,'2020-04-05 17:09:59'),
(6,2,'xxxxxYL0005',1,2,1,1,'2020-04-05 17:09:59',1,'2020-04-05 17:09:59'),
(7,3,'xxxxxYL0002',1,1,1,1,'2020-04-05 17:11:06',1,'2020-04-05 17:11:06'),
(8,3,'xxxxxYL0004',1,1,1,1,'2020-04-05 17:11:06',1,'2020-04-05 17:11:06'),
(9,3,'xxxxxYL0005',1,2,1,1,'2020-04-05 17:11:06',1,'2020-04-05 17:11:06');

/*Table structure for table `t_agv_call_button` */

DROP TABLE IF EXISTS `t_agv_call_button`;

CREATE TABLE `t_agv_call_button` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code` varchar(128) NOT NULL COMMENT '编号',
  `ip_address` varchar(128) DEFAULT NULL COMMENT 'IP地址',
  `port` int(11) NOT NULL DEFAULT '10000' COMMENT '端口号 默认 10000',
  `button_code` varchar(128) DEFAULT NULL COMMENT '按钮编号',
  `name` varchar(128) NOT NULL COMMENT '名称',
  `site_id` bigint(20) DEFAULT NULL COMMENT '站点ID',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='叫料按钮表';

/*Data for the table `t_agv_call_button` */

insert  into `t_agv_call_button`(`id`,`code`,`ip_address`,`port`,`button_code`,`name`,`site_id`,`enabled`,`create_user`,`create_time`,`last_modified_user`,`last_modified_time`) values 
(1,'L11_FILLING01_CALL','192.168.115.150',10000,'0','11号线灌装区1号库位叫料',43,1,1,'2020-04-11 18:01:42',1,'2020-04-24 09:41:43'),
(2,'L11_FILLING01_BACK','192.168.115.150',10000,'2','11号线灌装区1号库位退回',43,1,1,'2020-04-11 18:03:31',1,'2020-04-24 09:41:47'),
(3,'L11_FILLING02_CALL','192.168.115.150',10000,'1','11号线灌装区2号库位叫料',44,1,1,'2020-04-11 18:21:06',1,'2020-04-24 09:41:50'),
(4,'L11_FILLING02_BACK','192.168.115.150',10000,'3','11号线灌装区2号库位退回',44,1,1,'2020-04-11 18:21:06',1,'2020-04-24 09:45:53'),
(5,'L12_FILLING01_CALL','192.168.115.151',10000,'0','12号线灌装区1号库位叫料',45,1,1,'2020-04-11 18:23:18',1,'2020-04-24 09:46:14'),
(6,'L12_FILLING01_BACK','192.168.115.151',10000,'2','12号线灌装区1号库位退回',45,1,1,'2020-04-11 18:23:18',1,'2020-04-24 09:46:16'),
(7,'L12_FILLING02_CALL','192.168.115.151',10000,'1','12号线灌装区2号库位叫料',46,1,1,'2020-04-11 18:23:18',1,'2020-04-24 09:46:17'),
(8,'L12_FILLING02_BACK','192.168.115.151',10000,'3','12号线灌装区2号库位退回',46,1,1,'2020-04-11 18:23:18',1,'2020-04-24 09:46:19'),
(9,'L13_FILLING01_CALL','192.168.115.152',10000,'0','13号线灌装区1号库位叫料',47,1,1,'2020-04-11 18:24:47',1,'2020-04-24 09:46:25'),
(10,'L13_FILLING01_BACK','192.168.115.152',10000,'2','13号线灌装区1号库位退回',47,1,1,'2020-04-11 18:24:47',1,'2020-04-24 09:46:31'),
(11,'L13_FILLING02_CALL','192.168.115.152',10000,'1','13号线灌装区2号库位叫料',48,1,1,'2020-04-11 18:24:47',1,'2020-04-24 09:46:37'),
(12,'L13_FILLING02_BACK','192.168.115.152',10000,'3','13号线灌装区2号库位退回',48,1,1,'2020-04-11 18:24:47',1,'2020-04-24 10:45:04'),
(13,'L14_FILLING01_CALL','192.168.115.153',10000,'0','14号线灌装区1号库位叫料',49,1,1,'2020-04-11 18:25:35',1,'2020-04-24 10:45:24'),
(14,'L14_FILLING01_BACK','192.168.115.153',10000,'2','14号线灌装区1号库位退回',49,1,1,'2020-04-11 18:25:35',1,'2020-04-24 10:45:27'),
(15,'L14_FILLING02_CALL','192.168.115.153',10000,'1','14号线灌装区2号库位叫料',50,1,1,'2020-04-11 18:25:35',1,'2020-04-24 10:45:28'),
(16,'L14_FILLING02_BACK','192.168.115.153',10000,'3','14号线灌装区2号库位退回',50,1,1,'2020-04-11 18:25:35',1,'2020-04-24 10:45:29'),
(17,'L11_PACKAGING01_CALL','192.168.115.154',10000,'0','11号线包装区1号库位叫料',51,1,1,'2020-04-11 18:29:43',1,'2020-04-24 10:45:32'),
(18,'L11_PACKAGING01_BACK','192.168.115.154',10000,'2','11号线包装区1号库位退回',51,1,1,'2020-04-11 18:29:43',1,'2020-04-24 10:45:35'),
(19,'L11_PACKAGING02_CALL','192.168.115.154',10000,'1','11号线包装区2号库位叫料',52,1,1,'2020-04-11 18:29:43',1,'2020-04-24 10:45:36'),
(20,'L11_PACKAGING02_BACK','192.168.115.154',10000,'3','11号线包装区2号库位退回',52,1,1,'2020-04-11 18:29:43',1,'2020-04-24 10:45:37'),
(21,'L12_PACKAGING01_CALL','192.168.115.155',10000,'0','12号线包装区1号库位叫料',53,1,1,'2020-04-11 18:32:51',1,'2020-04-24 10:45:46'),
(22,'L12_PACKAGING01_BACK','192.168.115.155',10000,'2','12号线包装区1号库位退回',53,1,1,'2020-04-11 18:32:51',1,'2020-04-24 10:45:50'),
(23,'L12_PACKAGING02_CALL','192.168.115.155',10000,'1','12号线包装区2号库位叫料',54,1,1,'2020-04-11 18:32:51',1,'2020-04-24 10:45:52'),
(24,'L12_PACKAGING02_BACK','192.168.115.155',10000,'3','12号线包装区2号库位退回',54,1,1,'2020-04-11 18:32:51',1,'2020-04-24 10:45:53'),
(25,'L13_PACKAGING01_CALL','192.168.115.156',10000,'0','13号线包装区1号库位叫料',55,1,1,'2020-04-11 18:33:39',1,'2020-04-24 10:45:57'),
(26,'L13_PACKAGING01_BACK','192.168.115.156',10000,'2','13号线包装区1号库位退回',55,1,1,'2020-04-11 18:33:39',1,'2020-04-24 10:45:59'),
(27,'L13_PACKAGING02_CALL','192.168.115.156',10000,'1','13号线包装区2号库位叫料',56,1,1,'2020-04-11 18:33:39',1,'2020-04-24 10:46:00'),
(28,'L13_PACKAGING02_BACK','192.168.115.156',10000,'3','13号线包装区2号库位退回',56,1,1,'2020-04-11 18:33:39',1,'2020-04-24 10:46:02'),
(29,'L14_PACKAGING01_CALL','192.168.115.157',10000,'0','14号线包装区1号库位叫料',57,1,1,'2020-04-11 18:35:02',1,'2020-04-24 10:46:05'),
(30,'L14_PACKAGING01_BACK','192.168.115.157',10000,'2','14号线包装区1号库位退回',57,1,1,'2020-04-11 18:35:02',1,'2020-04-24 10:46:08'),
(31,'L14_PACKAGING02_CALL','192.168.115.157',10000,'1','14号线包装区2号库位叫料',58,1,1,'2020-04-11 18:35:02',1,'2020-04-24 10:46:09'),
(32,'L14_PACKAGING02_BACK','192.168.115.157',10000,'3','14号线包装区2号库位退回',58,1,1,'2020-04-11 18:35:02',1,'2020-04-24 10:46:10');

/*Table structure for table `t_agv_call_material` */

DROP TABLE IF EXISTS `t_agv_call_material`;

CREATE TABLE `t_agv_call_material` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `material_id` bigint(20) NOT NULL COMMENT '物料ID(原料)',
  `count` int(11) NOT NULL COMMENT '数量',
  `acceptance_count` int(11) NOT NULL DEFAULT '0' COMMENT '验收数量',
  `state` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态【1：未配送；2：配送中；3：已完成】',
  `call_time` datetime NOT NULL COMMENT '叫料时间',
  `wave_detail_code` varchar(128) NOT NULL COMMENT '配送波次详情编号',
  `type` tinyint(4) NOT NULL COMMENT '类型【1：灌装区；2：包装区；3：消毒间；4：拆包间】',
  `cancel_reason` varchar(255) DEFAULT NULL COMMENT '取消叫料原因',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用【1：启用；0：禁用】',
  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次更新时间',
  `area_id` bigint(20) DEFAULT NULL COMMENT '区域ID（站点ID）',
  `team_id` varchar(128) DEFAULT NULL COMMENT '班组ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='叫料表';

/*Data for the table `t_agv_call_material` */

insert  into `t_agv_call_material`(`id`,`material_id`,`count`,`acceptance_count`,`state`,`call_time`,`wave_detail_code`,`type`,`cancel_reason`,`enabled`,`create_user`,`create_time`,`last_modified_user`,`last_modified_time`,`area_id`,`team_id`) values 
(1,4,650,0,1,'2020-04-10 15:23:09','wduuid007',3,NULL,0,0,'2020-04-10 15:23:09',0,'2020-04-18 17:39:20',NULL,NULL),
(2,6,680,0,1,'2020-04-10 15:23:09','wduuid008',3,NULL,0,0,'2020-04-10 15:23:09',0,'2020-04-18 17:39:22',NULL,NULL),
(3,6,50,0,1,'2020-04-10 15:25:54','9e8bcab0eabd46f285dca0c64e7e7dd1',3,NULL,0,0,'2020-04-10 15:25:54',0,'2020-04-18 19:55:04',NULL,NULL),
(4,4,50,0,1,'2020-04-10 15:47:23','72fa66146ad94aa4816ae102e7d86744',3,NULL,0,0,'2020-04-10 15:47:23',0,'2020-04-18 19:55:06',NULL,NULL),
(5,4,650,0,1,'2020-04-10 15:47:38','wduuid009',3,NULL,1,0,'2020-04-10 15:47:38',0,'2020-04-18 21:48:06',NULL,NULL),
(6,6,670,0,1,'2020-04-10 15:47:38','wduuid010',3,NULL,1,0,'2020-04-10 15:47:38',0,'2020-04-18 17:39:25',NULL,NULL),
(7,4,650,0,2,'2020-04-10 15:59:20','wduuid007',4,NULL,1,0,'2020-04-10 15:59:20',0,'2020-04-18 21:50:26',NULL,NULL),
(8,6,680,0,2,'2020-04-10 15:59:20','wduuid008',4,NULL,1,0,'2020-04-10 15:59:20',0,'2020-04-18 21:50:26',NULL,NULL),
(9,4,660,0,1,'2020-04-10 15:59:22','wduuid011',4,NULL,1,0,'2020-04-10 15:59:22',0,'2020-04-18 17:39:27',NULL,NULL),
(10,6,650,0,1,'2020-04-10 15:59:22','wduuid012',4,NULL,1,0,'2020-04-10 15:59:22',0,'2020-04-18 17:39:28',NULL,NULL),
(11,4,660,0,1,'2020-04-13 10:20:28','wduuid011',3,NULL,1,0,'2020-04-13 10:20:28',0,'2020-04-18 17:39:28',NULL,NULL),
(12,6,650,0,1,'2020-04-13 10:20:28','wduuid012',3,NULL,1,0,'2020-04-13 10:20:28',0,'2020-04-18 21:48:10',NULL,NULL),
(13,4,650,0,1,'2020-04-13 10:24:05','ddf2fe6e09494f30aa456ff3a261e4f6',3,NULL,1,0,'2020-04-13 10:24:05',0,'2020-04-18 21:48:10',NULL,NULL),
(14,6,650,0,1,'2020-04-13 10:24:06','7602d59df231485f8602d91440a60ee8',3,NULL,1,0,'2020-04-13 10:24:06',0,'2020-04-18 21:48:11',NULL,NULL),
(15,4,650,0,1,'2020-04-13 15:31:54','wduuid007',3,NULL,1,0,'2020-04-13 15:31:54',0,'2020-04-18 21:48:11',NULL,NULL),
(16,6,680,0,1,'2020-04-13 15:31:54','wduuid008',3,NULL,1,0,'2020-04-13 15:31:54',0,'2020-04-18 21:48:12',NULL,NULL),
(17,4,650,0,1,'2020-04-13 16:32:26','wduuid009',4,NULL,1,0,'2020-04-13 16:32:26',0,'2020-04-18 17:39:32',NULL,NULL),
(18,6,660,0,1,'2020-04-13 16:32:26','wduuid010',4,NULL,1,0,'2020-04-13 16:32:26',0,'2020-04-18 17:39:33',NULL,NULL),
(19,4,650,0,1,'2020-04-13 16:32:37','ddf2fe6e09494f30aa456ff3a261e4f6',4,NULL,1,0,'2020-04-13 16:32:37',0,'2020-04-18 19:59:52',NULL,NULL),
(20,6,650,0,1,'2020-04-13 16:32:38','7602d59df231485f8602d91440a60ee8',4,NULL,0,0,'2020-04-13 16:32:38',0,'2020-04-20 17:42:54',NULL,NULL),
(21,6,650,0,1,'2020-04-20 17:43:23','7602d59df231485f8602d91440a60ee8',4,NULL,0,0,'2020-04-20 17:43:23',0,'2020-04-20 17:43:26',NULL,NULL),
(22,6,650,0,1,'2020-04-20 17:44:25','wduuid002',4,NULL,1,0,'2020-04-20 17:44:25',0,'2020-04-20 17:44:25',NULL,NULL);

/*Table structure for table `t_agv_config` */

DROP TABLE IF EXISTS `t_agv_config`;

CREATE TABLE `t_agv_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `create_user` bigint(20) NOT NULL COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次更新时间',
  `site_code` varchar(128) DEFAULT NULL COMMENT '站点二维码包含的关键字',
  `material_car_code` varchar(128) DEFAULT NULL COMMENT '料框二维码包含的关键字',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='agv系统配置表';

/*Data for the table `t_agv_config` */

insert  into `t_agv_config`(`id`,`create_user`,`create_time`,`last_modified_user`,`last_modified_time`,`site_code`,`material_car_code`,`enabled`) values 
(1,1,'2020-04-13 01:12:51',1,'2020-04-13 01:12:51','DB','LC',1);

/*Table structure for table `t_agv_delivery_task` */

DROP TABLE IF EXISTS `t_agv_delivery_task`;

CREATE TABLE `t_agv_delivery_task` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `task_no` varchar(255) NOT NULL COMMENT '配送任务单号(全系统唯一,自动生成)',
  `workflow_work_id` varchar(128) NOT NULL COMMENT 'WCS任务索引',
  `start_site_id` bigint(20) NOT NULL COMMENT '起点站点ID',
  `end_site_id` bigint(20) NOT NULL COMMENT '终点站点ID',
  `material_box_id` bigint(20) NOT NULL COMMENT '料框ID',
  `agv_uuid` varchar(128) DEFAULT NULL COMMENT 'AGV小车唯一标识',
  `state` tinyint(4) NOT NULL COMMENT '状态【0：待接单；1：取货中；2：配送中；3：已完成】',
  `type` tinyint(4) DEFAULT NULL COMMENT '类型【1：消毒-灌装；2：灌装-消毒；3：包材-拆包；4：拆包-包材；5：包材-包装；6：包装-包材】',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='配送任务表';

/*Data for the table `t_agv_delivery_task` */

insert  into `t_agv_delivery_task`(`id`,`task_no`,`workflow_work_id`,`start_site_id`,`end_site_id`,`material_box_id`,`agv_uuid`,`state`,`type`,`enabled`,`create_user`,`create_time`,`last_modified_user`,`last_modified_time`) values 
(4,'PS20200418215017386','14',29,18,3,NULL,0,NULL,1,0,'2020-04-18 21:50:27',0,'2020-04-18 21:50:26');

/*Table structure for table `t_agv_distribution` */

DROP TABLE IF EXISTS `t_agv_distribution`;

CREATE TABLE `t_agv_distribution` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `call_material_id` bigint(20) NOT NULL COMMENT '叫料ID',
  `count` int(11) NOT NULL COMMENT '配送数量',
  `state` tinyint(4) NOT NULL COMMENT '状态【0：未验收；1：部分验收；2：已验收】',
  `distribution_time` datetime NOT NULL COMMENT '配货时间',
  `type` tinyint(4) NOT NULL COMMENT '类型【1：消毒间-灌装区；2：包材仓-包装区；3：拆包间-消毒间；4：包材仓-拆包间】',
  `stock_up_id` bigint(20) DEFAULT NULL COMMENT '备货ID',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='配货表';

/*Data for the table `t_agv_distribution` */

/*Table structure for table `t_agv_material` */

DROP TABLE IF EXISTS `t_agv_material`;

CREATE TABLE `t_agv_material` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code` varchar(128) NOT NULL COMMENT '物料编号',
  `name` varchar(128) NOT NULL COMMENT '物料名称',
  `uuid` varchar(128) NOT NULL COMMENT '青蛙工厂唯一标识',
  `specs` varchar(64) DEFAULT NULL COMMENT '规格',
  `unit` varchar(32) DEFAULT NULL COMMENT '单位',
  `batch` varchar(64) DEFAULT NULL COMMENT '批次号',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用【1：启用；0：禁用】',
  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='物料表';

/*Data for the table `t_agv_material` */

insert  into `t_agv_material`(`id`,`code`,`name`,`uuid`,`specs`,`unit`,`batch`,`enabled`,`create_user`,`create_time`,`last_modified_user`,`last_modified_time`) values 
(1,'CP1','1.1L植物沐浴露','xxxxxCP0001','1.1L','瓶','PC011001',1,1,'2020-04-05 16:34:27',1,'2020-04-05 16:49:58'),
(2,'CP2','1.1L牛奶沐浴露','xxxxxCP0002','1.1L','瓶','PC011002',1,1,'2020-04-05 16:43:19',1,'2020-04-05 16:43:19'),
(3,'CP3','380ml洗发露','xxxxxCP0003','380mL','瓶','PC011003',1,1,'2020-04-05 16:43:19',1,'2020-04-05 16:43:19'),
(4,'YL1','1.1L瓶子','xxxxxYL0001','1.1L','瓶','PC011002',1,1,'2020-04-05 16:43:19',1,'2020-04-05 16:43:19'),
(5,'YL2','380ml瓶子','xxxxxYL0002','380ml','瓶','PC011003',1,1,'2020-04-05 16:43:19',1,'2020-04-05 16:43:19'),
(6,'YL3','1.1L瓶盖','xxxxxYL0003','1.1L','个','PC011002',1,1,'2020-04-05 16:43:19',1,'2020-04-05 16:43:19'),
(7,'YL4','压棒','xxxxxYL0004','100mm','个','PC011003',1,1,'2020-04-05 16:43:19',1,'2020-04-05 16:43:19'),
(8,'YL5','1.1L纸箱','xxxxxYL0005','380mm*680mm*400mm','个','PC011002',1,1,'2020-04-05 16:59:27',1,'2020-04-05 16:59:27'),
(9,'YL6','380ml纸箱','xxxxxYL0006','300mm*500mm*350mm','个','PC011003',1,1,'2020-04-05 16:59:27',1,'2020-04-05 16:59:27');

/*Table structure for table `t_agv_material_box` */

DROP TABLE IF EXISTS `t_agv_material_box`;

CREATE TABLE `t_agv_material_box` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `qr_code` varchar(255) NOT NULL COMMENT '二维码',
  `code` varchar(128) NOT NULL COMMENT '容器编码',
  `name` varchar(128) DEFAULT NULL COMMENT '料框名称',
  `state` tinyint(4) NOT NULL COMMENT '状态【0：空车；1：有货】',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='料框表{已填}';

/*Data for the table `t_agv_material_box` */

insert  into `t_agv_material_box`(`id`,`qr_code`,`code`,`name`,`state`,`enabled`,`create_user`,`create_time`,`last_modified_user`,`last_modified_time`) values 
(1,'00000001','PA000001','1号料车',1,1,1,'2020-03-25 14:38:42',1,'2020-04-23 00:31:06'),
(2,'00000002','PA000002','2号料车',1,1,1,'2020-03-25 14:38:52',1,'2020-04-23 00:31:09'),
(3,'00000003','PA000003','3号料车',1,1,1,'2020-03-25 14:38:58',1,'2020-04-23 00:31:15'),
(4,'00000004','PA000004','4号料车',1,1,1,'2020-03-25 14:39:08',1,'2020-04-23 00:31:18'),
(5,'00000005','PA000005','5号料车',0,1,1,'2020-03-25 14:39:15',1,'2020-04-23 00:31:21'),
(6,'00000006','PA000006','6号料车',0,1,1,'2020-03-25 14:39:20',1,'2020-04-23 00:31:24'),
(7,'00000007','PA000007','7号料车',0,1,1,'2020-03-25 14:39:25',1,'2020-04-23 00:31:29'),
(8,'00000008','PA000008','8号料车',0,1,1,'2020-03-25 14:39:30',1,'2020-04-23 00:31:35'),
(9,'00000009','PA000009','9号料车',0,1,1,'2020-03-25 14:39:34',1,'2020-04-23 00:31:38'),
(10,'00000010','PA000010','10号料车',0,1,1,'2020-03-25 14:39:39',1,'2020-04-23 00:31:41'),
(11,'00000011','PA000011','11号料车',0,1,1,'2020-03-25 14:39:43',1,'2020-04-23 00:31:44'),
(12,'00000012','PA000012','12号料车',0,1,1,'2020-03-25 14:41:20',1,'2020-04-23 00:31:48'),
(13,'00000013','PA000013','13号料车',0,1,1,'2020-03-25 14:41:24',1,'2020-04-23 00:31:52'),
(14,'00000014','PA000014','14号料车',0,1,1,'2020-03-25 14:41:30',1,'2020-04-23 00:31:55'),
(15,'00000015','PA000015','15号料车',0,1,1,'2020-03-25 14:41:34',1,'2020-04-23 00:31:58'),
(16,'00000016','PA000016','16号料车',0,1,1,'2020-03-25 14:41:39',1,'2020-04-23 00:32:01'),
(17,'00000017','PA000017','17号料车',0,1,1,'2020-03-25 14:41:44',1,'2020-04-23 00:32:05'),
(18,'00000018','PA000018','18号料车',0,1,1,'2020-03-25 14:41:48',1,'2020-04-23 00:32:08'),
(19,'00000019','PA000019','19号料车',0,1,1,'2020-03-25 14:41:52',1,'2020-04-23 00:32:12'),
(20,'00000020','PA000020','20号料车',0,1,1,'2020-03-25 14:41:57',1,'2020-04-23 00:32:15'),
(21,'00000021','PA000021','21号料车',0,1,1,'2020-03-25 14:42:02',1,'2020-04-23 00:32:18'),
(22,'00000022','PA000022','22号料车',0,1,1,'2020-03-25 14:42:07',1,'2020-04-23 00:32:23'),
(23,'00000023','PA000023','23号料车',0,1,1,'2020-03-25 14:42:14',1,'2020-04-23 00:32:26'),
(24,'00000024','PA000024','24号料车',0,1,1,'2020-03-25 14:42:18',1,'2020-04-23 00:32:29'),
(25,'00000025','PA000025','25号料车',0,1,1,'2020-03-25 14:42:22',1,'2020-04-23 00:32:32'),
(26,'00000026','PA000026','26号料车',0,1,1,'2020-03-25 14:42:26',1,'2020-04-23 00:32:36'),
(27,'00000027','PA000027','27号料车',0,1,1,'2020-03-25 14:42:30',1,'2020-04-23 00:32:38'),
(28,'00000028','PA000028','28号料车',0,1,1,'2020-03-25 14:42:33',1,'2020-04-23 00:32:42'),
(29,'00000029','PA000029','29号料车',0,1,1,'2020-03-25 14:42:37',1,'2020-04-23 00:32:45'),
(30,'00000030','PA000030','30号料车',0,1,1,'2020-03-25 14:42:41',1,'2020-04-23 00:32:48'),
(31,'00000031','PA000031','31号料车',0,1,1,'2020-03-25 14:42:46',1,'2020-04-23 00:32:50'),
(32,'00000032','PA000032','32号料车',0,1,1,'2020-03-25 14:42:50',1,'2020-04-23 00:32:53'),
(33,'00000033','PA000033','33号料车',0,1,1,'2020-03-25 14:42:54',1,'2020-04-23 00:32:55'),
(34,'00000034','PA000034','34号料车',0,1,1,'2020-03-25 14:42:58',1,'2020-04-23 00:32:58'),
(35,'00000035','PA000035','35号料车',0,1,1,'2020-03-25 14:43:01',1,'2020-04-23 00:33:00'),
(36,'00000036','PA000036','36号料车',0,1,1,'2020-03-25 14:43:05',1,'2020-04-23 00:33:03'),
(37,'00000037','PA000037','37号料车',0,1,1,'2020-03-25 14:43:08',1,'2020-04-23 00:33:06'),
(38,'00000038','PA000038','38号料车',0,1,1,'2020-03-25 14:43:12',1,'2020-04-23 00:33:08'),
(39,'00000039','PA000039','39号料车',0,1,1,'2020-03-25 14:43:16',1,'2020-04-23 00:33:11'),
(40,'00000040','PA000040','40号料车',0,1,1,'2020-03-25 14:43:20',1,'2020-04-23 00:33:14'),
(41,'00000041','PA000041','41号料车',0,1,1,'2020-03-25 14:43:36',1,'2020-04-23 00:33:19'),
(42,'00000042','PA000042','42号料车',0,1,1,'2020-03-25 14:43:39',1,'2020-04-23 00:33:21'),
(43,'00000043','PA000043','43号料车',0,1,1,'2020-03-25 14:43:43',1,'2020-04-23 00:33:24'),
(44,'00000044','PA000044','44号料车',0,1,1,'2020-03-25 14:43:47',1,'2020-04-23 00:33:27'),
(45,'00000045','PA000045','45号料车',0,1,1,'2020-03-25 14:43:51',1,'2020-04-23 00:33:30'),
(46,'00000046','PA000046','46号料车',0,1,1,'2020-03-25 14:43:55',1,'2020-04-23 00:33:32'),
(47,'00000047','PA000047','47号料车',0,1,1,'2020-03-25 14:43:59',1,'2020-04-23 00:33:38'),
(48,'00000048','PA000048','48号料车',0,1,1,'2020-03-25 14:44:03',1,'2020-04-23 00:33:40'),
(49,'00000049','PA000049','49号料车',0,1,1,'2020-03-25 14:44:07',1,'2020-04-23 00:33:43'),
(50,'00000050','PA000050','50号料车',0,1,1,'2020-03-25 14:44:13',1,'2020-04-23 00:33:46'),
(51,'00000051','PA000051','51号料车',0,1,1,'2020-03-25 14:44:17',1,'2020-04-23 00:33:49'),
(52,'00000052','PA000052','52号料车',0,1,1,'2020-03-25 14:44:20',1,'2020-04-23 00:33:51'),
(53,'00000053','PA000053','53号料车',0,1,1,'2020-03-25 14:44:24',1,'2020-04-23 00:33:57'),
(54,'00000054','PA000054','54号料车',0,1,1,'2020-03-25 14:44:28',1,'2020-04-23 00:34:00'),
(55,'00000055','PA000055','55号料车',0,1,1,'2020-03-25 14:44:32',1,'2020-04-23 00:34:02'),
(56,'00000056','PA000056','56号料车',0,1,1,'2020-03-25 14:44:35',1,'2020-04-23 00:34:05'),
(57,'00000057','PA000057','57号料车',0,1,1,'2020-03-25 14:44:39',1,'2020-04-23 00:34:07'),
(58,'00000058','PA000058','58号料车',0,1,1,'2020-03-25 14:44:43',1,'2020-04-23 00:34:10'),
(59,'00000059','PA000059','59号料车',0,1,1,'2020-03-25 14:44:47',1,'2020-04-23 00:34:12'),
(60,'00000060','PA000060','60号料车',0,1,1,'2020-03-25 14:44:52',1,'2020-04-23 00:34:15');

/*Table structure for table `t_agv_material_box_material` */

DROP TABLE IF EXISTS `t_agv_material_box_material`;

CREATE TABLE `t_agv_material_box_material` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `material_box_id` bigint(20) NOT NULL COMMENT '料框ID',
  `material_id` bigint(20) NOT NULL COMMENT '物料ID（原料）',
  `count` int(11) NOT NULL COMMENT '数量',
  `state` tinyint(4) NOT NULL COMMENT '状态【0：未验收；1：已验收】',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='料框-物料表';

/*Data for the table `t_agv_material_box_material` */

insert  into `t_agv_material_box_material`(`id`,`material_box_id`,`material_id`,`count`,`state`,`enabled`,`create_user`,`create_time`,`last_modified_user`,`last_modified_time`) values 
(1,1,4,650,0,1,1,'2020-04-13 17:08:55',1,'2020-04-18 21:47:11'),
(2,1,6,680,0,1,1,'2020-04-13 17:10:11',1,'2020-04-18 21:47:14'),
(3,2,4,650,0,1,1,'2020-04-18 19:33:52',1,'2020-04-18 21:47:15'),
(4,2,6,650,0,1,1,'2020-04-18 19:34:17',1,'2020-04-18 21:47:16'),
(5,3,4,650,0,1,1,'2020-04-18 19:36:14',1,'2020-04-18 19:36:14'),
(6,3,6,680,0,1,1,'2020-04-18 19:36:30',1,'2020-04-18 19:36:30'),
(7,4,4,650,0,1,1,'2020-04-18 19:53:12',1,'2020-04-18 21:47:19'),
(8,4,6,650,0,1,1,'2020-04-18 19:53:25',1,'2020-04-18 21:47:23');

/*Table structure for table `t_agv_material_requisition` */

DROP TABLE IF EXISTS `t_agv_material_requisition`;

CREATE TABLE `t_agv_material_requisition` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code` varchar(128) NOT NULL COMMENT '领料单号',
  `picking_time` datetime NOT NULL COMMENT '领料时间',
  `material_id` bigint(20) NOT NULL COMMENT '物料ID（产品）',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='领料单表';

/*Data for the table `t_agv_material_requisition` */

/*Table structure for table `t_agv_material_requisition_detail` */

DROP TABLE IF EXISTS `t_agv_material_requisition_detail`;

CREATE TABLE `t_agv_material_requisition_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `material_requisition_id` bigint(20) NOT NULL COMMENT '领料单ID',
  `material_id` bigint(20) NOT NULL COMMENT '物料ID（原料）',
  `count` int(11) NOT NULL COMMENT '数量',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='领料单详情表';

/*Data for the table `t_agv_material_requisition_detail` */

/*Table structure for table `t_agv_sales_return` */

DROP TABLE IF EXISTS `t_agv_sales_return`;

CREATE TABLE `t_agv_sales_return` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `call_material_id` bigint(20) NOT NULL COMMENT '叫料ID',
  `count` int(11) NOT NULL COMMENT '退货数量',
  `reason` varchar(255) DEFAULT NULL COMMENT '退货原因',
  `return_time` datetime NOT NULL COMMENT '退货时间',
  `team_id` varchar(128) NOT NULL COMMENT '班组唯一标识',
  `team_name` varchar(64) NOT NULL COMMENT '班组名称',
  `area_id` bigint(20) NOT NULL COMMENT '区域ID(产线ID)',
  `delivery_task_id` bigint(20) NOT NULL COMMENT '配送任务ID',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='退货表';

/*Data for the table `t_agv_sales_return` */

/*Table structure for table `t_agv_sales_return_record` */

DROP TABLE IF EXISTS `t_agv_sales_return_record`;

CREATE TABLE `t_agv_sales_return_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `operation_time` datetime NOT NULL COMMENT '操作时间',
  `team_id` varchar(128) NOT NULL COMMENT '班组唯一标识',
  `team_name` varchar(64) NOT NULL COMMENT '班组名称',
  `source` varchar(255) DEFAULT NULL COMMENT '源数据',
  `results` varchar(255) DEFAULT NULL COMMENT '结果数据',
  `type` tinyint(4) NOT NULL COMMENT '操作类型【1：新增；2：修改；3：删除】',
  `area_id` bigint(20) NOT NULL COMMENT '区域ID(产线ID)',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='退货记录表';

/*Data for the table `t_agv_sales_return_record` */

/*Table structure for table `t_agv_site` */

DROP TABLE IF EXISTS `t_agv_site`;

CREATE TABLE `t_agv_site` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `qr_code` varchar(255) NOT NULL COMMENT '二维码',
  `location_x` decimal(10,0) DEFAULT NULL COMMENT 'x轴坐标',
  `location_y` decimal(10,0) DEFAULT NULL COMMENT 'y轴坐标',
  `location_z` decimal(10,0) DEFAULT NULL COMMENT 'z轴坐标',
  `type` tinyint(4) NOT NULL COMMENT '类型【1：备货位；2：出货位；3：空车位；】',
  `name` varchar(128) NOT NULL COMMENT '名称',
  `code` varchar(128) NOT NULL COMMENT '编号',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='站点表{已填}';

/*Data for the table `t_agv_site` */

insert  into `t_agv_site`(`id`,`qr_code`,`location_x`,`location_y`,`location_z`,`type`,`name`,`code`,`enabled`,`create_user`,`create_time`,`last_modified_user`,`last_modified_time`) values 
(1,'01050515',NULL,NULL,NULL,1,'消毒间1号库位','26',1,1,'2020-03-25 11:18:45',1,'2020-04-27 21:38:28'),
(2,'01050525',NULL,NULL,NULL,1,'消毒间2号库位','25',1,1,'2020-03-25 11:24:29',1,'2020-04-27 21:38:34'),
(3,'01050535',NULL,NULL,NULL,1,'消毒间3号库位','24',1,1,'2020-03-25 11:24:53',1,'2020-04-27 21:38:40'),
(4,'01050545',NULL,NULL,NULL,1,'消毒间4号库位','23',1,1,'2020-03-25 11:24:59',1,'2020-04-27 21:38:46'),
(5,'01050555',NULL,NULL,NULL,1,'消毒间5号库位','22',1,1,'2020-03-25 11:25:04',1,'2020-04-27 21:38:51'),
(6,'xd006',NULL,NULL,NULL,1,'消毒间6号库位','GZ-1',0,1,'2020-03-25 11:25:10',1,'2020-04-18 18:50:18'),
(7,'xd007',NULL,NULL,NULL,1,'消毒间7号库位','GZ-1',0,1,'2020-03-25 11:25:18',1,'2020-04-18 18:50:18'),
(8,'xd008',NULL,NULL,NULL,1,'消毒间8号库位','GZ-1',0,1,'2020-03-25 11:25:24',1,'2020-04-18 18:50:18'),
(9,'xd009',NULL,NULL,NULL,1,'消毒间9号库位','GZ-1',0,1,'2020-03-25 11:25:31',1,'2020-04-18 18:50:18'),
(10,'xd010',NULL,NULL,NULL,1,'消毒间10号库位','GZ-1',0,1,'2020-03-25 11:25:41',1,'2020-04-18 18:50:18'),
(11,'xd011',NULL,NULL,NULL,1,'消毒间11号库位','GZ-1',0,1,'2020-03-25 11:25:51',1,'2020-04-18 18:50:18'),
(12,'xd012',NULL,NULL,NULL,1,'消毒间12号库位','GZ-1',0,1,'2020-03-25 11:25:59',1,'2020-04-18 18:50:18'),
(13,'xd013',NULL,NULL,NULL,1,'消毒间13号库位','GZ-1',0,1,'2020-03-25 13:12:11',1,'2020-04-18 18:50:18'),
(14,'xd014',NULL,NULL,NULL,1,'消毒间14号库位','GZ-1',0,1,'2020-03-25 13:12:19',1,'2020-04-18 18:50:18'),
(15,'01250605',NULL,NULL,NULL,1,'拆包间1号库位','13',1,1,'2020-03-25 13:13:49',1,'2020-04-27 21:39:16'),
(16,'01250615',NULL,NULL,NULL,1,'拆包间2号库位','12',1,1,'2020-03-25 13:13:57',1,'2020-04-27 21:39:24'),
(17,'01250625',NULL,NULL,NULL,1,'拆包间3号库位','11',1,1,'2020-03-25 13:14:07',1,'2020-04-27 21:39:30'),
(18,'01150635',NULL,NULL,NULL,1,'拆包间4号库位','9',1,1,'2020-03-25 13:14:13',1,'2020-04-27 21:39:46'),
(19,'01050635',NULL,NULL,NULL,1,'拆包间5号库位','8',1,1,'2020-03-25 13:14:20',1,'2020-04-27 21:40:01'),
(20,'cb006',NULL,NULL,NULL,1,'拆包间6号库位','GZ-1',0,1,'2020-03-25 13:14:27',1,'2020-04-18 18:50:18'),
(21,'cb007',NULL,NULL,NULL,1,'拆包间7号库位','GZ-1',0,1,'2020-03-25 13:14:33',1,'2020-04-18 18:50:18'),
(22,'cb008',NULL,NULL,NULL,1,'拆包间8号库位','GZ-1',0,1,'2020-03-25 13:14:40',1,'2020-04-18 18:50:18'),
(23,'cb009',NULL,NULL,NULL,1,'拆包间9号库位','GZ-1',0,1,'2020-03-25 13:14:47',1,'2020-04-18 18:50:18'),
(24,'cb010',NULL,NULL,NULL,1,'拆包间10号库位','GZ-1',0,1,'2020-03-25 13:14:57',1,'2020-04-18 18:50:18'),
(25,'cb011',NULL,NULL,NULL,1,'拆包间11号库位','GZ-1',0,1,'2020-03-25 13:15:04',1,'2020-04-18 18:50:18'),
(26,'cb012',NULL,NULL,NULL,1,'拆包间12号库位','GZ-1',0,1,'2020-03-25 13:15:11',1,'2020-04-18 18:50:18'),
(27,'cb013',NULL,NULL,NULL,1,'拆包间13号库位','GZ-1',0,1,'2020-03-25 13:15:18',1,'2020-04-18 18:50:18'),
(28,'cb014',NULL,NULL,NULL,1,'拆包间14号库位','GZ-1',0,1,'2020-03-25 13:15:25',1,'2020-04-18 18:50:18'),
(29,'01350845',NULL,NULL,NULL,1,'包材-拆包1号库位','GZ-2',1,1,'2020-03-25 13:16:22',1,'2020-04-23 00:38:51'),
(30,'01350865',NULL,NULL,NULL,1,'包材-拆包2号库位','4',1,1,'2020-03-25 13:16:30',1,'2020-04-26 11:17:25'),
(31,'01350875',NULL,NULL,NULL,1,'包材-拆包3号库位','3',1,1,'2020-03-25 13:16:37',1,'2020-04-26 11:17:00'),
(32,'01350885',NULL,NULL,NULL,1,'包材-拆包4号库位','2',1,1,'2020-03-25 13:16:45',1,'2020-04-26 11:16:00'),
(33,'bc_cb005',NULL,NULL,NULL,1,'包材-拆包5号库位','GZ-2',0,1,'2020-03-25 13:16:52',1,'2020-04-18 18:55:54'),
(34,'bc_cb006',NULL,NULL,NULL,1,'包材-拆包6号库位','GZ-2',0,1,'2020-03-25 13:16:59',1,'2020-04-18 18:55:56'),
(35,'bc_cb007',NULL,NULL,NULL,1,'包材-拆包7号库位','GZ-2',0,1,'2020-03-25 13:17:06',1,'2020-04-18 18:55:59'),
(36,'01350905',NULL,NULL,NULL,1,'包材-包装1号库位','1',1,1,'2020-03-25 13:17:34',1,'2020-04-26 11:17:41'),
(37,'01250885',NULL,NULL,NULL,1,'包材-包装2号库位','5',1,1,'2020-03-25 13:17:43',1,'2020-04-26 11:16:30'),
(38,'01250875',NULL,NULL,NULL,1,'包材-包装3号库位','6',1,1,'2020-03-25 13:17:49',1,'2020-04-26 11:16:43'),
(39,'01250865',NULL,NULL,NULL,1,'包材-包装4号库位','7',1,1,'2020-03-25 13:17:56',1,'2020-04-26 11:17:11'),
(40,'bc_bz005',NULL,NULL,NULL,1,'包材-包装5号库位','GZ-2',0,1,'2020-03-25 13:18:03',1,'2020-04-18 18:56:15'),
(41,'bc_bz006',NULL,NULL,NULL,1,'包材-包装6号库位','GZ-2',0,1,'2020-03-25 13:18:12',1,'2020-04-18 18:56:16'),
(42,'bc_bz007',NULL,NULL,NULL,1,'包材-包装7号库位','GZ-2',0,1,'2020-03-25 13:18:20',1,'2020-04-18 18:56:19'),
(43,'05050425',NULL,NULL,NULL,1,'灌装区11线-1号库位','27',1,1,'2020-03-25 13:20:26',1,'2020-04-27 21:35:50'),
(44,'05150425',NULL,NULL,NULL,1,'灌装区11线-2号库位','28',1,1,'2020-03-25 13:20:34',1,'2020-04-27 21:35:56'),
(45,'05450425',NULL,NULL,NULL,1,'灌装区12线-1号库位','29',1,1,'2020-03-25 13:20:57',1,'2020-04-27 21:36:03'),
(46,'05550425',NULL,NULL,NULL,1,'灌装区12线-2号库位','30',1,1,'2020-03-25 13:21:06',1,'2020-04-27 21:36:08'),
(47,'05750425',NULL,NULL,NULL,1,'灌装区13线-1号库位','31',1,1,'2020-03-25 13:21:23',1,'2020-04-27 21:36:14'),
(48,'05850425',NULL,NULL,NULL,1,'灌装区13线-2号库位','32',1,1,'2020-03-25 13:21:31',1,'2020-04-27 21:36:22'),
(49,'06150425',NULL,NULL,NULL,1,'灌装区14线-1号库位','33',1,1,'2020-03-25 13:21:48',1,'2020-04-27 21:36:26'),
(50,'06450425',NULL,NULL,NULL,1,'灌装区14线-2号库位','34',1,1,'2020-03-25 13:21:58',1,'2020-04-27 21:36:42'),
(51,'05250615',NULL,NULL,NULL,1,'包装区11线-1号库位','21',1,1,'2020-03-25 13:23:54',1,'2020-04-27 21:32:19'),
(52,'05350615',NULL,NULL,NULL,1,'包装区11线-2号库位','20',1,1,'2020-03-25 13:24:06',1,'2020-04-27 21:32:31'),
(53,'05650615',NULL,NULL,NULL,1,'包装区12线-1号库位','19',1,1,'2020-03-25 13:24:21',1,'2020-04-27 21:32:39'),
(54,'05750615',NULL,NULL,NULL,1,'包装区12线-2号库位','18',1,1,'2020-03-25 13:24:27',1,'2020-04-27 21:32:54'),
(55,'06050615',NULL,NULL,NULL,1,'包装区13线-1号库位','17',1,1,'2020-03-25 13:24:38',1,'2020-04-27 21:33:00'),
(56,'06150615',NULL,NULL,NULL,1,'包装区13线-2号库位','16',1,1,'2020-03-25 13:24:45',1,'2020-04-27 21:33:02'),
(57,'06250615',NULL,NULL,NULL,1,'包装区14线-1号库位','15',1,1,'2020-03-25 13:25:03',1,'2020-04-27 21:33:58'),
(58,'06350615',NULL,NULL,NULL,1,'包装区14线-2号库位','14',1,1,'2020-03-25 13:25:11',1,'2020-04-27 21:34:10');

/*Table structure for table `t_agv_site_detail` */

DROP TABLE IF EXISTS `t_agv_site_detail`;

CREATE TABLE `t_agv_site_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` bigint(20) NOT NULL COMMENT '站点ID',
  `material_box_id` bigint(20) DEFAULT NULL COMMENT '料框ID',
  `state` tinyint(4) NOT NULL COMMENT '状态【0：空闲；1：锁定；2：有货】',
  `delivery_task_id` bigint(20) DEFAULT NULL COMMENT '配送任务ID',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='站点详情表[站点瞬时备货状态]{已填}';

/*Data for the table `t_agv_site_detail` */

insert  into `t_agv_site_detail`(`id`,`site_id`,`material_box_id`,`state`,`delivery_task_id`,`enabled`,`create_user`,`create_time`,`last_modified_user`,`last_modified_time`) values 
(1,1,NULL,0,NULL,1,1,'2020-03-25 13:50:08',1,'2020-03-25 13:50:08'),
(2,2,NULL,0,NULL,1,1,'2020-03-25 13:50:11',1,'2020-03-25 13:50:11'),
(3,3,NULL,0,NULL,1,1,'2020-03-25 13:50:12',1,'2020-03-25 13:50:12'),
(4,4,NULL,0,NULL,1,1,'2020-03-25 13:50:13',1,'2020-03-25 13:50:13'),
(5,5,NULL,0,NULL,1,1,'2020-03-25 13:50:15',1,'2020-03-25 13:50:15'),
(6,6,NULL,0,NULL,0,1,'2020-03-25 13:50:16',1,'2020-04-07 02:33:04'),
(7,7,NULL,0,NULL,0,1,'2020-03-25 13:50:17',1,'2020-04-07 02:33:08'),
(8,8,NULL,0,NULL,0,1,'2020-03-25 13:50:19',1,'2020-04-07 02:33:11'),
(9,9,NULL,0,NULL,0,1,'2020-03-25 13:50:20',1,'2020-04-07 02:33:11'),
(10,10,NULL,0,NULL,0,1,'2020-03-25 13:50:22',1,'2020-04-07 02:33:12'),
(11,11,NULL,0,NULL,0,1,'2020-03-25 13:50:24',1,'2020-04-07 02:33:12'),
(12,12,NULL,0,NULL,0,1,'2020-03-25 13:50:25',1,'2020-04-07 02:33:13'),
(13,13,NULL,0,NULL,0,1,'2020-03-25 13:50:28',1,'2020-04-07 02:33:13'),
(14,14,NULL,0,NULL,0,1,'2020-03-25 13:50:29',1,'2020-04-07 02:33:30'),
(15,15,1,2,NULL,1,1,'2020-03-25 13:50:47',1,'2020-04-13 17:14:29'),
(16,16,2,2,NULL,1,1,'2020-03-25 13:50:49',1,'2020-04-18 21:11:40'),
(17,17,4,2,NULL,1,1,'2020-03-25 13:50:50',1,'2020-04-18 21:11:42'),
(18,18,NULL,0,NULL,1,1,'2020-03-25 13:50:52',1,'2020-04-18 21:52:26'),
(19,19,NULL,0,NULL,1,1,'2020-03-25 13:50:54',1,'2020-03-25 13:50:54'),
(20,20,NULL,0,NULL,0,1,'2020-03-25 13:50:56',1,'2020-04-07 02:33:39'),
(21,21,NULL,0,NULL,0,1,'2020-03-25 13:50:58',1,'2020-04-07 02:33:50'),
(22,22,NULL,0,NULL,0,1,'2020-03-25 13:51:00',1,'2020-04-07 02:33:51'),
(23,23,NULL,0,NULL,0,1,'2020-03-25 13:51:02',1,'2020-04-07 02:33:52'),
(24,24,NULL,0,NULL,0,1,'2020-03-25 13:51:04',1,'2020-04-07 02:33:52'),
(25,25,NULL,0,NULL,0,1,'2020-03-25 13:51:06',1,'2020-04-07 02:33:53'),
(26,26,NULL,0,NULL,0,1,'2020-03-25 13:51:08',1,'2020-04-07 02:33:53'),
(27,27,NULL,0,NULL,0,1,'2020-03-25 13:51:09',1,'2020-04-07 02:33:55'),
(28,28,NULL,0,NULL,0,1,'2020-03-25 13:51:10',1,'2020-04-07 02:33:57'),
(29,29,3,2,4,1,1,'2020-03-25 13:51:42',1,'2020-04-18 21:52:22'),
(30,30,NULL,0,NULL,1,1,'2020-03-25 13:51:45',1,'2020-03-25 13:51:45'),
(31,31,NULL,0,NULL,1,1,'2020-03-25 13:51:46',1,'2020-03-25 13:51:46'),
(32,32,NULL,0,NULL,1,1,'2020-03-25 13:51:48',1,'2020-03-25 13:51:48'),
(33,33,NULL,0,NULL,0,1,'2020-03-25 13:51:49',1,'2020-04-07 02:34:15'),
(34,34,NULL,0,NULL,0,1,'2020-03-25 13:51:50',1,'2020-04-07 02:34:15'),
(35,35,NULL,0,NULL,0,1,'2020-03-25 13:51:52',1,'2020-04-07 02:34:16'),
(36,36,NULL,0,NULL,1,1,'2020-03-25 13:51:53',1,'2020-03-25 13:51:53'),
(37,37,NULL,0,NULL,1,1,'2020-03-25 13:51:54',1,'2020-03-25 13:51:54'),
(38,38,NULL,0,NULL,1,1,'2020-03-25 13:51:56',1,'2020-03-25 13:51:56'),
(39,39,NULL,0,NULL,1,1,'2020-03-25 13:51:57',1,'2020-03-25 13:51:57'),
(40,40,NULL,0,NULL,0,1,'2020-03-25 13:51:59',1,'2020-04-07 02:34:28'),
(41,41,NULL,0,NULL,0,1,'2020-03-25 13:52:01',1,'2020-04-07 02:34:28'),
(42,42,NULL,0,NULL,0,1,'2020-03-25 13:52:02',1,'2020-04-07 02:34:29');

/*Table structure for table `t_agv_stock_up_record` */

DROP TABLE IF EXISTS `t_agv_stock_up_record`;

CREATE TABLE `t_agv_stock_up_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` bigint(20) NOT NULL COMMENT '站点ID',
  `material_box_id` bigint(20) NOT NULL COMMENT '料框ID',
  `type` tinyint(4) NOT NULL COMMENT '类型【1：消毒间备货；2：拆包间备货；3：包材仓备货】',
  `state` tinyint(4) NOT NULL COMMENT '状态【0：未出库；1：已出库】',
  `delivery_task_id` bigint(20) DEFAULT NULL COMMENT '配送任务ID',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='备货记录表[站点历史备货数据]';

/*Data for the table `t_agv_stock_up_record` */

insert  into `t_agv_stock_up_record`(`id`,`site_id`,`material_box_id`,`type`,`state`,`delivery_task_id`,`enabled`,`create_user`,`create_time`,`last_modified_user`,`last_modified_time`) values 
(1,15,1,2,0,NULL,1,1,'2020-04-13 17:11:19',1,'2020-04-13 17:11:19');

/*Table structure for table `t_agv_stock_up_record_detail` */

DROP TABLE IF EXISTS `t_agv_stock_up_record_detail`;

CREATE TABLE `t_agv_stock_up_record_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `stock_up_record_id` bigint(20) NOT NULL COMMENT '备货记录ID',
  `material_id` bigint(20) NOT NULL COMMENT '物料ID（原料）',
  `count` int(11) NOT NULL COMMENT '数量',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='备货记录详情表';

/*Data for the table `t_agv_stock_up_record_detail` */

insert  into `t_agv_stock_up_record_detail`(`id`,`stock_up_record_id`,`material_id`,`count`,`enabled`,`create_user`,`create_time`,`last_modified_user`,`last_modified_time`) values 
(1,1,4,650,1,1,'2020-04-13 17:11:56',1,'2020-04-13 17:11:56'),
(2,1,6,660,1,1,'2020-04-13 17:12:12',1,'2020-04-13 17:12:12');

/*Table structure for table `t_agv_wave` */

DROP TABLE IF EXISTS `t_agv_wave`;

CREATE TABLE `t_agv_wave` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code` varchar(128) NOT NULL COMMENT '编码',
  `team_id` varchar(128) NOT NULL COMMENT '班组唯一标识',
  `team_name` varchar(64) NOT NULL COMMENT '班组名称',
  `area_id` bigint(20) NOT NULL COMMENT '区域ID(生产线ID)',
  `material_id` bigint(20) NOT NULL COMMENT '物料ID(产品)',
  `execution_time` datetime NOT NULL COMMENT '执行时间',
  `finish_time` datetime DEFAULT NULL COMMENT '完成时间',
  `state` tinyint(4) NOT NULL COMMENT '状态【0：未配送；1：配送中；2：已完成】',
  `type` tinyint(4) NOT NULL COMMENT '类型【1：灌装区；2：包装区】',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='波次表';

/*Data for the table `t_agv_wave` */

insert  into `t_agv_wave`(`id`,`code`,`team_id`,`team_name`,`area_id`,`material_id`,`execution_time`,`finish_time`,`state`,`type`,`enabled`,`create_user`,`create_time`,`last_modified_user`,`last_modified_time`) values 
(1,'uuid001','uuidxxxxb03','B03班组',7,1,'2020-04-05 17:18:53',NULL,0,1,0,1,'2020-04-05 17:18:53',1,'2020-04-05 17:38:19'),
(2,'uuid001','uuidxxxxb03','B03班组',7,1,'2020-04-05 17:37:35',NULL,0,1,0,1,'2020-04-05 17:37:35',1,'2020-04-07 02:17:56'),
(3,'uuid002','uuidxxxxb03','B03班组',7,1,'2020-04-05 17:37:35',NULL,0,1,0,1,'2020-04-05 17:37:35',1,'2020-04-07 02:17:56'),
(4,'uuid003','uuidxxxxb03','B03班组',7,1,'2020-04-05 17:37:35',NULL,0,1,0,1,'2020-04-05 17:37:35',1,'2020-04-07 02:17:56'),
(5,'uuid004','uuidxxxxb03','B03班组',7,2,'2020-04-05 17:37:35',NULL,2,1,1,1,'2020-04-05 17:37:35',1,'2020-04-06 23:16:56'),
(6,'uuid005','uuidxxxxb03','B03班组',7,2,'2020-04-05 17:37:35',NULL,0,1,0,1,'2020-04-05 17:37:35',1,'2020-04-07 02:17:56'),
(7,'uuid006','uuidxxxxb03','B03班组',7,2,'2020-04-05 17:37:35',NULL,0,1,0,1,'2020-04-05 17:37:35',1,'2020-04-07 02:17:56'),
(8,'uuid007','uuidxxxxb04','B04班组',8,3,'2020-04-05 17:37:35',NULL,0,1,1,1,'2020-04-05 17:37:35',1,'2020-04-05 17:37:35'),
(9,'uuid008','uuidxxxxb04','B04班组',8,3,'2020-04-05 17:37:35',NULL,0,1,1,1,'2020-04-05 17:37:35',1,'2020-04-05 17:37:35'),
(10,'uuid009','uuidxxxxb04','B04班组',8,3,'2020-04-05 17:37:35',NULL,0,1,1,1,'2020-04-05 17:37:35',1,'2020-04-05 17:37:35'),
(11,'caa0c7ef8af744ab8fc5eb6dd0664a66','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-06 22:30:07',0,'2020-04-19 16:53:26'),
(12,'147adf93a85244c9863ee0f7e466d11d','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-06 22:34:25',0,'2020-04-19 16:53:26'),
(13,'4061177f69e64ac788dd5669f3109ae6','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-06 22:34:34',0,'2020-04-19 16:53:26'),
(14,'8f692bdfb3db483b83119c96789626b7','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-06 22:39:09',0,'2020-04-19 16:53:26'),
(15,'74d4518f1ab644d5b60a4399a548c525','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-06 22:57:42',0,'2020-04-19 16:53:26'),
(16,'615b450b59964e5ea4589cf8adb0a439','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-06 22:57:45',0,'2020-04-19 16:53:26'),
(17,'24f965f05b7848e8a29924dbd181b80c','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-06 22:57:45',0,'2020-04-19 16:53:26'),
(18,'bef78c47ad434ce6995c7eac4b4e5dab','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-06 22:57:45',0,'2020-04-19 16:53:26'),
(19,'uuid001','uuidxxxxb03','B03班组',7,1,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:17:57',0,'2020-04-19 16:53:26'),
(20,'uuid002','uuidxxxxb03','B03班组',7,1,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:17:57',0,'2020-04-19 16:53:26'),
(21,'uuid003','uuidxxxxb03','B03班组',7,1,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:17:57',0,'2020-04-19 16:53:26'),
(22,'uuid005','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:17:57',0,'2020-04-19 16:53:26'),
(23,'uuid006','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:17:57',0,'2020-04-19 16:53:26'),
(24,'caa0c7ef8af744ab8fc5eb6dd0664a66','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:17:57',0,'2020-04-19 16:53:26'),
(25,'74d4518f1ab644d5b60a4399a548c525','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:17:57',0,'2020-04-19 16:53:26'),
(26,'615b450b59964e5ea4589cf8adb0a439','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:17:57',0,'2020-04-19 16:53:26'),
(27,'24f965f05b7848e8a29924dbd181b80c','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:17:57',0,'2020-04-19 16:53:26'),
(28,'bef78c47ad434ce6995c7eac4b4e5dab','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:17:57',0,'2020-04-19 16:53:26'),
(29,'uuid001','uuidxxxxb03','B03班组',7,1,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:08',0,'2020-04-19 16:53:26'),
(30,'uuid002','uuidxxxxb03','B03班组',7,1,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:08',0,'2020-04-19 16:53:26'),
(31,'uuid003','uuidxxxxb03','B03班组',7,1,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:08',0,'2020-04-19 16:53:26'),
(32,'uuid005','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:08',0,'2020-04-19 16:53:26'),
(33,'uuid006','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:08',0,'2020-04-19 16:53:26'),
(34,'caa0c7ef8af744ab8fc5eb6dd0664a66','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:08',0,'2020-04-19 16:53:26'),
(35,'74d4518f1ab644d5b60a4399a548c525','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:08',0,'2020-04-19 16:53:26'),
(36,'615b450b59964e5ea4589cf8adb0a439','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:08',0,'2020-04-19 16:53:26'),
(37,'24f965f05b7848e8a29924dbd181b80c','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:08',0,'2020-04-19 16:53:26'),
(38,'bef78c47ad434ce6995c7eac4b4e5dab','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:08',0,'2020-04-19 16:53:26'),
(39,'uuid001','uuidxxxxb03','B03班组',7,1,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:09',0,'2020-04-19 16:53:26'),
(40,'uuid002','uuidxxxxb03','B03班组',7,1,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:09',0,'2020-04-19 16:53:26'),
(41,'uuid003','uuidxxxxb03','B03班组',7,1,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:09',0,'2020-04-19 16:53:26'),
(42,'uuid005','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:09',0,'2020-04-19 16:53:26'),
(43,'uuid006','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:09',0,'2020-04-19 16:53:26'),
(44,'caa0c7ef8af744ab8fc5eb6dd0664a66','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:09',0,'2020-04-19 16:53:26'),
(45,'74d4518f1ab644d5b60a4399a548c525','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:09',0,'2020-04-19 16:53:26'),
(46,'615b450b59964e5ea4589cf8adb0a439','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:09',0,'2020-04-19 16:53:26'),
(47,'24f965f05b7848e8a29924dbd181b80c','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:09',0,'2020-04-19 16:53:26'),
(48,'bef78c47ad434ce6995c7eac4b4e5dab','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:09',0,'2020-04-19 16:53:26'),
(49,'uuid001','uuidxxxxb03','B03班组',7,1,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:28',0,'2020-04-19 16:53:26'),
(50,'uuid002','uuidxxxxb03','B03班组',7,1,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:28',0,'2020-04-19 16:53:26'),
(51,'uuid005','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:28',0,'2020-04-19 16:53:26'),
(52,'uuid003','uuidxxxxb03','B03班组',7,1,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:28',0,'2020-04-19 16:53:26'),
(53,'uuid006','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:28',0,'2020-04-19 16:53:26'),
(54,'caa0c7ef8af744ab8fc5eb6dd0664a66','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:28',0,'2020-04-19 16:53:26'),
(55,'74d4518f1ab644d5b60a4399a548c525','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:28',0,'2020-04-19 16:53:26'),
(56,'615b450b59964e5ea4589cf8adb0a439','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:28',0,'2020-04-19 16:53:26'),
(57,'24f965f05b7848e8a29924dbd181b80c','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:28',0,'2020-04-19 16:53:26'),
(58,'bef78c47ad434ce6995c7eac4b4e5dab','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:28',0,'2020-04-19 16:53:26'),
(59,'uuid001','uuidxxxxb03','B03班组',7,1,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:34',0,'2020-04-19 16:53:26'),
(60,'uuid002','uuidxxxxb03','B03班组',7,1,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:34',0,'2020-04-19 16:53:26'),
(61,'uuid003','uuidxxxxb03','B03班组',7,1,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:34',0,'2020-04-19 16:53:26'),
(62,'uuid005','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:34',0,'2020-04-19 16:53:26'),
(63,'uuid006','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:34',0,'2020-04-19 16:53:26'),
(64,'caa0c7ef8af744ab8fc5eb6dd0664a66','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:34',0,'2020-04-19 16:53:26'),
(65,'74d4518f1ab644d5b60a4399a548c525','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:34',0,'2020-04-19 16:53:26'),
(66,'615b450b59964e5ea4589cf8adb0a439','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:34',0,'2020-04-19 16:53:26'),
(67,'24f965f05b7848e8a29924dbd181b80c','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:34',0,'2020-04-19 16:53:26'),
(68,'bef78c47ad434ce6995c7eac4b4e5dab','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-07 02:18:34',0,'2020-04-19 16:53:26'),
(69,'a4f45e930ebd46efb0cbdb36c9fb70d2','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-08 13:50:41',0,'2020-04-19 16:53:26'),
(72,'78fa6484bfe441308402198fff77a83a','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,0,0,'2020-04-12 12:22:41',0,'2020-04-19 16:53:26'),
(73,'uuid001','uuidxxxxb03','B03班组',7,1,'2020-04-19 16:53:26',NULL,0,1,1,0,'2020-04-12 14:48:50',0,'2020-04-19 16:53:26'),
(74,'uuid002','uuidxxxxb03','B03班组',7,1,'2020-04-19 16:53:26',NULL,0,1,1,0,'2020-04-12 14:48:50',0,'2020-04-19 16:53:26'),
(75,'uuid003','uuidxxxxb03','B03班组',7,1,'2020-04-19 16:53:26',NULL,0,1,1,0,'2020-04-12 14:48:50',0,'2020-04-19 16:53:26'),
(76,'uuid005','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,1,0,'2020-04-12 14:48:50',0,'2020-04-19 16:53:26'),
(77,'uuid006','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,1,0,'2020-04-12 14:48:50',0,'2020-04-19 16:53:26'),
(78,'caa0c7ef8af744ab8fc5eb6dd0664a66','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,1,0,'2020-04-12 14:48:50',0,'2020-04-19 16:53:26'),
(79,'74d4518f1ab644d5b60a4399a548c525','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,1,0,'2020-04-12 14:48:50',0,'2020-04-19 16:53:26'),
(80,'615b450b59964e5ea4589cf8adb0a439','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,1,0,'2020-04-12 14:48:50',0,'2020-04-19 16:53:26'),
(81,'24f965f05b7848e8a29924dbd181b80c','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,1,0,'2020-04-12 14:48:50',0,'2020-04-19 16:53:26'),
(82,'bef78c47ad434ce6995c7eac4b4e5dab','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,1,0,'2020-04-12 14:48:50',0,'2020-04-19 16:53:26'),
(83,'a4f45e930ebd46efb0cbdb36c9fb70d2','uuidxxxxb03','B03班组',7,2,'2020-04-19 16:53:26',NULL,0,1,1,0,'2020-04-12 14:48:50',0,'2020-04-19 16:53:26'),
(84,'bb27cbcbf3884fb49f9a1065ac3c620a','uuidxxxxb03','B03班组',11,2,'2020-04-19 16:53:26',NULL,0,2,1,0,'2020-04-19 11:36:59',0,'2020-04-19 17:41:44'),
(85,'549c1ef7f2374f4e8fcdac3b7c5de26c','uuidxxxxb03','B03班组',11,2,'2020-04-19 16:53:26',NULL,0,2,1,0,'2020-04-19 11:37:03',0,'2020-04-19 17:41:47');

/*Table structure for table `t_agv_wave_detail` */

DROP TABLE IF EXISTS `t_agv_wave_detail`;

CREATE TABLE `t_agv_wave_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code` varchar(128) NOT NULL COMMENT '编号',
  `wave_code` varchar(128) NOT NULL COMMENT '波次编号',
  `material_id` bigint(20) NOT NULL COMMENT '物料ID(原料)',
  `count` int(11) NOT NULL COMMENT '数量',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建者',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=179 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='波次详情表';

/*Data for the table `t_agv_wave_detail` */

insert  into `t_agv_wave_detail`(`id`,`code`,`wave_code`,`material_id`,`count`,`enabled`,`create_user`,`create_time`,`last_modified_user`,`last_modified_time`) values 
(1,'wduuid001','uuid001',4,650,0,1,'2020-04-05 20:39:07',1,'2020-04-07 02:17:56'),
(2,'wduuid002','uuid001',6,650,0,1,'2020-04-05 20:49:15',1,'2020-04-07 02:17:56'),
(3,'wduuid003','uuid002',4,650,0,1,'2020-04-05 20:49:15',1,'2020-04-07 02:17:56'),
(4,'wduuid004','uuid002',6,650,0,1,'2020-04-05 20:49:15',1,'2020-04-07 02:17:56'),
(5,'wduuid005','uuid003',4,650,0,1,'2020-04-05 20:49:15',1,'2020-04-07 02:17:56'),
(6,'wduuid006','uuid003',6,650,0,1,'2020-04-05 20:49:15',1,'2020-04-07 02:17:56'),
(7,'wduuid007','uuid004',4,650,1,1,'2020-04-05 20:49:15',1,'2020-04-05 20:49:15'),
(8,'wduuid008','uuid004',6,680,1,1,'2020-04-05 20:49:15',1,'2020-04-06 23:56:43'),
(9,'wduuid009','uuid005',4,650,0,1,'2020-04-05 20:49:15',1,'2020-04-07 02:17:56'),
(10,'wduuid010','uuid005',6,670,0,1,'2020-04-05 20:49:15',1,'2020-04-07 02:17:56'),
(11,'wduuid011','uuid006',4,660,0,1,'2020-04-05 20:49:15',1,'2020-04-07 02:17:56'),
(12,'wduuid012','uuid006',6,650,0,1,'2020-04-05 20:49:15',1,'2020-04-07 02:17:56'),
(13,'wduuid013','uuid007',5,800,1,1,'2020-04-05 20:49:15',1,'2020-04-05 20:49:15'),
(14,'wduuid014','uuid007',7,800,1,1,'2020-04-05 20:49:15',1,'2020-04-05 20:49:15'),
(15,'wduuid015','uuid008',5,800,1,1,'2020-04-05 20:49:15',1,'2020-04-05 20:49:15'),
(16,'wduuid016','uuid008',7,800,1,1,'2020-04-05 20:49:15',1,'2020-04-05 20:49:15'),
(17,'wduuid017','uuid009',5,800,1,1,'2020-04-05 20:49:15',1,'2020-04-05 20:49:15'),
(18,'wduuid018','uuid009',7,800,1,1,'2020-04-05 20:49:15',1,'2020-04-05 20:49:15'),
(19,'ddf2fe6e09494f30aa456ff3a261e4f6','caa0c7ef8af744ab8fc5eb6dd0664a66',4,650,0,0,'2020-04-06 22:30:15',0,'2020-04-07 02:17:56'),
(20,'7602d59df231485f8602d91440a60ee8','caa0c7ef8af744ab8fc5eb6dd0664a66',6,650,0,0,'2020-04-06 22:30:15',0,'2020-04-07 02:17:56'),
(21,'74e3cf3172024816b87dff651407e6d0','147adf93a85244c9863ee0f7e466d11d',4,650,0,0,'2020-04-06 22:34:25',0,'2020-04-06 22:55:18'),
(22,'6b82072916fc4e6b985c50723af4f7b8','147adf93a85244c9863ee0f7e466d11d',6,650,0,0,'2020-04-06 22:34:25',0,'2020-04-06 22:55:16'),
(23,'7a01e971270a420d8d7b0e0714f6b3a9','4061177f69e64ac788dd5669f3109ae6',4,650,0,0,'2020-04-06 22:34:34',0,'2020-04-06 22:38:22'),
(24,'f2edeb9086a94245b187cf1084b80d0c','4061177f69e64ac788dd5669f3109ae6',6,650,0,0,'2020-04-06 22:34:34',0,'2020-04-06 22:38:22'),
(25,'c16be1c9cb914fda919b3c602c428b0b','8f692bdfb3db483b83119c96789626b7',4,650,0,0,'2020-04-06 22:39:09',0,'2020-04-06 22:39:13'),
(26,'388ae9ffeddb45948c7d930f66124e0a','8f692bdfb3db483b83119c96789626b7',6,650,0,0,'2020-04-06 22:39:09',0,'2020-04-06 22:39:13'),
(27,'c4d863261ff94e878ddb81fbd56aaf6b','74d4518f1ab644d5b60a4399a548c525',4,650,0,0,'2020-04-06 22:57:42',0,'2020-04-07 02:17:56'),
(28,'4e87a599c2e94b189feb83d3c40880c2','74d4518f1ab644d5b60a4399a548c525',6,650,0,0,'2020-04-06 22:57:42',0,'2020-04-07 02:17:56'),
(29,'d9cb12c5b53845cd9b4739a0e46af6eb','615b450b59964e5ea4589cf8adb0a439',4,650,0,0,'2020-04-06 22:57:45',0,'2020-04-07 02:17:56'),
(30,'6686582d4ea34d1d9bd67d90f114db33','615b450b59964e5ea4589cf8adb0a439',6,650,0,0,'2020-04-06 22:57:45',0,'2020-04-07 02:17:56'),
(31,'5a9a2b5c3e134c74b568bf4dc3c9fdae','24f965f05b7848e8a29924dbd181b80c',4,650,0,0,'2020-04-06 22:57:45',0,'2020-04-07 02:17:56'),
(32,'f1f00514416648308ad8727b6985858d','24f965f05b7848e8a29924dbd181b80c',6,650,0,0,'2020-04-06 22:57:45',0,'2020-04-07 02:17:56'),
(33,'9b378cdc9be8418684cda3800899e0a1','bef78c47ad434ce6995c7eac4b4e5dab',4,650,0,0,'2020-04-06 22:57:45',0,'2020-04-07 02:17:56'),
(34,'8a464588bf434e65940ee10f163e777b','bef78c47ad434ce6995c7eac4b4e5dab',6,650,0,0,'2020-04-06 22:57:45',0,'2020-04-07 02:17:56'),
(35,'6aca8e43e10d42d482292b4d2b7e5d7e','uuid005',4,20,0,0,'2020-04-07 02:12:09',0,'2020-04-07 02:12:13'),
(36,'2b391e57a61f453da4d3610d3dac7b0c','uuid005',6,30,0,0,'2020-04-07 02:12:09',0,'2020-04-07 02:12:13'),
(37,'wduuid002','uuid001',6,650,0,0,'2020-04-07 02:17:57',0,'2020-04-07 02:18:07'),
(38,'wduuid001','uuid001',4,650,0,0,'2020-04-07 02:17:57',0,'2020-04-07 02:18:07'),
(39,'wduuid003','uuid002',4,650,0,0,'2020-04-07 02:17:57',0,'2020-04-07 02:18:07'),
(40,'wduuid004','uuid002',6,650,0,0,'2020-04-07 02:17:57',0,'2020-04-07 02:18:07'),
(41,'wduuid005','uuid003',4,650,0,0,'2020-04-07 02:17:57',0,'2020-04-07 02:18:07'),
(42,'wduuid006','uuid003',6,650,0,0,'2020-04-07 02:17:57',0,'2020-04-07 02:18:07'),
(43,'wduuid009','uuid005',4,650,0,0,'2020-04-07 02:17:57',0,'2020-04-07 02:18:07'),
(44,'wduuid010','uuid005',6,670,0,0,'2020-04-07 02:17:57',0,'2020-04-07 02:18:07'),
(45,'wduuid011','uuid006',4,660,0,0,'2020-04-07 02:17:57',0,'2020-04-07 02:18:07'),
(46,'wduuid012','uuid006',6,650,0,0,'2020-04-07 02:17:57',0,'2020-04-07 02:18:07'),
(47,'ddf2fe6e09494f30aa456ff3a261e4f6','caa0c7ef8af744ab8fc5eb6dd0664a66',4,650,0,0,'2020-04-07 02:17:57',0,'2020-04-07 02:18:07'),
(48,'7602d59df231485f8602d91440a60ee8','caa0c7ef8af744ab8fc5eb6dd0664a66',6,650,0,0,'2020-04-07 02:17:57',0,'2020-04-07 02:18:07'),
(49,'c4d863261ff94e878ddb81fbd56aaf6b','74d4518f1ab644d5b60a4399a548c525',4,650,0,0,'2020-04-07 02:17:57',0,'2020-04-07 02:18:07'),
(50,'4e87a599c2e94b189feb83d3c40880c2','74d4518f1ab644d5b60a4399a548c525',6,650,0,0,'2020-04-07 02:17:57',0,'2020-04-07 02:18:07'),
(51,'d9cb12c5b53845cd9b4739a0e46af6eb','615b450b59964e5ea4589cf8adb0a439',4,650,0,0,'2020-04-07 02:17:57',0,'2020-04-07 02:18:07'),
(52,'6686582d4ea34d1d9bd67d90f114db33','615b450b59964e5ea4589cf8adb0a439',6,650,0,0,'2020-04-07 02:17:57',0,'2020-04-07 02:18:07'),
(53,'5a9a2b5c3e134c74b568bf4dc3c9fdae','24f965f05b7848e8a29924dbd181b80c',4,650,0,0,'2020-04-07 02:17:57',0,'2020-04-07 02:18:07'),
(54,'f1f00514416648308ad8727b6985858d','24f965f05b7848e8a29924dbd181b80c',6,650,0,0,'2020-04-07 02:17:57',0,'2020-04-07 02:18:07'),
(55,'9b378cdc9be8418684cda3800899e0a1','bef78c47ad434ce6995c7eac4b4e5dab',4,650,0,0,'2020-04-07 02:17:57',0,'2020-04-07 02:18:07'),
(56,'8a464588bf434e65940ee10f163e777b','bef78c47ad434ce6995c7eac4b4e5dab',6,650,0,0,'2020-04-07 02:17:57',0,'2020-04-07 02:18:07'),
(57,'wduuid001','uuid001',4,650,0,0,'2020-04-07 02:18:08',0,'2020-04-07 02:18:08'),
(58,'wduuid002','uuid001',6,650,0,0,'2020-04-07 02:18:08',0,'2020-04-07 02:18:08'),
(59,'wduuid003','uuid002',4,650,0,0,'2020-04-07 02:18:08',0,'2020-04-07 02:18:08'),
(60,'wduuid004','uuid002',6,650,0,0,'2020-04-07 02:18:08',0,'2020-04-07 02:18:08'),
(61,'wduuid005','uuid003',4,650,0,0,'2020-04-07 02:18:08',0,'2020-04-07 02:18:08'),
(62,'wduuid006','uuid003',6,650,0,0,'2020-04-07 02:18:08',0,'2020-04-07 02:18:08'),
(63,'wduuid009','uuid005',4,650,0,0,'2020-04-07 02:18:08',0,'2020-04-07 02:18:08'),
(64,'wduuid010','uuid005',6,670,0,0,'2020-04-07 02:18:08',0,'2020-04-07 02:18:08'),
(65,'wduuid011','uuid006',4,660,0,0,'2020-04-07 02:18:08',0,'2020-04-07 02:18:08'),
(66,'wduuid012','uuid006',6,650,0,0,'2020-04-07 02:18:08',0,'2020-04-07 02:18:08'),
(67,'ddf2fe6e09494f30aa456ff3a261e4f6','caa0c7ef8af744ab8fc5eb6dd0664a66',4,650,0,0,'2020-04-07 02:18:08',0,'2020-04-07 02:18:08'),
(68,'7602d59df231485f8602d91440a60ee8','caa0c7ef8af744ab8fc5eb6dd0664a66',6,650,0,0,'2020-04-07 02:18:08',0,'2020-04-07 02:18:08'),
(69,'c4d863261ff94e878ddb81fbd56aaf6b','74d4518f1ab644d5b60a4399a548c525',4,650,0,0,'2020-04-07 02:18:08',0,'2020-04-07 02:18:08'),
(70,'4e87a599c2e94b189feb83d3c40880c2','74d4518f1ab644d5b60a4399a548c525',6,650,0,0,'2020-04-07 02:18:08',0,'2020-04-07 02:18:08'),
(71,'d9cb12c5b53845cd9b4739a0e46af6eb','615b450b59964e5ea4589cf8adb0a439',4,650,0,0,'2020-04-07 02:18:08',0,'2020-04-07 02:18:08'),
(72,'6686582d4ea34d1d9bd67d90f114db33','615b450b59964e5ea4589cf8adb0a439',6,650,0,0,'2020-04-07 02:18:08',0,'2020-04-07 02:18:08'),
(73,'5a9a2b5c3e134c74b568bf4dc3c9fdae','24f965f05b7848e8a29924dbd181b80c',4,650,0,0,'2020-04-07 02:18:08',0,'2020-04-07 02:18:08'),
(74,'f1f00514416648308ad8727b6985858d','24f965f05b7848e8a29924dbd181b80c',6,650,0,0,'2020-04-07 02:18:08',0,'2020-04-07 02:18:08'),
(75,'9b378cdc9be8418684cda3800899e0a1','bef78c47ad434ce6995c7eac4b4e5dab',4,650,0,0,'2020-04-07 02:18:08',0,'2020-04-07 02:18:08'),
(76,'8a464588bf434e65940ee10f163e777b','bef78c47ad434ce6995c7eac4b4e5dab',6,650,0,0,'2020-04-07 02:18:08',0,'2020-04-07 02:18:08'),
(77,'wduuid002','uuid001',6,650,0,0,'2020-04-07 02:18:09',0,'2020-04-07 02:18:28'),
(78,'wduuid001','uuid001',4,650,0,0,'2020-04-07 02:18:09',0,'2020-04-07 02:18:28'),
(79,'wduuid003','uuid002',4,650,0,0,'2020-04-07 02:18:09',0,'2020-04-07 02:18:28'),
(80,'wduuid004','uuid002',6,650,0,0,'2020-04-07 02:18:09',0,'2020-04-07 02:18:28'),
(81,'wduuid005','uuid003',4,650,0,0,'2020-04-07 02:18:09',0,'2020-04-07 02:18:28'),
(82,'wduuid006','uuid003',6,650,0,0,'2020-04-07 02:18:09',0,'2020-04-07 02:18:28'),
(83,'wduuid009','uuid005',4,650,0,0,'2020-04-07 02:18:09',0,'2020-04-07 02:18:28'),
(84,'wduuid010','uuid005',6,670,0,0,'2020-04-07 02:18:09',0,'2020-04-07 02:18:28'),
(85,'wduuid011','uuid006',4,660,0,0,'2020-04-07 02:18:09',0,'2020-04-07 02:18:28'),
(86,'wduuid012','uuid006',6,650,0,0,'2020-04-07 02:18:09',0,'2020-04-07 02:18:28'),
(87,'ddf2fe6e09494f30aa456ff3a261e4f6','caa0c7ef8af744ab8fc5eb6dd0664a66',4,650,0,0,'2020-04-07 02:18:09',0,'2020-04-07 02:18:28'),
(88,'7602d59df231485f8602d91440a60ee8','caa0c7ef8af744ab8fc5eb6dd0664a66',6,650,0,0,'2020-04-07 02:18:09',0,'2020-04-07 02:18:28'),
(89,'c4d863261ff94e878ddb81fbd56aaf6b','74d4518f1ab644d5b60a4399a548c525',4,650,0,0,'2020-04-07 02:18:09',0,'2020-04-07 02:18:28'),
(90,'4e87a599c2e94b189feb83d3c40880c2','74d4518f1ab644d5b60a4399a548c525',6,650,0,0,'2020-04-07 02:18:09',0,'2020-04-07 02:18:28'),
(91,'d9cb12c5b53845cd9b4739a0e46af6eb','615b450b59964e5ea4589cf8adb0a439',4,650,0,0,'2020-04-07 02:18:09',0,'2020-04-07 02:18:28'),
(92,'6686582d4ea34d1d9bd67d90f114db33','615b450b59964e5ea4589cf8adb0a439',6,650,0,0,'2020-04-07 02:18:09',0,'2020-04-07 02:18:28'),
(93,'5a9a2b5c3e134c74b568bf4dc3c9fdae','24f965f05b7848e8a29924dbd181b80c',4,650,0,0,'2020-04-07 02:18:09',0,'2020-04-07 02:18:28'),
(94,'f1f00514416648308ad8727b6985858d','24f965f05b7848e8a29924dbd181b80c',6,650,0,0,'2020-04-07 02:18:09',0,'2020-04-07 02:18:28'),
(95,'9b378cdc9be8418684cda3800899e0a1','bef78c47ad434ce6995c7eac4b4e5dab',4,650,0,0,'2020-04-07 02:18:09',0,'2020-04-07 02:18:28'),
(96,'8a464588bf434e65940ee10f163e777b','bef78c47ad434ce6995c7eac4b4e5dab',6,650,0,0,'2020-04-07 02:18:09',0,'2020-04-07 02:18:28'),
(97,'wduuid002','uuid001',6,650,0,0,'2020-04-07 02:18:28',0,'2020-04-07 02:18:34'),
(98,'wduuid001','uuid001',4,650,0,0,'2020-04-07 02:18:28',0,'2020-04-07 02:18:34'),
(99,'wduuid003','uuid002',4,650,0,0,'2020-04-07 02:18:28',0,'2020-04-07 02:18:34'),
(100,'wduuid004','uuid002',6,650,0,0,'2020-04-07 02:18:28',0,'2020-04-07 02:18:34'),
(101,'wduuid009','uuid005',4,650,0,0,'2020-04-07 02:18:28',0,'2020-04-07 02:18:34'),
(102,'wduuid010','uuid005',6,670,0,0,'2020-04-07 02:18:28',0,'2020-04-07 02:18:34'),
(103,'wduuid005','uuid003',4,650,0,0,'2020-04-07 02:18:28',0,'2020-04-07 02:18:34'),
(104,'wduuid006','uuid003',6,650,0,0,'2020-04-07 02:18:28',0,'2020-04-07 02:18:34'),
(105,'wduuid011','uuid006',4,660,0,0,'2020-04-07 02:18:28',0,'2020-04-07 02:18:34'),
(106,'wduuid012','uuid006',6,650,0,0,'2020-04-07 02:18:28',0,'2020-04-07 02:18:34'),
(107,'ddf2fe6e09494f30aa456ff3a261e4f6','caa0c7ef8af744ab8fc5eb6dd0664a66',4,650,0,0,'2020-04-07 02:18:28',0,'2020-04-07 02:18:34'),
(108,'7602d59df231485f8602d91440a60ee8','caa0c7ef8af744ab8fc5eb6dd0664a66',6,650,0,0,'2020-04-07 02:18:28',0,'2020-04-07 02:18:34'),
(109,'c4d863261ff94e878ddb81fbd56aaf6b','74d4518f1ab644d5b60a4399a548c525',4,650,0,0,'2020-04-07 02:18:28',0,'2020-04-07 02:18:34'),
(110,'4e87a599c2e94b189feb83d3c40880c2','74d4518f1ab644d5b60a4399a548c525',6,650,0,0,'2020-04-07 02:18:28',0,'2020-04-07 02:18:34'),
(111,'d9cb12c5b53845cd9b4739a0e46af6eb','615b450b59964e5ea4589cf8adb0a439',4,650,0,0,'2020-04-07 02:18:28',0,'2020-04-07 02:18:34'),
(112,'6686582d4ea34d1d9bd67d90f114db33','615b450b59964e5ea4589cf8adb0a439',6,650,0,0,'2020-04-07 02:18:28',0,'2020-04-07 02:18:34'),
(113,'5a9a2b5c3e134c74b568bf4dc3c9fdae','24f965f05b7848e8a29924dbd181b80c',4,650,0,0,'2020-04-07 02:18:28',0,'2020-04-07 02:18:34'),
(114,'f1f00514416648308ad8727b6985858d','24f965f05b7848e8a29924dbd181b80c',6,650,0,0,'2020-04-07 02:18:28',0,'2020-04-07 02:18:34'),
(115,'9b378cdc9be8418684cda3800899e0a1','bef78c47ad434ce6995c7eac4b4e5dab',4,650,0,0,'2020-04-07 02:18:28',0,'2020-04-07 02:18:34'),
(116,'8a464588bf434e65940ee10f163e777b','bef78c47ad434ce6995c7eac4b4e5dab',6,650,0,0,'2020-04-07 02:18:28',0,'2020-04-07 02:18:34'),
(117,'wduuid002','uuid001',6,650,0,0,'2020-04-07 02:18:34',0,'2020-04-12 14:48:50'),
(118,'wduuid001','uuid001',4,650,0,0,'2020-04-07 02:18:34',0,'2020-04-12 14:48:50'),
(119,'wduuid003','uuid002',4,650,0,0,'2020-04-07 02:18:34',0,'2020-04-12 14:48:50'),
(120,'wduuid004','uuid002',6,650,0,0,'2020-04-07 02:18:34',0,'2020-04-12 14:48:50'),
(121,'wduuid005','uuid003',4,650,0,0,'2020-04-07 02:18:34',0,'2020-04-12 14:48:50'),
(122,'wduuid006','uuid003',6,650,0,0,'2020-04-07 02:18:34',0,'2020-04-12 14:48:50'),
(123,'wduuid009','uuid005',4,650,0,0,'2020-04-07 02:18:34',0,'2020-04-12 14:48:50'),
(124,'wduuid010','uuid005',6,660,0,0,'2020-04-07 02:18:34',0,'2020-04-12 14:48:50'),
(125,'wduuid011','uuid006',4,660,0,0,'2020-04-07 02:18:34',0,'2020-04-12 14:48:50'),
(126,'wduuid012','uuid006',6,650,0,0,'2020-04-07 02:18:34',0,'2020-04-12 14:48:50'),
(127,'ddf2fe6e09494f30aa456ff3a261e4f6','caa0c7ef8af744ab8fc5eb6dd0664a66',4,650,0,0,'2020-04-07 02:18:34',0,'2020-04-12 14:48:50'),
(128,'7602d59df231485f8602d91440a60ee8','caa0c7ef8af744ab8fc5eb6dd0664a66',6,650,0,0,'2020-04-07 02:18:34',0,'2020-04-12 14:48:50'),
(129,'c4d863261ff94e878ddb81fbd56aaf6b','74d4518f1ab644d5b60a4399a548c525',4,650,0,0,'2020-04-07 02:18:34',0,'2020-04-12 14:48:50'),
(130,'4e87a599c2e94b189feb83d3c40880c2','74d4518f1ab644d5b60a4399a548c525',6,650,0,0,'2020-04-07 02:18:34',0,'2020-04-12 14:48:50'),
(131,'d9cb12c5b53845cd9b4739a0e46af6eb','615b450b59964e5ea4589cf8adb0a439',4,650,0,0,'2020-04-07 02:18:34',0,'2020-04-12 14:48:50'),
(132,'6686582d4ea34d1d9bd67d90f114db33','615b450b59964e5ea4589cf8adb0a439',6,650,0,0,'2020-04-07 02:18:34',0,'2020-04-12 14:48:50'),
(133,'5a9a2b5c3e134c74b568bf4dc3c9fdae','24f965f05b7848e8a29924dbd181b80c',4,650,0,0,'2020-04-07 02:18:34',0,'2020-04-12 14:48:50'),
(134,'f1f00514416648308ad8727b6985858d','24f965f05b7848e8a29924dbd181b80c',6,650,0,0,'2020-04-07 02:18:34',0,'2020-04-12 14:48:50'),
(135,'9b378cdc9be8418684cda3800899e0a1','bef78c47ad434ce6995c7eac4b4e5dab',4,650,0,0,'2020-04-07 02:18:34',0,'2020-04-12 14:48:50'),
(136,'8a464588bf434e65940ee10f163e777b','bef78c47ad434ce6995c7eac4b4e5dab',6,650,0,0,'2020-04-07 02:18:34',0,'2020-04-12 14:48:50'),
(137,'9e8bcab0eabd46f285dca0c64e7e7dd1','uuid005',6,50,0,0,'2020-04-08 10:23:43',0,'2020-04-12 12:31:40'),
(138,'72fa66146ad94aa4816ae102e7d86744','uuid005',4,50,0,0,'2020-04-08 10:23:43',0,'2020-04-12 12:31:37'),
(139,'db72b780d0474a259a3f90634b9f8c34','a4f45e930ebd46efb0cbdb36c9fb70d2',4,650,0,0,'2020-04-08 13:50:41',0,'2020-04-12 14:48:50'),
(140,'1cbdf51c55de40c1977ee1664321442c','a4f45e930ebd46efb0cbdb36c9fb70d2',6,670,0,0,'2020-04-08 13:50:41',0,'2020-04-12 14:48:50'),
(141,'eab6b5afcbb84d19872b0e933b8f0e0a','a4f45e930ebd46efb0cbdb36c9fb70d2',6,50,0,0,'2020-04-08 13:50:41',0,'2020-04-12 14:48:50'),
(142,'942e59b899264eb2a2dcedf4a05245b6','a4f45e930ebd46efb0cbdb36c9fb70d2',4,50,0,0,'2020-04-08 13:50:41',0,'2020-04-12 14:48:50'),
(143,'7e0b74e3c35a4e3e86383448cce8a58b','78fa6484bfe441308402198fff77a83a',4,650,0,0,'2020-04-12 12:22:45',0,'2020-04-12 12:28:16'),
(144,'2743949602fd4ad6bdd1b5f578b98782','78fa6484bfe441308402198fff77a83a',6,670,0,0,'2020-04-12 12:22:45',0,'2020-04-12 12:28:16'),
(145,'89412ee7ca244923b53d0eaddc9d8891','78fa6484bfe441308402198fff77a83a',6,50,0,0,'2020-04-12 12:22:45',0,'2020-04-12 12:28:16'),
(146,'98adb0cc439a430d84a7d5d469e113a8','78fa6484bfe441308402198fff77a83a',4,50,0,0,'2020-04-12 12:22:45',0,'2020-04-12 12:28:16'),
(147,'d2bb7ee0a51d440cb2c9170bfd350243','uuid005',4,50,0,0,'2020-04-12 14:26:19',0,'2020-04-12 14:26:39'),
(148,'b98154a711334fa98ddd11e465a3848c','uuid005',6,50,0,0,'2020-04-12 14:26:19',0,'2020-04-12 14:26:39'),
(149,'038a486a25f746e68f59c4d964f5b2c1','uuid005',4,60,0,0,'2020-04-12 14:26:33',0,'2020-04-12 14:26:40'),
(150,'f3932632efbf4074b67548d96f70f3e7','uuid005',6,60,0,0,'2020-04-12 14:26:33',0,'2020-04-12 14:26:41'),
(151,'wduuid002','uuid001',6,650,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(152,'wduuid001','uuid001',4,650,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(153,'wduuid003','uuid002',4,650,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(154,'wduuid004','uuid002',6,650,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(155,'wduuid005','uuid003',4,650,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(156,'wduuid006','uuid003',6,650,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(157,'wduuid009','uuid005',4,650,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(158,'wduuid010','uuid005',6,660,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(159,'wduuid011','uuid006',4,660,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(160,'wduuid012','uuid006',6,650,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(161,'ddf2fe6e09494f30aa456ff3a261e4f6','caa0c7ef8af744ab8fc5eb6dd0664a66',4,650,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(162,'7602d59df231485f8602d91440a60ee8','caa0c7ef8af744ab8fc5eb6dd0664a66',6,650,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(163,'c4d863261ff94e878ddb81fbd56aaf6b','74d4518f1ab644d5b60a4399a548c525',4,650,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(164,'4e87a599c2e94b189feb83d3c40880c2','74d4518f1ab644d5b60a4399a548c525',6,650,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(165,'d9cb12c5b53845cd9b4739a0e46af6eb','615b450b59964e5ea4589cf8adb0a439',4,650,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(166,'6686582d4ea34d1d9bd67d90f114db33','615b450b59964e5ea4589cf8adb0a439',6,650,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(167,'5a9a2b5c3e134c74b568bf4dc3c9fdae','24f965f05b7848e8a29924dbd181b80c',4,650,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(168,'f1f00514416648308ad8727b6985858d','24f965f05b7848e8a29924dbd181b80c',6,650,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(169,'9b378cdc9be8418684cda3800899e0a1','bef78c47ad434ce6995c7eac4b4e5dab',4,650,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(170,'8a464588bf434e65940ee10f163e777b','bef78c47ad434ce6995c7eac4b4e5dab',6,650,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(171,'db72b780d0474a259a3f90634b9f8c34','a4f45e930ebd46efb0cbdb36c9fb70d2',4,650,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(172,'eab6b5afcbb84d19872b0e933b8f0e0a','a4f45e930ebd46efb0cbdb36c9fb70d2',6,50,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(173,'1cbdf51c55de40c1977ee1664321442c','a4f45e930ebd46efb0cbdb36c9fb70d2',6,670,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(174,'942e59b899264eb2a2dcedf4a05245b6','a4f45e930ebd46efb0cbdb36c9fb70d2',4,50,1,0,'2020-04-12 14:48:50',0,'2020-04-12 14:48:50'),
(175,'1ce2e94dfa784b419aed76b634333dc9','bb27cbcbf3884fb49f9a1065ac3c620a',4,650,1,0,'2020-04-19 11:36:59',0,'2020-04-19 11:36:58'),
(176,'f61be2ce1d3043d09f0b3d01784616cb','bb27cbcbf3884fb49f9a1065ac3c620a',6,680,1,0,'2020-04-19 11:36:59',0,'2020-04-19 11:36:58'),
(177,'d92cffa1010e4caa97dacca3b9f7f717','549c1ef7f2374f4e8fcdac3b7c5de26c',4,650,1,0,'2020-04-19 11:37:03',0,'2020-04-19 11:37:03'),
(178,'a1a2781395bd45c5820ac2c7d940f95a','549c1ef7f2374f4e8fcdac3b7c5de26c',6,680,1,0,'2020-04-19 11:37:03',0,'2020-04-19 11:37:03');

/*Table structure for table `t_sys_area` */

DROP TABLE IF EXISTS `t_sys_area`;

CREATE TABLE `t_sys_area` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'UUID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_user` varchar(32) NOT NULL COMMENT '创建用户',
  `code` varchar(32) NOT NULL COMMENT '区域代码',
  `name` varchar(255) NOT NULL COMMENT '区域名称',
  `parent_id` bigint(20) NOT NULL COMMENT 'pid',
  `remark` varchar(512) DEFAULT NULL COMMENT '备注信息',
  `state` int(1) DEFAULT '0' COMMENT '状态:0 启用, 1 禁用',
  `priority` varchar(11) DEFAULT NULL COMMENT '排序号',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  `last_modified_user` varchar(32) NOT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `UK_23ahu6mjk385fl50ld23iljes` (`code`) USING BTREE,
  UNIQUE KEY `UK_brixco4h19cnj4fowxsen6dst` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

/*Data for the table `t_sys_area` */

insert  into `t_sys_area`(`id`,`create_time`,`create_user`,`code`,`name`,`parent_id`,`remark`,`state`,`priority`,`last_modified_time`,`last_modified_user`) values 
(5,'2018-08-10 10:30:18','0','350000','福建省',0,NULL,0,NULL,'2018-08-15 10:14:17',''),
(6,'2018-09-05 17:38:22','1','某某街','120101',4,NULL,0,NULL,'2018-09-05 17:38:21','1');

/*Table structure for table `t_sys_attachment` */

DROP TABLE IF EXISTS `t_sys_attachment`;

CREATE TABLE `t_sys_attachment` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'UUID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_user` varchar(32) NOT NULL COMMENT '创建用户',
  `hash` varchar(128) DEFAULT NULL COMMENT '文件哈希',
  `name` varchar(56) NOT NULL COMMENT '文件名称',
  `size` bigint(20) DEFAULT NULL COMMENT '文件大小',
  `state` int(1) DEFAULT NULL COMMENT '状态:0 启用, 1 禁用',
  `type` varchar(32) DEFAULT NULL COMMENT '类型',
  `url` varchar(1024) DEFAULT NULL COMMENT 'URL',
  `show_name` varchar(255) DEFAULT NULL COMMENT '前台显示的文件名',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  `last_modified_user` varchar(32) NOT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `UK_sprcv6iwieerbdqnlfdhg0qk1` (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

/*Data for the table `t_sys_attachment` */

/*Table structure for table `t_sys_company` */

DROP TABLE IF EXISTS `t_sys_company`;

CREATE TABLE `t_sys_company` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'UUID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_user` varchar(32) NOT NULL COMMENT '创建用户',
  `address` text COMMENT '地址',
  `barcode` varchar(32) DEFAULT NULL COMMENT '公司网站二维码',
  `contact` text COMMENT '联系方式',
  `copyright` text COMMENT '权限',
  `credential` text COMMENT '证书',
  `email` text COMMENT '电子邮箱',
  `information` text COMMENT '信息',
  `logo` varchar(32) DEFAULT NULL COMMENT '公司标识',
  `name` text NOT NULL COMMENT '名称',
  `phone` text COMMENT '联系电话',
  `slogan1` text COMMENT '标语1',
  `slogan2` text COMMENT '标语2',
  `system_name` text COMMENT '系统名称',
  `welcome_picture` varchar(32) DEFAULT NULL COMMENT '欢迎图片',
  `fax` varchar(64) DEFAULT NULL COMMENT '传真号码',
  `mobile` varchar(32) DEFAULT NULL COMMENT '联系电话',
  `web_site` varchar(128) DEFAULT NULL COMMENT '官方网站',
  `zip` varchar(8) DEFAULT NULL COMMENT '邮政编码',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  `last_modified_user` varchar(32) NOT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `UK_1ogheau6g40tewkkguf8r01t1` (`fax`) USING BTREE,
  UNIQUE KEY `UK_7wigop1491uxv5pum03uri3wm` (`mobile`) USING BTREE,
  UNIQUE KEY `UK_bbu877aw3g0jefur0c5ldhvks` (`web_site`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

/*Data for the table `t_sys_company` */

/*Table structure for table `t_sys_config` */

DROP TABLE IF EXISTS `t_sys_config`;

CREATE TABLE `t_sys_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'UUID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_user` varchar(32) NOT NULL COMMENT '创建用户',
  `attachment_server` varchar(50) DEFAULT NULL COMMENT '附件服务器地址',
  `logo` varchar(32) DEFAULT NULL COMMENT '系统logo',
  `name` varchar(126) DEFAULT NULL COMMENT '系统名称',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  `last_modified_user` varchar(32) NOT NULL COMMENT '最后修改用户',
  `level` varchar(10) DEFAULT NULL COMMENT '级别',
  `threshold` float DEFAULT NULL COMMENT '人脸匹配度配置',
  `attachment_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

/*Data for the table `t_sys_config` */

insert  into `t_sys_config`(`id`,`create_time`,`create_user`,`attachment_server`,`logo`,`name`,`last_modified_time`,`last_modified_user`,`level`,`threshold`,`attachment_id`) values 
(1,'2018-05-22 14:47:52','0','http://localhost:8080/attachments/','','后台系统','2018-09-07 11:35:52','',NULL,NULL,NULL);

/*Table structure for table `t_sys_dict` */

DROP TABLE IF EXISTS `t_sys_dict`;

CREATE TABLE `t_sys_dict` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `dict_group_id` bigint(20) NOT NULL COMMENT '字典组ID',
  `dict_group_code` varchar(128) DEFAULT NULL COMMENT '字典组code',
  `name` varchar(128) NOT NULL COMMENT '字典名',
  `system` tinyint(1) DEFAULT '0' COMMENT '是否系统内置:0 是, 1 否',
  `code` varchar(128) DEFAULT NULL COMMENT '字典编码',
  `sort` tinyint(4) NOT NULL DEFAULT '0' COMMENT '排序',
  `remark` text COMMENT '备注',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_user` varchar(32) NOT NULL COMMENT '创建用户',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  `last_modified_user` varchar(32) NOT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `NewIndex1` (`dict_group_id`,`code`) USING BTREE,
  KEY `NewIndex2` (`dict_group_id`,`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='字典表';

/*Data for the table `t_sys_dict` */

insert  into `t_sys_dict`(`id`,`dict_group_id`,`dict_group_code`,`name`,`system`,`code`,`sort`,`remark`,`create_time`,`create_user`,`last_modified_time`,`last_modified_user`) values 
(6,1,NULL,'1',0,'1',0,NULL,'2018-08-21 10:10:41','1','2018-11-01 10:12:46','1'),
(68,16,'pms_week_daily_excel','chenfuqian@furongsoft.com',0,'chenfuqian@furongsoft.com',0,NULL,'2018-09-02 17:51:56','1','2018-09-02 18:53:24','1'),
(70,17,'日报其他类型','售后服务',0,'1',0,NULL,'2018-09-15 13:11:27','1','2018-09-15 21:11:26','1'),
(78,18,'mes_production_line_type','生产流水线',0,'1',0,NULL,'2018-10-22 22:22:44','1','2018-10-22 22:22:43','1'),
(79,18,'mes_production_line_type','组件生产',0,'2',0,NULL,'2018-10-22 22:23:01','1','2018-10-22 22:23:01','1'),
(80,18,'mes_production_line_type','原料加工',0,'3',0,NULL,'2018-10-22 22:23:11','1','2018-10-22 22:23:11','1'),
(81,19,'mes_bill_of_material_type','产品',0,'1',1,NULL,'2018-10-24 06:38:49','1','2018-10-24 06:38:48','1'),
(82,19,'mes_bill_of_material_type','组合件',0,'2',2,NULL,'2018-10-24 06:39:02','1','2018-10-24 06:39:02','1'),
(83,19,'mes_bill_of_material_type','零部件',0,'3',3,NULL,'2018-10-24 06:39:13','1','2018-10-24 06:39:12','1'),
(84,19,'mes_bill_of_material_type','原材料',0,'4',4,NULL,'2018-10-24 06:39:22','1','2018-10-24 06:39:22','1'),
(85,20,'mes_bill_of_material_source','自制件',0,'1',1,NULL,'2018-10-24 06:41:19','1','2018-10-24 06:41:19','1'),
(86,20,'mes_bill_of_material_source','采购件',0,'2',2,NULL,'2018-10-24 06:41:29','1','2018-10-24 06:41:28','1'),
(87,21,'mes_bill_of_material_state','未审核',0,'1',1,NULL,'2018-10-24 06:42:19','1','2018-10-24 06:42:18','1'),
(88,21,'mes_bill_of_material_state','已审核',0,'2',2,NULL,'2018-10-24 06:42:30','1','2018-10-24 06:42:29','1'),
(89,22,'mes_bill_of_material_unit','个',0,'1',1,NULL,'2018-10-24 06:47:52','1','2018-10-24 06:47:52','1'),
(90,22,'mes_bill_of_material_unit','箱',0,'2',2,NULL,'2018-10-24 06:48:06','1','2018-10-24 06:48:05','1'),
(91,22,'mes_bill_of_material_unit','斤',0,'3',3,NULL,'2018-10-24 06:48:14','1','2018-10-24 06:48:14','1'),
(92,22,'mes_bill_of_material_unit','堆',0,'4',4,NULL,'2018-10-24 06:48:27','1','2018-10-24 06:48:26','1'),
(93,22,'mes_bill_of_material_unit','台',0,'5',5,NULL,'2018-10-24 06:48:36','1','2018-10-24 06:48:36','1'),
(94,22,'mes_bill_of_material_unit','架',0,'6',6,NULL,'2018-10-24 06:48:52','1','2018-10-24 06:48:52','1'),
(95,23,'mes_equipment_state','空闲中',0,'1',1,NULL,'2018-10-25 16:40:05','1','2018-10-25 16:40:04','1'),
(96,23,'mes_equipment_state','生产中',0,'2',2,NULL,'2018-10-25 16:40:19','1','2018-10-25 16:40:19','1'),
(97,23,'mes_equipment_state','停用',0,'3',3,NULL,'2018-10-25 16:40:30','1','2018-10-25 16:40:30','1'),
(98,23,'mes_equipment_state','维护中',0,'4',4,NULL,'2018-10-25 16:40:41','1','2018-10-25 16:40:41','1'),
(99,23,'mes_equipment_state','准备中',0,'6',6,NULL,'2018-10-25 16:40:55','1','2018-10-25 16:40:54','1'),
(100,24,'mes_working_process_state','未审核',0,'1',1,NULL,'2018-11-01 15:45:12','1','2018-11-01 15:45:11','1'),
(101,24,'mes_working_process_state','已审核',0,'2',2,NULL,'2018-11-01 15:45:22','1','2018-11-01 15:45:22','1'),
(102,25,'mes_working_procedure_build_type','自制',0,'1',1,NULL,'2018-11-01 17:52:19','1','2018-11-01 17:52:18','1'),
(103,25,'mes_working_procedure_build_type','外协',0,'2',2,NULL,'2018-11-01 17:52:37','1','2018-11-01 17:52:37','1'),
(104,26,'mes_product_category','全新产品',0,'1',0,NULL,'2018-11-15 17:34:05','1','2018-11-15 17:34:04','1'),
(105,26,'mes_product_category','改进产品',0,'2',0,NULL,'2018-11-15 17:34:16','1','2018-11-15 17:34:15','1'),
(106,26,'mes_product_category','换代产品',0,'3',0,NULL,'2018-11-15 17:34:30','1','2018-11-15 17:34:30','1'),
(107,26,'mes_product_category','仿制产品',0,'4',0,NULL,'2018-11-15 17:34:45','1','2018-11-15 17:34:45','1'),
(108,27,'mes_product_state','未审核',0,'1',0,NULL,'2018-11-15 17:34:55','1','2018-11-15 17:34:55','1'),
(109,27,'mes_product_state','已审核',0,'2',0,NULL,'2018-11-15 17:35:04','1','2018-11-15 17:35:04','1'),
(110,28,'mes_product_unit','架',0,'1',0,NULL,'2018-11-16 11:31:00','1','2018-11-16 11:31:00','1'),
(111,28,'mes_product_unit','台',0,'2',0,NULL,'2018-11-16 11:31:06','1','2018-11-16 11:31:06','1'),
(112,28,'mes_product_unit','箱',0,'3',0,NULL,'2018-11-16 11:31:15','1','2018-11-16 11:31:14','1'),
(113,28,'mes_product_unit','堆',0,'4',0,NULL,'2018-11-16 11:31:23','1','2018-11-16 11:31:22','1'),
(114,28,'mes_product_unit','个',0,'5',0,NULL,'2018-11-16 11:31:28','1','2018-11-16 11:31:27','1'),
(115,28,'mes_product_unit','框',0,'6',0,NULL,'2018-11-16 11:31:35','1','2018-11-16 11:31:34','1'),
(116,28,'mes_product_unit','斤',0,'7',0,NULL,'2018-11-16 11:31:43','1','2018-11-16 11:31:43','1');

/*Table structure for table `t_sys_dict_group` */

DROP TABLE IF EXISTS `t_sys_dict_group`;

CREATE TABLE `t_sys_dict_group` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(128) NOT NULL COMMENT '字典组名',
  `code` varchar(128) NOT NULL COMMENT '字典组编码',
  `system` int(1) DEFAULT '0' COMMENT '是否系统内置:0 是, 1 否',
  `sort` tinyint(4) NOT NULL DEFAULT '0' COMMENT '排序',
  `remark` text COMMENT '备注',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_user` varchar(32) NOT NULL COMMENT '创建用户',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  `last_modified_user` varchar(32) NOT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `code` (`code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='字典组表';

/*Data for the table `t_sys_dict_group` */

insert  into `t_sys_dict_group`(`id`,`name`,`code`,`system`,`sort`,`remark`,`create_time`,`create_user`,`last_modified_time`,`last_modified_user`) values 
(18,'生产线类型','mes_production_line_type',0,0,NULL,'2018-10-22 22:22:04','1','2018-10-22 22:22:03','1'),
(19,'物料类型','mes_bill_of_material_type',0,0,NULL,'2018-10-24 06:38:19','1','2018-10-24 06:38:18','1'),
(20,'物料来源','mes_bill_of_material_source',0,0,NULL,'2018-10-24 06:40:55','1','2018-10-24 06:40:54','1'),
(21,'物料状态','mes_bill_of_material_state',0,0,NULL,'2018-10-24 06:41:56','1','2018-10-24 06:41:55','1'),
(22,'物料单位','mes_bill_of_material_unit',0,0,NULL,'2018-10-24 06:47:39','1','2018-10-24 06:47:38','1'),
(23,'设备状态','mes_equipment_state',0,0,NULL,'2018-10-25 16:39:27','1','2018-10-25 16:39:27','1'),
(24,'工艺状态','mes_working_process_state',0,0,NULL,'2018-11-01 15:41:18','1','2018-11-01 15:41:17','1'),
(25,'工序生产方式','mes_working_procedure_build_type',0,0,NULL,'2018-11-01 17:52:02','1','2018-11-01 17:52:01','1'),
(26,'产品类型','mes_product_category',0,0,NULL,'2018-11-15 17:30:43','1','2018-11-15 17:30:42','1'),
(27,'产品状态','mes_product_state',0,0,NULL,'2018-11-15 17:31:08','1','2018-11-15 17:31:08','1'),
(28,'产品单位','mes_product_unit',0,0,NULL,'2018-11-16 11:30:42','1','2018-11-16 11:30:42','1');

/*Table structure for table `t_sys_loginfo` */

DROP TABLE IF EXISTS `t_sys_loginfo`;

CREATE TABLE `t_sys_loginfo` (
  `company_id` varchar(32) NOT NULL COMMENT '公司ID',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(32) NOT NULL COMMENT '创建用户',
  `err_log` text NOT NULL COMMENT '错误信息',
  `exec_time` double NOT NULL COMMENT '执行时间',
  `ip` varchar(64) NOT NULL COMMENT '客户端ip',
  `model` varchar(32) NOT NULL COMMENT '当前操作模块',
  `operation` varchar(32) NOT NULL COMMENT '操作模块功能',
  `type` varchar(32) NOT NULL COMMENT '操作类型',
  `username` varchar(32) NOT NULL COMMENT '用户登录名'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

/*Data for the table `t_sys_loginfo` */

/*Table structure for table `t_sys_organization` */

DROP TABLE IF EXISTS `t_sys_organization`;

CREATE TABLE `t_sys_organization` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'UUID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_user` varchar(32) NOT NULL COMMENT '创建用户',
  `duty` text COMMENT '部门职责',
  `name` varchar(255) NOT NULL COMMENT '部门名称',
  `code` varchar(128) NOT NULL COMMENT '部门编号',
  `parent_id` varchar(32) NOT NULL COMMENT 'parentId',
  `sort` tinyint(4) DEFAULT '0' COMMENT '排序号',
  `state` int(1) DEFAULT '0' COMMENT '状态:0 启用, 1 禁用',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  `last_modified_user` varchar(32) NOT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

/*Data for the table `t_sys_organization` */

insert  into `t_sys_organization`(`id`,`create_time`,`create_user`,`duty`,`name`,`code`,`parent_id`,`sort`,`state`,`last_modified_time`,`last_modified_user`) values 
(1,'2018-08-21 09:55:06','1',NULL,'软件开发部','8600','0',0,0,'2018-08-21 09:55:05','1'),
(5,'2018-09-09 02:23:22','1',NULL,'总经办','8100','0',0,0,'2018-09-09 10:23:21','1'),
(6,'2018-09-09 02:23:40','1',NULL,'行政部','8200','0',0,0,'2018-09-09 10:23:40','1'),
(7,'2018-09-09 02:24:05','1',NULL,'教育事业部','8300','0',0,0,'2018-09-09 10:24:04','1'),
(8,'2018-09-09 02:24:18','1',NULL,'财务部','8500','0',0,0,'2018-09-09 10:24:17','1'),
(9,'2018-09-09 02:24:32','1',NULL,'销售部','8700','0',0,0,'2018-09-09 10:24:32','1'),
(10,'2018-09-09 02:24:47','1',NULL,'方案部','8800','0',0,0,'2018-09-09 10:24:47','1'),
(11,'2018-09-09 02:25:01','1',NULL,'工程项目部','8900','0',0,0,'2018-09-09 10:25:01','1'),
(12,'2018-09-09 02:25:15','1',NULL,'培训部','9000','0',0,0,'2018-09-09 10:25:14','1');

/*Table structure for table `t_sys_permission` */

DROP TABLE IF EXISTS `t_sys_permission`;

CREATE TABLE `t_sys_permission` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'UUID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_user` varchar(32) NOT NULL COMMENT '创建用户',
  `name` varchar(64) NOT NULL COMMENT '名称',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `state` int(1) NOT NULL DEFAULT '0' COMMENT '状态:0 启用, 1 禁用',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  `last_modified_user` varchar(32) NOT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `UK_qqmk03vklngso0j13kukc1f90` (`name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=718299469 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

/*Data for the table `t_sys_permission` */

insert  into `t_sys_permission`(`id`,`create_time`,`create_user`,`name`,`remark`,`state`,`last_modified_time`,`last_modified_user`) values 
(718299464,'2018-05-24 10:35:17','','超级管理员',NULL,0,'2018-08-15 10:14:25',''),
(718299465,'2018-09-04 12:04:56','1','管理层',NULL,0,'2018-09-04 12:04:56','1'),
(718299466,'2018-09-07 02:52:33','1','普通用户',NULL,0,'2018-09-07 10:52:32','1'),
(718299467,'2018-09-07 02:56:40','1','项目经理',NULL,0,'2018-09-07 10:56:40','1'),
(718299468,'2018-09-09 11:32:53','1','发送周报',NULL,0,'2018-09-09 19:32:53','1');

/*Table structure for table `t_sys_permission_resource` */

DROP TABLE IF EXISTS `t_sys_permission_resource`;

CREATE TABLE `t_sys_permission_resource` (
  `permission_id` bigint(20) NOT NULL COMMENT '权限ID',
  `resource_id` bigint(20) NOT NULL COMMENT '资源ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

/*Data for the table `t_sys_permission_resource` */

insert  into `t_sys_permission_resource`(`permission_id`,`resource_id`) values 
(718299464,1),
(718299464,2),
(718299464,3),
(718299464,4),
(718299464,5),
(718299464,6),
(718299464,7),
(718299464,8),
(718299464,11),
(718299464,12),
(718299464,25),
(718299464,26),
(718299464,27),
(718299464,28),
(718299464,29),
(718299464,31),
(718299464,33),
(718299464,34),
(718299464,35),
(718299464,30),
(718299464,36),
(718299464,37),
(718299464,38),
(718299464,39),
(718299464,40),
(718299464,41),
(718299464,42),
(718299464,43),
(718299464,44),
(718299464,45);

/*Table structure for table `t_sys_position` */

DROP TABLE IF EXISTS `t_sys_position`;

CREATE TABLE `t_sys_position` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(128) DEFAULT NULL COMMENT '名称',
  `parent_id` bigint(20) NOT NULL COMMENT '父级岗位',
  `department_id` bigint(20) NOT NULL COMMENT '部门索引',
  `type` bigint(20) NOT NULL COMMENT '岗位分类',
  `duty` text COMMENT '岗位职责',
  `state` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_user` bigint(20) NOT NULL COMMENT '创建用户',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='岗位表';

/*Data for the table `t_sys_position` */

insert  into `t_sys_position`(`id`,`name`,`parent_id`,`department_id`,`type`,`duty`,`state`,`create_time`,`create_user`,`last_modified_time`,`last_modified_user`) values 
(1,'开发',0,1,5,'1',0,'2018-08-21 11:24:15',1,'2018-08-21 11:25:44',1),
(2,'打法',1,1,5,NULL,0,'2018-08-21 11:24:32',1,'2018-08-21 11:25:46',1);

/*Table structure for table `t_sys_resource` */

DROP TABLE IF EXISTS `t_sys_resource`;

CREATE TABLE `t_sys_resource` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'UUID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_user` bigint(20) NOT NULL COMMENT '创建用户',
  `icon` varchar(32) DEFAULT NULL COMMENT '图标',
  `name` varchar(64) NOT NULL COMMENT '名称',
  `path` varchar(255) NOT NULL COMMENT '路径',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `state` int(1) NOT NULL DEFAULT '0' COMMENT '状态:0 启用, 1 禁用',
  `type` int(4) NOT NULL DEFAULT '0' COMMENT '类型:0 图片, 1 文件',
  `system` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否系统内置:1 是, 0 否',
  `parent_id` bigint(20) NOT NULL COMMENT '父级节点ID',
  `priority` int(4) DEFAULT '0' COMMENT '优先级',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

/*Data for the table `t_sys_resource` */

insert  into `t_sys_resource`(`id`,`create_time`,`create_user`,`icon`,`name`,`path`,`remark`,`state`,`type`,`system`,`parent_id`,`priority`,`last_modified_time`,`last_modified_user`) values 
(1,'2018-08-03 13:08:41',0,NULL,'字典管理','/system/dict',NULL,0,0,1,5,0,'2018-08-15 15:07:43',0),
(2,'2018-08-07 10:20:04',0,NULL,'组织管理','/system/organization',NULL,0,0,1,5,0,'2018-08-15 15:07:44',0),
(3,'2018-08-02 17:13:10',0,NULL,'区域管理','/system/area',NULL,0,0,1,5,1,'2018-08-15 15:07:44',0),
(4,'2018-05-25 15:22:10',0,NULL,'角色管理','/system/role','',0,0,1,5,0,'2018-08-15 15:07:45',0),
(5,'2018-05-24 21:38:46',0,NULL,'系统管理','/','2',0,0,1,0,0,'2018-08-15 15:07:21',0),
(6,'2018-05-24 21:38:46',0,NULL,'资源管理','/system/resource',NULL,0,0,1,5,0,'2018-08-15 15:07:45',0),
(7,'2018-05-24 22:12:59',0,NULL,'权限管理','/system/permission',NULL,0,0,1,5,0,'2018-08-15 15:07:46',0),
(8,'2018-05-24 22:48:35',0,NULL,'用户管理','/system/user',NULL,0,0,1,5,0,'2018-08-15 15:07:48',0),
(11,'2018-08-21 09:45:06',1,NULL,'组织架构','/system/organization',NULL,0,0,1,5,0,'2018-08-21 09:45:06',1),
(12,'2018-08-21 11:07:14',1,NULL,'岗位管理','/system/position',NULL,0,0,1,5,0,'2018-08-21 11:07:13',1),
(25,'2018-09-25 09:20:42',1,NULL,'公司管理','/system/company',NULL,0,0,0,5,0,'2018-09-25 09:20:42',1),
(26,'2018-09-25 14:11:31',1,NULL,'生产管理','/mes',NULL,0,0,0,0,0,'2018-09-25 14:11:31',1),
(27,'2018-09-25 14:13:58',1,NULL,'工厂管理','/mes/base/factory',NULL,0,0,0,37,1,'2018-09-25 14:13:58',1),
(28,'2018-09-25 14:20:30',1,NULL,'车间管理','/mes/base/workshop',NULL,0,0,0,37,2,'2018-09-25 14:20:30',1),
(29,'2018-09-25 14:21:06',1,NULL,'班次管理','/mes/base/workshift',NULL,0,0,0,37,7,'2018-09-25 14:21:05',1),
(30,'2018-09-25 14:21:39',1,NULL,'生产线管理','/mes/base/productionLine',NULL,0,0,0,37,3,'2018-09-25 14:21:38',1),
(31,'2018-09-29 22:25:31',1,NULL,'班制管理','/mes/base/workingSystem',NULL,0,0,0,37,6,'2018-09-29 22:25:31',1),
(32,'2018-09-30 14:44:10',1,NULL,'工作日历','/mes/workingCalendar',NULL,0,0,0,26,6,'2018-09-30 14:44:09',1),
(33,'2018-10-10 09:14:30',1,NULL,'系统监控','monitor',NULL,0,0,0,0,0,'2018-10-10 09:14:30',1),
(34,'2018-10-10 09:15:24',1,NULL,'操作日志','/monitor/log',NULL,0,0,0,33,0,'2018-10-10 09:15:23',1),
(35,'2018-10-10 09:16:27',1,NULL,'数据库监控','/monitor/druid',NULL,0,0,0,33,0,'2018-10-10 09:16:26',1),
(36,'2018-10-23 23:20:44',1,NULL,'物料管理','/mes/product/billOfMaterial',NULL,0,0,0,38,2,'2018-10-23 23:20:43',1),
(37,'2018-10-25 15:06:37',1,NULL,'基础信息','/mes/base',NULL,0,0,0,26,1,'2018-10-25 15:06:36',1),
(38,'2018-10-25 15:13:56',1,NULL,'产品信息','/mes/product',NULL,0,0,0,26,3,'2018-10-25 15:13:56',1),
(39,'2018-10-25 15:14:56',1,NULL,'设备信息','/mes/equipment',NULL,0,0,0,26,2,'2018-10-25 15:14:56',1),
(40,'2018-10-25 15:18:26',1,NULL,'设备类型','/mes/equipment/equipmentCategory',NULL,0,0,0,39,1,'2018-10-25 15:18:25',1),
(41,'2018-10-25 15:19:21',1,NULL,'设备管理','/mes/equipment/equipment',NULL,0,0,0,39,2,'2018-10-25 15:19:21',1),
(42,'2018-10-29 17:15:26',1,NULL,'工作站类型','/mes/base/workingStationCategory',NULL,0,0,0,37,5,'2018-10-29 17:15:25',1),
(43,'2018-10-29 22:06:43',1,NULL,'工作站管理','/mes/base/workingStation',NULL,0,0,0,37,4,'2018-10-29 22:06:42',1),
(44,'2018-11-01 18:07:18',1,NULL,'工艺管理','/mes/product/workingProcess',NULL,0,0,0,38,3,'2018-11-01 18:07:17',1),
(45,'2018-11-16 11:17:34',1,NULL,'产品管理','/mes/product/product',NULL,0,0,0,38,1,'2018-11-16 11:17:34',1);

/*Table structure for table `t_sys_role` */

DROP TABLE IF EXISTS `t_sys_role`;

CREATE TABLE `t_sys_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'UUID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_user` bigint(20) NOT NULL COMMENT '创建用户',
  `name` varchar(64) DEFAULT NULL COMMENT '名称',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `system` tinyint(1) DEFAULT '0' COMMENT '是否系统角色 0-是 1-否',
  `state` int(1) DEFAULT '0' COMMENT '状态:0 启用, 1 禁用',
  `code` varchar(64) DEFAULT NULL COMMENT '角色编码',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

/*Data for the table `t_sys_role` */

insert  into `t_sys_role`(`id`,`create_time`,`create_user`,`name`,`remark`,`system`,`state`,`code`,`last_modified_time`,`last_modified_user`) values 
(3,'2018-05-24 10:36:59',0,'超级管理员',NULL,0,0,'admin','2018-08-15 15:08:48',0),
(5,'2018-09-04 11:28:26',1,'管理层',NULL,0,0,'pms_all_project_manage','2018-09-07 11:11:29',1),
(6,'2018-09-04 11:28:34',1,'项目经理',NULL,0,0,'pms_project_create','2018-09-07 11:11:20',1),
(7,'2018-09-04 11:28:47',1,'产品经理',NULL,0,0,'pms_project_create','2018-09-07 11:11:27',1),
(8,'2018-09-07 02:52:21',1,'普通用户',NULL,0,0,NULL,'2018-09-07 10:52:20',1),
(9,'2018-09-09 11:33:28',1,'发送周报',NULL,0,0,NULL,'2018-09-09 19:33:27',1);

/*Table structure for table `t_sys_role_permission` */

DROP TABLE IF EXISTS `t_sys_role_permission`;

CREATE TABLE `t_sys_role_permission` (
  `permission_id` bigint(20) NOT NULL COMMENT '权限ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

/*Data for the table `t_sys_role_permission` */

insert  into `t_sys_role_permission`(`permission_id`,`role_id`) values 
(0,0),
(718299464,3),
(718299465,5);

/*Table structure for table `t_sys_user` */

DROP TABLE IF EXISTS `t_sys_user`;

CREATE TABLE `t_sys_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'UUID',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_user` bigint(20) NOT NULL COMMENT '创建用户',
  `address` varchar(64) DEFAULT NULL COMMENT '住宅地址',
  `address2` varchar(64) DEFAULT NULL COMMENT '住宅地址',
  `age` int(10) DEFAULT NULL COMMENT '年龄',
  `birthday` datetime DEFAULT NULL COMMENT '生日',
  `business_address` varchar(64) DEFAULT NULL COMMENT '工作地址',
  `business_address2` varchar(64) DEFAULT NULL COMMENT '工作地址',
  `city` varchar(255) DEFAULT NULL COMMENT '市/县',
  `company` bigint(20) DEFAULT NULL COMMENT '工作单位',
  `company2` bigint(20) DEFAULT NULL COMMENT '工作单位',
  `company3` bigint(20) DEFAULT NULL COMMENT '工作单位',
  `country` varchar(255) DEFAULT NULL COMMENT '国家',
  `email` varchar(255) DEFAULT NULL COMMENT '电子邮件',
  `email2` varchar(255) DEFAULT NULL COMMENT '电子邮件',
  `email3` varchar(255) DEFAULT NULL COMMENT '电子邮件',
  `icon_url` varchar(255) DEFAULT NULL COMMENT '头像',
  `identification` varchar(255) DEFAULT NULL COMMENT '证件',
  `identification2` varchar(255) DEFAULT NULL COMMENT '证件',
  `identification3` varchar(255) DEFAULT NULL COMMENT '证件',
  `mobile` varchar(32) DEFAULT NULL COMMENT '移动电话',
  `mobile2` varchar(32) DEFAULT NULL COMMENT '移动电话',
  `name` varchar(128) DEFAULT NULL COMMENT '姓名',
  `password` varchar(64) NOT NULL COMMENT '密码',
  `picture_url` varchar(255) DEFAULT NULL COMMENT '照片',
  `province` varchar(255) DEFAULT NULL COMMENT '省份/州',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `salt` varchar(64) NOT NULL COMMENT '盐值',
  `sex` int(10) DEFAULT NULL COMMENT '性别',
  `sns_account` varchar(255) DEFAULT NULL COMMENT '社交软件账号',
  `sns_account2` varchar(255) DEFAULT NULL COMMENT '社交软件账号',
  `sns_account3` varchar(255) DEFAULT NULL COMMENT '社交软件账号',
  `state` int(1) DEFAULT '0' COMMENT '状态:0 启用, 1 禁用',
  `street` varchar(255) DEFAULT NULL COMMENT '街道',
  `telephone` varchar(32) DEFAULT NULL COMMENT '固定电话',
  `telephone2` varchar(32) DEFAULT NULL COMMENT '固定电话',
  `department` bigint(20) DEFAULT NULL COMMENT '部门',
  `department2` bigint(20) DEFAULT NULL COMMENT '部门',
  `department3` bigint(20) DEFAULT NULL COMMENT '部门',
  `title` bigint(20) DEFAULT NULL COMMENT '头衔',
  `title2` bigint(20) DEFAULT NULL COMMENT '头衔',
  `title3` bigint(20) DEFAULT NULL COMMENT '头衔',
  `town` varchar(255) DEFAULT NULL COMMENT '区/镇',
  `username` varchar(32) NOT NULL COMMENT '登录账户',
  `web` varchar(255) DEFAULT NULL COMMENT '网站',
  `web2` varchar(255) DEFAULT NULL COMMENT '网站',
  `web3` varchar(255) DEFAULT NULL COMMENT '网站',
  `zip` varchar(32) DEFAULT NULL COMMENT '邮编',
  `code` varchar(128) DEFAULT NULL COMMENT '用户编号',
  `web_site` varchar(255) DEFAULT NULL COMMENT '网站',
  `web_site2` varchar(255) DEFAULT NULL COMMENT '网站',
  `area_id` bigint(20) DEFAULT NULL COMMENT '区域',
  `web_site3` varchar(255) DEFAULT NULL COMMENT '网站',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `UK_c6kfx4dbytwpxd74oon192ai0` (`username`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

/*Data for the table `t_sys_user` */

insert  into `t_sys_user`(`id`,`create_time`,`create_user`,`address`,`address2`,`age`,`birthday`,`business_address`,`business_address2`,`city`,`company`,`company2`,`company3`,`country`,`email`,`email2`,`email3`,`icon_url`,`identification`,`identification2`,`identification3`,`mobile`,`mobile2`,`name`,`password`,`picture_url`,`province`,`remark`,`salt`,`sex`,`sns_account`,`sns_account2`,`sns_account3`,`state`,`street`,`telephone`,`telephone2`,`department`,`department2`,`department3`,`title`,`title2`,`title3`,`town`,`username`,`web`,`web2`,`web3`,`zip`,`code`,`web_site`,`web_site2`,`area_id`,`web_site3`,`last_modified_time`,`last_modified_user`) values 
(1,'2018-05-22 14:47:52',0,NULL,NULL,NULL,'2018-07-17 00:00:00',NULL,NULL,'2',NULL,NULL,NULL,NULL,'11@qq.com',NULL,NULL,'747330000113',NULL,NULL,NULL,'222',NULL,'管理员','9e8aa87f55fe04b6a94e5abbf10f262c',NULL,'1',NULL,'e7e8219f1332e31eaeec233786a61cf4',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,1,NULL,NULL,1,NULL,NULL,'4','admin',NULL,NULL,NULL,NULL,'360000',NULL,NULL,NULL,NULL,'2019-07-17 15:09:42',1);

/*Table structure for table `t_sys_user_configure` */

DROP TABLE IF EXISTS `t_sys_user_configure`;

CREATE TABLE `t_sys_user_configure` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `report_type` bigint(20) DEFAULT NULL COMMENT '日报类型',
  `create_user` bigint(20) NOT NULL COMMENT '创建用户',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后修改用户',
  `last_modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

/*Data for the table `t_sys_user_configure` */

insert  into `t_sys_user_configure`(`id`,`user_id`,`report_type`,`create_user`,`create_time`,`last_modified_user`,`last_modified_time`) values 
(1,1,49,1,'2018-09-16 22:43:21',1,'2018-09-20 17:02:37');

/*Table structure for table `t_sys_user_role` */

DROP TABLE IF EXISTS `t_sys_user_role`;

CREATE TABLE `t_sys_user_role` (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

/*Data for the table `t_sys_user_role` */

insert  into `t_sys_user_role`(`user_id`,`role_id`) values 
(1,3),
(1,5);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
