

-- MySQL Workbench Synchronization
-- Generated: 2017-06-18 16:33
-- Model: New Model
-- Version: 1.0
-- Project: DwD Assignment 04 Post Module
-- Author: Shameka Brayton

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `DwDAssign04Pt1` DEFAULT CHARACTER SET utf8 ;

SET FOREIGN_KEY_CHECKS = 1;

/*
to assist with normalization, I am putting the redundant location fields in a seperate table
also, if in the furtur some other table needs to have a location defined
*/
CREATE TABLE IF NOT EXISTS `DwDAssign04Pt1`.`Location`(
idLoc INT NOT NULL AUTO_INCREMENT
,City char(128) NOT NULL
,State char(5)
,Country char(128) NOT NULL
,zipcode int
,CONSTRAINT uc_cityStateCountry UNIQUE (City,State,Country,zipcode)
,PRIMARY KEY (`idLoc`)
)ENGINE=INNODB;

/*
1.	I am setting the payment type not as a bit, since in the future, someother form of payment could crop up
2.	Since mysql does not recognize check constraints to ensure the proper values are within
	a column, I added a table to hold payment type, forcing the input in the employee table to the 
	required values 
*/

CREATE TABLE IF NOT EXISTS `DwDAssign04Pt1`.`PaymentType`(
idPtype char(2) NOT NULL 
,PaymentType char(25) NOT NULL
,CONSTRAINT uc_payment UNIQUE (PaymentType)
,PRIMARY KEY (`idPtype`)
)ENGINE=INNODB;
/*here I am enacting an automatic insert of the payment types available now, so that when the db is created
they will exist in advance
*/
INSERT INTO `DwDAssign04Pt1`.`PaymentType`(`idPtype`,`PaymentType`)
VALUES("DD","Direct Deposit"),("PC","Paper Check");

/*
I put a unique constraint on the employee name and address to reduce the possibility of duplicates
*/
CREATE TABLE IF NOT EXISTS `DwDAssign04Pt1`.`employees`(
idemployee INT NOT NULL AUTO_INCREMENT
,FirstName char(128) NOT NULL
,LastName char(128) NOT NULL
,StreetAddress char(128) NOT NULL
,idPtype char(2) NOT NULL
,idLoc INT NOT NULL
,	PRIMARY KEY (`idEmployee`)
,	INDEX locEmpl_IDX (idLoc)
,	CONSTRAINT uc_empNameAddr UNIQUE (FirstName,LastName,StreetAddress)
,  	CONSTRAINT `fk_location_employee`
	    FOREIGN KEY (`idLoc`)
	    REFERENCES `DwDAssign04Pt1`.`Location` (`idLoc`)
	    ON DELETE NO ACTION
	    ON UPDATE NO ACTION
,  	CONSTRAINT `fk_PaymentType`
	    FOREIGN KEY (`idPtype`)
	    REFERENCES `DwDAssign04Pt1`.`PaymentType` (`idPtype`)
	    ON DELETE NO ACTION
	    ON UPDATE NO ACTION    
)ENGINE=INNODB;

/*
1. I put a fk on supervised employee id to ensure that the supervised employee exists in the employee table
2. I put a Unique constraint on the supervised employee to make sure he can only have one manager.
*/
CREATE TABLE IF NOT EXISTS `DwDAssign04Pt1`.`management`(
idMgr INT NOT NULL 
,idSupEmployee INT NOT NULL
,PRIMARY KEY (`idMgr`,`idSupEmployee`)
,CONSTRAINT uc_supervised UNIQUE (idSupEmployee)
,  CONSTRAINT `fk_mgr_employee`
    FOREIGN KEY (`idMgr`)
    REFERENCES `DwDAssign04Pt1`.`employees` (`idemployee`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION

,  CONSTRAINT `fk_supervised_employee`
    FOREIGN KEY (`idSupEmployee`)
    REFERENCES `DwDAssign04Pt1`.`employees` (`idemployee`)
     ON DELETE CASCADE
    ON UPDATE NO ACTION  

)ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS `DwDAssign04Pt1`.`timeCardStatus`(
idstatType TINYINT NOT NULL AUTO_INCREMENT
,Status char(25) NOT NULL
,CONSTRAINT uc_payment UNIQUE (Status)
,PRIMARY KEY (`idstatType`)
)ENGINE=INNODB;
/*here I am enacting an automatic insert of the payment types available now, so that when the db is created
they will exist in advance
*/
INSERT INTO `DwDAssign04Pt1`.`timeCardStatus`(`idstatType`,`Status`)
VALUES(1,"Pending"),(2,"Approved"),(3,"Not Approved");

CREATE TABLE IF NOT EXISTS `DwDAssign04Pt1`.`timecard`(
idTimeCard INT NOT NULL AUTO_INCREMENT
,idemployee INT NOT NULL
,hoursWrk INT NOT NULL
,submitDate DATE NOT NULL
,idstatType tinyint NOT NULL
,idApprover INT 
,PRIMARY KEY (`idTimeCard`)
,INDEX timeEmpl_IDX (idemployee)
,CONSTRAINT uc_timeEmployee UNIQUE (idemployee,submitDate)
,  CONSTRAINT `fk_time_employee`
    FOREIGN KEY (`idemployee`)
    REFERENCES `DwDAssign04Pt1`.`employees` (`idemployee`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION 

,  CONSTRAINT `fk_time_status`
    FOREIGN KEY (`idstatType`)
    REFERENCES `DwDAssign04Pt1`.`timeCardStatus` (`idstatType`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION  

,  CONSTRAINT `fk_time_approver`
    FOREIGN KEY (`idApprover`)
    REFERENCES `DwDAssign04Pt1`.`management` (`idMgr`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION         

,  CONSTRAINT `fk_time_mgr`
    FOREIGN KEY (`idemployee`)
    REFERENCES `DwDAssign04Pt1`.`management` (`idSupEmployee`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION       
)ENGINE=INNODB;

ALTER TABLE `DwDAssign04Pt1`.`timecard` ALTER COLUMN `idstatType` SET DEFAULT 1;

USE `DwDAssign04Pt1`;
CREATE TRIGGER timecard_OnInsert BEFORE INSERT ON `DwDAssign04Pt1`.`timecard`
     FOR EACH ROW SET NEW.`submitDate` = IFNULL(NEW.`submitDate`, CURDATE());
-- drop database `DwDAssign04Pt1`

