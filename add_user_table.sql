-- MySQL Workbench Forward Engineering




SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;

SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;

SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';




-- -----------------------------------------------------

-- Schema iowa_moves

-- -----------------------------------------------------




-- -----------------------------------------------------

-- Schema iowa_moves

-- -----------------------------------------------------

CREATE SCHEMA IF NOT EXISTS `iowa_moves` DEFAULT CHARACTER SET utf8 ;

USE `iowa_moves` ;




-- -----------------------------------------------------

-- Table `iowa_moves`.`train`

-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `iowa_moves`.`user_id` (

	`Id` INT NOT NULL AUTO_INCREMENT,

    `Name` VARCHAR(45) NOT NULL,

  PRIMARY KEY (`Id`))

ENGINE = InnoDB;







SET SQL_MODE=@OLD_SQL_MODE;

SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;

SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
