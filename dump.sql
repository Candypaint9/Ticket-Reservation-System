-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: indianrailway
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `class`
--

DROP TABLE IF EXISTS `class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class` (
  `class_id` int NOT NULL AUTO_INCREMENT,
  `class_name` varchar(20) NOT NULL,
  `base_fare` decimal(8,2) NOT NULL,
  PRIMARY KEY (`class_id`),
  UNIQUE KEY `class_name` (`class_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class`
--

LOCK TABLES `class` WRITE;
/*!40000 ALTER TABLE `class` DISABLE KEYS */;
INSERT INTO `class` VALUES (1,'SL',500.00),(2,'3A',1500.00),(3,'2A',2000.00),(4,'1A',3000.00),(5,'CC',1000.00);
/*!40000 ALTER TABLE `class` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `passenger`
--

DROP TABLE IF EXISTS `passenger`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `passenger` (
  `passenger_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(50) NOT NULL,
  `age` int NOT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `concession` enum('None','Senior Citizen','Student','Disabled') DEFAULT 'None',
  PRIMARY KEY (`passenger_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `passenger`
--

LOCK TABLES `passenger` WRITE;
/*!40000 ALTER TABLE `passenger` DISABLE KEYS */;
INSERT INTO `passenger` VALUES (1,'Rahul Sharma',28,'Male','None'),(2,'Priya Singh',65,'Female','Senior Citizen'),(3,'Amit Kumar',22,'Male','Student'),(4,'Suman Rao',30,'Female','None');
/*!40000 ALTER TABLE `passenger` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `amount` decimal(10,2) NOT NULL,
  `payment_mode` enum('Credit Card','Debit Card','UPI','Net Banking','Cash') NOT NULL,
  `payment_status` enum('Success','Pending','Failed','Refunded') DEFAULT 'Pending',
  `payment_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `refund_date` datetime DEFAULT NULL,
  PRIMARY KEY (`payment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (1,1500.00,'UPI','Success','2025-04-10 05:00:00',NULL),(2,3000.00,'Credit Card','Pending','2025-04-11 10:15:00',NULL),(3,1000.00,'Debit Card','Success','2025-04-12 03:50:00',NULL),(4,1000.00,'Debit Card','Success','2025-04-12 04:40:00',NULL);
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `route`
--

DROP TABLE IF EXISTS `route`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `route` (
  `route_id` int NOT NULL AUTO_INCREMENT,
  `source_station` varchar(5) NOT NULL,
  `destination_station` varchar(5) NOT NULL,
  PRIMARY KEY (`route_id`),
  KEY `source_station` (`source_station`),
  KEY `destination_station` (`destination_station`),
  CONSTRAINT `route_ibfk_1` FOREIGN KEY (`source_station`) REFERENCES `station` (`station_code`),
  CONSTRAINT `route_ibfk_2` FOREIGN KEY (`destination_station`) REFERENCES `station` (`station_code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `route`
--

LOCK TABLES `route` WRITE;
/*!40000 ALTER TABLE `route` DISABLE KEYS */;
INSERT INTO `route` VALUES (1,'NDLS','BCT'),(2,'NDLS','HWH'),(3,'MAS','BLR');
/*!40000 ALTER TABLE `route` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule`
--

DROP TABLE IF EXISTS `schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule` (
  `schedule_id` int NOT NULL AUTO_INCREMENT,
  `train_number` int NOT NULL,
  `route_id` int NOT NULL,
  `departure_time` time NOT NULL,
  `arrival_time` time NOT NULL,
  `journey_date` date NOT NULL,
  PRIMARY KEY (`schedule_id`),
  KEY `train_number` (`train_number`),
  KEY `route_id` (`route_id`),
  CONSTRAINT `schedule_ibfk_1` FOREIGN KEY (`train_number`) REFERENCES `train` (`train_number`),
  CONSTRAINT `schedule_ibfk_2` FOREIGN KEY (`route_id`) REFERENCES `route` (`route_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
INSERT INTO `schedule` VALUES (1,12301,1,'16:00:00','08:00:00','2025-05-01'),(2,12002,1,'06:00:00','12:30:00','2025-05-02'),(3,12215,2,'22:00:00','10:00:00','2025-05-03'),(4,12627,3,'07:30:00','17:00:00','2025-05-04');
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seat`
--

DROP TABLE IF EXISTS `seat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seat` (
  `seat_id` int NOT NULL AUTO_INCREMENT,
  `train_number` int NOT NULL,
  `class_id` int NOT NULL,
  `seat_number` varchar(10) NOT NULL,
  PRIMARY KEY (`seat_id`),
  KEY `train_number` (`train_number`),
  KEY `class_id` (`class_id`),
  CONSTRAINT `seat_ibfk_1` FOREIGN KEY (`train_number`) REFERENCES `train` (`train_number`),
  CONSTRAINT `seat_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `class` (`class_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seat`
--

LOCK TABLES `seat` WRITE;
/*!40000 ALTER TABLE `seat` DISABLE KEYS */;
INSERT INTO `seat` VALUES (1,12301,1,'SL1'),(2,12301,1,'SL2'),(3,12301,1,'SL3'),(4,12301,1,'SL4'),(5,12301,1,'SL5'),(6,12301,2,'3A1'),(7,12301,2,'3A2'),(8,12301,3,'2A1'),(9,12002,5,'CC1'),(10,12002,5,'CC2'),(11,12002,5,'CC3'),(12,12002,5,'CC4'),(13,12002,5,'CC5'),(14,12215,1,'SL2'),(15,12215,4,'1A1'),(16,12627,5,'CC3'),(17,12627,5,'CC4');
/*!40000 ALTER TABLE `seat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `station`
--

DROP TABLE IF EXISTS `station`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `station` (
  `station_code` varchar(5) NOT NULL,
  `station_name` varchar(50) NOT NULL,
  `city` varchar(30) NOT NULL,
  PRIMARY KEY (`station_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `station`
--

LOCK TABLES `station` WRITE;
/*!40000 ALTER TABLE `station` DISABLE KEYS */;
INSERT INTO `station` VALUES ('BCT','Mumbai Central','Mumbai'),('BLR','Bangalore City','Bengaluru'),('HWH','Howrah','Kolkata'),('MAS','Chennai Central','Chennai'),('NDLS','New Delhi','New Delhi');
/*!40000 ALTER TABLE `station` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket`
--

DROP TABLE IF EXISTS `ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticket` (
  `pnr` varchar(10) NOT NULL,
  `passenger_id` int NOT NULL,
  `schedule_id` int NOT NULL,
  `seat_id` int DEFAULT NULL,
  `class_id` int NOT NULL,
  `booking_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `ticket_status` enum('Confirmed','RAC','Waitlist') NOT NULL,
  `payment_id` int NOT NULL,
  PRIMARY KEY (`pnr`),
  KEY `passenger_id` (`passenger_id`),
  KEY `schedule_id` (`schedule_id`),
  KEY `seat_id` (`seat_id`),
  KEY `class_id` (`class_id`),
  KEY `payment_id` (`payment_id`),
  CONSTRAINT `ticket_ibfk_1` FOREIGN KEY (`passenger_id`) REFERENCES `passenger` (`passenger_id`),
  CONSTRAINT `ticket_ibfk_2` FOREIGN KEY (`schedule_id`) REFERENCES `schedule` (`schedule_id`),
  CONSTRAINT `ticket_ibfk_3` FOREIGN KEY (`seat_id`) REFERENCES `seat` (`seat_id`),
  CONSTRAINT `ticket_ibfk_4` FOREIGN KEY (`class_id`) REFERENCES `class` (`class_id`),
  CONSTRAINT `ticket_ibfk_5` FOREIGN KEY (`payment_id`) REFERENCES `payment` (`payment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket`
--

LOCK TABLES `ticket` WRITE;
/*!40000 ALTER TABLE `ticket` DISABLE KEYS */;
INSERT INTO `ticket` VALUES ('PNR001',1,1,2,2,'2025-04-23 08:23:55','Confirmed',1),('PNR002',2,2,5,5,'2025-04-23 08:23:55','Confirmed',2),('PNR003',3,3,7,1,'2025-04-23 08:23:55','Waitlist',3),('PNR004',4,4,10,5,'2025-04-23 08:23:55','RAC',4);
/*!40000 ALTER TABLE `ticket` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `AfterTicketUpdate` AFTER UPDATE ON `ticket` FOR EACH ROW BEGIN
    DECLARE v_next_pnr VARCHAR(10) DEFAULT NULL;

    IF OLD.ticket_status <> 'Cancelled'
       AND NEW.ticket_status = 'Cancelled'
       AND OLD.seat_id IS NOT NULL
    THEN
        -- find the earliest RAC for same schedule & class
        SELECT pnr
          INTO v_next_pnr
        FROM Ticket
        WHERE schedule_id  = OLD.schedule_id
          AND class_id      = OLD.class_id
          AND ticket_status = 'RAC'
        ORDER BY booking_date, pnr
        LIMIT 1;

        -- if found, assign the freed seat and confirm it
        IF v_next_pnr IS NOT NULL THEN
            UPDATE Ticket
               SET seat_id       = OLD.seat_id,
                   ticket_status = 'Confirmed'
             WHERE pnr = v_next_pnr;
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `train`
--

DROP TABLE IF EXISTS `train`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `train` (
  `train_number` int NOT NULL,
  `train_name` varchar(50) NOT NULL,
  PRIMARY KEY (`train_number`),
  UNIQUE KEY `train_name` (`train_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `train`
--

LOCK TABLES `train` WRITE;
/*!40000 ALTER TABLE `train` DISABLE KEYS */;
INSERT INTO `train` VALUES (12627,'Bangalore – Chennai Shatabdi Express'),(12215,'Howrah – Chennai Mail'),(12002,'New Delhi – Bhopal Shatabdi Express'),(12301,'New Delhi – Mumbai Rajdhani Express');
/*!40000 ALTER TABLE `train` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'indianrailway'
--

--
-- Dumping routines for database 'indianrailway'
--
/*!50003 DROP PROCEDURE IF EXISTS `BookTicket` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `BookTicket`(
    IN p_passenger_name VARCHAR(50),
    IN p_age INT,
    IN p_gender ENUM('Male','Female','Other'),
    IN p_concession ENUM('None','Senior Citizen','Student','Disabled'),
    IN p_schedule_id INT,
    IN p_class_id INT,
    IN p_payment_mode ENUM('Credit Card','Debit Card','UPI','Net Banking','Cash')
)
BEGIN
    DECLARE v_train_num       INT;
    DECLARE v_seat_id         INT;
    DECLARE v_passenger_id    INT;
    DECLARE v_existing_pid    INT DEFAULT NULL;
    DECLARE v_payment_id      INT;
    DECLARE v_rac_count       INT DEFAULT 0;
    DECLARE v_pnr             VARCHAR(10);
    DECLARE v_base_fare       DECIMAL(10,2);
    DECLARE v_final_fare      DECIMAL(10,2);
    DECLARE v_ticket_status   ENUM('Confirmed','RAC','Waitlist');

    START TRANSACTION;

    -- 1) Lookup train_number & base fare
    SELECT train_number 
      INTO v_train_num
    FROM Schedule
    WHERE schedule_id = p_schedule_id;

    SELECT base_fare
      INTO v_base_fare
    FROM Class
    WHERE class_id = p_class_id;

    -- 2) Apply concession discount
    SET v_final_fare = v_base_fare
        - CASE p_concession
            WHEN 'Senior Citizen' THEN v_base_fare * 0.40
            WHEN 'Student'        THEN v_base_fare * 0.35
            WHEN 'Disabled'       THEN v_base_fare * 0.50
            ELSE 0
          END;

    -- 3) Reuse existing passenger if match found
    SELECT passenger_id
      INTO v_existing_pid
    FROM Passenger
    WHERE full_name  = p_passenger_name
      AND age        = p_age
      AND gender     = p_gender
      AND concession = p_concession
    LIMIT 1;

    IF v_existing_pid IS NOT NULL THEN
        SET v_passenger_id = v_existing_pid;
    ELSE
        INSERT INTO Passenger(full_name, age, gender, concession)
        VALUES (p_passenger_name, p_age, p_gender, p_concession);
        SET v_passenger_id = LAST_INSERT_ID();
    END IF;

    -- 4) Create payment record
    INSERT INTO Payment(amount, payment_mode, payment_status)
    VALUES (v_final_fare, p_payment_mode, 'Success');
    SET v_payment_id = LAST_INSERT_ID();

    -- 5) Find a free seat *in this class* on *this schedule*
    SELECT s.seat_id
      INTO v_seat_id
    FROM Seat s
    JOIN Schedule sch 
      ON s.train_number = sch.train_number
     AND sch.schedule_id = p_schedule_id
    WHERE s.class_id = p_class_id
      AND NOT EXISTS (
          SELECT 1
          FROM Ticket t
          WHERE t.schedule_id   = p_schedule_id
            AND t.seat_id       = s.seat_id
            AND t.ticket_status = 'Confirmed'
            AND t.class_id      = p_class_id
      )
    ORDER BY s.seat_number
    LIMIT 1;

    IF v_seat_id IS NOT NULL THEN
        SET v_ticket_status = 'Confirmed';
    ELSE
        -- count current RAC bookings for this class/schedule
        SELECT COUNT(*) 
          INTO v_rac_count
        FROM Ticket t
        WHERE t.schedule_id   = p_schedule_id
          AND t.class_id      = p_class_id
          AND t.ticket_status = 'RAC';

        IF v_rac_count < 5 THEN
            SET v_ticket_status = 'RAC';
        ELSE
            SET v_ticket_status = 'Waitlist';
        END IF;
    END IF;

    -- 6) Generate PNR and insert ticket
	REPEAT
		SET v_pnr = CONCAT('PNR', FLOOR(100000 + RAND() * 900000));
		UNTIL NOT EXISTS (SELECT 1 FROM Ticket WHERE pnr = v_pnr)
	END REPEAT;


    INSERT INTO Ticket (
        pnr, passenger_id, schedule_id, seat_id, class_id,
        ticket_status, payment_id
    )
    VALUES (
        v_pnr, v_passenger_id, p_schedule_id, v_seat_id,
        p_class_id, v_ticket_status, v_payment_id
    );

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CalculateTrainCancellationRefund` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CalculateTrainCancellationRefund`(
    IN p_schedule_id INT,
    IN p_seat_id INT
)
BEGIN
    SELECT 
        SUM(c.base_fare) AS total_refund,
        SUM(c.base_fare) * 0.75 AS refund_amount
    FROM Ticket t
    JOIN Class c ON t.class_id = c.class_id
    JOIN Payment py ON t.payment_id = py.payment_id
    WHERE t.schedule_id = p_schedule_id
      AND t.seat_id = p_seat_id
      AND t.ticket_status != 'Cancelled'
      AND py.payment_status = 'Success';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CancelTicket` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CancelTicket`(IN p_pnr VARCHAR(10))
BEGIN
    DECLARE v_seat_id INT;
    DECLARE v_schedule_id INT;
    DECLARE v_class_id INT;
    DECLARE v_payment_id INT;
    DECLARE v_rac_ticket VARCHAR(10);
    DECLARE v_waitlist_ticket VARCHAR(10);

    START TRANSACTION;

    -- Get ticket details
    SELECT seat_id, schedule_id, class_id, payment_id 
    INTO v_seat_id, v_schedule_id, v_class_id, v_payment_id
    FROM Ticket
    WHERE pnr = p_pnr;

    -- Delete the ticket
    DELETE FROM Ticket WHERE pnr = p_pnr;

    -- Update payment status and refund date
    UPDATE Payment 
    SET payment_status = 'Refunded',
        refund_date = CURRENT_TIMESTAMP
    WHERE payment_id = v_payment_id;

    IF v_seat_id IS NOT NULL THEN
        -- Find first RAC ticket to upgrade
        SELECT pnr INTO v_rac_ticket
        FROM Ticket
        WHERE schedule_id = v_schedule_id
          AND class_id = v_class_id
          AND ticket_status = 'RAC'
        ORDER BY booking_date
        LIMIT 1;

        IF v_rac_ticket IS NOT NULL THEN
            -- Upgrade RAC to confirmed and assign the seat
            UPDATE Ticket
            SET seat_id = v_seat_id,
                ticket_status = 'Confirmed'
            WHERE pnr = v_rac_ticket;
        ELSE
            -- Find first waitlist ticket to upgrade to RAC
            SELECT pnr INTO v_waitlist_ticket
            FROM Ticket
            WHERE schedule_id = v_schedule_id
              AND class_id = v_class_id
              AND ticket_status = 'Waitlist'
            ORDER BY booking_date
            LIMIT 1;

            IF v_waitlist_ticket IS NOT NULL THEN
                UPDATE Ticket
                SET ticket_status = 'RAC'
                WHERE pnr = v_waitlist_ticket;
            END IF;
        END IF;
    END IF;

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CheckAvailability` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CheckAvailability`(
    IN train_num INT,
    IN journey_date DATE,
    IN class_num INT
)
BEGIN
    SELECT s.seat_id, s.seat_number, s.class_id
    FROM Seat s
    WHERE s.train_number = train_num
      AND s.class_id = class_num
      AND NOT EXISTS (
          SELECT 1 FROM Ticket t
          JOIN Schedule sch ON t.schedule_id = sch.schedule_id
          WHERE t.seat_id = s.seat_id
            AND sch.train_number = train_num
            AND sch.journey_date = journey_date
      );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `countTicketsByConcession` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `countTicketsByConcession`()
BEGIN
  SELECT
    p.concession,
    COUNT(*) AS ticket_count
  FROM Ticket AS tk
  JOIN Passenger AS p
    ON tk.passenger_id = p.passenger_id
  GROUP BY
    p.concession;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `FindBusiestRoute` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FindBusiestRoute`()
BEGIN
    SELECT s.station_name AS source, 
           d.station_name AS destination,
           COUNT(*) AS total_passengers
    FROM Ticket t
    JOIN Schedule sch ON t.schedule_id = sch.schedule_id
    JOIN Route r ON sch.route_id = r.route_id
    JOIN Station s ON r.source_station = s.station_code
    JOIN Station d ON r.destination_station = d.station_code
    GROUP BY r.route_id
    ORDER BY total_passengers DESC
    LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GenerateItemizedBill` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GenerateItemizedBill`(IN input_pnr VARCHAR(10))
BEGIN
    SELECT t.pnr, c.class_name, c.base_fare,
           CASE 
               WHEN p.concession = 'Senior Citizen' THEN c.base_fare * 0.4
               WHEN p.concession = 'Student' THEN c.base_fare * 0.35
               WHEN p.concession = 'Disabled' THEN c.base_fare * 0.5
               ELSE 0
           END AS concession_discount,
           (c.base_fare - 
           CASE 
               WHEN p.concession = 'Senior Citizen' THEN c.base_fare * 0.4
               WHEN p.concession = 'Student' THEN c.base_fare * 0.35
               WHEN p.concession = 'Disabled' THEN c.base_fare * 0.5
               ELSE 0
           END) AS final_amount
    FROM Ticket t
    JOIN Passenger p ON t.passenger_id = p.passenger_id
    JOIN Class c ON t.class_id = c.class_id
    WHERE t.pnr = input_pnr;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetCancellationRecords` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCancellationRecords`()
BEGIN
    SELECT t.pnr, p.full_name, py.amount, 
           (py.amount * 0.75) AS refund_amount,
           py.payment_status
    FROM Ticket t
    JOIN Payment py ON t.payment_id = py.payment_id
    JOIN Passenger p ON t.passenger_id = p.passenger_id
    WHERE t.ticket_status = 'Cancelled';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getFullyBookedTrains` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getFullyBookedTrains`(IN in_date DATE)
BEGIN
  SELECT
    tr.train_number,
    tr.train_name
  FROM Train AS tr
  JOIN (
    -- count confirmed tickets per train on that date
    SELECT
      s.train_number,
      COUNT(*) AS confirmed_count
    FROM Ticket AS tk
    JOIN Schedule AS s
      ON tk.schedule_id = s.schedule_id
    WHERE
      s.journey_date = in_date
      AND tk.ticket_status = 'Confirmed'
    GROUP BY
      s.train_number
  ) AS bk
    ON tr.train_number = bk.train_number
  JOIN (
    -- total seats per train
    SELECT
      train_number,
      COUNT(*) AS total_seats
    FROM Seat
    GROUP BY train_number
  ) AS ts
    ON tr.train_number = ts.train_number
  WHERE
    bk.confirmed_count >= ts.total_seats;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getMostBookedTrain` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getMostBookedTrain`(IN in_date DATE)
BEGIN
  SELECT
    tr.train_number,
    tr.train_name,
    COUNT(*) AS bookings
  FROM Ticket AS tk
  JOIN Schedule AS s
    ON tk.schedule_id = s.schedule_id
  JOIN Train AS tr
    ON s.train_number = tr.train_number
  WHERE
    s.journey_date = in_date
  GROUP BY
    tr.train_number,
    tr.train_name
  ORDER BY
    bookings DESC
  LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetPNRStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetPNRStatus`(IN input_pnr VARCHAR(10))
BEGIN
    SELECT t.pnr, t.ticket_status, tr.train_name,
           s.station_name AS source, d.station_name AS destination,
           sch.departure_time, sch.arrival_time, sch.journey_date,
           c.class_name, st.seat_number, py.payment_status
    FROM Ticket t
    JOIN Schedule sch ON t.schedule_id = sch.schedule_id
    JOIN Train tr ON sch.train_number = tr.train_number
    JOIN Route r ON sch.route_id = r.route_id
    JOIN Station s ON r.source_station = s.station_code
    JOIN Station d ON r.destination_station = d.station_code
    LEFT JOIN Seat st ON t.seat_id = st.seat_id
    JOIN Class c ON t.class_id = c.class_id
    JOIN Payment py ON t.payment_id = py.payment_id
    WHERE t.pnr = input_pnr;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetTotalRevenue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetTotalRevenue`(
    IN start_date DATE,
    IN end_date DATE
)
BEGIN
    SELECT 
        SUM(py.amount) AS total_revenue
    FROM Payment py
    JOIN Ticket t ON py.payment_id = t.payment_id
    JOIN Schedule sch ON t.schedule_id = sch.schedule_id
    WHERE py.payment_status = 'Success'
      AND sch.journey_date BETWEEN start_date AND end_date;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetTrainSchedule` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetTrainSchedule`(IN train_num INT)
BEGIN
    SELECT sch.journey_date,
           s.station_name AS source,
           d.station_name AS destination,
           sch.departure_time,
           sch.arrival_time
    FROM Schedule sch
    JOIN Route r ON sch.route_id = r.route_id
    JOIN Station s ON r.source_station = s.station_code
    JOIN Station d ON r.destination_station = d.station_code
    WHERE sch.train_number = train_num
    ORDER BY sch.journey_date;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetWaitlist` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetWaitlist`(
    IN in_schedule_id INT
)
BEGIN
    SELECT 
        p.full_name,
        t.pnr,
        t.booking_date
    FROM Ticket t
    JOIN Passenger p 
      ON t.passenger_id = p.passenger_id
    WHERE t.schedule_id    = in_schedule_id
      AND t.ticket_status  = 'Waitlist';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ListPassengers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ListPassengers`(
    IN in_schedule_id INT
)
BEGIN
    SELECT 
        p.full_name,
        t.pnr,
        c.class_name,
        t.ticket_status,
        s.seat_number
    FROM Ticket t
    JOIN Passenger p 
      ON t.passenger_id = p.passenger_id
    JOIN Class c 
      ON t.class_id = c.class_id
    LEFT JOIN Seat s 
      ON t.seat_id = s.seat_id
    WHERE t.schedule_id = in_schedule_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-23 20:42:33
