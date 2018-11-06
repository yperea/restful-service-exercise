#!/usr/bin/env bash

set -e

mysql -umadjava -pmadjava -D directory <<EOF

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema directory
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS directory ;

-- -----------------------------------------------------
-- Schema directory
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS directory DEFAULT CHARACTER SET utf8 ;
USE directory ;

-- -----------------------------------------------------
-- Table users
-- -----------------------------------------------------
DROP TABLE IF EXISTS users ;

CREATE TABLE IF NOT EXISTS users (
  id INT NOT NULL AUTO_INCREMENT,
  first_name NVARCHAR(45) NULL,
  last_name NVARCHAR(45) NULL,
  user_name NVARCHAR(45) NOT NULL,
  password NVARCHAR(45) NULL,
  api_key NVARCHAR(45) NULL,
  created DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id))
ENGINE = InnoDB;

CREATE UNIQUE INDEX user_name_UNIQUE ON users (user_name ASC);


-- -----------------------------------------------------
-- Table roles
-- -----------------------------------------------------
DROP TABLE IF EXISTS roles ;

CREATE TABLE IF NOT EXISTS roles (
  id INT NOT NULL AUTO_INCREMENT,
  role_name NVARCHAR(45) NULL,
  created DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id))
ENGINE = InnoDB;

CREATE UNIQUE INDEX role_name_UNIQUE ON roles (role_name ASC);


-- -----------------------------------------------------
-- Table users_roles
-- -----------------------------------------------------
DROP TABLE IF EXISTS users_roles ;

CREATE TABLE IF NOT EXISTS users_roles (
  user_id INT NOT NULL,
  role_id INT NOT NULL,
  PRIMARY KEY (user_id, role_id),
  CONSTRAINT fk_users_has_roles_users
    FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_users_has_roles_roles1
    FOREIGN KEY (role_id)
    REFERENCES roles (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE INDEX fk_users_has_roles_roles1_idx ON users_roles (role_id ASC);

CREATE INDEX fk_users_has_roles_users_idx ON users_roles (user_id ASC);

USE directory ;

-- -----------------------------------------------------
-- Placeholder table for view v_users_roles
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS v_users_roles (user_name INT, role_name INT);

-- -----------------------------------------------------
-- View v_users_roles
-- -----------------------------------------------------
DROP TABLE IF EXISTS v_users_roles;
DROP VIEW IF EXISTS v_users_roles ;
USE directory;
CREATE OR REPLACE VIEW v_users_roles AS
  SELECT u.user_name, r.role_name
  FROM users u INNER JOIN users_roles ur ON u.id = ur.user_id
               INNER JOIN roles r ON r.id = ur.role_id;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table users
-- -----------------------------------------------------
START TRANSACTION;
USE directory;
INSERT INTO users (id, first_name, last_name, user_name, password, api_key, created) VALUES (DEFAULT, 'Joe', 'Coyne', 'jcoyne', 'supersecret1', 'supersecret1', DEFAULT);
INSERT INTO users (id, first_name, last_name, user_name, password, api_key, created) VALUES (DEFAULT, 'Fred', 'Hensen', 'fhensen', 'supersecret2', 'supersecret2', DEFAULT);
INSERT INTO users (id, first_name, last_name, user_name, password, api_key, created) VALUES (DEFAULT, 'John', 'Smith', 'jsmith', 'supersecret3', 'supersecret3', DEFAULT);
INSERT INTO users (id, first_name, last_name, user_name, password, api_key, created) VALUES (DEFAULT, 'Karen', 'Mack', 'kmack', 'supersecret4', 'supersecret4', DEFAULT);
INSERT INTO users (id, first_name, last_name, user_name, password, api_key, created) VALUES (DEFAULT, 'Dianne', 'Klein', 'dklein', 'supersecret5', 'supersecret5', DEFAULT);
INSERT INTO users (id, first_name, last_name, user_name, password, api_key, created) VALUES (DEFAULT, 'Dawn', 'Tillman', 'dtillman', 'supersecret6', 'supersecret6', DEFAULT);
INSERT INTO users (id, first_name, last_name, user_name, password, api_key, created) VALUES (DEFAULT, 'Fred', 'Flintstone', 'fflintstone', 'supersecret7', 'supersecret7', DEFAULT);

COMMIT;


-- -----------------------------------------------------
-- Data for table roles
-- -----------------------------------------------------
START TRANSACTION;
USE directory;
INSERT INTO roles (id, role_name, created) VALUES (DEFAULT, 'administrator', DEFAULT);
INSERT INTO roles (id, role_name, created) VALUES (DEFAULT, 'user', DEFAULT);

COMMIT;


-- -----------------------------------------------------
-- Data for table users_roles
-- -----------------------------------------------------
START TRANSACTION;
USE directory;
INSERT INTO users_roles (user_id, role_id) VALUES (1, 1);
INSERT INTO users_roles (user_id, role_id) VALUES (2, 1);
INSERT INTO users_roles (user_id, role_id) VALUES (3, 2);
INSERT INTO users_roles (user_id, role_id) VALUES (4, 2);
INSERT INTO users_roles (user_id, role_id) VALUES (5, 2);
INSERT INTO users_roles (user_id, role_id) VALUES (6, 2);
INSERT INTO users_roles (user_id, role_id) VALUES (7, 2);

COMMIT;

EOF