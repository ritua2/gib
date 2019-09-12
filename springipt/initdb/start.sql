

CREATE USER IF NOT EXISTS 'spring'@'localhost';
ALTER USER 'spring'@'localhost' IDENTIFIED WITH mysql_native_password BY 'spring';

CREATE DATABASE  IF NOT EXISTS `iptweb`;
GRANT ALL PRIVILEGES ON iptweb.* to 'spring'@'localhost';

use iptweb;

DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `tag` varchar(255) NOT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `lastUpdated` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `createdby` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS `reply`;
CREATE TABLE `reply` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `body` text NOT NULL,
  `tag` varchar(255) NOT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `lastUpdated` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `parentid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_comment_replies` (`parentid`),
  CONSTRAINT `fk_comment_replies` FOREIGN KEY (`parentid`) REFERENCES `comment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `name` varchar(500) NOT NULL,
  `institution` varchar(1000) NOT NULL,
  `country` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role` (
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `fk_user_role_roleid_idx` (`role_id`),
  CONSTRAINT `fk_user_role_roleid` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_role_userid` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `assignment`;	
CREATE TABLE `assignment` (
  `user` varchar(255) NOT NULL,
  `ip` varchar(255) NOT NULL,
  PRIMARY KEY (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS jobs;
CREATE TABLE jobs (
    id                      VARCHAR(255) UNIQUE NOT NULL, # UUID
    username                VARCHAR(255)        NOT NULL,
    compile_commands        VARCHAR(3000),
    run_commands            VARCHAR(3000),
    modules                 VARCHAR(3000)       NOT NULL,
    type                    VARCHAR(255)        NOT NULL,
    status                  VARCHAR(255)        NOT NULL,
    output_files            VARCHAR(1000)       NOT NULL,
    directory_location      VARCHAR(255)        NOT NULL,
    sc_system               VARCHAR(255),
    sc_queue                VARCHAR(255),
    n_cores                 INT,
    n_nodes                 INT,
    date_submitted          DATETIME,
    date_started            DATETIME,
    date_sc_upload          DATETIME,
    date_server_received    DATETIME,
    sc_execution_time       DOUBLE, # seconds
    submission_method       VARCHAR(255),
    notes_user              VARCHAR(255),
    notes_sc                VARCHAR(255),
    notes_server            VARCHAR(255),
    error                   VARCHAR(255),

    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `iptweb`.`role` (`id`, `name`) VALUES (1, 'ROLE_USER');
INSERT INTO `iptweb`.`role` (`id`, `name`) VALUES (2, 'ROLE_ADMIN');


# Adds column to user table
ALTER TABLE user ADD COLUMN email VARCHAR(255);

# Email validation table
CREATE TABLE prevalidation (
    id                      int(11)      UNIQUE NOT NULL,
    username                VARCHAR(255)        NOT NULL,
    password                VARCHAR(255),
    email                   VARCHAR(255),
    validation_key          VARCHAR(255),

    PRIMARY KEY (id)
);
