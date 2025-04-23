-- Stations
INSERT INTO Station (station_code, station_name, city) VALUES
('NDLS', 'New Delhi',       'New Delhi'),
('BCT',  'Mumbai Central',  'Mumbai'),
('HWH',  'Howrah',          'Kolkata'),
('MAS',  'Chennai Central', 'Chennai'),
('BLR',  'Bangalore City',  'Bengaluru');
	
-- Routes (auto‑incremented route_id = 1,2,3)
INSERT INTO Route (source_station, destination_station) VALUES
('NDLS', 'BCT'),
('NDLS', 'HWH'),
('MAS',  'BLR');

-- Trains
INSERT INTO Train (train_number, train_name) VALUES
(12301, 'New Delhi – Mumbai Rajdhani Express'),
(12002, 'New Delhi – Bhopal Shatabdi Express'),
(12215, 'Howrah – Chennai Mail'),
(12627, 'Bangalore – Chennai Shatabdi Express');

-- Schedules (auto‑incremented schedule_id = 1–4)
INSERT INTO Schedule (train_number, route_id, departure_time, arrival_time, journey_date) VALUES
(12301, 1, '16:00:00', '08:00:00', '2025-05-01'),
(12002, 1, '06:00:00', '12:30:00', '2025-05-02'),
(12215, 2, '22:00:00', '10:00:00', '2025-05-03'),
(12627, 3, '07:30:00', '17:00:00', '2025-05-04');

-- Classes (auto‑incremented class_id = 1–5)
INSERT INTO Class (class_name, base_fare) VALUES
('SL',  500.00),   -- Sleeper
('3A', 1500.00),   -- AC 3-Tier
('2A', 2000.00),   -- AC 2-Tier
('1A', 3000.00),   -- AC First Class
('CC', 1000.00);   -- AC Chair Car

-- Seats (auto‑incremented seat_id = 1–10)
INSERT INTO Seat (train_number, class_id, seat_number) VALUES
(12301, 1, 'SL1'),
(12301, 1, 'SL2'),
(12301, 1, 'SL3'),
(12301, 1, 'SL4'),
(12301, 1, 'SL5'),
(12301, 2, '3A1'),
(12301, 2, '3A2'),
(12301, 3, '2A1'),
(12002, 5, 'CC1'),
(12002, 5, 'CC2'),
(12002, 5, 'CC3'),
(12002, 5, 'CC4'),
(12002, 5, 'CC5'),
(12215, 1, 'SL2'),
(12215, 4, '1A1'),
(12627, 5, 'CC3'),
(12627, 5, 'CC4');

-- Passengers (auto‑incremented passenger_id = 1–4)
INSERT INTO Passenger (full_name, age, gender, concession) VALUES
('Rahul Sharma', 28, 'Male',   'None'),
('Priya Singh', 65, 'Female', 'Senior Citizen'),
('Amit Kumar',   22, 'Male',   'Student'),
('Suman Rao',    30, 'Female', 'None');

-- Payments (auto‑incremented payment_id = 1–3)
INSERT INTO Payment (amount, payment_mode, payment_status, payment_date) VALUES
(1500.00, 'UPI',         'Success', '2025-04-10 10:30:00'),
(3000.00, 'Credit Card', 'Pending', '2025-04-11 15:45:00'),
(1000.00, 'Debit Card',  'Success', '2025-04-12 09:20:00'),
(1000.00, 'Debit Card',  'Success', '2025-04-12 10:10:00');

-- Tickets
--   (pnr, passenger_id, schedule_id, seat_id, class_id, ticket_status, payment_id)
INSERT INTO Ticket (pnr,    passenger_id, schedule_id, seat_id, class_id, ticket_status, payment_id) VALUES
('PNR001',          1,           1,           2,       2,       'Confirmed',     1),
('PNR002',          2,           2,           5,       5,       'Confirmed',     2),
('PNR003',          3,           3,           7,       1,       'Waitlist',      3),
('PNR004',          4,           4,          10,       5,       'RAC',           4);
