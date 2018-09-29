-- phpMyAdmin SQL Dump
-- version 4.4.15.10
-- https://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Sep 29, 2018 at 01:58 PM
-- Server version: 10.1.35-MariaDB
-- PHP Version: 5.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `moneymanager`
--

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE `account` (
  `account_id` int(10) unsigned NOT NULL,
  `account_name` varchar(255) NOT NULL,
  `account_type_id` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `accountCurrency` char(3) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `parentAccount` int(10) unsigned DEFAULT NULL,
  `balance` decimal(25,5) NOT NULL DEFAULT '0.00000',
  `last_reconciliation` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `account_properties`
--

CREATE TABLE `account_properties` (
  `account_id` int(10) unsigned NOT NULL,
  `property_name` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `property_value` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `account_properties_list`
--

CREATE TABLE `account_properties_list` (
  `property_name` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `default_value` text,
  `description` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `account_type`
--

CREATE TABLE `account_type` (
  `account_type_id` varchar(255) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `accout_type_name` text NOT NULL,
  `debit_label` varchar(255) NOT NULL,
  `credit_label` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `apiKeys`
--

CREATE TABLE `apiKeys` (
  `apiKey` char(86) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `userId` int(10) unsigned NOT NULL,
  `keyName` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `audit_log`
--

CREATE TABLE `audit_log` (
  `logID` bigint(20) unsigned NOT NULL,
  `TAG` varchar(200) COLLATE utf8_bin NOT NULL,
  `datetime` datetime NOT NULL,
  `message` text COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Table structure for table `currency`
--

CREATE TABLE `currency` (
  `currencyCode` char(3) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `currencyName` varchar(500) NOT NULL,
  `subUnitSize` decimal(8,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `currencyRate`
--

CREATE TABLE `currencyRate` (
  `currencyCode` char(3) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `updatedDate` datetime NOT NULL,
  `rate` decimal(12,4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `role`
--

CREATE TABLE `role` (
  `roleName` varchar(20) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `roleDescription` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `subRole`
--

CREATE TABLE `subRole` (
  `parentRole` varchar(20) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `childRole` varchar(20) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Table structure for table `Transaction`
--

CREATE TABLE `Transaction` (
  `transactionID` char(32) CHARACTER SET ascii NOT NULL,
  `account` int(10) unsigned DEFAULT NULL,
  `creditAmount` decimal(25,5) NOT NULL,
  `debitAmount` decimal(25,5) NOT NULL,
  `Description` text,
  `transactionDate` datetime DEFAULT NULL,
  `reconciliationStatus` char(1) DEFAULT 'N',
  `reconciliationDate` datetime NOT NULL,
  `currency` char(3) CHARACTER SET latin1 COLLATE latin1_general_ci DEFAULT NULL,
  `rate` decimal(12,4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `userId` int(10) unsigned NOT NULL,
  `userName` varchar(64) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL,
  `password` varchar(255) NOT NULL,
  `lastPasswordUpdate` datetime NOT NULL,
  `resetFlag` char(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `userRole`
--

CREATE TABLE `userRole` (
  `userId` int(10) unsigned NOT NULL,
  `roleName` varchar(20) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_account_properties`
--
CREATE TABLE `vw_account_properties` (
`account_id` int(10) unsigned
,`property_name` varchar(255)
,`property_value` mediumtext
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_current_currency_rate`
--
CREATE TABLE `vw_current_currency_rate` (
`currencyCode` char(3)
,`currencyName` varchar(500)
,`subUnitSize` decimal(8,0)
,`rate` decimal(12,4)
,`updatedDate` datetime
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_user_role`
--
CREATE TABLE `vw_user_role` (
`userId` int(11) unsigned
,`roleName` varchar(20)
);

-- --------------------------------------------------------

--
-- Structure for view `vw_account_properties`
--
DROP TABLE IF EXISTS `vw_account_properties`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_account_properties` AS select `a`.`account_id` AS `account_id`,`apl`.`property_name` AS `property_name`,ifnull(`ap`.`property_value`,`apl`.`default_value`) AS `property_value` from ((`account` `a` join `account_properties_list` `apl` on((1 = 1))) left join `account_properties` `ap` on(((`a`.`account_id` = `ap`.`account_id`) and (`apl`.`property_name` = `ap`.`property_name`))));

-- --------------------------------------------------------

--
-- Structure for view `vw_current_currency_rate`
--
DROP TABLE IF EXISTS `vw_current_currency_rate`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_current_currency_rate` AS select `c`.`currencyCode` AS `currencyCode`,`c`.`currencyName` AS `currencyName`,`c`.`subUnitSize` AS `subUnitSize`,`cr`.`rate` AS `rate`,`cr`.`updatedDate` AS `updatedDate` from (`currency` `c` left join `currencyRate` `cr` on((`c`.`currencyCode` = `cr`.`currencyCode`))) where ((`c`.`currencyCode`,`cr`.`updatedDate`) in (select `currencyRate`.`currencyCode`,max(`currencyRate`.`updatedDate`) from `currencyRate` group by `currencyRate`.`currencyCode`) or isnull(`cr`.`currencyCode`));

-- --------------------------------------------------------

--
-- Structure for view `vw_user_role`
--
DROP TABLE IF EXISTS `vw_user_role`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_user_role` AS select `userRole`.`userId` AS `userId`,`userRole`.`roleName` AS `roleName` from `userRole` union select distinct `ur`.`userId` AS `userId`,`sr`.`childRole` AS `childRole` from (`userRole` `ur` join `subRole` `sr` on((`ur`.`roleName` = `sr`.`parentRole`)));

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`account_id`),
  ADD KEY `accountCurrency` (`accountCurrency`),
  ADD KEY `parentAccount` (`parentAccount`),
  ADD KEY `account_type_id` (`account_type_id`);

--
-- Indexes for table `account_properties`
--
ALTER TABLE `account_properties`
  ADD PRIMARY KEY (`account_id`,`property_name`),
  ADD KEY `property_name` (`property_name`);

--
-- Indexes for table `account_properties_list`
--
ALTER TABLE `account_properties_list`
  ADD PRIMARY KEY (`property_name`);

--
-- Indexes for table `account_type`
--
ALTER TABLE `account_type`
  ADD PRIMARY KEY (`account_type_id`);

--
-- Indexes for table `apiKeys`
--
ALTER TABLE `apiKeys`
  ADD PRIMARY KEY (`apiKey`),
  ADD KEY `userId` (`userId`);

--
-- Indexes for table `audit_log`
--
ALTER TABLE `audit_log`
  ADD PRIMARY KEY (`logID`);

--
-- Indexes for table `currency`
--
ALTER TABLE `currency`
  ADD PRIMARY KEY (`currencyCode`);

--
-- Indexes for table `currencyRate`
--
ALTER TABLE `currencyRate`
  ADD PRIMARY KEY (`currencyCode`,`updatedDate`);

--
-- Indexes for table `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`roleName`);

--
-- Indexes for table `subRole`
--
ALTER TABLE `subRole`
  ADD PRIMARY KEY (`parentRole`,`childRole`),
  ADD KEY `childRole` (`childRole`);

--
-- Indexes for table `Transaction`
--
ALTER TABLE `Transaction`
  ADD PRIMARY KEY (`transactionID`),
  ADD KEY `account` (`account`),
  ADD KEY `currency` (`currency`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`userId`),
  ADD UNIQUE KEY `userName` (`userName`);

--
-- Indexes for table `userRole`
--
ALTER TABLE `userRole`
  ADD PRIMARY KEY (`userId`,`roleName`),
  ADD KEY `roleName` (`roleName`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account`
--
ALTER TABLE `account`
  MODIFY `account_id` int(10) unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `logID` bigint(20) unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `userId` int(10) unsigned NOT NULL AUTO_INCREMENT;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `account`
--
ALTER TABLE `account`
  ADD CONSTRAINT `account_ibfk_1` FOREIGN KEY (`accountCurrency`) REFERENCES `currency` (`currencyCode`) ON UPDATE CASCADE,
  ADD CONSTRAINT `account_ibfk_2` FOREIGN KEY (`parentAccount`) REFERENCES `account` (`account_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `account_ibfk_3` FOREIGN KEY (`account_type_id`) REFERENCES `account_type` (`account_type_id`) ON UPDATE CASCADE;

--
-- Constraints for table `account_properties`
--
ALTER TABLE `account_properties`
  ADD CONSTRAINT `account_properties_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `account` (`account_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `account_properties_ibfk_2` FOREIGN KEY (`property_name`) REFERENCES `account_properties_list` (`property_name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `apiKeys`
--
ALTER TABLE `apiKeys`
  ADD CONSTRAINT `apiKeys_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `user` (`userId`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `currencyRate`
--
ALTER TABLE `currencyRate`
  ADD CONSTRAINT `currencyRate_ibfk_1` FOREIGN KEY (`currencyCode`) REFERENCES `currency` (`currencyCode`) ON UPDATE CASCADE;

--
-- Constraints for table `subRole`
--
ALTER TABLE `subRole`
  ADD CONSTRAINT `subRole_ibfk_1` FOREIGN KEY (`parentRole`) REFERENCES `role` (`roleName`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `subRole_ibfk_2` FOREIGN KEY (`childRole`) REFERENCES `role` (`roleName`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Transaction`
--
ALTER TABLE `Transaction`
  ADD CONSTRAINT `Transaction_ibfk_1` FOREIGN KEY (`account`) REFERENCES `account` (`account_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `Transaction_ibfk_2` FOREIGN KEY (`currency`) REFERENCES `currency` (`currencyCode`);

--
-- Constraints for table `userRole`
--
ALTER TABLE `userRole`
  ADD CONSTRAINT `userRole_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `user` (`userId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `userRole_ibfk_2` FOREIGN KEY (`roleName`) REFERENCES `role` (`roleName`) ON UPDATE CASCADE;

