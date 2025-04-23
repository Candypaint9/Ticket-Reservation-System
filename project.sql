-- Create Database
CREATE DATABASE IF NOT EXISTS IndianRailway;
USE IndianRailway;

-- Station Table
CREATE TABLE Station (
    station_code VARCHAR(5) PRIMARY KEY,
    station_name VARCHAR(50) NOT NULL,
    city VARCHAR(30) NOT NULL
);

-- Routes Table
CREATE TABLE Route (
    route_id INT PRIMARY KEY AUTO_INCREMENT,
    source_station VARCHAR(5) NOT NULL,
    destination_station VARCHAR(5) NOT NULL,
    FOREIGN KEY (source_station) REFERENCES Station(station_code),
    FOREIGN KEY (destination_station) REFERENCES Station(station_code)
);

-- Trains Table (Physical Trains)
CREATE TABLE Train (
    train_number INT PRIMARY KEY,
    train_name VARCHAR(50) NOT NULL UNIQUE
);

-- Schedule Table (Timetable for train operations)
CREATE TABLE Schedule (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    train_number INT NOT NULL,
    route_id INT NOT NULL,
    departure_time TIME NOT NULL,
    arrival_time TIME NOT NULL,
    journey_date DATE NOT NULL,
    FOREIGN KEY (train_number) REFERENCES Train(train_number),
    FOREIGN KEY (route_id) REFERENCES Route(route_id)
);

-- Class Table
CREATE TABLE Class (
    class_id INT PRIMARY KEY AUTO_INCREMENT,
    class_name VARCHAR(20) NOT NULL UNIQUE,
    base_fare DECIMAL(8,2) NOT NULL
);

-- Seat Table (Physical seats in trains)
CREATE TABLE Seat (
    seat_id INT PRIMARY KEY AUTO_INCREMENT,
    train_number INT NOT NULL,
    class_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    FOREIGN KEY (train_number) REFERENCES Train(train_number),
    FOREIGN KEY (class_id) REFERENCES Class(class_id)
);

-- Passenger Table
CREATE TABLE Passenger (
    passenger_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    gender ENUM('Male', 'Female', 'Other'),
    concession ENUM('None', 'Senior Citizen', 'Student', 'Disabled') DEFAULT 'None'
);

-- Payment Table
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    amount DECIMAL(10,2) NOT NULL,
    payment_mode ENUM('Credit Card', 'Debit Card', 'UPI', 'Net Banking', 'Cash') NOT NULL,
    payment_status ENUM('Success', 'Pending', 'Failed') DEFAULT 'Pending',
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Ticket Table
CREATE TABLE Ticket (
    pnr VARCHAR(10) PRIMARY KEY,
    passenger_id INT NOT NULL,
    schedule_id INT NOT NULL,
    seat_id INT,
    class_id INT NOT NULL,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ticket_status ENUM('Confirmed', 'RAC', 'Waitlist') NOT NULL,
    payment_id INT NOT NULL,
    FOREIGN KEY (passenger_id) REFERENCES Passenger(passenger_id),
    FOREIGN KEY (schedule_id) REFERENCES Schedule(schedule_id),
    FOREIGN KEY (seat_id) REFERENCES Seat(seat_id),
    FOREIGN KEY (class_id) REFERENCES Class(class_id),
    FOREIGN KEY (payment_id) REFERENCES Payment(payment_id)
);

DELIMITER //

-- 1. PNR Status Tracking
CREATE PROCEDURE GetPNRStatus(IN input_pnr VARCHAR(10))
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
END //

-- 2. Train Schedule Lookup
CREATE PROCEDURE GetTrainSchedule(IN train_num INT)
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
END //

-- 3. Available Seats Query
CREATE PROCEDURE CheckAvailability(
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
END //

-- 4. List Passengers on Train
CREATE PROCEDURE ListPassengers(
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
END //

-- 5. Waitlisted Passengers
CREATE PROCEDURE GetWaitlist(
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
END //

-- 6. Train Cancellation Refund
CREATE PROCEDURE CalculateTrainCancellationRefund(
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
END //

-- 7. Total Revenue
CREATE PROCEDURE GetTotalRevenue(
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
END //

-- 8. Cancellation Records
CREATE PROCEDURE GetCancellationRecords()
BEGIN
    SELECT t.pnr, p.full_name, py.amount, 
           (py.amount * 0.75) AS refund_amount,
           py.payment_status
    FROM Ticket t
    JOIN Payment py ON t.payment_id = py.payment_id
    JOIN Passenger p ON t.passenger_id = p.passenger_id
    WHERE t.ticket_status = 'Cancelled';
END //

-- 9. Busiest Route
CREATE PROCEDURE FindBusiestRoute()
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
END //

-- 10. Itemized Bill
CREATE PROCEDURE GenerateItemizedBill(IN input_pnr VARCHAR(10))
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
END //

-- Update Payment Table Structure
ALTER TABLE Payment 
ADD COLUMN refund_date DATETIME DEFAULT NULL,
MODIFY COLUMN payment_status ENUM('Success', 'Pending', 'Failed', 'Refunded') DEFAULT 'Pending';

-- CancelTicket Procedure
CREATE PROCEDURE CancelTicket(IN p_pnr VARCHAR(10))
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
END //

DROP PROCEDURE IF EXISTS BookTicket;
//

CREATE PROCEDURE BookTicket(
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
END //

-- List all trains that are fully booked on a given date
CREATE PROCEDURE getFullyBookedTrains(IN in_date DATE)
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
END //

-- Number of tickets booked under each concession category
CREATE PROCEDURE countTicketsByConcession()
BEGIN
  SELECT
    p.concession,
    COUNT(*) AS ticket_count
  FROM Ticket AS tk
  JOIN Passenger AS p
    ON tk.passenger_id = p.passenger_id
  GROUP BY
    p.concession;
END //

-- Get the most booked train on a given date
CREATE PROCEDURE getMostBookedTrain(IN in_date DATE)
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
END //

DELIMITER ;


