-- ============================================================
--  SecureRank — Secure Ranked Multi-Keyword Search System
--              over Encrypted Cloud Data
--
--  Database : securerank_db
--  Project  :  SecureRank-Cloud-Dynamic-Multi-Keyword-Search-over-Encrypted-Data
--  Version  : 2.0 
--
--  System Roles:
--    DO  = Data Owner       — encrypts and uploads files
--    DC  = Data Consumer    — searches and downloads files
--    PKG = Private Key Gen  — issues keys to DO and DC
--    CS  = Cloud Server / Admin — manages users, monitors system
--    SCP = Secure Coprocessor  — verifies Boolean match & ranks
--
--  Tables:
--    1. doregister   — Data Owner accounts        (DO)
--    2. dcregister   — Data Consumer accounts     (DC)
--    3. cloudserver  — Admin / Cloud Server login  (CS)
--    4. pkg          — Private Key Generator login (PKG)
--    5. upload       — Encrypted files uploaded by DO
--    6. keygen       — Secret/master keys issued by PKG
--    7. trapdoor     — Encrypted search queries from DC
--    8. request      — DC file access requests
--    9. response     — Cloud Server ranked search results
--   10. equality     — SCP Boolean equality verification
--
--  Import : mysql -u root -proot securerank_db < securerank_database.sql
--  JDBC   : jdbc:mysql://localhost:3306/securerank_db
-- ============================================================

CREATE DATABASE IF NOT EXISTS `securerank_db`
  DEFAULT CHARACTER SET utf8
  DEFAULT COLLATE utf8_general_ci;

USE `securerank_db`;


-- ============================================================
-- 1. DOREGISTER  (Data Owner accounts)
--    DO registers here. Admin sets status1='Approved' to allow login.
--    Servlet reference: DOLogin.java, RegisterServlet.java
-- ============================================================

DROP TABLE IF EXISTS `doregister`;

CREATE TABLE `doregister` (
    `id`       INT(11)      NOT NULL AUTO_INCREMENT COMMENT 'Auto-increment ID',
    `name`     VARCHAR(255) DEFAULT NULL             COMMENT 'Full name of Data Owner',
    `email`    VARCHAR(255) DEFAULT NULL             COMMENT 'Login email (unique)',
    `password` VARCHAR(255) DEFAULT NULL             COMMENT 'Login password',
    `mobile`   VARCHAR(15)  DEFAULT NULL             COMMENT 'Contact number',
    `address`  VARCHAR(500) DEFAULT NULL             COMMENT 'Address',
    `status1`  VARCHAR(50)  DEFAULT 'Pending'        COMMENT 'Pending → Approved by Admin',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_do_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `doregister` (`name`, `email`, `password`, `mobile`, `address`, `status1`)
VALUES
  ('Alice Thomas', 'alice@securerank.com', 'Alice@123', '9876500001', 'Hyderabad, Telangana', 'Approved'),
  ('Ravi Kumar',   'ravi@securerank.com',  'Ravi@123',  '9876500004', 'Warangal, Telangana',  'Pending');


-- ============================================================
-- 2. DCREGISTER  (Data Consumer accounts)
--    DC registers here. Admin sets status='Approved' to allow login.
--    Servlet reference: DCLogin.java, RegisterServlet.java
-- ============================================================

DROP TABLE IF EXISTS `dcregister`;

CREATE TABLE `dcregister` (
    `id`       INT(11)      NOT NULL AUTO_INCREMENT COMMENT 'Auto-increment ID',
    `name`     VARCHAR(255) DEFAULT NULL             COMMENT 'Full name of Data Consumer',
    `email`    VARCHAR(255) DEFAULT NULL             COMMENT 'Login email (unique)',
    `password` VARCHAR(255) DEFAULT NULL             COMMENT 'Login password',
    `mobile`   VARCHAR(15)  DEFAULT NULL             COMMENT 'Contact number',
    `address`  VARCHAR(500) DEFAULT NULL             COMMENT 'Address',
    `status`   VARCHAR(50)  DEFAULT 'Pending'        COMMENT 'Pending → Approved by Admin',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_dc_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `dcregister` (`name`, `email`, `password`, `mobile`, `address`, `status`)
VALUES
  ('Bob Kumar',   'bob@securerank.com',    'Bob@123',    '9876500002', 'Bangalore, Karnataka', 'Approved'),
  ('Diana Reddy', 'diana@securerank.com',  'Diana@123',  '9876500003', 'Chennai, Tamil Nadu',  'Approved'),
  ('Suresh Naik', 'suresh@securerank.com', 'Suresh@123', '9876500005', 'Pune, Maharashtra',    'Pending');


-- ============================================================
-- 3. CLOUDSERVER  (Admin / Cloud Server login)
--    The CS admin approves users and monitors the entire system.
--    Servlet reference: CSLogin.java
-- ============================================================

DROP TABLE IF EXISTS `cloudserver`;

CREATE TABLE `cloudserver` (
    `id`       INT(11)      NOT NULL AUTO_INCREMENT COMMENT 'Auto-increment ID',
    `name`     VARCHAR(255) DEFAULT NULL             COMMENT 'Admin name',
    `email`    VARCHAR(255) DEFAULT NULL             COMMENT 'Admin login email',
    `password` VARCHAR(255) DEFAULT NULL             COMMENT 'Admin login password',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_cs_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `cloudserver` (`name`, `email`, `password`)
VALUES ('Admin', 'admin@securerank.com', 'admin123');


-- ============================================================
-- 4. PKG  (Private Key Generator login)
--    PKG generates and distributes cryptographic keys to DO and DC.
--    Servlet reference: PKGLogin.java, GeneratePKDC.java
-- ============================================================

DROP TABLE IF EXISTS `pkg`;

CREATE TABLE `pkg` (
    `id`       INT(11)      NOT NULL AUTO_INCREMENT COMMENT 'Auto-increment ID',
    `name`     VARCHAR(255) DEFAULT NULL             COMMENT 'PKG admin name',
    `email`    VARCHAR(255) DEFAULT NULL             COMMENT 'PKG login email',
    `password` VARCHAR(255) DEFAULT NULL             COMMENT 'PKG login password',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_pkg_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `pkg` (`name`, `email`, `password`)
VALUES ('PKG Admin', 'pkg@securerank.com', 'pkg123');


-- ============================================================
-- 5. UPLOAD  (Encrypted files stored by Data Owner)
--    Each row = one encrypted file uploaded by a DO.
--    - Photo         : raw file bytes (BLOB)
--    - Enc           : encrypted file content (GM/Paillier algorithm)
--    - Tkey          : trapdoor key for keyword index matching
--    - stringcontent : TF-IDF encrypted keyword index vector
--    Servlet reference: UploadFile.java
-- ============================================================

DROP TABLE IF EXISTS `upload`;

CREATE TABLE `upload` (
    `Fid`           INT(11)      NOT NULL AUTO_INCREMENT COMMENT 'File ID (primary key)',
    `Email`         VARCHAR(255) DEFAULT NULL            COMMENT 'DO email who uploaded this file',
    `Filename`      VARCHAR(255) DEFAULT NULL            COMMENT 'Original file name',
    `Photo`         LONGBLOB                             COMMENT 'Raw file bytes',
    `Label`         VARCHAR(255) DEFAULT NULL            COMMENT 'File classification label',
    `Enc`           LONGTEXT                             COMMENT 'GM/Paillier encrypted file content',
    `Content`       VARCHAR(255) DEFAULT NULL            COMMENT 'Original plaintext summary',
    `Tkey`          VARCHAR(255) DEFAULT NULL            COMMENT 'Trapdoor key for index matching',
    `stringcontent` LONGTEXT                             COMMENT 'TF-IDF encrypted keyword index vector',
    PRIMARY KEY (`Fid`),
    UNIQUE KEY `uq_fid` (`Fid`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

INSERT INTO `upload` (`Email`, `Filename`, `Photo`, `Label`, `Enc`, `Content`, `Tkey`, `stringcontent`)
VALUES (
  'alice@securerank.com',
  'medical_report.txt',
  NULL,
  'Confidential',
  'GM_ENCRYPTED_CONTENT_EXAMPLE_XYZ123',
  'Patient medical records Q1 2024',
  '65V23gddb1VfWlbY',
  'TFIDF_ENCRYPTED_KEYWORD_VECTOR_INDEX'
);


-- ============================================================
-- 6. KEYGEN  (Cryptographic keys generated by PKG)
--    - sk  : secret key issued to the user (DO or DC)
--    - mk  : PKG master key used to derive secret keys
--    - uid : email of the user this key belongs to
--    Servlet reference: GeneratePKDC.java
-- ============================================================

DROP TABLE IF EXISTS `keygen`;

CREATE TABLE `keygen` (
    `id`  INT(11)      NOT NULL AUTO_INCREMENT COMMENT 'Auto-increment ID',
    `sk`  VARCHAR(255) DEFAULT NULL            COMMENT 'Secret key issued to user',
    `mk`  VARCHAR(255) DEFAULT NULL            COMMENT 'PKG master key',
    `uid` VARCHAR(255) DEFAULT NULL            COMMENT 'Email of key recipient (DO or DC)',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `keygen` (`sk`, `mk`, `uid`)
VALUES ('202hz9h_SECRET', 'da869u5_MASTER', 'alice@securerank.com');


-- ============================================================
-- 7. TRAPDOOR  (Encrypted search queries from Data Consumer)
--    A trapdoor = an encrypted form of a keyword.
--    The cloud server uses it to search the index
--    without ever seeing the actual keyword plaintext.
--    Servlet reference: GenerateTrapdoor.java
-- ============================================================

DROP TABLE IF EXISTS `trapdoor`;

CREATE TABLE `trapdoor` (
    `id`   INT(11)      NOT NULL AUTO_INCREMENT COMMENT 'Auto-increment ID',
    `name` VARCHAR(255) DEFAULT NULL            COMMENT 'Keyword name (DC reference only)',
    `uid`  VARCHAR(255) DEFAULT NULL            COMMENT 'DC email who generated this trapdoor',
    `trap` VARCHAR(255) DEFAULT NULL            COMMENT 'Encrypted trapdoor value sent to cloud',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Populated at runtime when DC submits a search query


-- ============================================================
-- 8. REQUEST  (DC file access requests to Cloud Server)
--    DC sends a search request for a specific file.
--    Status: 'Search Request' → processed by CS
--    Servlet reference: SendRequest.java
-- ============================================================

DROP TABLE IF EXISTS `request`;

CREATE TABLE `request` (
    `Rid`      INT(11)       NOT NULL AUTO_INCREMENT COMMENT 'Request ID',
    `uid`      VARCHAR(255)  DEFAULT NULL            COMMENT 'DO email (owner of the file)',
    `fid`      VARCHAR(255)  DEFAULT NULL            COMMENT 'File ID being requested',
    `Receiver` VARCHAR(1000) DEFAULT NULL            COMMENT 'DC email making the request',
    `Status`   VARCHAR(255)  DEFAULT 'Search Request' COMMENT 'Current request status',
    UNIQUE KEY `uq_rid` (`Rid`),
    PRIMARY KEY (`Rid`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

INSERT INTO `request` (`uid`, `fid`, `Receiver`, `Status`)
VALUES
  ('alice@securerank.com', '1', 'bob@securerank.com',   'Search Request'),
  ('alice@securerank.com', '1', 'diana@securerank.com', 'Search Request');


-- ============================================================
-- 9. RESPONSE  (Cloud Server ranked search results)
--    Cloud Server stores matched file + trapdoor key here.
--    DC retrieves this to download the correct encrypted file.
--    Servlet reference: SearchFile.java
-- ============================================================

DROP TABLE IF EXISTS `response`;

CREATE TABLE `response` (
    `Rid`   VARCHAR(11)   NOT NULL COMMENT 'Response ID',
    `uid`   VARCHAR(255)  DEFAULT NULL COMMENT 'DO email (owner of matched file)',
    `fid`   VARCHAR(255)  DEFAULT NULL COMMENT 'Matched file ID',
    `TKey`  VARCHAR(255)  DEFAULT NULL COMMENT 'Trapdoor key used for matching',
    `recid` VARCHAR(1000) DEFAULT NULL COMMENT 'DC email receiving this result',
    PRIMARY KEY (`Rid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `response` (`Rid`, `uid`, `fid`, `TKey`, `recid`)
VALUES
  ('1', 'alice@securerank.com', '1', '65V23gddb1VfWlbY', 'bob@securerank.com'),
  ('2', 'alice@securerank.com', '1', '65V23gddb1VfWlbY', 'diana@securerank.com');


-- ============================================================
-- 10. EQUALITY  (SCP Boolean equality verification)
--     Secure Coprocessor verifies that the DC trapdoor matches
--     the file's stored trapdoor — confirming Boolean keyword match.
--     Status: 'Pending' → 'Verified'
--     Servlet reference: VerifyEquality.java
-- ============================================================

DROP TABLE IF EXISTS `equality`;

CREATE TABLE `equality` (
    `Rid`    VARCHAR(11)  DEFAULT NULL COMMENT 'Verification record ID',
    `Uid`    VARCHAR(255) DEFAULT NULL COMMENT 'DO email (file owner)',
    `Fid`    VARCHAR(255) DEFAULT NULL COMMENT 'File ID being verified',
    `Tkey`   VARCHAR(255) DEFAULT NULL COMMENT 'Trapdoor key used for verification',
    `Status` VARCHAR(255) DEFAULT NULL COMMENT 'Pending → Verified',
    `recid`  VARCHAR(266) DEFAULT NULL COMMENT 'DC email being verified'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `equality` (`Rid`, `Uid`, `Fid`, `Tkey`, `Status`, `recid`)
VALUES
  ('1', 'alice@securerank.com', '1', '65V23gddb1VfWlbY', 'Verified', 'bob@securerank.com'),
  ('2', 'alice@securerank.com', '1', '65V23gddb1VfWlbY', 'Verified', 'diana@securerank.com');


-- ============================================================
-- END OF securerank_db SCHEMA
--
--  Test Login Credentials:
--  ┌─────────────────┬─────────────────────────────┬───────────┐
--  │ Role            │ Email                       │ Password  │
--  ├─────────────────┼─────────────────────────────┼───────────┤
--  │ Admin (CS)      │ admin@securerank.com         │ admin123  │
--  │ Data Owner (DO) │ alice@securerank.com         │ Alice@123 │
--  │ Data Consumer   │ bob@securerank.com           │ Bob@123   │
--  │ PKG             │ pkg@securerank.com           │ pkg123    │
--  └─────────────────┴─────────────────────────────┴───────────┘
-- ============================================================


-- ============================================================
-- 11. STORE  (File master keys stored by Data Owner)
--     Holds the master key (mk) for each uploaded file.
--     PKG reads from here to send mk to DC via SendKeysToDC.
--     Servlet reference: UploadFile.java, SendKeysToDC.java
-- ============================================================

DROP TABLE IF EXISTS `store`;

CREATE TABLE `store` (
    `id`  INT(11)      NOT NULL AUTO_INCREMENT COMMENT 'Auto ID',
    `fid` VARCHAR(255) DEFAULT NULL            COMMENT 'File ID from upload table',
    `mk`  VARCHAR(255) DEFAULT NULL            COMMENT 'Master key for this file',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `store` (`fid`, `mk`)
VALUES ('1', 'da869u5_MASTER');


-- ============================================================
-- 12. UKEYS  (Master keys sent by PKG to Data Consumers)
--     Records which DC received which file's master key.
--     Used to prevent duplicate key sending.
--     Servlet reference: SendKeysToDC.java
-- ============================================================

DROP TABLE IF EXISTS `ukeys`;

CREATE TABLE `ukeys` (
    `fid`  VARCHAR(255) DEFAULT NULL COMMENT 'File ID',
    `doid` VARCHAR(255) DEFAULT NULL COMMENT 'Data Owner email',
    `uid`  VARCHAR(255) DEFAULT NULL COMMENT 'Data Consumer email (key recipient)',
    `key1` VARCHAR(255) DEFAULT NULL COMMENT 'Master key value sent to DC'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- ============================================================
-- 13. KEYREQ  (Decryption key requests from Data Consumers)
--     Records DC requests for master key access to specific files.
--     Status: 'Pending' → 'Approved' (approved by Admin)
--     Servlet reference: DCDecryptRequest.java
-- ============================================================

DROP TABLE IF EXISTS `keyreq`;

CREATE TABLE `keyreq` (
    `id`      INT(11)      NOT NULL AUTO_INCREMENT COMMENT 'Auto-increment ID',
    `uid`     VARCHAR(255) DEFAULT NULL            COMMENT 'DC email making request',
    `fid`     VARCHAR(255) DEFAULT NULL            COMMENT 'File ID being requested',
    `status1` VARCHAR(50)  DEFAULT 'Pending'       COMMENT 'Approval status',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `keyreq` (`uid`, `fid`, `status1`) VALUES
  ('bob@securerank.com', '1', 'Approved'),
  ('diana@securerank.com', '1', 'Pending');


