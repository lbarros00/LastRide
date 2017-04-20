DROP PROCEDURE IF EXISTS trip_cancel;
DROP PROCEDURE IF EXISTS res_cancel;
DELIMITER //

#This is a procedure that removes a specific trip
#If it is the last/only remaining trip as part of a reservation, then it will remove the reservation too.

CREATE PROCEDURE trip_cancel(f_trip_id int)
BEGIN

	DECLARE qty_trips INT;
	DECLARE f_reservation_id INT;

	SET f_reservation_id = (SELECT reservation_id from trips WHERE trip_id = f_trip_id);

	SET qty_trips = (SELECT count(*) from trips WHERE reservation_id = f_reservation_id);

	DELETE FROM trips WHERE trip_id = f_trip_id;

	IF qty_trips = 1 THEN

		DELETE FROM reservations WHERE reservation_id = f_reservation_id;

	END IF;


END//

CREATE PROCEDURE res_cancel(f_reservation_id int)
#This is a procedure that deletes a reservation
# ALL linked trips will be cancelled too
BEGIN
	DELETE FROM trips WHERE reservation_id = f_reservation_id;
	DELETE FROM reservations WHERE reservation_id = f_reservation_id;

END//


DELIMITER ;
