/*
 Navicat Premium Data Transfer

 Source Server         : myself
 Source Server Type    : MySQL
 Source Server Version : 50729
 Source Host           : localhost:3306
 Source Schema         : frog_agv

 Target Server Type    : MySQL
 Target Server Version : 50729
 File Encoding         : 65001

 Date: 04/04/2020 13:12:08
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for t_agv_acceptance
-- ----------------------------
DROP TABLE IF EXISTS `t_agv_acceptance`;
CREATE TABLE `t_agv_acceptance`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `call_material_id` bigint(20) NOT NULL COMMENT '叫料ID',
  `count` int(11) NOT NULL COMMENT '验收数量',
  `acceptance_time` datetime(0) NOT NULL COMMENT '验收时间',
  `team_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '班组唯一标识',
  `team_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '班组名称',
  `area_id` bigint(20) NULL DEFAULT NULL COMMENT '区域ID(产线ID)',
  `delivery_task_id` bigint(20) NULL DEFAULT NULL COMMENT '配送任务ID',
  `enabled` tinyint(1) NOT NULL COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT 0 COMMENT '创建者',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '验收表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_agv_acceptance_record
-- ----------------------------
DROP TABLE IF EXISTS `t_agv_acceptance_record`;
CREATE TABLE `t_agv_acceptance_record`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `operation_time` datetime(0) NOT NULL COMMENT '操作时间',
  `team_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '班组唯一标识',
  `team_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '班组名称',
  `source` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '源数据',
  `results` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '结果数据',
  `type` tinyint(4) NOT NULL COMMENT '操作类型【1：新增；2：修改；3：删除】',
  `area_id` bigint(20) NULL DEFAULT NULL COMMENT '区域ID(产线ID)',
  `enabled` tinyint(1) NOT NULL COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT 0 COMMENT '创建者',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '验收记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_agv_area
-- ----------------------------
DROP TABLE IF EXISTS `t_agv_area`;
CREATE TABLE `t_agv_area`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `parent_id` bigint(20) NOT NULL COMMENT '父级区域ID',
  `type` tinyint(4) NOT NULL COMMENT '类型【1：生产区；2：灌装区；3：包装区；4：消毒间；5：拆包间；6：包材仓；7：生产线；8：库位区】',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '编号',
  `enabled` tinyint(1) NOT NULL COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT 0 COMMENT '创建者',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '区域表{已填}' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_agv_area
-- ----------------------------
INSERT INTO `t_agv_area` VALUES (1, 0, 1, '生产区', 'PRODUCT', 1, 1, '2020-03-25 10:06:55', 1, '2020-03-25 10:19:44');
INSERT INTO `t_agv_area` VALUES (2, 1, 2, '灌装区', 'PRODUCT_FILLING', 1, 1, '2020-03-25 10:08:24', 1, '2020-03-25 10:19:41');
INSERT INTO `t_agv_area` VALUES (3, 1, 3, '包装区', 'PRODUCT_PACKAGING', 1, 1, '2020-03-25 10:08:53', 1, '2020-03-25 10:19:41');
INSERT INTO `t_agv_area` VALUES (4, 0, 4, '消毒间', 'DISINFECTION', 1, 1, '2020-03-25 10:10:01', 1, '2020-03-25 10:19:40');
INSERT INTO `t_agv_area` VALUES (5, 0, 5, '拆包间', 'UNPACKING', 1, 1, '2020-03-25 10:10:35', 1, '2020-03-25 10:19:40');
INSERT INTO `t_agv_area` VALUES (6, 0, 6, '包材仓', 'WAREHOUSE', 1, 1, '2020-03-25 10:11:22', 1, '2020-03-25 10:19:39');
INSERT INTO `t_agv_area` VALUES (7, 2, 7, '产线11', 'L11', 1, 1, '2020-03-25 10:17:52', 1, '2020-03-25 10:19:39');
INSERT INTO `t_agv_area` VALUES (8, 2, 7, '产线12', 'L12', 1, 1, '2020-03-25 10:18:19', 1, '2020-03-25 10:19:38');
INSERT INTO `t_agv_area` VALUES (9, 2, 7, '产线13', 'L13', 1, 1, '2020-03-25 10:18:48', 1, '2020-03-25 10:21:49');
INSERT INTO `t_agv_area` VALUES (10, 2, 7, '产线14', 'L14', 1, 1, '2020-03-25 10:19:27', 1, '2020-03-25 10:19:38');
INSERT INTO `t_agv_area` VALUES (11, 3, 7, '产线11', 'L11', 1, 1, '2020-03-25 10:21:44', 1, '2020-03-25 10:21:44');
INSERT INTO `t_agv_area` VALUES (12, 3, 7, '产线12', 'L12', 1, 1, '2020-03-25 10:22:08', 1, '2020-03-25 10:22:08');
INSERT INTO `t_agv_area` VALUES (13, 3, 7, '产线13', 'L13', 1, 1, '2020-03-25 10:22:29', 1, '2020-03-25 10:22:29');
INSERT INTO `t_agv_area` VALUES (14, 3, 7, '产线14', 'L14', 1, 1, '2020-03-25 10:22:52', 1, '2020-03-25 10:22:52');
INSERT INTO `t_agv_area` VALUES (15, 4, 8, '消毒间库位', 'XD_LOCATION', 1, 1, '2020-03-25 10:45:33', 1, '2020-03-25 10:45:33');
INSERT INTO `t_agv_area` VALUES (16, 5, 8, '拆包间库位', 'CB_LOCATION', 1, 1, '2020-03-25 10:46:24', 1, '2020-03-25 10:46:24');
INSERT INTO `t_agv_area` VALUES (17, 6, 8, '包材-拆包库位', 'BC_CB_LOCATION', 1, 1, '2020-03-25 10:50:12', 1, '2020-03-25 10:50:12');
INSERT INTO `t_agv_area` VALUES (18, 6, 8, '包材-包装库位', 'BC_BZ_LOCATION', 1, 1, '2020-03-25 10:59:11', 1, '2020-03-25 10:59:37');
INSERT INTO `t_agv_area` VALUES (19, 7, 8, '灌装产线11库位', 'GZ_L11_LOCATION', 1, 1, '2020-03-25 11:00:39', 1, '2020-03-25 11:00:39');
INSERT INTO `t_agv_area` VALUES (20, 8, 8, '灌装产线12库位', 'GZ_L12_LOCATION', 1, 1, '2020-03-25 11:01:21', 1, '2020-03-25 11:01:21');
INSERT INTO `t_agv_area` VALUES (21, 9, 8, '灌装产线13库位', 'GZ_L13_LOCATION', 1, 1, '2020-03-25 11:01:58', 1, '2020-03-25 11:01:58');
INSERT INTO `t_agv_area` VALUES (22, 10, 8, '灌装产线14库位', 'GZ_L14_LOCATION', 1, 1, '2020-03-25 11:02:34', 1, '2020-03-25 11:02:34');
INSERT INTO `t_agv_area` VALUES (23, 11, 8, '包装产线11库位', 'BZ_L11_LOCATION', 1, 1, '2020-03-25 11:03:29', 1, '2020-03-25 11:03:29');
INSERT INTO `t_agv_area` VALUES (24, 12, 8, '包装产线12库位', 'BZ_L12_LOCATION', 1, 1, '2020-03-25 11:04:10', 1, '2020-03-25 11:04:10');
INSERT INTO `t_agv_area` VALUES (25, 13, 8, '包装产线13库位', 'BZ_L13_LOCATION', 1, 1, '2020-03-25 11:04:58', 1, '2020-03-25 11:04:58');
INSERT INTO `t_agv_area` VALUES (26, 14, 8, '包装产线14库位', 'BZ_L14_LOCATION', 1, 1, '2020-03-25 11:05:58', 1, '2020-03-25 11:05:58');

-- ----------------------------
-- Table structure for t_agv_area_site
-- ----------------------------
DROP TABLE IF EXISTS `t_agv_area_site`;
CREATE TABLE `t_agv_area_site`  (
  `area_id` bigint(20) NOT NULL COMMENT '区域ID',
  `site_id` bigint(20) NOT NULL COMMENT '站点ID'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '区域-站点表{已填}' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_agv_area_site
-- ----------------------------
INSERT INTO `t_agv_area_site` VALUES (15, 1);
INSERT INTO `t_agv_area_site` VALUES (15, 2);
INSERT INTO `t_agv_area_site` VALUES (15, 3);
INSERT INTO `t_agv_area_site` VALUES (15, 4);
INSERT INTO `t_agv_area_site` VALUES (15, 5);
INSERT INTO `t_agv_area_site` VALUES (15, 6);
INSERT INTO `t_agv_area_site` VALUES (15, 7);
INSERT INTO `t_agv_area_site` VALUES (15, 8);
INSERT INTO `t_agv_area_site` VALUES (15, 9);
INSERT INTO `t_agv_area_site` VALUES (15, 10);
INSERT INTO `t_agv_area_site` VALUES (15, 11);
INSERT INTO `t_agv_area_site` VALUES (15, 12);
INSERT INTO `t_agv_area_site` VALUES (15, 13);
INSERT INTO `t_agv_area_site` VALUES (15, 14);
INSERT INTO `t_agv_area_site` VALUES (16, 15);
INSERT INTO `t_agv_area_site` VALUES (16, 16);
INSERT INTO `t_agv_area_site` VALUES (16, 17);
INSERT INTO `t_agv_area_site` VALUES (16, 18);
INSERT INTO `t_agv_area_site` VALUES (16, 19);
INSERT INTO `t_agv_area_site` VALUES (16, 20);
INSERT INTO `t_agv_area_site` VALUES (16, 21);
INSERT INTO `t_agv_area_site` VALUES (16, 22);
INSERT INTO `t_agv_area_site` VALUES (16, 23);
INSERT INTO `t_agv_area_site` VALUES (16, 24);
INSERT INTO `t_agv_area_site` VALUES (16, 25);
INSERT INTO `t_agv_area_site` VALUES (16, 26);
INSERT INTO `t_agv_area_site` VALUES (16, 27);
INSERT INTO `t_agv_area_site` VALUES (16, 28);
INSERT INTO `t_agv_area_site` VALUES (17, 29);
INSERT INTO `t_agv_area_site` VALUES (17, 30);
INSERT INTO `t_agv_area_site` VALUES (17, 31);
INSERT INTO `t_agv_area_site` VALUES (17, 32);
INSERT INTO `t_agv_area_site` VALUES (17, 33);
INSERT INTO `t_agv_area_site` VALUES (17, 34);
INSERT INTO `t_agv_area_site` VALUES (17, 35);
INSERT INTO `t_agv_area_site` VALUES (18, 36);
INSERT INTO `t_agv_area_site` VALUES (18, 37);
INSERT INTO `t_agv_area_site` VALUES (18, 38);
INSERT INTO `t_agv_area_site` VALUES (18, 39);
INSERT INTO `t_agv_area_site` VALUES (18, 40);
INSERT INTO `t_agv_area_site` VALUES (18, 41);
INSERT INTO `t_agv_area_site` VALUES (18, 42);
INSERT INTO `t_agv_area_site` VALUES (19, 43);
INSERT INTO `t_agv_area_site` VALUES (19, 44);
INSERT INTO `t_agv_area_site` VALUES (20, 45);
INSERT INTO `t_agv_area_site` VALUES (20, 46);
INSERT INTO `t_agv_area_site` VALUES (21, 47);
INSERT INTO `t_agv_area_site` VALUES (21, 48);
INSERT INTO `t_agv_area_site` VALUES (22, 49);
INSERT INTO `t_agv_area_site` VALUES (22, 50);
INSERT INTO `t_agv_area_site` VALUES (23, 51);
INSERT INTO `t_agv_area_site` VALUES (23, 52);
INSERT INTO `t_agv_area_site` VALUES (24, 53);
INSERT INTO `t_agv_area_site` VALUES (24, 54);
INSERT INTO `t_agv_area_site` VALUES (25, 55);
INSERT INTO `t_agv_area_site` VALUES (25, 56);
INSERT INTO `t_agv_area_site` VALUES (26, 57);
INSERT INTO `t_agv_area_site` VALUES (26, 58);

-- ----------------------------
-- Table structure for t_agv_call_material
-- ----------------------------
DROP TABLE IF EXISTS `t_agv_call_material`;
CREATE TABLE `t_agv_call_material`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `material_id` bigint(20) NOT NULL COMMENT '物料ID(原料)',
  `count` int(11) NOT NULL COMMENT '数量',
  `acceptance_count` int(11) NULL DEFAULT NULL COMMENT '验收数量',
  `state` tinyint(4) NOT NULL COMMENT '状态【0：未配送；1：配送中；2：已完成】',
  `call_time` datetime(0) NOT NULL COMMENT '叫料时间',
  `wave_detail_code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配送波次详情编号',
  `type` tinyint(4) NOT NULL COMMENT '类型【1：灌装区；2：包装区；3：消毒间；4：拆包间】',
  `cancel_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '取消叫料原因',
  `enabled` tinyint(1) NOT NULL COMMENT '是否启用【1：启用；0：禁用】',
  `create_user` bigint(20) NOT NULL DEFAULT 0 COMMENT '创建者',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后一次更新时间',
  `area_id` bigint(20) NULL DEFAULT NULL COMMENT '区域ID（产线ID）',
  `team_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '班组ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '叫料表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_agv_delivery_task
-- ----------------------------
DROP TABLE IF EXISTS `t_agv_delivery_task`;
CREATE TABLE `t_agv_delivery_task`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `task_no` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配送任务单号(全系统唯一,自动生成)',
  `start_site_id` bigint(20) NOT NULL COMMENT '起点站点ID',
  `end_site_id` bigint(20) NOT NULL COMMENT '终点站点ID',
  `material_box_id` bigint(20) NOT NULL COMMENT '料框ID',
  `agv_uuid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'AGV小车唯一标识',
  `state` tinyint(4) NOT NULL COMMENT '状态【0：待接单；1：取货中；2：配送中；3：已完成】',
  `type` tinyint(4) NOT NULL COMMENT '类型【1：消毒-灌装；2：灌装-消毒；3：包材-拆包；4：拆包-包材；5：包材-包装；6：包装-包材】',
  `enabled` tinyint(1) NOT NULL COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT 0 COMMENT '创建者',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '配送任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_agv_distribution
-- ----------------------------
DROP TABLE IF EXISTS `t_agv_distribution`;
CREATE TABLE `t_agv_distribution`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `call_material_id` bigint(20) NOT NULL COMMENT '叫料ID',
  `count` int(11) NOT NULL COMMENT '配送数量',
  `state` tinyint(4) NOT NULL COMMENT '状态【0：未验收；1：部分验收；2：已验收】',
  `distribution_time` datetime(0) NOT NULL COMMENT '配货时间',
  `type` tinyint(4) NOT NULL COMMENT '类型【1：消毒间-灌装区；2：包材仓-包装区；3：拆包间-消毒间；4：包材仓-拆包间】',
  `stock_up_id` bigint(20) NULL DEFAULT NULL COMMENT '备货ID',
  `enabled` tinyint(1) NOT NULL COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT 0 COMMENT '创建者',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '配货表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_agv_material
-- ----------------------------
DROP TABLE IF EXISTS `t_agv_material`;
CREATE TABLE `t_agv_material`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '物料编号',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '物料名称',
  `uuid` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '青蛙工厂唯一标识',
  `specs` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '规格',
  `unit` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '单位',
  `batch` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '批次号',
  `enabled` tinyint(1) NOT NULL COMMENT '是否启用【1：启用；0：禁用】',
  `create_user` bigint(20) NOT NULL DEFAULT 0 COMMENT '创建者',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '物料表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_agv_material_box
-- ----------------------------
DROP TABLE IF EXISTS `t_agv_material_box`;
CREATE TABLE `t_agv_material_box`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `qr_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '二维码',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '料框名称',
  `state` tinyint(4) NOT NULL COMMENT '状态【0：空车；1：有货】',
  `enabled` tinyint(1) NOT NULL COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT 0 COMMENT '创建者',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 61 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '料框表{已填}' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_agv_material_box
-- ----------------------------
INSERT INTO `t_agv_material_box` VALUES (1, 'LC001', '1号料车', 0, 1, 1, '2020-03-25 14:38:42', 1, '2020-03-25 14:38:42');
INSERT INTO `t_agv_material_box` VALUES (2, 'LC002', '2号料车', 0, 1, 1, '2020-03-25 14:38:52', 1, '2020-03-25 14:38:52');
INSERT INTO `t_agv_material_box` VALUES (3, 'LC003', '3号料车', 0, 1, 1, '2020-03-25 14:38:58', 1, '2020-03-25 14:38:58');
INSERT INTO `t_agv_material_box` VALUES (4, 'LC004', '4号料车', 0, 1, 1, '2020-03-25 14:39:08', 1, '2020-03-25 14:39:08');
INSERT INTO `t_agv_material_box` VALUES (5, 'LC005', '5号料车', 0, 1, 1, '2020-03-25 14:39:15', 1, '2020-03-25 14:39:15');
INSERT INTO `t_agv_material_box` VALUES (6, 'LC006', '6号料车', 0, 1, 1, '2020-03-25 14:39:20', 1, '2020-03-25 14:39:20');
INSERT INTO `t_agv_material_box` VALUES (7, 'LC007', '7号料车', 0, 1, 1, '2020-03-25 14:39:25', 1, '2020-03-25 14:39:25');
INSERT INTO `t_agv_material_box` VALUES (8, 'LC008', '8号料车', 0, 1, 1, '2020-03-25 14:39:30', 1, '2020-03-25 14:39:30');
INSERT INTO `t_agv_material_box` VALUES (9, 'LC009', '9号料车', 0, 1, 1, '2020-03-25 14:39:34', 1, '2020-03-25 14:39:34');
INSERT INTO `t_agv_material_box` VALUES (10, 'LC010', '10号料车', 0, 1, 1, '2020-03-25 14:39:39', 1, '2020-03-25 14:39:39');
INSERT INTO `t_agv_material_box` VALUES (11, 'LC011', '11号料车', 0, 1, 1, '2020-03-25 14:39:43', 1, '2020-03-25 14:39:54');
INSERT INTO `t_agv_material_box` VALUES (12, 'LC012', '12号料车', 0, 1, 1, '2020-03-25 14:41:20', 1, '2020-03-25 14:41:20');
INSERT INTO `t_agv_material_box` VALUES (13, 'LC013', '13号料车', 0, 1, 1, '2020-03-25 14:41:24', 1, '2020-03-25 14:41:24');
INSERT INTO `t_agv_material_box` VALUES (14, 'LC014', '14号料车', 0, 1, 1, '2020-03-25 14:41:30', 1, '2020-03-25 14:41:30');
INSERT INTO `t_agv_material_box` VALUES (15, 'LC015', '15号料车', 0, 1, 1, '2020-03-25 14:41:34', 1, '2020-03-25 14:41:34');
INSERT INTO `t_agv_material_box` VALUES (16, 'LC016', '16号料车', 0, 1, 1, '2020-03-25 14:41:39', 1, '2020-03-25 14:41:39');
INSERT INTO `t_agv_material_box` VALUES (17, 'LC017', '17号料车', 0, 1, 1, '2020-03-25 14:41:44', 1, '2020-03-25 14:41:44');
INSERT INTO `t_agv_material_box` VALUES (18, 'LC018', '18号料车', 0, 1, 1, '2020-03-25 14:41:48', 1, '2020-03-25 14:41:48');
INSERT INTO `t_agv_material_box` VALUES (19, 'LC019', '19号料车', 0, 1, 1, '2020-03-25 14:41:52', 1, '2020-03-25 14:41:52');
INSERT INTO `t_agv_material_box` VALUES (20, 'LC020', '20号料车', 0, 1, 1, '2020-03-25 14:41:57', 1, '2020-03-25 14:41:57');
INSERT INTO `t_agv_material_box` VALUES (21, 'LC021', '21号料车', 0, 1, 1, '2020-03-25 14:42:02', 1, '2020-03-25 14:42:02');
INSERT INTO `t_agv_material_box` VALUES (22, 'LC022', '22号料车', 0, 1, 1, '2020-03-25 14:42:07', 1, '2020-03-25 14:42:07');
INSERT INTO `t_agv_material_box` VALUES (23, 'LC023', '23号料车', 0, 1, 1, '2020-03-25 14:42:14', 1, '2020-03-25 14:42:14');
INSERT INTO `t_agv_material_box` VALUES (24, 'LC024', '24号料车', 0, 1, 1, '2020-03-25 14:42:18', 1, '2020-03-25 14:42:18');
INSERT INTO `t_agv_material_box` VALUES (25, 'LC025', '25号料车', 0, 1, 1, '2020-03-25 14:42:22', 1, '2020-03-25 14:42:22');
INSERT INTO `t_agv_material_box` VALUES (26, 'LC026', '26号料车', 0, 1, 1, '2020-03-25 14:42:26', 1, '2020-03-25 14:42:26');
INSERT INTO `t_agv_material_box` VALUES (27, 'LC027', '27号料车', 0, 1, 1, '2020-03-25 14:42:30', 1, '2020-03-25 14:42:30');
INSERT INTO `t_agv_material_box` VALUES (28, 'LC028', '28号料车', 0, 1, 1, '2020-03-25 14:42:33', 1, '2020-03-25 14:42:33');
INSERT INTO `t_agv_material_box` VALUES (29, 'LC029', '29号料车', 0, 1, 1, '2020-03-25 14:42:37', 1, '2020-03-25 14:42:37');
INSERT INTO `t_agv_material_box` VALUES (30, 'LC030', '30号料车', 0, 1, 1, '2020-03-25 14:42:41', 1, '2020-03-25 14:42:41');
INSERT INTO `t_agv_material_box` VALUES (31, 'LC031', '31号料车', 0, 1, 1, '2020-03-25 14:42:46', 1, '2020-03-25 14:42:46');
INSERT INTO `t_agv_material_box` VALUES (32, 'LC032', '32号料车', 0, 1, 1, '2020-03-25 14:42:50', 1, '2020-03-25 14:42:50');
INSERT INTO `t_agv_material_box` VALUES (33, 'LC033', '33号料车', 0, 1, 1, '2020-03-25 14:42:54', 1, '2020-03-25 14:42:54');
INSERT INTO `t_agv_material_box` VALUES (34, 'LC034', '34号料车', 0, 1, 1, '2020-03-25 14:42:58', 1, '2020-03-25 14:42:58');
INSERT INTO `t_agv_material_box` VALUES (35, 'LC035', '35号料车', 0, 1, 1, '2020-03-25 14:43:01', 1, '2020-03-25 14:43:01');
INSERT INTO `t_agv_material_box` VALUES (36, 'LC036', '36号料车', 0, 1, 1, '2020-03-25 14:43:05', 1, '2020-03-25 14:43:05');
INSERT INTO `t_agv_material_box` VALUES (37, 'LC037', '37号料车', 0, 1, 1, '2020-03-25 14:43:08', 1, '2020-03-25 14:43:08');
INSERT INTO `t_agv_material_box` VALUES (38, 'LC038', '38号料车', 0, 1, 1, '2020-03-25 14:43:12', 1, '2020-03-25 14:43:12');
INSERT INTO `t_agv_material_box` VALUES (39, 'LC039', '39号料车', 0, 1, 1, '2020-03-25 14:43:16', 1, '2020-03-25 14:43:16');
INSERT INTO `t_agv_material_box` VALUES (40, 'LC040', '40号料车', 0, 1, 1, '2020-03-25 14:43:20', 1, '2020-03-25 14:43:20');
INSERT INTO `t_agv_material_box` VALUES (41, 'LC041', '41号料车', 0, 1, 1, '2020-03-25 14:43:36', 1, '2020-03-25 14:43:36');
INSERT INTO `t_agv_material_box` VALUES (42, 'LC042', '42号料车', 0, 1, 1, '2020-03-25 14:43:39', 1, '2020-03-25 14:43:39');
INSERT INTO `t_agv_material_box` VALUES (43, 'LC043', '43号料车', 0, 1, 1, '2020-03-25 14:43:43', 1, '2020-03-25 14:43:43');
INSERT INTO `t_agv_material_box` VALUES (44, 'LC044', '44号料车', 0, 1, 1, '2020-03-25 14:43:47', 1, '2020-03-25 14:43:47');
INSERT INTO `t_agv_material_box` VALUES (45, 'LC045', '45号料车', 0, 1, 1, '2020-03-25 14:43:51', 1, '2020-03-25 14:43:51');
INSERT INTO `t_agv_material_box` VALUES (46, 'LC046', '46号料车', 0, 1, 1, '2020-03-25 14:43:55', 1, '2020-03-25 14:43:55');
INSERT INTO `t_agv_material_box` VALUES (47, 'LC047', '47号料车', 0, 1, 1, '2020-03-25 14:43:59', 1, '2020-03-25 14:43:59');
INSERT INTO `t_agv_material_box` VALUES (48, 'LC048', '48号料车', 0, 1, 1, '2020-03-25 14:44:03', 1, '2020-03-25 14:44:03');
INSERT INTO `t_agv_material_box` VALUES (49, 'LC049', '49号料车', 0, 1, 1, '2020-03-25 14:44:07', 1, '2020-03-25 14:44:07');
INSERT INTO `t_agv_material_box` VALUES (50, 'LC050', '50号料车', 0, 1, 1, '2020-03-25 14:44:13', 1, '2020-03-25 14:44:13');
INSERT INTO `t_agv_material_box` VALUES (51, 'LC051', '51号料车', 0, 1, 1, '2020-03-25 14:44:17', 1, '2020-03-25 14:44:17');
INSERT INTO `t_agv_material_box` VALUES (52, 'LC052', '52号料车', 0, 1, 1, '2020-03-25 14:44:20', 1, '2020-03-25 14:44:20');
INSERT INTO `t_agv_material_box` VALUES (53, 'LC053', '53号料车', 0, 1, 1, '2020-03-25 14:44:24', 1, '2020-03-25 14:44:24');
INSERT INTO `t_agv_material_box` VALUES (54, 'LC054', '54号料车', 0, 1, 1, '2020-03-25 14:44:28', 1, '2020-03-25 14:44:28');
INSERT INTO `t_agv_material_box` VALUES (55, 'LC055', '55号料车', 0, 1, 1, '2020-03-25 14:44:32', 1, '2020-03-25 14:44:32');
INSERT INTO `t_agv_material_box` VALUES (56, 'LC056', '56号料车', 0, 1, 1, '2020-03-25 14:44:35', 1, '2020-03-25 14:44:35');
INSERT INTO `t_agv_material_box` VALUES (57, 'LC057', '57号料车', 0, 1, 1, '2020-03-25 14:44:39', 1, '2020-03-25 14:44:39');
INSERT INTO `t_agv_material_box` VALUES (58, 'LC058', '58号料车', 0, 1, 1, '2020-03-25 14:44:43', 1, '2020-03-25 14:44:43');
INSERT INTO `t_agv_material_box` VALUES (59, 'LC059', '59号料车', 0, 1, 1, '2020-03-25 14:44:47', 1, '2020-03-25 14:44:47');
INSERT INTO `t_agv_material_box` VALUES (60, 'LC060', '60号料车', 0, 1, 1, '2020-03-25 14:44:52', 1, '2020-03-25 14:44:52');

-- ----------------------------
-- Table structure for t_agv_material_box_material
-- ----------------------------
DROP TABLE IF EXISTS `t_agv_material_box_material`;
CREATE TABLE `t_agv_material_box_material`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `material_box_id` bigint(20) NOT NULL COMMENT '料框ID',
  `material_id` bigint(20) NOT NULL COMMENT '物料ID（原料）',
  `count` int(11) NOT NULL COMMENT '数量',
  `state` tinyint(4) NOT NULL COMMENT '状态【0：未验收；1：已验收】',
  `enabled` tinyint(1) NOT NULL COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT 0 COMMENT '创建者',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '料框-物料表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_agv_material_requisition
-- ----------------------------
DROP TABLE IF EXISTS `t_agv_material_requisition`;
CREATE TABLE `t_agv_material_requisition`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '领料单号',
  `picking_time` datetime(0) NOT NULL COMMENT '领料时间',
  `material_id` bigint(20) NOT NULL COMMENT '物料ID（产品）',
  `enabled` tinyint(1) NOT NULL COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT 0 COMMENT '创建者',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '领料单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_agv_material_requisition_detail
-- ----------------------------
DROP TABLE IF EXISTS `t_agv_material_requisition_detail`;
CREATE TABLE `t_agv_material_requisition_detail`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `material_requisition_id` bigint(20) NOT NULL COMMENT '领料单ID',
  `material_id` bigint(20) NOT NULL COMMENT '物料ID（原料）',
  `count` int(11) NOT NULL COMMENT '数量',
  `enabled` tinyint(1) NOT NULL COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT 0 COMMENT '创建者',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '领料单详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_agv_sales_return
-- ----------------------------
DROP TABLE IF EXISTS `t_agv_sales_return`;
CREATE TABLE `t_agv_sales_return`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `call_material_id` bigint(20) NOT NULL COMMENT '叫料ID',
  `count` int(11) NOT NULL COMMENT '退货数量',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '退货原因',
  `return_time` datetime(0) NOT NULL COMMENT '退货时间',
  `team_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '班组唯一标识',
  `team_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '班组名称',
  `area_id` bigint(20) NOT NULL COMMENT '区域ID(产线ID)',
  `delivery_task_id` bigint(20) NOT NULL COMMENT '配送任务ID',
  `enabled` tinyint(1) NOT NULL COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT 0 COMMENT '创建者',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '退货表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_agv_sales_return_record
-- ----------------------------
DROP TABLE IF EXISTS `t_agv_sales_return_record`;
CREATE TABLE `t_agv_sales_return_record`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `operation_time` datetime(0) NOT NULL COMMENT '操作时间',
  `team_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '班组唯一标识',
  `team_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '班组名称',
  `source` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '源数据',
  `results` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '结果数据',
  `type` tinyint(4) NOT NULL COMMENT '操作类型【1：新增；2：修改；3：删除】',
  `area_id` bigint(20) NOT NULL COMMENT '区域ID(产线ID)',
  `enabled` tinyint(1) NOT NULL COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT 0 COMMENT '创建者',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '退货记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_agv_site
-- ----------------------------
DROP TABLE IF EXISTS `t_agv_site`;
CREATE TABLE `t_agv_site`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `qr_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '二维码',
  `location_x` decimal(10, 0) NULL DEFAULT NULL COMMENT 'x轴坐标',
  `location_y` decimal(10, 0) NULL DEFAULT NULL COMMENT 'y轴坐标',
  `location_z` decimal(10, 0) NULL DEFAULT NULL COMMENT 'z轴坐标',
  `type` tinyint(4) NOT NULL COMMENT '类型【1：备货位；2：出货位；3：空车位；】',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '编号',
  `enabled` tinyint(1) NOT NULL COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT 0 COMMENT '创建者',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 59 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '站点表{已填}' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_agv_site
-- ----------------------------
INSERT INTO `t_agv_site` VALUES (1, 'xd001', NULL, NULL, NULL, 1, '消毒间1号库位', 'XD001', 1, 1, '2020-03-25 11:18:45', 1, '2020-03-25 11:18:45');
INSERT INTO `t_agv_site` VALUES (2, 'xd002', NULL, NULL, NULL, 1, '消毒间2号库位', 'XD002', 1, 1, '2020-03-25 11:24:29', 1, '2020-03-25 11:24:29');
INSERT INTO `t_agv_site` VALUES (3, 'xd003', NULL, NULL, NULL, 1, '消毒间3号库位', 'XD003', 1, 1, '2020-03-25 11:24:53', 1, '2020-03-25 11:24:53');
INSERT INTO `t_agv_site` VALUES (4, 'xd004', NULL, NULL, NULL, 1, '消毒间4号库位', 'XD004', 1, 1, '2020-03-25 11:24:59', 1, '2020-03-25 11:24:59');
INSERT INTO `t_agv_site` VALUES (5, 'xd005', NULL, NULL, NULL, 1, '消毒间5号库位', 'XD005', 1, 1, '2020-03-25 11:25:04', 1, '2020-03-25 11:25:04');
INSERT INTO `t_agv_site` VALUES (6, 'xd006', NULL, NULL, NULL, 1, '消毒间6号库位', 'XD006', 1, 1, '2020-03-25 11:25:10', 1, '2020-03-25 11:25:10');
INSERT INTO `t_agv_site` VALUES (7, 'xd007', NULL, NULL, NULL, 1, '消毒间7号库位', 'XD007', 1, 1, '2020-03-25 11:25:18', 1, '2020-03-25 11:25:18');
INSERT INTO `t_agv_site` VALUES (8, 'xd008', NULL, NULL, NULL, 1, '消毒间8号库位', 'XD008', 1, 1, '2020-03-25 11:25:24', 1, '2020-03-25 11:25:24');
INSERT INTO `t_agv_site` VALUES (9, 'xd009', NULL, NULL, NULL, 1, '消毒间9号库位', 'XD009', 1, 1, '2020-03-25 11:25:31', 1, '2020-03-25 11:25:31');
INSERT INTO `t_agv_site` VALUES (10, 'xd010', NULL, NULL, NULL, 1, '消毒间10号库位', 'XD010', 1, 1, '2020-03-25 11:25:41', 1, '2020-03-25 11:25:41');
INSERT INTO `t_agv_site` VALUES (11, 'xd011', NULL, NULL, NULL, 1, '消毒间11号库位', 'XD011', 1, 1, '2020-03-25 11:25:51', 1, '2020-03-25 11:25:51');
INSERT INTO `t_agv_site` VALUES (12, 'xd012', NULL, NULL, NULL, 1, '消毒间12号库位', 'XD012', 1, 1, '2020-03-25 11:25:59', 1, '2020-03-25 11:25:59');
INSERT INTO `t_agv_site` VALUES (13, 'xd013', NULL, NULL, NULL, 1, '消毒间13号库位', 'XD013', 1, 1, '2020-03-25 13:12:11', 1, '2020-03-25 13:12:11');
INSERT INTO `t_agv_site` VALUES (14, 'xd014', NULL, NULL, NULL, 1, '消毒间14号库位', 'XD014', 1, 1, '2020-03-25 13:12:19', 1, '2020-03-25 13:12:19');
INSERT INTO `t_agv_site` VALUES (15, 'cb001', NULL, NULL, NULL, 1, '拆包间1号库位', 'CB001', 1, 1, '2020-03-25 13:13:49', 1, '2020-03-25 13:13:49');
INSERT INTO `t_agv_site` VALUES (16, 'cb002', NULL, NULL, NULL, 1, '拆包间2号库位', 'CB002', 1, 1, '2020-03-25 13:13:57', 1, '2020-03-25 13:13:57');
INSERT INTO `t_agv_site` VALUES (17, 'cb003', NULL, NULL, NULL, 1, '拆包间3号库位', 'CB003', 1, 1, '2020-03-25 13:14:07', 1, '2020-03-25 13:14:07');
INSERT INTO `t_agv_site` VALUES (18, 'cb004', NULL, NULL, NULL, 1, '拆包间4号库位', 'CB004', 1, 1, '2020-03-25 13:14:13', 1, '2020-03-25 13:14:13');
INSERT INTO `t_agv_site` VALUES (19, 'cb005', NULL, NULL, NULL, 1, '拆包间5号库位', 'CB005', 1, 1, '2020-03-25 13:14:20', 1, '2020-03-25 13:14:20');
INSERT INTO `t_agv_site` VALUES (20, 'cb006', NULL, NULL, NULL, 1, '拆包间6号库位', 'CB006', 1, 1, '2020-03-25 13:14:27', 1, '2020-03-25 13:14:27');
INSERT INTO `t_agv_site` VALUES (21, 'cb007', NULL, NULL, NULL, 1, '拆包间7号库位', 'CB007', 1, 1, '2020-03-25 13:14:33', 1, '2020-03-25 13:14:33');
INSERT INTO `t_agv_site` VALUES (22, 'cb008', NULL, NULL, NULL, 1, '拆包间8号库位', 'CB008', 1, 1, '2020-03-25 13:14:40', 1, '2020-03-25 13:14:40');
INSERT INTO `t_agv_site` VALUES (23, 'cb009', NULL, NULL, NULL, 1, '拆包间9号库位', 'CB009', 1, 1, '2020-03-25 13:14:47', 1, '2020-03-25 13:14:47');
INSERT INTO `t_agv_site` VALUES (24, 'cb010', NULL, NULL, NULL, 1, '拆包间10号库位', 'CB010', 1, 1, '2020-03-25 13:14:57', 1, '2020-03-25 13:14:57');
INSERT INTO `t_agv_site` VALUES (25, 'cb011', NULL, NULL, NULL, 1, '拆包间11号库位', 'CB011', 1, 1, '2020-03-25 13:15:04', 1, '2020-03-25 13:15:04');
INSERT INTO `t_agv_site` VALUES (26, 'cb012', NULL, NULL, NULL, 1, '拆包间12号库位', 'CB012', 1, 1, '2020-03-25 13:15:11', 1, '2020-03-25 13:15:11');
INSERT INTO `t_agv_site` VALUES (27, 'cb013', NULL, NULL, NULL, 1, '拆包间13号库位', 'CB013', 1, 1, '2020-03-25 13:15:18', 1, '2020-03-25 13:15:18');
INSERT INTO `t_agv_site` VALUES (28, 'cb014', NULL, NULL, NULL, 1, '拆包间14号库位', 'CB014', 1, 1, '2020-03-25 13:15:25', 1, '2020-03-25 13:15:25');
INSERT INTO `t_agv_site` VALUES (29, 'bc_cb001', NULL, NULL, NULL, 1, '包材-拆包1号库位', 'BC_CB001', 1, 1, '2020-03-25 13:16:22', 1, '2020-03-25 13:16:22');
INSERT INTO `t_agv_site` VALUES (30, 'bc_cb002', NULL, NULL, NULL, 1, '包材-拆包2号库位', 'BC_CB002', 1, 1, '2020-03-25 13:16:30', 1, '2020-03-25 13:16:30');
INSERT INTO `t_agv_site` VALUES (31, 'bc_cb003', NULL, NULL, NULL, 1, '包材-拆包3号库位', 'BC_CB003', 1, 1, '2020-03-25 13:16:37', 1, '2020-03-25 13:16:37');
INSERT INTO `t_agv_site` VALUES (32, 'bc_cb004', NULL, NULL, NULL, 1, '包材-拆包4号库位', 'BC_CB004', 1, 1, '2020-03-25 13:16:45', 1, '2020-03-25 13:16:45');
INSERT INTO `t_agv_site` VALUES (33, 'bc_cb005', NULL, NULL, NULL, 1, '包材-拆包5号库位', 'BC_CB005', 1, 1, '2020-03-25 13:16:52', 1, '2020-03-25 13:16:52');
INSERT INTO `t_agv_site` VALUES (34, 'bc_cb006', NULL, NULL, NULL, 1, '包材-拆包6号库位', 'BC_CB006', 1, 1, '2020-03-25 13:16:59', 1, '2020-03-25 13:16:59');
INSERT INTO `t_agv_site` VALUES (35, 'bc_cb007', NULL, NULL, NULL, 1, '包材-拆包7号库位', 'BC_CB007', 1, 1, '2020-03-25 13:17:06', 1, '2020-03-25 13:17:06');
INSERT INTO `t_agv_site` VALUES (36, 'bc_bz001', NULL, NULL, NULL, 1, '包材-包装1号库位', 'BC_BZ001', 1, 1, '2020-03-25 13:17:34', 1, '2020-03-25 13:17:34');
INSERT INTO `t_agv_site` VALUES (37, 'bc_bz002', NULL, NULL, NULL, 1, '包材-包装2号库位', 'BC_BZ002', 1, 1, '2020-03-25 13:17:43', 1, '2020-03-25 13:17:43');
INSERT INTO `t_agv_site` VALUES (38, 'bc_bz003', NULL, NULL, NULL, 1, '包材-包装3号库位', 'BC_BZ003', 1, 1, '2020-03-25 13:17:49', 1, '2020-03-25 13:17:49');
INSERT INTO `t_agv_site` VALUES (39, 'bc_bz004', NULL, NULL, NULL, 1, '包材-包装4号库位', 'BC_BZ004', 1, 1, '2020-03-25 13:17:56', 1, '2020-03-25 13:17:56');
INSERT INTO `t_agv_site` VALUES (40, 'bc_bz005', NULL, NULL, NULL, 1, '包材-包装5号库位', 'BC_BZ005', 1, 1, '2020-03-25 13:18:03', 1, '2020-03-25 13:18:03');
INSERT INTO `t_agv_site` VALUES (41, 'bc_bz006', NULL, NULL, NULL, 1, '包材-包装6号库位', 'BC_BZ006', 1, 1, '2020-03-25 13:18:12', 1, '2020-03-25 13:18:12');
INSERT INTO `t_agv_site` VALUES (42, 'bc_bz007', NULL, NULL, NULL, 1, '包材-包装7号库位', 'BC_BZ007', 1, 1, '2020-03-25 13:18:20', 1, '2020-03-25 13:18:20');
INSERT INTO `t_agv_site` VALUES (43, 'gz11_01', NULL, NULL, NULL, 1, '灌装区11线-1号库位', 'GZ11_01', 1, 1, '2020-03-25 13:20:26', 1, '2020-03-25 13:20:26');
INSERT INTO `t_agv_site` VALUES (44, 'gz11_02', NULL, NULL, NULL, 3, '灌装区11线-2号库位', 'GZ11_02', 1, 1, '2020-03-25 13:20:34', 1, '2020-03-25 13:22:46');
INSERT INTO `t_agv_site` VALUES (45, 'gz12_01', NULL, NULL, NULL, 1, '灌装区12线-1号库位', 'GZ12_01', 1, 1, '2020-03-25 13:20:57', 1, '2020-03-25 13:20:57');
INSERT INTO `t_agv_site` VALUES (46, 'gz12_02', NULL, NULL, NULL, 3, '灌装区12线-2号库位', 'GZ12_02', 1, 1, '2020-03-25 13:21:06', 1, '2020-03-25 13:22:47');
INSERT INTO `t_agv_site` VALUES (47, 'gz13_01', NULL, NULL, NULL, 1, '灌装区13线-1号库位', 'GZ13_01', 1, 1, '2020-03-25 13:21:23', 1, '2020-03-25 13:21:23');
INSERT INTO `t_agv_site` VALUES (48, 'gz13_02', NULL, NULL, NULL, 3, '灌装区13线-2号库位', 'GZ13_02', 1, 1, '2020-03-25 13:21:31', 1, '2020-03-25 13:22:49');
INSERT INTO `t_agv_site` VALUES (49, 'gz14_01', NULL, NULL, NULL, 1, '灌装区14线-1号库位', 'GZ14_01', 1, 1, '2020-03-25 13:21:48', 1, '2020-03-25 13:21:48');
INSERT INTO `t_agv_site` VALUES (50, 'gz14_02', NULL, NULL, NULL, 3, '灌装区14线-2号库位', 'GZ14_02', 1, 1, '2020-03-25 13:21:58', 1, '2020-03-25 13:22:50');
INSERT INTO `t_agv_site` VALUES (51, 'bz11_01', NULL, NULL, NULL, 1, '包装区11线-1号库位', 'BZ11_01', 1, 1, '2020-03-25 13:23:54', 1, '2020-03-25 13:23:54');
INSERT INTO `t_agv_site` VALUES (52, 'bz11_02', NULL, NULL, NULL, 3, '包装区11线-2号库位', 'BZ11_02', 1, 1, '2020-03-25 13:24:06', 1, '2020-03-25 13:25:24');
INSERT INTO `t_agv_site` VALUES (53, 'bz12_01', NULL, NULL, NULL, 1, '包装区12线-1号库位', 'BZ12_01', 1, 1, '2020-03-25 13:24:21', 1, '2020-03-25 13:24:21');
INSERT INTO `t_agv_site` VALUES (54, 'bz12_02', NULL, NULL, NULL, 3, '包装区12线-2号库位', 'BZ12_02', 1, 1, '2020-03-25 13:24:27', 1, '2020-03-25 13:25:25');
INSERT INTO `t_agv_site` VALUES (55, 'bz13_01', NULL, NULL, NULL, 1, '包装区13线-1号库位', 'BZ13_01', 1, 1, '2020-03-25 13:24:38', 1, '2020-03-25 13:24:38');
INSERT INTO `t_agv_site` VALUES (56, 'bz13_02', NULL, NULL, NULL, 3, '包装区13线-2号库位', 'BZ13_02', 1, 1, '2020-03-25 13:24:45', 1, '2020-03-25 13:25:27');
INSERT INTO `t_agv_site` VALUES (57, 'bz14_01', NULL, NULL, NULL, 1, '包装区14线-1号库位', 'BZ14_01', 1, 1, '2020-03-25 13:25:03', 1, '2020-03-25 13:25:03');
INSERT INTO `t_agv_site` VALUES (58, 'bz14_02', NULL, NULL, NULL, 3, '包装区14线-2号库位', 'BZ14_02', 1, 1, '2020-03-25 13:25:11', 1, '2020-03-25 13:25:33');

-- ----------------------------
-- Table structure for t_agv_site_detail
-- ----------------------------
DROP TABLE IF EXISTS `t_agv_site_detail`;
CREATE TABLE `t_agv_site_detail`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` bigint(20) NOT NULL COMMENT '站点ID',
  `stock_up_record_id` bigint(20) NULL DEFAULT NULL COMMENT '备货ID',
  `state` tinyint(4) NOT NULL COMMENT '状态【0：空闲；1：待出库；2：出库中；3：已出库；4：待入库；5：入库中；6：已入库】',
  `delivery_task_id` bigint(20) NULL DEFAULT NULL COMMENT '配送任务ID',
  `enabled` tinyint(1) NOT NULL COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT 0 COMMENT '创建者',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 43 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '站点详情表[站点瞬时备货状态]{已填}' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_agv_site_detail
-- ----------------------------
INSERT INTO `t_agv_site_detail` VALUES (1, 1, NULL, 0, NULL, 1, 1, '2020-03-25 13:50:08', 1, '2020-03-25 13:50:08');
INSERT INTO `t_agv_site_detail` VALUES (2, 2, NULL, 0, NULL, 1, 1, '2020-03-25 13:50:11', 1, '2020-03-25 13:50:11');
INSERT INTO `t_agv_site_detail` VALUES (3, 3, NULL, 0, NULL, 1, 1, '2020-03-25 13:50:12', 1, '2020-03-25 13:50:12');
INSERT INTO `t_agv_site_detail` VALUES (4, 4, NULL, 0, NULL, 1, 1, '2020-03-25 13:50:13', 1, '2020-03-25 13:50:13');
INSERT INTO `t_agv_site_detail` VALUES (5, 5, NULL, 0, NULL, 1, 1, '2020-03-25 13:50:15', 1, '2020-03-25 13:50:15');
INSERT INTO `t_agv_site_detail` VALUES (6, 6, NULL, 0, NULL, 1, 1, '2020-03-25 13:50:16', 1, '2020-03-25 13:50:16');
INSERT INTO `t_agv_site_detail` VALUES (7, 7, NULL, 0, NULL, 1, 1, '2020-03-25 13:50:17', 1, '2020-03-25 13:50:17');
INSERT INTO `t_agv_site_detail` VALUES (8, 8, NULL, 0, NULL, 1, 1, '2020-03-25 13:50:19', 1, '2020-03-25 13:50:19');
INSERT INTO `t_agv_site_detail` VALUES (9, 9, NULL, 0, NULL, 1, 1, '2020-03-25 13:50:20', 1, '2020-03-25 13:50:20');
INSERT INTO `t_agv_site_detail` VALUES (10, 10, NULL, 0, NULL, 1, 1, '2020-03-25 13:50:22', 1, '2020-03-25 13:50:22');
INSERT INTO `t_agv_site_detail` VALUES (11, 11, NULL, 0, NULL, 1, 1, '2020-03-25 13:50:24', 1, '2020-03-25 13:50:24');
INSERT INTO `t_agv_site_detail` VALUES (12, 12, NULL, 0, NULL, 1, 1, '2020-03-25 13:50:25', 1, '2020-03-25 13:50:25');
INSERT INTO `t_agv_site_detail` VALUES (13, 13, NULL, 0, NULL, 1, 1, '2020-03-25 13:50:28', 1, '2020-03-25 13:50:28');
INSERT INTO `t_agv_site_detail` VALUES (14, 14, NULL, 0, NULL, 1, 1, '2020-03-25 13:50:29', 1, '2020-03-25 13:50:29');
INSERT INTO `t_agv_site_detail` VALUES (15, 15, NULL, 0, NULL, 1, 1, '2020-03-25 13:50:47', 1, '2020-03-25 13:50:47');
INSERT INTO `t_agv_site_detail` VALUES (16, 16, NULL, 0, NULL, 1, 1, '2020-03-25 13:50:49', 1, '2020-03-25 13:50:49');
INSERT INTO `t_agv_site_detail` VALUES (17, 17, NULL, 0, NULL, 1, 1, '2020-03-25 13:50:50', 1, '2020-03-25 13:50:50');
INSERT INTO `t_agv_site_detail` VALUES (18, 18, NULL, 0, NULL, 1, 1, '2020-03-25 13:50:52', 1, '2020-03-25 13:50:52');
INSERT INTO `t_agv_site_detail` VALUES (19, 19, NULL, 0, NULL, 1, 1, '2020-03-25 13:50:54', 1, '2020-03-25 13:50:54');
INSERT INTO `t_agv_site_detail` VALUES (20, 20, NULL, 0, NULL, 1, 1, '2020-03-25 13:50:56', 1, '2020-03-25 13:50:56');
INSERT INTO `t_agv_site_detail` VALUES (21, 21, NULL, 0, NULL, 1, 1, '2020-03-25 13:50:58', 1, '2020-03-25 13:50:58');
INSERT INTO `t_agv_site_detail` VALUES (22, 22, NULL, 0, NULL, 1, 1, '2020-03-25 13:51:00', 1, '2020-03-25 13:51:00');
INSERT INTO `t_agv_site_detail` VALUES (23, 23, NULL, 0, NULL, 1, 1, '2020-03-25 13:51:02', 1, '2020-03-25 13:51:02');
INSERT INTO `t_agv_site_detail` VALUES (24, 24, NULL, 0, NULL, 1, 1, '2020-03-25 13:51:04', 1, '2020-03-25 13:51:04');
INSERT INTO `t_agv_site_detail` VALUES (25, 25, NULL, 0, NULL, 1, 1, '2020-03-25 13:51:06', 1, '2020-03-25 13:51:06');
INSERT INTO `t_agv_site_detail` VALUES (26, 26, NULL, 0, NULL, 1, 1, '2020-03-25 13:51:08', 1, '2020-03-25 13:51:08');
INSERT INTO `t_agv_site_detail` VALUES (27, 27, NULL, 0, NULL, 1, 1, '2020-03-25 13:51:09', 1, '2020-03-25 13:51:09');
INSERT INTO `t_agv_site_detail` VALUES (28, 28, NULL, 0, NULL, 1, 1, '2020-03-25 13:51:10', 1, '2020-03-25 13:51:10');
INSERT INTO `t_agv_site_detail` VALUES (29, 29, NULL, 0, NULL, 1, 1, '2020-03-25 13:51:42', 1, '2020-03-25 13:51:42');
INSERT INTO `t_agv_site_detail` VALUES (30, 30, NULL, 0, NULL, 1, 1, '2020-03-25 13:51:45', 1, '2020-03-25 13:51:45');
INSERT INTO `t_agv_site_detail` VALUES (31, 31, NULL, 0, NULL, 1, 1, '2020-03-25 13:51:46', 1, '2020-03-25 13:51:46');
INSERT INTO `t_agv_site_detail` VALUES (32, 32, NULL, 0, NULL, 1, 1, '2020-03-25 13:51:48', 1, '2020-03-25 13:51:48');
INSERT INTO `t_agv_site_detail` VALUES (33, 33, NULL, 0, NULL, 1, 1, '2020-03-25 13:51:49', 1, '2020-03-25 13:51:49');
INSERT INTO `t_agv_site_detail` VALUES (34, 34, NULL, 0, NULL, 1, 1, '2020-03-25 13:51:50', 1, '2020-03-25 13:51:50');
INSERT INTO `t_agv_site_detail` VALUES (35, 35, NULL, 0, NULL, 1, 1, '2020-03-25 13:51:52', 1, '2020-03-25 13:51:52');
INSERT INTO `t_agv_site_detail` VALUES (36, 36, NULL, 0, NULL, 1, 1, '2020-03-25 13:51:53', 1, '2020-03-25 13:51:53');
INSERT INTO `t_agv_site_detail` VALUES (37, 37, NULL, 0, NULL, 1, 1, '2020-03-25 13:51:54', 1, '2020-03-25 13:51:54');
INSERT INTO `t_agv_site_detail` VALUES (38, 38, NULL, 0, NULL, 1, 1, '2020-03-25 13:51:56', 1, '2020-03-25 13:51:56');
INSERT INTO `t_agv_site_detail` VALUES (39, 39, NULL, 0, NULL, 1, 1, '2020-03-25 13:51:57', 1, '2020-03-25 13:51:57');
INSERT INTO `t_agv_site_detail` VALUES (40, 40, NULL, 0, NULL, 1, 1, '2020-03-25 13:51:59', 1, '2020-03-25 13:51:59');
INSERT INTO `t_agv_site_detail` VALUES (41, 41, NULL, 0, NULL, 1, 1, '2020-03-25 13:52:01', 1, '2020-03-25 13:52:01');
INSERT INTO `t_agv_site_detail` VALUES (42, 42, NULL, 0, NULL, 1, 1, '2020-03-25 13:52:02', 1, '2020-03-25 13:52:02');

-- ----------------------------
-- Table structure for t_agv_stock_up_record
-- ----------------------------
DROP TABLE IF EXISTS `t_agv_stock_up_record`;
CREATE TABLE `t_agv_stock_up_record`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `site_id` bigint(20) NOT NULL COMMENT '站点ID',
  `material_box_id` bigint(20) NOT NULL COMMENT '料框ID',
  `type` tinyint(4) NOT NULL COMMENT '类型【1：消毒间备货；2：拆包间备货；3：包材仓备货】',
  `state` tinyint(4) NOT NULL COMMENT '状态【0：未出库；1：已出库】',
  `delivery_task_id` bigint(20) NULL DEFAULT NULL COMMENT '配送任务ID',
  `enabled` tinyint(1) NOT NULL COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT 0 COMMENT '创建者',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '备货记录表[站点历史备货数据]' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_agv_stock_up_record_detail
-- ----------------------------
DROP TABLE IF EXISTS `t_agv_stock_up_record_detail`;
CREATE TABLE `t_agv_stock_up_record_detail`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `stock_up_record_id` bigint(20) NOT NULL COMMENT '备货记录ID',
  `material_id` bigint(20) NOT NULL COMMENT '物料ID（原料）',
  `count` int(11) NOT NULL COMMENT '数量',
  `enabled` tinyint(1) NOT NULL COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT 0 COMMENT '创建者',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '备货记录详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_agv_wave
-- ----------------------------
DROP TABLE IF EXISTS `t_agv_wave`;
CREATE TABLE `t_agv_wave`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '编码',
  `team_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '班组唯一标识',
  `team_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '班组名称',
  `area_id` bigint(20) NOT NULL COMMENT '区域ID(生产线ID)',
  `material_id` bigint(20) NOT NULL COMMENT '物料ID(产品)',
  `execution_time` datetime(0) NOT NULL COMMENT '执行时间',
  `finish_time` datetime(0) NOT NULL COMMENT '完成时间',
  `state` tinyint(4) NOT NULL COMMENT '状态【0：未配送；1：配送中；2：已完成】',
  `type` tinyint(4) NOT NULL COMMENT '类型【1：灌装区；2：包装区】',
  `enabled` tinyint(1) NOT NULL COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT 0 COMMENT '创建者',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '波次表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_agv_wave_detail
-- ----------------------------
DROP TABLE IF EXISTS `t_agv_wave_detail`;
CREATE TABLE `t_agv_wave_detail`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '编号',
  `wave_code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '波次编号',
  `material_id` bigint(20) NOT NULL COMMENT '物料ID(原料)',
  `count` int(11) NOT NULL COMMENT '数量',
  `state` tinyint(4) NOT NULL COMMENT '状态【0：未配送；1：配送中；2：已完成】',
  `enabled` tinyint(1) NOT NULL COMMENT '是否启用',
  `create_user` bigint(20) NOT NULL DEFAULT 0 COMMENT '创建者',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后一次更新者',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后一次更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '波次详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_sys_area
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_area`;
CREATE TABLE `t_sys_area`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'UUID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_user` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建用户',
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '区域代码',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '区域名称',
  `parent_id` bigint(20) NOT NULL COMMENT 'pid',
  `remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注信息',
  `state` int(1) NULL DEFAULT 0 COMMENT '状态:0 启用, 1 禁用',
  `priority` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '排序号',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后修改时间',
  `last_modified_user` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `UK_23ahu6mjk385fl50ld23iljes`(`code`) USING BTREE,
  UNIQUE INDEX `UK_brixco4h19cnj4fowxsen6dst`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_sys_area
-- ----------------------------
INSERT INTO `t_sys_area` VALUES (1, '0000-00-00 00:00:00', '', '110000', '北京市', 0, NULL, 0, NULL, '2018-08-15 10:14:17', '');
INSERT INTO `t_sys_area` VALUES (2, '0000-00-00 00:00:00', '', '110100', '北京城区', 1, NULL, 0, NULL, '2018-08-15 10:14:17', '');
INSERT INTO `t_sys_area` VALUES (3, '0000-00-00 00:00:00', '', '120000', '天津市', 0, NULL, 0, NULL, '2018-08-15 10:14:17', '');
INSERT INTO `t_sys_area` VALUES (4, '0000-00-00 00:00:00', '', '120100', '天津城区', 2, NULL, 0, NULL, '2018-08-15 10:14:17', '');
INSERT INTO `t_sys_area` VALUES (5, '2018-08-10 10:30:18', '0', '350000', '福建省', 0, NULL, 0, NULL, '2018-08-15 10:14:17', '');
INSERT INTO `t_sys_area` VALUES (6, '2018-09-05 17:38:22', '1', '某某街', '120101', 4, NULL, 0, NULL, '2018-09-05 17:38:21', '1');

-- ----------------------------
-- Table structure for t_sys_attachment
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_attachment`;
CREATE TABLE `t_sys_attachment`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'UUID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_user` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建用户',
  `hash` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件哈希',
  `name` varchar(56) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文件名称',
  `size` bigint(20) NULL DEFAULT NULL COMMENT '文件大小',
  `state` int(1) NULL DEFAULT NULL COMMENT '状态:0 启用, 1 禁用',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '类型',
  `url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'URL',
  `show_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '前台显示的文件名',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后修改时间',
  `last_modified_user` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `UK_sprcv6iwieerbdqnlfdhg0qk1`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_sys_company
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_company`;
CREATE TABLE `t_sys_company`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'UUID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_user` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建用户',
  `address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '地址',
  `barcode` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '公司网站二维码',
  `contact` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '联系方式',
  `copyright` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '权限',
  `credential` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '证书',
  `email` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '电子邮箱',
  `information` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '信息',
  `logo` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '公司标识',
  `name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `phone` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '联系电话',
  `slogan1` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '标语1',
  `slogan2` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '标语2',
  `system_name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '系统名称',
  `welcome_picture` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '欢迎图片',
  `fax` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '传真号码',
  `mobile` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `web_site` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '官方网站',
  `zip` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮政编码',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后修改时间',
  `last_modified_user` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `UK_1ogheau6g40tewkkguf8r01t1`(`fax`) USING BTREE,
  UNIQUE INDEX `UK_7wigop1491uxv5pum03uri3wm`(`mobile`) USING BTREE,
  UNIQUE INDEX `UK_bbu877aw3g0jefur0c5ldhvks`(`web_site`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_sys_config
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_config`;
CREATE TABLE `t_sys_config`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'UUID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_user` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建用户',
  `attachment_server` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '附件服务器地址',
  `logo` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '系统logo',
  `name` varchar(126) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '系统名称',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后修改时间',
  `last_modified_user` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最后修改用户',
  `level` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '级别',
  `threshold` float NULL DEFAULT NULL COMMENT '人脸匹配度配置',
  `attachment_id` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_sys_config
-- ----------------------------
INSERT INTO `t_sys_config` VALUES (1, '2018-05-22 14:47:52', '0', 'http://localhost:8080/attachments/', '', '后台系统', '2018-09-07 11:35:52', '', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for t_sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_dict`;
CREATE TABLE `t_sys_dict`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `dict_group_id` bigint(20) NOT NULL COMMENT '字典组ID',
  `dict_group_code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '字典组code',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字典名',
  `system` tinyint(1) NULL DEFAULT 0 COMMENT '是否系统内置:0 是, 1 否',
  `code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '字典编码',
  `sort` tinyint(4) NOT NULL DEFAULT 0 COMMENT '排序',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '备注',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_user` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建用户',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后修改时间',
  `last_modified_user` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `NewIndex1`(`dict_group_id`, `code`) USING BTREE,
  INDEX `NewIndex2`(`dict_group_id`, `name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 117 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_sys_dict
-- ----------------------------
INSERT INTO `t_sys_dict` VALUES (6, 1, NULL, '1', 0, '1', 0, NULL, '2018-08-21 10:10:41', '1', '2018-11-01 10:12:46', '1');
INSERT INTO `t_sys_dict` VALUES (68, 16, 'pms_week_daily_excel', 'chenfuqian@furongsoft.com', 0, 'chenfuqian@furongsoft.com', 0, NULL, '2018-09-02 17:51:56', '1', '2018-09-02 18:53:24', '1');
INSERT INTO `t_sys_dict` VALUES (70, 17, '日报其他类型', '售后服务', 0, '1', 0, NULL, '2018-09-15 13:11:27', '1', '2018-09-15 21:11:26', '1');
INSERT INTO `t_sys_dict` VALUES (78, 18, 'mes_production_line_type', '生产流水线', 0, '1', 0, NULL, '2018-10-22 22:22:44', '1', '2018-10-22 22:22:43', '1');
INSERT INTO `t_sys_dict` VALUES (79, 18, 'mes_production_line_type', '组件生产', 0, '2', 0, NULL, '2018-10-22 22:23:01', '1', '2018-10-22 22:23:01', '1');
INSERT INTO `t_sys_dict` VALUES (80, 18, 'mes_production_line_type', '原料加工', 0, '3', 0, NULL, '2018-10-22 22:23:11', '1', '2018-10-22 22:23:11', '1');
INSERT INTO `t_sys_dict` VALUES (81, 19, 'mes_bill_of_material_type', '产品', 0, '1', 1, NULL, '2018-10-24 06:38:49', '1', '2018-10-24 06:38:48', '1');
INSERT INTO `t_sys_dict` VALUES (82, 19, 'mes_bill_of_material_type', '组合件', 0, '2', 2, NULL, '2018-10-24 06:39:02', '1', '2018-10-24 06:39:02', '1');
INSERT INTO `t_sys_dict` VALUES (83, 19, 'mes_bill_of_material_type', '零部件', 0, '3', 3, NULL, '2018-10-24 06:39:13', '1', '2018-10-24 06:39:12', '1');
INSERT INTO `t_sys_dict` VALUES (84, 19, 'mes_bill_of_material_type', '原材料', 0, '4', 4, NULL, '2018-10-24 06:39:22', '1', '2018-10-24 06:39:22', '1');
INSERT INTO `t_sys_dict` VALUES (85, 20, 'mes_bill_of_material_source', '自制件', 0, '1', 1, NULL, '2018-10-24 06:41:19', '1', '2018-10-24 06:41:19', '1');
INSERT INTO `t_sys_dict` VALUES (86, 20, 'mes_bill_of_material_source', '采购件', 0, '2', 2, NULL, '2018-10-24 06:41:29', '1', '2018-10-24 06:41:28', '1');
INSERT INTO `t_sys_dict` VALUES (87, 21, 'mes_bill_of_material_state', '未审核', 0, '1', 1, NULL, '2018-10-24 06:42:19', '1', '2018-10-24 06:42:18', '1');
INSERT INTO `t_sys_dict` VALUES (88, 21, 'mes_bill_of_material_state', '已审核', 0, '2', 2, NULL, '2018-10-24 06:42:30', '1', '2018-10-24 06:42:29', '1');
INSERT INTO `t_sys_dict` VALUES (89, 22, 'mes_bill_of_material_unit', '个', 0, '1', 1, NULL, '2018-10-24 06:47:52', '1', '2018-10-24 06:47:52', '1');
INSERT INTO `t_sys_dict` VALUES (90, 22, 'mes_bill_of_material_unit', '箱', 0, '2', 2, NULL, '2018-10-24 06:48:06', '1', '2018-10-24 06:48:05', '1');
INSERT INTO `t_sys_dict` VALUES (91, 22, 'mes_bill_of_material_unit', '斤', 0, '3', 3, NULL, '2018-10-24 06:48:14', '1', '2018-10-24 06:48:14', '1');
INSERT INTO `t_sys_dict` VALUES (92, 22, 'mes_bill_of_material_unit', '堆', 0, '4', 4, NULL, '2018-10-24 06:48:27', '1', '2018-10-24 06:48:26', '1');
INSERT INTO `t_sys_dict` VALUES (93, 22, 'mes_bill_of_material_unit', '台', 0, '5', 5, NULL, '2018-10-24 06:48:36', '1', '2018-10-24 06:48:36', '1');
INSERT INTO `t_sys_dict` VALUES (94, 22, 'mes_bill_of_material_unit', '架', 0, '6', 6, NULL, '2018-10-24 06:48:52', '1', '2018-10-24 06:48:52', '1');
INSERT INTO `t_sys_dict` VALUES (95, 23, 'mes_equipment_state', '空闲中', 0, '1', 1, NULL, '2018-10-25 16:40:05', '1', '2018-10-25 16:40:04', '1');
INSERT INTO `t_sys_dict` VALUES (96, 23, 'mes_equipment_state', '生产中', 0, '2', 2, NULL, '2018-10-25 16:40:19', '1', '2018-10-25 16:40:19', '1');
INSERT INTO `t_sys_dict` VALUES (97, 23, 'mes_equipment_state', '停用', 0, '3', 3, NULL, '2018-10-25 16:40:30', '1', '2018-10-25 16:40:30', '1');
INSERT INTO `t_sys_dict` VALUES (98, 23, 'mes_equipment_state', '维护中', 0, '4', 4, NULL, '2018-10-25 16:40:41', '1', '2018-10-25 16:40:41', '1');
INSERT INTO `t_sys_dict` VALUES (99, 23, 'mes_equipment_state', '准备中', 0, '6', 6, NULL, '2018-10-25 16:40:55', '1', '2018-10-25 16:40:54', '1');
INSERT INTO `t_sys_dict` VALUES (100, 24, 'mes_working_process_state', '未审核', 0, '1', 1, NULL, '2018-11-01 15:45:12', '1', '2018-11-01 15:45:11', '1');
INSERT INTO `t_sys_dict` VALUES (101, 24, 'mes_working_process_state', '已审核', 0, '2', 2, NULL, '2018-11-01 15:45:22', '1', '2018-11-01 15:45:22', '1');
INSERT INTO `t_sys_dict` VALUES (102, 25, 'mes_working_procedure_build_type', '自制', 0, '1', 1, NULL, '2018-11-01 17:52:19', '1', '2018-11-01 17:52:18', '1');
INSERT INTO `t_sys_dict` VALUES (103, 25, 'mes_working_procedure_build_type', '外协', 0, '2', 2, NULL, '2018-11-01 17:52:37', '1', '2018-11-01 17:52:37', '1');
INSERT INTO `t_sys_dict` VALUES (104, 26, 'mes_product_category', '全新产品', 0, '1', 0, NULL, '2018-11-15 17:34:05', '1', '2018-11-15 17:34:04', '1');
INSERT INTO `t_sys_dict` VALUES (105, 26, 'mes_product_category', '改进产品', 0, '2', 0, NULL, '2018-11-15 17:34:16', '1', '2018-11-15 17:34:15', '1');
INSERT INTO `t_sys_dict` VALUES (106, 26, 'mes_product_category', '换代产品', 0, '3', 0, NULL, '2018-11-15 17:34:30', '1', '2018-11-15 17:34:30', '1');
INSERT INTO `t_sys_dict` VALUES (107, 26, 'mes_product_category', '仿制产品', 0, '4', 0, NULL, '2018-11-15 17:34:45', '1', '2018-11-15 17:34:45', '1');
INSERT INTO `t_sys_dict` VALUES (108, 27, 'mes_product_state', '未审核', 0, '1', 0, NULL, '2018-11-15 17:34:55', '1', '2018-11-15 17:34:55', '1');
INSERT INTO `t_sys_dict` VALUES (109, 27, 'mes_product_state', '已审核', 0, '2', 0, NULL, '2018-11-15 17:35:04', '1', '2018-11-15 17:35:04', '1');
INSERT INTO `t_sys_dict` VALUES (110, 28, 'mes_product_unit', '架', 0, '1', 0, NULL, '2018-11-16 11:31:00', '1', '2018-11-16 11:31:00', '1');
INSERT INTO `t_sys_dict` VALUES (111, 28, 'mes_product_unit', '台', 0, '2', 0, NULL, '2018-11-16 11:31:06', '1', '2018-11-16 11:31:06', '1');
INSERT INTO `t_sys_dict` VALUES (112, 28, 'mes_product_unit', '箱', 0, '3', 0, NULL, '2018-11-16 11:31:15', '1', '2018-11-16 11:31:14', '1');
INSERT INTO `t_sys_dict` VALUES (113, 28, 'mes_product_unit', '堆', 0, '4', 0, NULL, '2018-11-16 11:31:23', '1', '2018-11-16 11:31:22', '1');
INSERT INTO `t_sys_dict` VALUES (114, 28, 'mes_product_unit', '个', 0, '5', 0, NULL, '2018-11-16 11:31:28', '1', '2018-11-16 11:31:27', '1');
INSERT INTO `t_sys_dict` VALUES (115, 28, 'mes_product_unit', '框', 0, '6', 0, NULL, '2018-11-16 11:31:35', '1', '2018-11-16 11:31:34', '1');
INSERT INTO `t_sys_dict` VALUES (116, 28, 'mes_product_unit', '斤', 0, '7', 0, NULL, '2018-11-16 11:31:43', '1', '2018-11-16 11:31:43', '1');

-- ----------------------------
-- Table structure for t_sys_dict_group
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_dict_group`;
CREATE TABLE `t_sys_dict_group`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字典组名',
  `code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字典组编码',
  `system` int(1) NULL DEFAULT 0 COMMENT '是否系统内置:0 是, 1 否',
  `sort` tinyint(4) NOT NULL DEFAULT 0 COMMENT '排序',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '备注',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_user` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建用户',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后修改时间',
  `last_modified_user` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典组表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_sys_dict_group
-- ----------------------------
INSERT INTO `t_sys_dict_group` VALUES (18, '生产线类型', 'mes_production_line_type', 0, 0, NULL, '2018-10-22 22:22:04', '1', '2018-10-22 22:22:03', '1');
INSERT INTO `t_sys_dict_group` VALUES (19, '物料类型', 'mes_bill_of_material_type', 0, 0, NULL, '2018-10-24 06:38:19', '1', '2018-10-24 06:38:18', '1');
INSERT INTO `t_sys_dict_group` VALUES (20, '物料来源', 'mes_bill_of_material_source', 0, 0, NULL, '2018-10-24 06:40:55', '1', '2018-10-24 06:40:54', '1');
INSERT INTO `t_sys_dict_group` VALUES (21, '物料状态', 'mes_bill_of_material_state', 0, 0, NULL, '2018-10-24 06:41:56', '1', '2018-10-24 06:41:55', '1');
INSERT INTO `t_sys_dict_group` VALUES (22, '物料单位', 'mes_bill_of_material_unit', 0, 0, NULL, '2018-10-24 06:47:39', '1', '2018-10-24 06:47:38', '1');
INSERT INTO `t_sys_dict_group` VALUES (23, '设备状态', 'mes_equipment_state', 0, 0, NULL, '2018-10-25 16:39:27', '1', '2018-10-25 16:39:27', '1');
INSERT INTO `t_sys_dict_group` VALUES (24, '工艺状态', 'mes_working_process_state', 0, 0, NULL, '2018-11-01 15:41:18', '1', '2018-11-01 15:41:17', '1');
INSERT INTO `t_sys_dict_group` VALUES (25, '工序生产方式', 'mes_working_procedure_build_type', 0, 0, NULL, '2018-11-01 17:52:02', '1', '2018-11-01 17:52:01', '1');
INSERT INTO `t_sys_dict_group` VALUES (26, '产品类型', 'mes_product_category', 0, 0, NULL, '2018-11-15 17:30:43', '1', '2018-11-15 17:30:42', '1');
INSERT INTO `t_sys_dict_group` VALUES (27, '产品状态', 'mes_product_state', 0, 0, NULL, '2018-11-15 17:31:08', '1', '2018-11-15 17:31:08', '1');
INSERT INTO `t_sys_dict_group` VALUES (28, '产品单位', 'mes_product_unit', 0, 0, NULL, '2018-11-16 11:30:42', '1', '2018-11-16 11:30:42', '1');

-- ----------------------------
-- Table structure for t_sys_loginfo
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_loginfo`;
CREATE TABLE `t_sys_loginfo`  (
  `company_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公司ID',
  `create_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建用户',
  `err_log` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '错误信息',
  `exec_time` double NOT NULL COMMENT '执行时间',
  `ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '客户端ip',
  `model` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '当前操作模块',
  `operation` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作模块功能',
  `type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '操作类型',
  `username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户登录名'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_sys_loginfo
-- ----------------------------
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-06-19 15:03:04', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-06-20 09:07:00', '1', '', 0, '192.168.8.105', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-06-20 10:32:09', '1', '', 0, '192.168.8.106', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-06-20 10:32:23', '1', '', 0, '192.168.8.106', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-06-20 10:33:15', '1', '', 0, '192.168.8.106', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-06-20 10:34:00', '1', '', 0, '192.168.8.106', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-06-21 16:14:55', '1', '', 0, '192.168.8.105', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-06-21 16:15:50', '1', '', 0, '192.168.8.105', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-01 16:40:59', '1', '', 7, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-01 16:41:16', '1', '', 0, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-01 16:51:12', '1', '', 0, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-01 17:44:15', '1', '', 0, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-01 17:44:24', '1', '', 0, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-01 17:44:36', '1', '', 0, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-01 17:44:50', '1', '', 0, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 00:03:29', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 00:12:07', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 00:17:44', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 00:18:02', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 00:18:54', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 08:19:42', '1', '', 0, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 08:21:37', '1', '', 0, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 08:21:43', '1', '', 0, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 08:21:54', '1', '', 0, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 08:22:11', '1', '', 0, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 08:29:42', '1', '', 0, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 08:32:31', '1', '', 0, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 08:34:03', '1', '', 0, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 08:34:19', '1', '', 0, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 08:34:26', '1', '', 0, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 08:35:40', '1', '', 0, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 08:36:46', '1', '', 0, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 08:38:57', '1', '', 0, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 08:39:10', '1', '', 0, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 08:44:26', '1', '', 0, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 08:46:16', '1', '', 0, '192.168.8.20', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 08:53:00', '1', '', 0, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 08:53:10', '1', '', 0, '192.168.8.48', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 10:13:36', '1', '', 0, '192.168.8.20', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 10:35:53', '1', '', 0, '192.168.8.94', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 10:36:17', '1', '', 0, '192.168.8.94', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 10:36:24', '1', '', 0, '192.168.8.94', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 10:36:31', '1', '', 0, '192.168.8.94', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 10:36:40', '1', '', 0, '192.168.8.94', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-02 10:44:34', '1', '', 0, '192.168.8.20', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-04 10:43:02', '1', '', 2, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-04 11:11:24', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-04 11:23:13', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-04 11:23:20', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-04 11:24:32', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-04 11:24:40', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-04 11:46:14', '1', '', 8, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-05 10:14:07', '1', '', 1, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-05 10:14:13', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-05 10:22:28', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-05 10:25:22', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-05 10:40:48', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-08 16:51:19', '1', '', 7, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-15 10:28:54', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-15 10:30:41', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-15 10:31:16', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-15 10:31:48', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-15 10:41:39', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-16 09:12:54', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-16 09:14:33', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-16 16:08:18', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-17 14:37:58', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-17 14:40:54', '1', '', 24, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-17 14:41:00', '1', '', 2, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-17 14:41:50', '1', '', 7, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-17 14:48:49', '1', '', 28, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-17 14:49:00', '1', '', 5, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-17 14:59:33', '1', '', 13, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-17 15:05:34', '1', '', 6, '192.168.8.20', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-17 15:05:49', '1', 'newPassword.error', 0, '192.168.8.20', 'UserController', 'updateUserPassword', 'other', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-17 15:06:19', '1', 'newPassword.error', 8, '0:0:0:0:0:0:0:1', 'UserController', 'updateUserPassword', 'other', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-17 15:06:52', '1', 'newPassword.error', 17, '0:0:0:0:0:0:0:1', 'UserController', 'updateUserPassword', 'other', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-17 15:08:55', '1', '', 100, '0:0:0:0:0:0:0:1', 'UserController', 'updateUserPassword', 'other', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-17 15:09:26', '1', '', 11, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-17 15:09:43', '1', '', 4, '0:0:0:0:0:0:0:1', 'UserController', 'updateUserPassword', 'other', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-19 09:08:45', '1', '', 1, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-19 09:14:15', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-19 09:14:25', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-19 09:16:14', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-19 09:18:17', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-19 09:22:22', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-19 14:32:00', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-19 14:35:07', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-07-19 15:35:42', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-10-15 10:45:43', '1', '', 29, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-10-15 10:45:51', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-10-15 10:46:33', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-10-15 10:48:47', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-10-15 10:49:00', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-20 10:36:49', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-20 11:01:31', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-20 11:01:47', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-27 14:53:34', '1', '', 1, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-27 14:54:09', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-27 15:12:05', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-27 15:12:55', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-27 15:13:05', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-27 15:13:12', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-27 15:13:16', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-27 15:13:19', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-27 15:13:31', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-27 15:17:18', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-27 15:17:44', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-27 15:18:08', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-27 15:18:42', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-27 15:19:26', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-27 15:20:04', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-27 17:40:01', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-27 17:40:07', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-29 07:49:53', '1', '', 24, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-29 07:50:17', '1', '', 13, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-29 07:51:10', '1', '', 3, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-29 08:06:25', '1', '', 3, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-29 08:07:05', '1', '', 3, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-29 08:07:49', '1', '', 3, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-29 08:10:12', '1', '', 40, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-29 08:14:46', '1', '', 6, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-29 08:24:11', '1', '', 4, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-29 08:25:37', '1', '', 5, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-29 08:30:05', '1', '', 3, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-11-29 08:30:46', '1', '', 5, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 10:20:24', '1', '', 16, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 10:20:24', '1', '', 637, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 10:20:24', '1', '', 17, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 10:20:38', '1', '', 3, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 10:21:25', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 10:25:51', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 10:27:37', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 10:35:17', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 10:52:44', '1', '', 1, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 11:02:03', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 11:02:21', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 11:02:46', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 11:02:55', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 11:03:04', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 11:08:19', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 11:08:28', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 11:14:39', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 11:25:56', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 11:27:01', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 13:13:00', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 13:19:53', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 13:21:10', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 13:23:02', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 13:48:40', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 13:54:34', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 13:54:55', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 13:55:31', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 13:55:33', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 13:55:33', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 13:55:34', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 13:55:34', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 13:55:34', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 13:55:35', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 13:55:36', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 13:55:37', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 13:56:41', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 13:56:42', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 13:56:51', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 14:05:43', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 14:06:35', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 14:13:22', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 14:25:42', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 14:26:15', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 14:31:08', '1', '', 0, '0:0:0:0:0:0:0:1', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 15:02:14', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 15:17:08', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 15:27:30', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 15:35:49', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 15:56:42', '1', '', 0, '192.168.8.68', 'UserController', 'login', 'login', 'admin');
INSERT INTO `t_sys_loginfo` VALUES ('Test', '2019-12-03 17:34:02', '1', '', 3, '192.168.8.68', 'UserController', 'login', 'login', 'admin');

-- ----------------------------
-- Table structure for t_sys_organization
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_organization`;
CREATE TABLE `t_sys_organization`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'UUID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_user` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建用户',
  `duty` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '部门职责',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '部门名称',
  `code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '部门编号',
  `parent_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'parentId',
  `sort` tinyint(4) NULL DEFAULT 0 COMMENT '排序号',
  `state` int(1) NULL DEFAULT 0 COMMENT '状态:0 启用, 1 禁用',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后修改时间',
  `last_modified_user` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_sys_organization
-- ----------------------------
INSERT INTO `t_sys_organization` VALUES (1, '2018-08-21 09:55:06', '1', NULL, '软件开发部', '8600', '0', 0, 0, '2018-08-21 09:55:05', '1');
INSERT INTO `t_sys_organization` VALUES (5, '2018-09-09 02:23:22', '1', NULL, '总经办', '8100', '0', 0, 0, '2018-09-09 10:23:21', '1');
INSERT INTO `t_sys_organization` VALUES (6, '2018-09-09 02:23:40', '1', NULL, '行政部', '8200', '0', 0, 0, '2018-09-09 10:23:40', '1');
INSERT INTO `t_sys_organization` VALUES (7, '2018-09-09 02:24:05', '1', NULL, '教育事业部', '8300', '0', 0, 0, '2018-09-09 10:24:04', '1');
INSERT INTO `t_sys_organization` VALUES (8, '2018-09-09 02:24:18', '1', NULL, '财务部', '8500', '0', 0, 0, '2018-09-09 10:24:17', '1');
INSERT INTO `t_sys_organization` VALUES (9, '2018-09-09 02:24:32', '1', NULL, '销售部', '8700', '0', 0, 0, '2018-09-09 10:24:32', '1');
INSERT INTO `t_sys_organization` VALUES (10, '2018-09-09 02:24:47', '1', NULL, '方案部', '8800', '0', 0, 0, '2018-09-09 10:24:47', '1');
INSERT INTO `t_sys_organization` VALUES (11, '2018-09-09 02:25:01', '1', NULL, '工程项目部', '8900', '0', 0, 0, '2018-09-09 10:25:01', '1');
INSERT INTO `t_sys_organization` VALUES (12, '2018-09-09 02:25:15', '1', NULL, '培训部', '9000', '0', 0, 0, '2018-09-09 10:25:14', '1');

-- ----------------------------
-- Table structure for t_sys_permission
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_permission`;
CREATE TABLE `t_sys_permission`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'UUID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_user` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建用户',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `state` int(1) NOT NULL DEFAULT 0 COMMENT '状态:0 启用, 1 禁用',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后修改时间',
  `last_modified_user` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `UK_qqmk03vklngso0j13kukc1f90`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 718299469 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_sys_permission
-- ----------------------------
INSERT INTO `t_sys_permission` VALUES (718299464, '2018-05-24 10:35:17', '', '超级管理员', NULL, 0, '2018-08-15 10:14:25', '');
INSERT INTO `t_sys_permission` VALUES (718299465, '2018-09-04 12:04:56', '1', '管理层', NULL, 0, '2018-09-04 12:04:56', '1');
INSERT INTO `t_sys_permission` VALUES (718299466, '2018-09-07 02:52:33', '1', '普通用户', NULL, 0, '2018-09-07 10:52:32', '1');
INSERT INTO `t_sys_permission` VALUES (718299467, '2018-09-07 02:56:40', '1', '项目经理', NULL, 0, '2018-09-07 10:56:40', '1');
INSERT INTO `t_sys_permission` VALUES (718299468, '2018-09-09 11:32:53', '1', '发送周报', NULL, 0, '2018-09-09 19:32:53', '1');

-- ----------------------------
-- Table structure for t_sys_permission_resource
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_permission_resource`;
CREATE TABLE `t_sys_permission_resource`  (
  `permission_id` bigint(20) NOT NULL COMMENT '权限ID',
  `resource_id` bigint(20) NOT NULL COMMENT '资源ID'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_sys_permission_resource
-- ----------------------------
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 1);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 2);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 3);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 4);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 5);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 6);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 7);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 8);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 11);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 12);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 25);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 26);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 27);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 28);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 29);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 31);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 33);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 34);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 35);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 30);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 36);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 37);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 38);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 39);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 40);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 41);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 42);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 43);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 44);
INSERT INTO `t_sys_permission_resource` VALUES (718299464, 45);

-- ----------------------------
-- Table structure for t_sys_position
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_position`;
CREATE TABLE `t_sys_position`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '名称',
  `parent_id` bigint(20) NOT NULL COMMENT '父级岗位',
  `department_id` bigint(20) NOT NULL COMMENT '部门索引',
  `type` bigint(20) NOT NULL COMMENT '岗位分类',
  `duty` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '岗位职责',
  `state` tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_user` bigint(20) NOT NULL COMMENT '创建用户',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后修改时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '岗位表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_sys_position
-- ----------------------------
INSERT INTO `t_sys_position` VALUES (1, '开发', 0, 1, 5, '1', 0, '2018-08-21 11:24:15', 1, '2018-08-21 11:25:44', 1);
INSERT INTO `t_sys_position` VALUES (2, '打法', 1, 1, 5, NULL, 0, '2018-08-21 11:24:32', 1, '2018-08-21 11:25:46', 1);

-- ----------------------------
-- Table structure for t_sys_resource
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_resource`;
CREATE TABLE `t_sys_resource`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'UUID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_user` bigint(20) NOT NULL COMMENT '创建用户',
  `icon` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图标',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '路径',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `state` int(1) NOT NULL DEFAULT 0 COMMENT '状态:0 启用, 1 禁用',
  `type` int(4) NOT NULL DEFAULT 0 COMMENT '类型:0 图片, 1 文件',
  `system` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否系统内置:1 是, 0 否',
  `parent_id` bigint(20) NOT NULL COMMENT '父级节点ID',
  `priority` int(4) NULL DEFAULT 0 COMMENT '优先级',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后修改时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_sys_resource
-- ----------------------------
INSERT INTO `t_sys_resource` VALUES (1, '2018-08-03 13:08:41', 0, NULL, '字典管理', '/system/dict', NULL, 0, 0, 1, 5, 0, '2018-08-15 15:07:43', 0);
INSERT INTO `t_sys_resource` VALUES (2, '2018-08-07 10:20:04', 0, NULL, '组织管理', '/system/organization', NULL, 0, 0, 1, 5, 0, '2018-08-15 15:07:44', 0);
INSERT INTO `t_sys_resource` VALUES (3, '2018-08-02 17:13:10', 0, NULL, '区域管理', '/system/area', NULL, 0, 0, 1, 5, 1, '2018-08-15 15:07:44', 0);
INSERT INTO `t_sys_resource` VALUES (4, '2018-05-25 15:22:10', 0, NULL, '角色管理', '/system/role', '', 0, 0, 1, 5, 0, '2018-08-15 15:07:45', 0);
INSERT INTO `t_sys_resource` VALUES (5, '2018-05-24 21:38:46', 0, NULL, '系统管理', '/', '2', 0, 0, 1, 0, 0, '2018-08-15 15:07:21', 0);
INSERT INTO `t_sys_resource` VALUES (6, '2018-05-24 21:38:46', 0, NULL, '资源管理', '/system/resource', NULL, 0, 0, 1, 5, 0, '2018-08-15 15:07:45', 0);
INSERT INTO `t_sys_resource` VALUES (7, '2018-05-24 22:12:59', 0, NULL, '权限管理', '/system/permission', NULL, 0, 0, 1, 5, 0, '2018-08-15 15:07:46', 0);
INSERT INTO `t_sys_resource` VALUES (8, '2018-05-24 22:48:35', 0, NULL, '用户管理', '/system/user', NULL, 0, 0, 1, 5, 0, '2018-08-15 15:07:48', 0);
INSERT INTO `t_sys_resource` VALUES (11, '2018-08-21 09:45:06', 1, NULL, '组织架构', '/system/organization', NULL, 0, 0, 1, 5, 0, '2018-08-21 09:45:06', 1);
INSERT INTO `t_sys_resource` VALUES (12, '2018-08-21 11:07:14', 1, NULL, '岗位管理', '/system/position', NULL, 0, 0, 1, 5, 0, '2018-08-21 11:07:13', 1);
INSERT INTO `t_sys_resource` VALUES (25, '2018-09-25 09:20:42', 1, NULL, '公司管理', '/system/company', NULL, 0, 0, 0, 5, 0, '2018-09-25 09:20:42', 1);
INSERT INTO `t_sys_resource` VALUES (26, '2018-09-25 14:11:31', 1, NULL, '生产管理', '/mes', NULL, 0, 0, 0, 0, 0, '2018-09-25 14:11:31', 1);
INSERT INTO `t_sys_resource` VALUES (27, '2018-09-25 14:13:58', 1, NULL, '工厂管理', '/mes/base/factory', NULL, 0, 0, 0, 37, 1, '2018-09-25 14:13:58', 1);
INSERT INTO `t_sys_resource` VALUES (28, '2018-09-25 14:20:30', 1, NULL, '车间管理', '/mes/base/workshop', NULL, 0, 0, 0, 37, 2, '2018-09-25 14:20:30', 1);
INSERT INTO `t_sys_resource` VALUES (29, '2018-09-25 14:21:06', 1, NULL, '班次管理', '/mes/base/workshift', NULL, 0, 0, 0, 37, 7, '2018-09-25 14:21:05', 1);
INSERT INTO `t_sys_resource` VALUES (30, '2018-09-25 14:21:39', 1, NULL, '生产线管理', '/mes/base/productionLine', NULL, 0, 0, 0, 37, 3, '2018-09-25 14:21:38', 1);
INSERT INTO `t_sys_resource` VALUES (31, '2018-09-29 22:25:31', 1, NULL, '班制管理', '/mes/base/workingSystem', NULL, 0, 0, 0, 37, 6, '2018-09-29 22:25:31', 1);
INSERT INTO `t_sys_resource` VALUES (32, '2018-09-30 14:44:10', 1, NULL, '工作日历', '/mes/workingCalendar', NULL, 0, 0, 0, 26, 6, '2018-09-30 14:44:09', 1);
INSERT INTO `t_sys_resource` VALUES (33, '2018-10-10 09:14:30', 1, NULL, '系统监控', 'monitor', NULL, 0, 0, 0, 0, 0, '2018-10-10 09:14:30', 1);
INSERT INTO `t_sys_resource` VALUES (34, '2018-10-10 09:15:24', 1, NULL, '操作日志', '/monitor/log', NULL, 0, 0, 0, 33, 0, '2018-10-10 09:15:23', 1);
INSERT INTO `t_sys_resource` VALUES (35, '2018-10-10 09:16:27', 1, NULL, '数据库监控', '/monitor/druid', NULL, 0, 0, 0, 33, 0, '2018-10-10 09:16:26', 1);
INSERT INTO `t_sys_resource` VALUES (36, '2018-10-23 23:20:44', 1, NULL, '物料管理', '/mes/product/billOfMaterial', NULL, 0, 0, 0, 38, 2, '2018-10-23 23:20:43', 1);
INSERT INTO `t_sys_resource` VALUES (37, '2018-10-25 15:06:37', 1, NULL, '基础信息', '/mes/base', NULL, 0, 0, 0, 26, 1, '2018-10-25 15:06:36', 1);
INSERT INTO `t_sys_resource` VALUES (38, '2018-10-25 15:13:56', 1, NULL, '产品信息', '/mes/product', NULL, 0, 0, 0, 26, 3, '2018-10-25 15:13:56', 1);
INSERT INTO `t_sys_resource` VALUES (39, '2018-10-25 15:14:56', 1, NULL, '设备信息', '/mes/equipment', NULL, 0, 0, 0, 26, 2, '2018-10-25 15:14:56', 1);
INSERT INTO `t_sys_resource` VALUES (40, '2018-10-25 15:18:26', 1, NULL, '设备类型', '/mes/equipment/equipmentCategory', NULL, 0, 0, 0, 39, 1, '2018-10-25 15:18:25', 1);
INSERT INTO `t_sys_resource` VALUES (41, '2018-10-25 15:19:21', 1, NULL, '设备管理', '/mes/equipment/equipment', NULL, 0, 0, 0, 39, 2, '2018-10-25 15:19:21', 1);
INSERT INTO `t_sys_resource` VALUES (42, '2018-10-29 17:15:26', 1, NULL, '工作站类型', '/mes/base/workingStationCategory', NULL, 0, 0, 0, 37, 5, '2018-10-29 17:15:25', 1);
INSERT INTO `t_sys_resource` VALUES (43, '2018-10-29 22:06:43', 1, NULL, '工作站管理', '/mes/base/workingStation', NULL, 0, 0, 0, 37, 4, '2018-10-29 22:06:42', 1);
INSERT INTO `t_sys_resource` VALUES (44, '2018-11-01 18:07:18', 1, NULL, '工艺管理', '/mes/product/workingProcess', NULL, 0, 0, 0, 38, 3, '2018-11-01 18:07:17', 1);
INSERT INTO `t_sys_resource` VALUES (45, '2018-11-16 11:17:34', 1, NULL, '产品管理', '/mes/product/product', NULL, 0, 0, 0, 38, 1, '2018-11-16 11:17:34', 1);

-- ----------------------------
-- Table structure for t_sys_role
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_role`;
CREATE TABLE `t_sys_role`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'UUID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_user` bigint(20) NOT NULL COMMENT '创建用户',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '名称',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `system` tinyint(1) NULL DEFAULT 0 COMMENT '是否系统角色 0-是 1-否',
  `state` int(1) NULL DEFAULT 0 COMMENT '状态:0 启用, 1 禁用',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '角色编码',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后修改时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_sys_role
-- ----------------------------
INSERT INTO `t_sys_role` VALUES (3, '2018-05-24 10:36:59', 0, '超级管理员', NULL, 0, 0, 'admin', '2018-08-15 15:08:48', 0);
INSERT INTO `t_sys_role` VALUES (5, '2018-09-04 11:28:26', 1, '管理层', NULL, 0, 0, 'pms_all_project_manage', '2018-09-07 11:11:29', 1);
INSERT INTO `t_sys_role` VALUES (6, '2018-09-04 11:28:34', 1, '项目经理', NULL, 0, 0, 'pms_project_create', '2018-09-07 11:11:20', 1);
INSERT INTO `t_sys_role` VALUES (7, '2018-09-04 11:28:47', 1, '产品经理', NULL, 0, 0, 'pms_project_create', '2018-09-07 11:11:27', 1);
INSERT INTO `t_sys_role` VALUES (8, '2018-09-07 02:52:21', 1, '普通用户', NULL, 0, 0, NULL, '2018-09-07 10:52:20', 1);
INSERT INTO `t_sys_role` VALUES (9, '2018-09-09 11:33:28', 1, '发送周报', NULL, 0, 0, NULL, '2018-09-09 19:33:27', 1);

-- ----------------------------
-- Table structure for t_sys_role_permission
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_role_permission`;
CREATE TABLE `t_sys_role_permission`  (
  `permission_id` bigint(20) NOT NULL COMMENT '权限ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_sys_role_permission
-- ----------------------------
INSERT INTO `t_sys_role_permission` VALUES (0, 0);
INSERT INTO `t_sys_role_permission` VALUES (718299464, 3);
INSERT INTO `t_sys_role_permission` VALUES (718299465, 5);

-- ----------------------------
-- Table structure for t_sys_user
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_user`;
CREATE TABLE `t_sys_user`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'UUID',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_user` bigint(20) NOT NULL COMMENT '创建用户',
  `address` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '住宅地址',
  `address2` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '住宅地址',
  `age` int(10) NULL DEFAULT NULL COMMENT '年龄',
  `birthday` datetime(0) NULL DEFAULT NULL COMMENT '生日',
  `business_address` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '工作地址',
  `business_address2` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '工作地址',
  `city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '市/县',
  `company` bigint(20) NULL DEFAULT NULL COMMENT '工作单位',
  `company2` bigint(20) NULL DEFAULT NULL COMMENT '工作单位',
  `company3` bigint(20) NULL DEFAULT NULL COMMENT '工作单位',
  `country` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '国家',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '电子邮件',
  `email2` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '电子邮件',
  `email3` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '电子邮件',
  `icon_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '头像',
  `identification` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '证件',
  `identification2` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '证件',
  `identification3` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '证件',
  `mobile` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '移动电话',
  `mobile2` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '移动电话',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `password` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码',
  `picture_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '照片',
  `province` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '省份/州',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `salt` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '盐值',
  `sex` int(10) NULL DEFAULT NULL COMMENT '性别',
  `sns_account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '社交软件账号',
  `sns_account2` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '社交软件账号',
  `sns_account3` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '社交软件账号',
  `state` int(1) NULL DEFAULT 0 COMMENT '状态:0 启用, 1 禁用',
  `street` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '街道',
  `telephone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '固定电话',
  `telephone2` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '固定电话',
  `department` bigint(20) NULL DEFAULT NULL COMMENT '部门',
  `department2` bigint(20) NULL DEFAULT NULL COMMENT '部门',
  `department3` bigint(20) NULL DEFAULT NULL COMMENT '部门',
  `title` bigint(20) NULL DEFAULT NULL COMMENT '头衔',
  `title2` bigint(20) NULL DEFAULT NULL COMMENT '头衔',
  `title3` bigint(20) NULL DEFAULT NULL COMMENT '头衔',
  `town` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '区/镇',
  `username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '登录账户',
  `web` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '网站',
  `web2` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '网站',
  `web3` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '网站',
  `zip` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮编',
  `code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户编号',
  `web_site` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '网站',
  `web_site2` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '网站',
  `area_id` bigint(20) NULL DEFAULT NULL COMMENT '区域',
  `web_site3` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '网站',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后修改时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后修改用户',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `UK_c6kfx4dbytwpxd74oon192ai0`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_sys_user
-- ----------------------------
INSERT INTO `t_sys_user` VALUES (1, '2018-05-22 14:47:52', 0, NULL, NULL, NULL, '2018-07-17 00:00:00', NULL, NULL, '2', NULL, NULL, NULL, NULL, '11@qq.com', NULL, NULL, '747330000113', NULL, NULL, NULL, '222', NULL, '管理员', '9e8aa87f55fe04b6a94e5abbf10f262c', NULL, '1', NULL, 'e7e8219f1332e31eaeec233786a61cf4', NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, 1, NULL, NULL, 1, NULL, NULL, '4', 'admin', NULL, NULL, NULL, NULL, '360000', NULL, NULL, NULL, NULL, '2019-07-17 15:09:42', 1);

-- ----------------------------
-- Table structure for t_sys_user_configure
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_user_configure`;
CREATE TABLE `t_sys_user_configure`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `report_type` bigint(20) NULL DEFAULT NULL COMMENT '日报类型',
  `create_user` bigint(20) NOT NULL COMMENT '创建用户',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `last_modified_user` bigint(20) NOT NULL COMMENT '最后修改用户',
  `last_modified_time` timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '最后修改时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_sys_user_configure
-- ----------------------------
INSERT INTO `t_sys_user_configure` VALUES (1, 1, 49, 1, '2018-09-16 22:43:21', 1, '2018-09-20 17:02:37');

-- ----------------------------
-- Table structure for t_sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `t_sys_user_role`;
CREATE TABLE `t_sys_user_role`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_sys_user_role
-- ----------------------------
INSERT INTO `t_sys_user_role` VALUES (1, 3);
INSERT INTO `t_sys_user_role` VALUES (1, 5);

SET FOREIGN_KEY_CHECKS = 1;
