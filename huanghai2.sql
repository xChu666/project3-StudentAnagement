/*
Navicat MySQL Data Transfer

Source Server         : mySQL数据库
Source Server Version : 80011
Source Host           : 127.0.0.1:3306
Source Database       : huanghai2

Target Server Type    : MYSQL
Target Server Version : 80011
File Encoding         : 65001

Date: 2021-01-28 17:52:41
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for dt_class
-- ----------------------------
DROP TABLE IF EXISTS `dt_class`;
CREATE TABLE `dt_class` (
  `cls_id` int(11) NOT NULL AUTO_INCREMENT,
  `cls_name` varchar(20) NOT NULL,
  `cls_dic_id_major` int(11) NOT NULL,
  `cls_clsr_id` int(11) DEFAULT NULL,
  `cls_stf_id_teacher` int(11) NOT NULL,
  `cls_stf_id_admin` int(11) NOT NULL,
  `cls_stf_id_job` int(11) NOT NULL,
  `cls_begin` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `cls_end` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `cls_remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`cls_id`),
  KEY `fk_teacher` (`cls_stf_id_teacher`),
  KEY `fk_admin` (`cls_stf_id_admin`),
  KEY `fk_job` (`cls_stf_id_job`),
  KEY `fk_clsr` (`cls_clsr_id`),
  KEY `fk_major` (`cls_dic_id_major`),
  CONSTRAINT `fk_admin` FOREIGN KEY (`cls_stf_id_admin`) REFERENCES `dt_staff` (`stf_id`),
  CONSTRAINT `fk_clsr` FOREIGN KEY (`cls_clsr_id`) REFERENCES `dt_classroom` (`clsr_id`),
  CONSTRAINT `fk_job` FOREIGN KEY (`cls_stf_id_job`) REFERENCES `dt_staff` (`stf_id`),
  CONSTRAINT `fk_major` FOREIGN KEY (`cls_dic_id_major`) REFERENCES `dt_dictionary` (`dic_id`),
  CONSTRAINT `fk_teacher` FOREIGN KEY (`cls_stf_id_teacher`) REFERENCES `dt_staff` (`stf_id`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dt_class
-- ----------------------------
INSERT INTO `dt_class` VALUES ('101', '2009H5', '9', '30', '15', '22', '17', '2021-01-28', '2021-01-28', '一班');
INSERT INTO `dt_class` VALUES ('102', '2009Java', '8', '30', '13', '12', '16', '2021-01-28', null, '');
INSERT INTO `dt_class` VALUES ('103', '2009UI', '10', null, '15', '22', '16', null, null, '');

-- ----------------------------
-- Table structure for dt_classroom
-- ----------------------------
DROP TABLE IF EXISTS `dt_classroom`;
CREATE TABLE `dt_classroom` (
  `clsr_id` int(11) NOT NULL AUTO_INCREMENT,
  `clsr_name` varchar(20) NOT NULL,
  `clsr_occupy` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`clsr_id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dt_classroom
-- ----------------------------
INSERT INTO `dt_classroom` VALUES ('30', '教室101', '1');
INSERT INTO `dt_classroom` VALUES ('31', '教室4', '0');
INSERT INTO `dt_classroom` VALUES ('34', '教室5', '0');
INSERT INTO `dt_classroom` VALUES ('37', '101', '0');
INSERT INTO `dt_classroom` VALUES ('38', '205', '0');
INSERT INTO `dt_classroom` VALUES ('39', '303', '0');
INSERT INTO `dt_classroom` VALUES ('40', '606', '0');
INSERT INTO `dt_classroom` VALUES ('41', '909', '0');

-- ----------------------------
-- Table structure for dt_dictionary
-- ----------------------------
DROP TABLE IF EXISTS `dt_dictionary`;
CREATE TABLE `dt_dictionary` (
  `dic_id` int(11) NOT NULL AUTO_INCREMENT,
  `dic_name` varchar(20) NOT NULL,
  `dic_group_key` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `dic_group_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`dic_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dt_dictionary
-- ----------------------------
INSERT INTO `dt_dictionary` VALUES ('1', '本科及以上', 'qualification', '学历');
INSERT INTO `dt_dictionary` VALUES ('2', '专科', 'qualification', '学历');
INSERT INTO `dt_dictionary` VALUES ('3', '高中及以下', 'qualification', '学历');
INSERT INTO `dt_dictionary` VALUES ('4', '教学老师', 'staff_category', '职务类别');
INSERT INTO `dt_dictionary` VALUES ('5', '教务老师', 'staff_category', '职务类别');
INSERT INTO `dt_dictionary` VALUES ('6', '就业老师', 'staff_category', '职务类别');
INSERT INTO `dt_dictionary` VALUES ('7', '市场老师', 'staff_category', '职务类别');
INSERT INTO `dt_dictionary` VALUES ('8', 'Java', 'class_major', '班级专业');
INSERT INTO `dt_dictionary` VALUES ('9', 'H5前端', 'class_major', '班级专业');
INSERT INTO `dt_dictionary` VALUES ('10', 'UI设计', 'class_major', '班级专业');

-- ----------------------------
-- Table structure for dt_function
-- ----------------------------
DROP TABLE IF EXISTS `dt_function`;
CREATE TABLE `dt_function` (
  `func_id` int(11) NOT NULL AUTO_INCREMENT,
  `func_name` varchar(50) NOT NULL,
  `func_key` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `func_fid` int(11) NOT NULL,
  PRIMARY KEY (`func_id`)
) ENGINE=InnoDB AUTO_INCREMENT=142 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dt_function
-- ----------------------------
INSERT INTO `dt_function` VALUES ('44', '系统管理', '', '0');
INSERT INTO `dt_function` VALUES ('45', '系统功能管理', 'Func', '44');
INSERT INTO `dt_function` VALUES ('121', '角色及角色功能管理', 'Role', '44');
INSERT INTO `dt_function` VALUES ('126', '用户及用户角色分配', 'User', '44');
INSERT INTO `dt_function` VALUES ('129', '教学管理', '', '0');
INSERT INTO `dt_function` VALUES ('130', '教室管理', 'Classroom', '129');
INSERT INTO `dt_function` VALUES ('131', '学生管理', 'Student', '129');
INSERT INTO `dt_function` VALUES ('134', '行政人事管理', '', '0');
INSERT INTO `dt_function` VALUES ('135', '人员管理', 'Staff', '134');
INSERT INTO `dt_function` VALUES ('138', '班级管理', 'Class', '129');
INSERT INTO `dt_function` VALUES ('139', '密码修改', 'ChangePwd', '0');

-- ----------------------------
-- Table structure for dt_role
-- ----------------------------
DROP TABLE IF EXISTS `dt_role`;
CREATE TABLE `dt_role` (
  `role_id` int(11) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(20) NOT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `uq_name` (`role_name`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dt_role
-- ----------------------------
INSERT INTO `dt_role` VALUES ('20', '学生');
INSERT INTO `dt_role` VALUES ('52', '彭于晏');
INSERT INTO `dt_role` VALUES ('56', '李云龙');
INSERT INTO `dt_role` VALUES ('54', '柳岩');
INSERT INTO `dt_role` VALUES ('50', '校长');
INSERT INTO `dt_role` VALUES ('35', '老师');

-- ----------------------------
-- Table structure for dt_role_function
-- ----------------------------
DROP TABLE IF EXISTS `dt_role_function`;
CREATE TABLE `dt_role_function` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `func_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_func_id` (`func_id`),
  KEY `fk_role_id` (`role_id`),
  CONSTRAINT `fk_func_id` FOREIGN KEY (`func_id`) REFERENCES `dt_function` (`func_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_role_id` FOREIGN KEY (`role_id`) REFERENCES `dt_role` (`role_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dt_role_function
-- ----------------------------
INSERT INTO `dt_role_function` VALUES ('59', '35', '129');
INSERT INTO `dt_role_function` VALUES ('60', '35', '130');
INSERT INTO `dt_role_function` VALUES ('61', '35', '131');
INSERT INTO `dt_role_function` VALUES ('62', '35', '139');
INSERT INTO `dt_role_function` VALUES ('63', '50', '129');
INSERT INTO `dt_role_function` VALUES ('64', '50', '130');
INSERT INTO `dt_role_function` VALUES ('65', '50', '131');
INSERT INTO `dt_role_function` VALUES ('66', '50', '138');
INSERT INTO `dt_role_function` VALUES ('67', '50', '134');
INSERT INTO `dt_role_function` VALUES ('68', '50', '135');
INSERT INTO `dt_role_function` VALUES ('69', '50', '139');
INSERT INTO `dt_role_function` VALUES ('70', '52', '139');

-- ----------------------------
-- Table structure for dt_staff
-- ----------------------------
DROP TABLE IF EXISTS `dt_staff`;
CREATE TABLE `dt_staff` (
  `stf_id` int(11) NOT NULL AUTO_INCREMENT,
  `stf_name` varchar(20) NOT NULL,
  `stf_category` int(11) NOT NULL,
  `stf_remark` varchar(255) DEFAULT NULL,
  `stf_invalid` int(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`stf_id`),
  KEY `fk_category` (`stf_category`),
  CONSTRAINT `fk_category` FOREIGN KEY (`stf_category`) REFERENCES `dt_dictionary` (`dic_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dt_staff
-- ----------------------------
INSERT INTO `dt_staff` VALUES ('11', '张五3', '7', '风一', '1');
INSERT INTO `dt_staff` VALUES ('12', '王五2', '5', '', '1');
INSERT INTO `dt_staff` VALUES ('13', '马六', '4', '', '1');
INSERT INTO `dt_staff` VALUES ('15', '小褚', '4', '669', '1');
INSERT INTO `dt_staff` VALUES ('16', '张8', '6', '123312', '1');
INSERT INTO `dt_staff` VALUES ('17', '康康', '6', '憨憨', '1');
INSERT INTO `dt_staff` VALUES ('18', '嚣张', '5', '12312312', '1');
INSERT INTO `dt_staff` VALUES ('22', '邱老师', '5', '', '1');
INSERT INTO `dt_staff` VALUES ('23', '小杨', '4', '调皮', '0');

-- ----------------------------
-- Table structure for dt_student
-- ----------------------------
DROP TABLE IF EXISTS `dt_student`;
CREATE TABLE `dt_student` (
  `stu_id` int(11) NOT NULL AUTO_INCREMENT,
  `stu_name` varchar(20) NOT NULL,
  `stu_avatar` varchar(255) DEFAULT NULL,
  `stu_cls_id` int(11) DEFAULT NULL,
  `stu_sex` int(1) NOT NULL,
  `stu_phone` varchar(11) NOT NULL,
  `stu_phone2` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `stu_born` varchar(10) NOT NULL,
  `stu_qualification` int(11) NOT NULL,
  `stu_school` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '',
  `stu_major` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '',
  `stu_address` varchar(100) NOT NULL,
  `stu_remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '',
  PRIMARY KEY (`stu_id`),
  KEY `fk_qualification` (`stu_qualification`),
  KEY `fk_cls_id` (`stu_cls_id`),
  CONSTRAINT `fk_cls_id` FOREIGN KEY (`stu_cls_id`) REFERENCES `dt_class` (`cls_id`),
  CONSTRAINT `fk_qualification` FOREIGN KEY (`stu_qualification`) REFERENCES `dt_dictionary` (`dic_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dt_student
-- ----------------------------
INSERT INTO `dt_student` VALUES ('19', '张三', null, '102', '1', '15999999999', '15999999999', '2006-01-11', '1', '高中', '计算机', '青岛', '');
INSERT INTO `dt_student` VALUES ('20', '李四', null, null, '2', '16988888888', '16988888888', '2021-01-19', '2', '大学', '', '背景', '');
INSERT INTO `dt_student` VALUES ('21', '王五', '/images/student/1611810986497.png', '102', '1', '13255555555', '13255555555', '2021-01-09', '1', '青岛大学', '', '上海', '');

-- ----------------------------
-- Table structure for dt_user
-- ----------------------------
DROP TABLE IF EXISTS `dt_user`;
CREATE TABLE `dt_user` (
  `user_name` varchar(20) NOT NULL,
  `user_pwd` varchar(20) NOT NULL,
  PRIMARY KEY (`user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dt_user
-- ----------------------------
INSERT INTO `dt_user` VALUES ('user2', '1234');
INSERT INTO `dt_user` VALUES ('user3', '123');
INSERT INTO `dt_user` VALUES ('user5', '12399');
INSERT INTO `dt_user` VALUES ('user7', '123');
INSERT INTO `dt_user` VALUES ('user8', '123');
INSERT INTO `dt_user` VALUES ('user9', '123');
INSERT INTO `dt_user` VALUES ('小七', '123444');
INSERT INTO `dt_user` VALUES ('小王', '666');
INSERT INTO `dt_user` VALUES ('康康', '123');

-- ----------------------------
-- Table structure for dt_user_role
-- ----------------------------
DROP TABLE IF EXISTS `dt_user_role`;
CREATE TABLE `dt_user_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(20) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_role_id2` (`role_id`),
  KEY `fk_user_name` (`user_name`),
  CONSTRAINT `fk_role_id2` FOREIGN KEY (`role_id`) REFERENCES `dt_role` (`role_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_name` FOREIGN KEY (`user_name`) REFERENCES `dt_user` (`user_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of dt_user_role
-- ----------------------------
INSERT INTO `dt_user_role` VALUES ('23', 'user3', '20');
INSERT INTO `dt_user_role` VALUES ('25', 'user8', '35');
INSERT INTO `dt_user_role` VALUES ('29', 'user7', '35');
INSERT INTO `dt_user_role` VALUES ('30', 'user5', '20');
INSERT INTO `dt_user_role` VALUES ('33', 'user2', '35');
INSERT INTO `dt_user_role` VALUES ('34', 'user9', '20');
INSERT INTO `dt_user_role` VALUES ('36', '小七', '50');
INSERT INTO `dt_user_role` VALUES ('42', '康康', '52');

-- ----------------------------
-- Procedure structure for p_changePwd
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_changePwd`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_changePwd`(
	_user_name varchar(20),
	oldPwd varchar(20),
	newPwd varchar(20)
)
BEGIN
	DECLARE result varchar(20) DEFAULT '原始密码错误';
	DECLARE temp int;
	
	SELECT count(*) INTO temp FROM dt_user WHERE user_name = _user_name AND user_pwd = oldPwd;
	IF temp != 0 THEN
		UPDATE dt_user SET user_pwd = newPwd WHERE user_name = _user_name;
		SET result = '';
	END IF;
	SELECT result;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for p_classBegin
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_classBegin`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_classBegin`(
	_cls_id int,
	_cls_clsr_id int
)
BEGIN
		UPDATE `dt_classroom` SET `clsr_occupy` = 1 WHERE `clsr_id` = _cls_clsr_id;
		SET @cur_date = date_format(now(), '%Y-%m-%d');
		UPDATE `dt_class` SET `cls_clsr_id` = _cls_clsr_id, `cls_begin` = @cur_date WHERE `cls_id` = _cls_id;
		SELECT @cur_date as result;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for p_classEnd
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_classEnd`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_classEnd`(
	_cls_id int
)
BEGIN
		UPDATE `dt_classroom` SET `clsr_occupy` = 0 
		WHERE `clsr_id` = (SELECT `cls_clsr_id` FROM `dt_class` WHERE `cls_id` = _cls_id);
		SET @cur_date = date_format(now(), '%Y-%m-%d');
		UPDATE `dt_class` SET `cls_end` = @cur_date WHERE `cls_id` = _cls_id;
		SELECT @cur_date as result;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for p_classRetrieve
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_classRetrieve`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_classRetrieve`(
	_cls_name varchar(20),		
	_cls_dic_id_major int,	
	_cls_status int,
	_begin int,								
  _pageSize int							
)
BEGIN
	SET @whereSql = 'WHERE 1 = 1';
	
	IF _cls_name != '' THEN 
		SET @whereSql = CONCAT(@whereSqL, ' AND cls_name LIKE ''%', _cls_name, '%''');
	END IF;

	IF _cls_dic_id_major != 0 THEN
		SET @whereSql = CONCAT(@whereSql, ' AND cls_dic_id_major = ', _cls_dic_id_major);
	END IF;

	-- SET @cur_date = date_format(now(), '%Y-%m-%d');

	IF _cls_status = 1 THEN					-- 查看开课中的班级
		SET @whereSql = CONCAT(@whereSql, ' AND cls_begin is not NULL AND cls_end is NULL');
	ELSEIF _cls_status = 2 THEN 		-- 查看未开课的班级
		SET @whereSql = CONCAT(@whereSql, ' AND cls_begin is NULL');
	ELSEIF _cls_status = 3 THEN			-- 查看结课的班级
		SET @whereSql = CONCAT(@whereSql, ' AND cls_end is not NULL');
	ELSE														-- 查看所有班级
		SET @whereSql = CONCAT(@whereSql, ' AND 1 = 1');
	END IF;

	SET @totalSql = CONCAT('SELECT count(*) as total FROM dt_class ', @whereSql);
	PREPARE totalStmt FROM @totalSql;
	EXECUTE totalStmt;
	DEALLOCATE PREPARE totalStmt;

			-- (SELECT stf_name from `dt_staff` where stf_id = cls_stf_id_teacher) as cls_stf_name_teacher, 
			-- (SELECT stf_name from `dt_staff` where stf_id = cls_stf_id_admin) as cls_stf_name_admin, 
			-- (SELECT stf_name from `dt_staff` where stf_id = cls_stf_id_job) as cls_stf_name_job
	SET @selectSql = 'SELECT *, 
		(select `stf_name` from `dt_staff` where `stf_id` = `cls_stf_id_teacher`) as `cls_stf_id_teacher_name`,
		(select `stf_name` from `dt_staff` where `stf_id` = `cls_stf_id_admin`) as `cls_stf_id_admin_name` ,
		(select `stf_name` from `dt_staff` where `stf_id` = `cls_stf_id_job`) as `cls_stf_id_job_name` 
		FROM dt_class ';
	SET @selectSql = CONCAT(@selectSql, @whereSql, ' LIMIT ', _begin, ',', _pageSize);

	PREPARE selectStmt FROM @selectSql;
	EXECUTE selectStmt;
	DEALLOCATE PREPARE selectStmt;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for p_classUpdate
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_classUpdate`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_classUpdate`(
	_cls_id int,	
	_cls_name varchar(20), 
	_cls_dic_id_major int, 
	_cls_clsr_id int, 
	_cls_stf_id_teacher int, 
	_cls_stf_id_admin int, 
	_cls_stf_id_job int, 
	_cls_begin varchar(10), 
	_cls_end varchar(10), 
	_cls_remark varchar(255)				
)
BEGIN
	DECLARE _cls_clsr_id_temp INT DEFAULT NULL; 
	IF _cls_clsr_id IS NOT NULL THEN
		SELECT cls_clsr_id INTO _cls_clsr_id_temp FROM dt_class WHERE cls_id = _cls_id;
	END IF;

	IF _cls_clsr_id_temp != _cls_clsr_id THEN
		UPDATE dt_classroom SET clsr_occupy = 0 WHERE clsr_id = _cls_clsr_id_temp;
		UPDATE dt_classroom SET clsr_occupy = 1 WHERE clsr_id = _cls_clsr_id;
	END IF;

	UPDATE dt_class 
	SET cls_name = _cls_name, 
			cls_dic_id_major = _cls_dic_id_major, 
			cls_clsr_id = _cls_clsr_id, 
			cls_stf_id_teacher = _cls_stf_id_teacher, 
			cls_stf_id_admin = _cls_stf_id_admin, 
			cls_stf_id_job = _cls_stf_id_job, 
			cls_begin = _cls_begin, 
			cls_end = _cls_end, 
			cls_remark = _cls_remark 
	WHERE cls_id = _cls_id;	
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for p_configRoleFunction
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_configRoleFunction`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_configRoleFunction`(
	_role_id int,							-- 角色的id
	_func_ids varchar(50)		-- 多个功能id连成的字符串
)
BEGIN
	DECLARE _func_id varchar(10) DEFAULT '';
	-- 先删除角色原有的所有功能
	DELETE FROM `dt_role_function` WHERE `role_id` = _role_id;
	-- 逐个添加角色新的关联功能
	SET _func_id = substring_index(_func_ids, ',', 1);
	WHILE LENGTH(_func_id) > 0 DO
			INSERT INTO `dt_role_function`(`role_id`,`func_id`) VALUES(_role_id, CONVERT(_func_id, SIGNED));
			SET _func_ids = substring(_func_ids, length(_func_id) + 2);
			SET _func_id = substring_index(_func_ids, ',', 1);
	END WHILE;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for p_configUserRole
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_configUserRole`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_configUserRole`(
	_user_name varchar(20),		-- 用户名
	_role_id int							-- 角色分类id
)
BEGIN
	DELETE FROM `dt_user_role` WHERE `user_name` = _user_name;
	IF _role_id != 0 THEN
		INSERT INTO `dt_user_role`(`user_name`, `role_id`) VALUES(_user_name, _role_id);
	END IF;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for p_getFunctionByRole
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_getFunctionByRole`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_getFunctionByRole`(
	_role_id int				-- 职位分类id
)
BEGIN
	IF _role_id = 0 THEN
		SELECT * FROM `dt_function`;
	ELSE
		SELECT T2.* 
		FROM (SELECT * FROM `dt_role_function` WHERE `role_id` = _role_id) T1 LEFT JOIN `dt_function` T2
		ON 	T1.func_id = T2.func_id;
	END IF;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for p_getUserMenu
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_getUserMenu`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_getUserMenu`(
	_user_name varchar(20)
)
BEGIN
		DECLARE _role_id INT DEFAULT 0;
    # 根据用户名找到用户的角色id
		SELECT role_id INTO _role_id FROM dt_user_role WHERE user_name = _user_name;
		# 根据用户角色id找到其角色可以使用的所有功能
		SELECT T2.*
    FROM (SELECT func_id FROM dt_role_function WHERE role_id = _role_id) T1 
		LEFT JOIN dt_function T2 
		ON T1.func_id = T2.func_id;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for p_staffRetrieve
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_staffRetrieve`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_staffRetrieve`(
	_stf_category int,				-- 职位分类id
	_stf_name varchar(20),		-- 员工检索名字
	_begin int,								-- limit的offset
  _pageSize int							-- limit的rows
)
BEGIN
	SET @whereSql = 'WHERE 1 = 1';
	IF _stf_category != 0 THEN
		SET @whereSql = CONCAT(@whereSql, ' AND T1.stf_category = ', _stf_category);
	END IF;
	IF _stf_name != '' THEN 
		SET @whereSql = CONCAT(@whereSqL, ' AND T1.stf_name LIKE ''%', _stf_name, '%''');
	END IF;

	SET @totalSql = CONCAT('SELECT count(*) as total FROM dt_staff T1 ', @whereSql);
	PREPARE totalStmt FROM @totalSql;
	EXECUTE totalStmt;
	DEALLOCATE PREPARE totalStmt;

	SET @selectSql = 'SELECT T1.* FROM dt_staff T1 ';
	
	SET @selectSql = CONCAT(@selectSql, @whereSql, ' LIMIT ', _begin, ',', _pageSize);

	PREPARE selectStmt FROM @selectSql;
	EXECUTE selectStmt;
	DEALLOCATE PREPARE selectStmt;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for p_studentRetrieve
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_studentRetrieve`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_studentRetrieve`(
	_stu_name varchar(20),		
	_stu_cls_id int,	
	_stu_qualification int,
	_begin int,								
  _pageSize int							
)
BEGIN
	SET @whereSql = 'WHERE 1 = 1';
	
	IF _stu_name != '' THEN 
		SET @whereSql = CONCAT(@whereSqL, ' AND stu_name LIKE ''%', _stu_name, '%''');
	END IF;

	IF _stu_cls_id = 0 THEN
		SET @whereSql = CONCAT(@whereSql, ' AND 1 = 1 ');
	ELSEIF _stu_cls_id IS NULL THEN
		SET @whereSql = CONCAT(@whereSql, ' AND stu_cls_id IS NULL ');
	ELSE
		SET @whereSql = CONCAT(@whereSql, ' AND stu_cls_id = ', _stu_cls_id);
	END IF;

	IF _stu_qualification != 0 THEN
		SET @whereSql = CONCAT(@whereSql, ' AND stu_qualification = ', _stu_qualification);
	END IF;

	SET @totalSql = CONCAT('SELECT count(*) as total FROM dt_student ', @whereSql);
	PREPARE totalStmt FROM @totalSql;
	EXECUTE totalStmt;
	DEALLOCATE PREPARE totalStmt;

	SET @selectSql = 'SELECT * FROM dt_student ';
	SET @selectSql = CONCAT(@selectSql, @whereSql, ' LIMIT ', _begin, ',', _pageSize);

	PREPARE selectStmt FROM @selectSql;
	EXECUTE selectStmt;
	DEALLOCATE PREPARE selectStmt;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for p_userRetrieve
-- ----------------------------
DROP PROCEDURE IF EXISTS `p_userRetrieve`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `p_userRetrieve`(
	_user_name varchar(20),		-- 用户检索名字
	_role_id int,							-- 角色id
	_begin int,								-- limit的offset
  _pageSize int							-- limit的rows
)
BEGIN
	SET @fromSql = ' FROM dt_user T1 LEFT JOIN dt_user_role T2 ON T1.user_name = T2.user_name ';

	SET @whereSql = 'WHERE 1 = 1';
	IF _user_name != '' THEN 
		SET @whereSql = CONCAT(@whereSqL, ' AND T1.user_name LIKE ''%', _user_name, '%''');
	END IF;

	IF _role_id > 0 THEN
		SET @whereSql = CONCAT(@whereSql, ' AND T2.role_id = ', _role_id);
	ELSEIF _role_id = 0  THEN
		SET @whereSql = CONCAT(@whereSql, ' AND T2.role_id is NULL ');
	END IF;

	SET @totalSql = CONCAT('SELECT count(*) as total', @fromSql, @whereSql);
	PREPARE totalStmt FROM @totalSql;
	EXECUTE totalStmt;
	DEALLOCATE PREPARE totalStmt;
	
	SET @selectSql = 'SELECT T1.*, T2.role_id';	
	SET @selectSql = CONCAT(@selectSql, @fromSql, @whereSql, ' LIMIT ', _begin, ',', _pageSize);
	PREPARE selectStmt FROM @selectSql;
	EXECUTE selectStmt;
	DEALLOCATE PREPARE selectStmt;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `t_afterinsert_on_student`;
DELIMITER ;;
CREATE TRIGGER `t_afterinsert_on_student` AFTER INSERT ON `dt_student` FOR EACH ROW BEGIN
     insert into dt_user(user_name,user_pwd) values(new.stu_phone, '123');
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `t_afterupdate_on_student`;
DELIMITER ;;
CREATE TRIGGER `t_afterupdate_on_student` AFTER UPDATE ON `dt_student` FOR EACH ROW BEGIN
        IF NEW.stu_phone != OLD.stu_phone THEN
              UPDATE dt_user SET user_name = NEW.stu_phone WHERE user_name = OLD.stu_phone;
        END IF;
END
;;
DELIMITER ;
