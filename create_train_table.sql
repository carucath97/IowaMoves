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
CREATE TABLE IF NOT EXISTS `iowa_moves`.`train` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `MSSubClass` INT NOT NULL,
  `MSZoning` VARCHAR(10) NULL,
  `LotFrontage` INT NULL,
  `LotArea` INT NULL,
  `Street` VARCHAR(45) NULL,
  `Alley` VARCHAR(45) NULL,
  `LotShape` VARCHAR(45) NULL,
  `LandContour` VARCHAR(45) NULL,
  `Utilities` VARCHAR(45) NULL,
  `LotConfig` VARCHAR(45) NULL,
  `LandSlope` VARCHAR(45) NULL,
  `Neigborhood` VARCHAR(45) NULL,
  `Condition1` VARCHAR(45) NULL,
  `Condition2` VARCHAR(45) NULL,
  `BldgType` VARCHAR(45) NULL,
  `HouseStyle` VARCHAR(45) NULL,
  `OverallQual` VARCHAR(45) NULL,
  `OverallCond` VARCHAR(45) NULL,
  `YearBuilt` VARCHAR(45) NULL,
  `YearRemodAdd` VARCHAR(45) NULL,
  `RoofStyle` VARCHAR(45) NULL,
  `RoofMat1` VARCHAR(45) NULL,
  `Exterior1st` VARCHAR(45) NULL,
  `Exterior2nd` VARCHAR(45) NULL,
  `MasVnrType` VARCHAR(45) NULL,
  `ExterQual` VARCHAR(2) NULL,
  `ExterCond` VARCHAR(2) NULL,
  `Foundation` VARCHAR(45) NULL,
  `BsmtQual` VARCHAR(2) NULL,
  `BsmtCond` VARCHAR(2) NULL,
  `BsmtExposure` VARCHAR(2) NULL,
  `BsmtFinType1` VARCHAR(3) NULL,
  `BsmtFinSF1` INT NULL,
  `BsmtFinType2` VARCHAR(3) NULL,
  `BsmtFinSF2` INT NULL,
  `BsmtUnfSF` INT NULL,
  `TotalBsmtSF` INT NULL,
  `Heating` VARCHAR(5) NULL,
  `HeatingQC` VARCHAR(2) NULL,
  `CentralAir` VARCHAR(1) NULL,
  `Electrical` VARCHAR(5) NULL,
  `1stFlrSF` INT NULL,
  `2ndFlrSF` INT NULL,
  `LowQualFinSF` INT NULL,
  `GrLivArea` INT NULL,
  `BsmtFullBath` INT NULL,
  `BsmtHalfBath` INT NULL,
  `FullBath` INT NULL,
  `HalfBath` INT NULL,
  `Bedroom` INT NULL,
  `Kitchen` INT NULL,
  `KitchenQual` VARCHAR(2) NULL,
  `TotRmsAbvGrd` INT NULL,
  `Functional` VARCHAR(3) NULL,
  `Fireplaces` INT NULL,
  `FireplaceQu` VARCHAR(2) NULL,
  `GarageType` VARCHAR(45) NULL,
  `GarageYrBuilt` INT NULL,
  `GarageFinish` VARCHAR(3) NULL,
  `GarageCars` INT NULL,
  `GarageArea` INT NULL,
  `GarageQual` VARCHAR(2) NULL,
  `GarageCond` VARCHAR(2) NULL,
  `PavedDrive` VARCHAR(1) NULL,
  `WoodDeckSF` INT NULL,
  `OpenPorchSF` INT NULL,
  `EnclosedPorchSF` INT NULL,
  `3SsnPorch` INT NULL,
  `ScreenPorch` INT NULL,
  `PoolArea` INT NULL,
  `PoolQC` VARCHAR(2) NULL,
  `Fence` VARCHAR(5) NULL,
  `MiscFeature` VARCHAR(5) NULL,
  `MiscVal` INT NULL,
  `MoSold` INT NULL,
  `YrSold` INT NULL,
  `SaleType` VARCHAR(5) NULL,
  `SaleCondition` VARCHAR(45) NULL,
  PRIMARY KEY (`Id`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
