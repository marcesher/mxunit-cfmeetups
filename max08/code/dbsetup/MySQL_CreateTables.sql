DROP TABLE IF EXISTS `unittest`.`users`;
CREATE TABLE  `unittest`.`users` (
  `UserID` int(10) unsigned NOT NULL auto_increment,
  `FirstName` varchar(100) NOT NULL,
  `LastName` varchar(100) NOT NULL,
  `Username` varchar(15) default NULL,
  `Password` varchar(15) default NULL,
  PRIMARY KEY  (`UserID`)
) ENGINE=InnoDB 



DROP TABLE IF EXISTS `unittest`.`permissions`;
CREATE TABLE  `unittest`.`permissions` (
  `PermissionID` int(10) unsigned NOT NULL auto_increment,
  `PermissionName` varchar(100) NOT NULL,
  PRIMARY KEY  (`PermissionID`)
) ENGINE=InnoDB



DROP TABLE IF EXISTS `unittest`.`j_users_permissions`;
CREATE TABLE  `unittest`.`j_users_permissions` (
  `UserID` int(10) unsigned NOT NULL,
  `PermissionID` int(10) unsigned NOT NULL
) ENGINE=InnoDB