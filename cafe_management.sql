
create database cafe_management;

use cafe_management;


CREATE TABLE `admins` (
  `admin_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `menuitems` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `item_name` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `status` enum('available','unavailable') DEFAULT 'available',
  PRIMARY KEY (`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `menuitems` VALUES (1,'Cafe Đen Phin',25000.00,'available'),(2,'Cafe Đen Ép',30000.00,'available'),(3,'Cafe Sữa Phin',30000.00,'available'),(4,'Cafe Đen Ép',20000.00,'available'),(5,'Bạc Xỉu',30000.00,'available'),(6,'Cafe Kem Trứng Cháy',30000.00,'available'),(7,'Matcha Latte',40000.00,'available'),(8,'Trà Sữa Gạo',30000.00,'available'),(9,'Nước Ép (Cam, Thơm, Ổi)',20000.00,'available'),(10,'Chocolate Đá Xay',40000.00,'available');


CREATE TABLE `orderdetails` (
  `order_detail_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `item_id` int NOT NULL,
  `quantity` int NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  PRIMARY KEY (`order_detail_id`),
  KEY `order_id` (`order_id`),
  KEY `item_id` (`item_id`),
  CONSTRAINT `orderdetails_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `orderdetails_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `menuitems` (`item_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `table_id` int NOT NULL,
  `admin_id` int DEFAULT NULL,
  `order_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('pending','preparing','completed','cancelled') DEFAULT 'pending',
  `payment_method` enum('cash','transfer') NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `comments` text,
  PRIMARY KEY (`order_id`),
  KEY `table_id` (`table_id`),
  KEY `admin_id` (`admin_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`table_id`) REFERENCES `tables` (`table_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`admin_id`) REFERENCES `admins` (`admin_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `tables` (
  `table_id` int NOT NULL AUTO_INCREMENT,
  `table_number` varchar(10) NOT NULL,
  `qr_code` varchar(255) NOT NULL,
  `status` enum('available','occupied') DEFAULT 'available',
  PRIMARY KEY (`table_id`),
  UNIQUE KEY `table_number` (`table_number`),
  UNIQUE KEY `qr_code` (`qr_code`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO `tables` VALUES (1,'Bàn 1','qr_table_1747887406904','available'),(2,'Bàn','qr_table_1747887411186','available'),(3,'Bàn 3','qr_table_1747887415386','available'),(4,'Bàn 4','qr_table_1747887421086','available'),(5,'Bàn 5','qr_table_1747887427506','available'),(6,'Bàn 6','qr_table_1747887433493','available'),(7,'Bàn 7','qr_table_1750655144122','available');
