-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema pk-boilerplate
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema pk-boilerplate
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pk-boilerplate` DEFAULT CHARACTER SET utf8mb4 ;
USE `pk-boilerplate` ;

-- -----------------------------------------------------
-- Table `pk-boilerplate`.`user_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pk-boilerplate`.`user_status` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pk-boilerplate`.`role`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pk-boilerplate`.`role` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pk-boilerplate`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pk-boilerplate`.`user` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `firstName` VARCHAR(45) NOT NULL,
  `lastName` VARCHAR(96) NULL DEFAULT NULL,
  `email` VARCHAR(96) NULL DEFAULT NULL,
  `password` VARCHAR(196) NULL DEFAULT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT NOW(),
  `profilePic` VARCHAR(96) NULL,
  `statusId` INT NOT NULL,
  `roleId` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `status-id_idx` (`statusId` ASC) VISIBLE,
  INDEX `user-role-id_idx` (`roleId` ASC) VISIBLE,
  CONSTRAINT `user-status-id`
    FOREIGN KEY (`statusId`)
    REFERENCES `pk-boilerplate`.`user_status` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `user-role-id`
    FOREIGN KEY (`roleId`)
    REFERENCES `pk-boilerplate`.`role` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `pk-boilerplate`.`record`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pk-boilerplate`.`record` (
  `idRecord` INT(11) NOT NULL AUTO_INCREMENT,
  `idUser` INT(11) NOT NULL,
  `hashId` VARCHAR(18) NOT NULL,
  `publicURL` VARCHAR(70) NULL DEFAULT NULL,
  PRIMARY KEY (`idRecord`),
  INDEX `recordUser_idx` (`idUser` ASC) VISIBLE,
  CONSTRAINT `recordUser`
    FOREIGN KEY (`idUser`)
    REFERENCES `pk-boilerplate`.`user` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `pk-boilerplate`.`login_provider`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pk-boilerplate`.`login_provider` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `appId` VARCHAR(156) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pk-boilerplate`.`user_external_login`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pk-boilerplate`.`user_external_login` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `userAccountId` VARCHAR(96) NULL,
  `userId` INT NULL,
  `firstName` VARCHAR(45) NULL,
  `lastName` VARCHAR(45) NULL,
  `email` VARCHAR(96) NULL,
  `loginProviderId` INT NOT NULL,
  `createdAt` DATETIME NOT NULL DEFAULT NOW(),
  PRIMARY KEY (`id`),
  INDEX `user-external-login-id_idx` (`userId` ASC) VISIBLE,
  INDEX `login-provider-id_idx` (`loginProviderId` ASC) VISIBLE,
  CONSTRAINT `provider-user-external-login-id`
    FOREIGN KEY (`userId`)
    REFERENCES `pk-boilerplate`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `login-provider-id`
    FOREIGN KEY (`loginProviderId`)
    REFERENCES `pk-boilerplate`.`login_provider` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pk-boilerplate`.`todo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pk-boilerplate`.`todo` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(45) NULL,
  `isDone` BINARY NOT NULL DEFAULT 0,
  `createdAt` DATETIME NULL DEFAULT NOW(),
  `userId` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `todo-user-id_idx` (`userId` ASC) VISIBLE,
  CONSTRAINT `todo-user-id`
    FOREIGN KEY (`userId`)
    REFERENCES `pk-boilerplate`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pk-boilerplate`.`forgot_password`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pk-boilerplate`.`forgot_password` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `token` VARCHAR(96) NOT NULL,
  `userId` INT NOT NULL,
  `createdAt` DATETIME NULL DEFAULT NOW(),
  `expiresAt` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `forgot-user-id_idx` (`userId` ASC) VISIBLE,
  CONSTRAINT `forgot-user-id`
    FOREIGN KEY (`userId`)
    REFERENCES `pk-boilerplate`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
