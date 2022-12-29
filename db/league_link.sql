-- MySQL Script generated by MySQL Workbench
-- Monday 26 December 2022 09:40:11 AM
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
-- -----------------------------------------------------
-- Schema league_link
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `league_link` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `league_link` ;

-- -----------------------------------------------------
-- Table `league_link`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `league_link`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `status` TINYINT NOT NULL DEFAULT '1',
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 17
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `league_link`.`tournaments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `league_link`.`tournaments` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `user_id` INT NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  `number_of_teams` INT NOT NULL,
  `image_url` VARCHAR(255) NOT NULL,
  `status` TINYINT NOT NULL DEFAULT '1',
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `user_id` (`user_id` ASC) VISIBLE,
  CONSTRAINT `tournaments_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `league_link`.`users` (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `league_link`.`teams`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `league_link`.`teams` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `image_url` VARCHAR(255) NOT NULL,
  `status` TINYINT NOT NULL DEFAULT '1',
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_teams_1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_teams_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `league_link`.`users` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `league_link`.`matches`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `league_link`.`matches` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tournament_id` INT NOT NULL,
  `team1_id` INT NOT NULL,
  `team2_id` INT NOT NULL,
  `start_time` DATETIME NOT NULL,
  `location` VARCHAR(255) NOT NULL,
  `winner_team_id` INT NULL DEFAULT NULL,
  `status` TINYINT NOT NULL DEFAULT '1',
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `tournament_id` (`tournament_id` ASC) VISIBLE,
  INDEX `team1_id` (`team1_id` ASC) VISIBLE,
  INDEX `team2_id` (`team2_id` ASC) VISIBLE,
  INDEX `matches_ibfk_4` (`winner_team_id` ASC) VISIBLE,
  CONSTRAINT `matches_ibfk_1`
    FOREIGN KEY (`tournament_id`)
    REFERENCES `league_link`.`tournaments` (`id`),
  CONSTRAINT `matches_ibfk_2`
    FOREIGN KEY (`team1_id`)
    REFERENCES `league_link`.`teams` (`id`),
  CONSTRAINT `matches_ibfk_3`
    FOREIGN KEY (`team2_id`)
    REFERENCES `league_link`.`teams` (`id`),
  CONSTRAINT `matches_ibfk_4`
    FOREIGN KEY (`winner_team_id`)
    REFERENCES `league_link`.`teams` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `league_link`.`players`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `league_link`.`players` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `team_id` INT NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `status` TINYINT NOT NULL DEFAULT '1',
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `team_id` (`team_id` ASC) VISIBLE,
  CONSTRAINT `players_ibfk_1`
    FOREIGN KEY (`team_id`)
    REFERENCES `league_link`.`teams` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `league_link`.`scorecard`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `league_link`.`scorecard` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `match_id` INT NOT NULL,
  `player_id` INT NOT NULL,
  `runs` INT NOT NULL,
  `wickets` INT NOT NULL,
  `status` TINYINT NOT NULL DEFAULT '1',
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `match_id` (`match_id` ASC) VISIBLE,
  INDEX `player_id` (`player_id` ASC) VISIBLE,
  CONSTRAINT `scorecard_ibfk_1`
    FOREIGN KEY (`match_id`)
    REFERENCES `league_link`.`matches` (`id`),
  CONSTRAINT `scorecard_ibfk_3`
    FOREIGN KEY (`player_id`)
    REFERENCES `league_link`.`players` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `league_link`.`tournament_teams`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `league_link`.`tournament_teams` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `team_id` INT NOT NULL,
  `tournament_id` INT NOT NULL,
  `pool` INT NOT NULL DEFAULT '0',
  `match_count` INT NOT NULL DEFAULT '0',
  `win_count` INT NOT NULL DEFAULT '0',
  `draw_count` INT NOT NULL DEFAULT '0',
  `lose_count` INT NOT NULL DEFAULT '0',
  `points` INT NOT NULL DEFAULT '0',
  `status` TINYINT NOT NULL DEFAULT '1',
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `team_id` (`team_id` ASC) VISIBLE,
  INDEX `tournament_id` (`tournament_id` ASC) VISIBLE,
  CONSTRAINT `tournament_teams_ibfk_1`
    FOREIGN KEY (`team_id`)
    REFERENCES `league_link`.`teams` (`id`),
  CONSTRAINT `tournament_teams_ibfk_2`
    FOREIGN KEY (`tournament_id`)
    REFERENCES `league_link`.`tournaments` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


-- -----------------------------------------------------
-- UPDATES DEC 29 2022
-- -----------------------------------------------------

ALTER TABLE `league_link`.`teams` ADD COLUMN `manager` VARCHAR(100) NOT NULL AFTER `image_url`;

ALTER TABLE `league_link`.`players` 
ADD COLUMN `phone` VARCHAR(13) NOT NULL AFTER `name`,
ADD COLUMN `user_id` INT NOT NULL AFTER `phone`,
ADD INDEX `fk_players_1_idx` (`user_id` ASC) VISIBLE;
;
ALTER TABLE `league_link`.`players` 
ADD CONSTRAINT `fk_players_1`
  FOREIGN KEY (`user_id`)
  REFERENCES `league_link`.`users` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `league_link`.`players` 
DROP FOREIGN KEY `players_ibfk_1`;
ALTER TABLE `league_link`.`players` 
CHANGE COLUMN `team_id` `team_id` INT NULL ;
ALTER TABLE `league_link`.`players` 
ADD CONSTRAINT `players_ibfk_1`
  FOREIGN KEY (`team_id`)
  REFERENCES `league_link`.`teams` (`id`);