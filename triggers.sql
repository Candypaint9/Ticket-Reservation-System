DELIMITER //

CREATE TRIGGER AfterTicketUpdate
AFTER UPDATE ON Ticket
FOR EACH ROW
BEGIN
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
END //


DELIMITER ;
