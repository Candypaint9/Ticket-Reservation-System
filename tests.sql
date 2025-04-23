-- call GetPNRStatus("PNR001");

-- call GetTrainSchedule("12002");

-- call CheckAvailability("12301", "2025-05-01", 2);

-- call ListPassengers(1);

-- call GetWaitlist(3);

-- call GetTotalRevenue("2025-05-01", "2025-05-06");

-- call FindBusiestRoute();

-- call GenerateItemizedBill("PNR001");

-- call BookTicket("Aditya Mehrotra", 19, "Male", "Student", 1, 1, "Debit Card");

-- call CancelTicket("PNR678626");

-- call CalculateTrainCancellationRefund(1, 1);

CALL getFullyBookedTrains('2025-05-01');
CALL countTicketsByConcession();
CALL getMostBookedTrain('2025-05-01');