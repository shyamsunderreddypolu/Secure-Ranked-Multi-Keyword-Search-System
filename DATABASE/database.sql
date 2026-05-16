# Formatted MySQL Database SQL File

```sql


CREATE DATABASE IF NOT EXISTS `genricpks-2024`
DEFAULT CHARACTER SET latin1;

USE `genricpks-2024`;

-- --------------------------------------------------------
-- Table structure for `equality`
-- --------------------------------------------------------

DROP TABLE IF EXISTS `equality`;

CREATE TABLE `equality` (
    `Rid` VARCHAR(11) DEFAULT NULL,
    `Uid` VARCHAR(255) DEFAULT NULL,
    `Fid` VARCHAR(255) DEFAULT NULL,
    `Tkey` VARCHAR(255) DEFAULT NULL,
    `Status` VARCHAR(255) DEFAULT NULL,
    `recid` VARCHAR(266) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `equality`
(`Rid`, `Uid`, `Fid`, `Tkey`, `Status`, `recid`)
VALUES
('1', 'aaa@gmail.com', '1', '65V23gddb1VfWlbY', 'Verified', 'bb@gmail.com'),
('2', 'aaa@gmail.com', '1', '65V23gddb1VfWlbY', 'Verified', 'dd@gmail.com');

-- --------------------------------------------------------
-- Table structure for `keygen`
-- --------------------------------------------------------

DROP TABLE IF EXISTS `keygen`;

CREATE TABLE `keygen` (
    `sk` VARCHAR(255) DEFAULT NULL,
    `mk` VARCHAR(255) DEFAULT NULL,
    `uid` VARCHAR(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `keygen`
(`sk`, `mk`, `uid`)
VALUES
('202hz9h', 'da869u5', 'aaa@gmail.com');

-- --------------------------------------------------------
-- Table structure for `owner`
-- --------------------------------------------------------

DROP TABLE IF EXISTS `owner`;

CREATE TABLE `owner` (
    `Name` VARCHAR(255) DEFAULT NULL,
    `Email` VARCHAR(255) DEFAULT NULL,
    `Age` VARCHAR(255) DEFAULT NULL,
    `Password` VARCHAR(255) DEFAULT NULL,
    `Mobile` VARCHAR(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `owner`
(`Name`, `Email`, `Age`, `Password`, `Mobile`)
VALUES
('aaa', 'aaa@gmail.com', '23', 'Pass@123', '8989789079');

-- --------------------------------------------------------
-- Table structure for `request`
-- --------------------------------------------------------

DROP TABLE IF EXISTS `request`;

CREATE TABLE `request` (
    `Rid` INT(11) NOT NULL AUTO_INCREMENT,
    `uid` VARCHAR(255) DEFAULT NULL,
    `fid` VARCHAR(255) DEFAULT NULL,
    `Receiver` VARCHAR(1000) DEFAULT NULL,
    `Status` VARCHAR(255) DEFAULT NULL,
    UNIQUE KEY `Rid` (`Rid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

INSERT INTO `request`
(`Rid`, `uid`, `fid`, `Receiver`, `Status`)
VALUES
(1, 'aaa@gmail.com', '1', 'bb@gmail.com', 'Search request'),
(2, 'aaa@gmail.com', '1', 'dd@gmail.com', 'Search request');

-- --------------------------------------------------------
-- Table structure for `response`
-- --------------------------------------------------------

DROP TABLE IF EXISTS `response`;

CREATE TABLE `response` (
    `Rid` VARCHAR(11) NOT NULL,
    `uid` VARCHAR(255) DEFAULT NULL,
    `fid` VARCHAR(255) DEFAULT NULL,
    `TKey` VARCHAR(255) DEFAULT NULL,
    `recid` VARCHAR(1000) DEFAULT NULL,
    PRIMARY KEY (`Rid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `response`
(`Rid`, `uid`, `fid`, `TKey`, `recid`)
VALUES
('1', 'aaa@gmail.com', '1', '65V23gddb1VfWlbY', 'bb@gmail.com'),
('2', 'aaa@gmail.com', '1', '65V23gddb1VfWlbY', 'dd@gmail.com');

-- --------------------------------------------------------
-- Table structure for `trapdoor`
-- --------------------------------------------------------

DROP TABLE IF EXISTS `trapdoor`;

CREATE TABLE `trapdoor` (
    `name` VARCHAR(255) DEFAULT NULL,
    `uid` VARCHAR(255) DEFAULT NULL,
    `trap` VARCHAR(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------
-- Table structure for `upload`
-- --------------------------------------------------------

DROP TABLE IF EXISTS `upload`;

CREATE TABLE `upload` (
    `Fid` INT(11) NOT NULL AUTO_INCREMENT,
    `Email` VARCHAR(255) DEFAULT NULL,
    `Filename` VARCHAR(255) DEFAULT NULL,
    `Photo` LONGBLOB,
    `Label` VARCHAR(255) DEFAULT NULL,
    `Enc` LONGTEXT,
    `Content` VARCHAR(255) DEFAULT NULL,
    `Tkey` VARCHAR(255) DEFAULT NULL,
    `stringcontent` LONGTEXT,
    PRIMARY KEY (`Fid`),
    UNIQUE KEY `Fid` (`Fid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

INSERT INTO `upload`
(`Fid`, `Email`, `Filename`, `Photo`, `Label`, `Enc`, `Content`, `Tkey`, `stringcontent`)
VALUES
(
    1,
    'aaa@gmail.com',
    'sample.txt',
    NULL,
    'Confidential',
    'EncryptedDataExample',
    'Original file content',
    '65V23gddb1VfWlbY',
    'String content example'
);

-- --------------------------------------------------------
-- Table structure for `user`
-- --------------------------------------------------------

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
    `Name` VARCHAR(255) DEFAULT NULL,
    `Email` VARCHAR(255) DEFAULT NULL,
    `Age` VARCHAR(255) DEFAULT NULL,
    `Password` VARCHAR(255) DEFAULT NULL,
    `Mobile` VARCHAR(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `user`
(`Name`, `Email`, `Age`, `Password`, `Mobile`)
VALUES
('bbb', 'bb@gmail.com', '22', 'Pass@123', '9876543211'),
('ddd', 'dd@gmail.com', '23', 'Pass@123', '9876543214');

-- --------------------------------------------------------
-- SQL Settings Restore
-- --------------------------------------------------------

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
```

You can now copy and paste this formatted SQL into a new `.sql` file.

continue
