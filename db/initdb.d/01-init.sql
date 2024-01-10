CREATE DATABASE IF NOT EXISTS `shop`;

CREATE TABLE IF NOT EXISTS `user` (
	`id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`first_name` VARCHAR(255) NOT NULL,
	`last_name` VARCHAR(255) NOT NULL,
	`mail` VARCHAR(255) NOT NULL,
	`birthdate` DATE NOT NULL,
	`password` CHAR(65) NOT NULL
);

CREATE TABLE IF NOT EXISTS `product` (
	`id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`name` VARCHAR(200) NOT NULL,
	`price` DECIMAL(10,2) NOT NULL,
	`width` SMALLINT UNSIGNED NOT NULL,
	`height` SMALLINT UNSIGNED NOT NULL,
	`depth` SMALLINT UNSIGNED NOT NULL,
	`weight` SMALLINT UNSIGNED NOT NULL
);

CREATE TABLE IF NOT EXISTS `inventory` (
	`product_id` MEDIUMINT UNSIGNED NOT NULL PRIMARY KEY,
	`quantity` INT UNSIGNED NOT NULL DEFAULT 0,
	CONSTRAINT `fk_inventory_product`
		FOREIGN KEY (`product_id`) REFERENCES product (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS `order` (
	`id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`datetime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`status` ENUM('NOT_SHIPPED', 'SHIPPED') NOT NULL DEFAULT 'NOT_SHIPPED'
);

CREATE TABLE IF NOT EXISTS `order_product` (
	`order_id` MEDIUMINT UNSIGNED NOT NULL,
	`product_id` MEDIUMINT UNSIGNED NOT NULL,
	`quantity` INT UNSIGNED NOT NULL,
	CONSTRAINT `pk_order_product` PRIMARY KEY (`order_id`, `product_id`),
	CONSTRAINT `fk_order_product_oid`
		FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
	CONSTRAINT `fk_order_product_pid`
		FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
);

CREATE TABLE IF NOT EXISTS `shipment` (
	`id` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`order_id` MEDIUMINT UNSIGNED NOT NULL,
	`datetime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT `fk_shipment_oid`
		FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
);