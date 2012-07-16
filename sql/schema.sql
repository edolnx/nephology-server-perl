--
-- Table structure for table `caste`
--

DROP TABLE IF EXISTS `caste`;
CREATE TABLE `caste` (
  `id` int(11) NOT NULL,
  `ctime` datetime NOT NULL,
  `mtime` datetime NOT NULL,
  `description` varchar(200) NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `caste_rule`
--

DROP TABLE IF EXISTS `caste_rule`;
CREATE TABLE `caste_rule` (
  `id` int(11) NOT NULL,
  `ctime` datetime NOT NULL,
  `mtime` datetime NOT NULL,
  `description` varchar(200) NOT NULL,
  `url` varchar(200) NOT NULL,
  `template` varchar(200) NOT NULL,
  `type_id` int(11) NOT NULL,
  UNIQUE KEY `id` (`id`),
  KEY `caste_id` (`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `map_caste_rule`
--

DROP TABLE IF EXISTS `map_caste_rule`;
CREATE TABLE `map_caste_rule` (
  `caste_id` int(11) NOT NULL,
  `caste_rule_id` int(11) NOT NULL,
  `ctime` datetime NOT NULL,
  `mtime` datetime NOT NULL,
  `priority` int(11) NOT NULL,
  KEY `caste_id` (`caste_id`,`caste_rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `node`
--

DROP TABLE IF EXISTS `node`;
CREATE TABLE `node` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ctime` datetime NOT NULL,
  `mtime` datetime NOT NULL,
  `asset_tag` varchar(10) NOT NULL,
  `hostname` varchar(50) DEFAULT NULL,
  `boot_mac` varchar(20) NOT NULL,
  `admin_user` varchar(20) NOT NULL,
  `admin_password` varchar(100) NOT NULL,
  `ipmi_user` varchar(20) NOT NULL,
  `ipmi_password` varchar(100) NOT NULL,
  `caste_id` int(11) NOT NULL,
  `status_id` int(11) NOT NULL DEFAULT '1',
  `domain` varchar(50) NOT NULL,
  `primary_ip` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `status_id` (`status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `node_status`
--

DROP TABLE IF EXISTS `node_status`;
CREATE TABLE `node_status` (
  `ctime` datetime NOT NULL,
  `mtime` datetime NOT NULL,
  `status_id` int(11) NOT NULL,
  `template` varchar(45) NOT NULL,
  `next_status` int(11) DEFAULT NULL,
  KEY `status_id` (`status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `ref_caste_rule_type`
--

DROP TABLE IF EXISTS `ref_caste_rule_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ref_caste_rule_type` (
  `id` int(11) NOT NULL,
  `ctime` datetime NOT NULL,
  `mtime` datetime NOT NULL,
  `description` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Table structure for table `ref_status`
--

DROP TABLE IF EXISTS `ref_status`;
CREATE TABLE `ref_status` (
  `id` int(11) NOT NULL,
  `mtime` datetime NOT NULL,
  `ctime` datetime NOT NULL,
  `description` varchar(200) NOT NULL,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
