DROP PROCEDURE IF EXISTS trip_cancel;
DROP PROCEDURE IF EXISTS res_cancel;
DELIMITER //

#This is a procedure that removes a specific trip
#If it is the last/only remaining trip as part of a reservation, then it will remove the reservation too.

CREATE PROCEDURE trip_cancel(f_trip_id int)
BEGIN

	DECLARE qty_trips INT; # used to test if we should delete corresponding reservation
	DECLARE f_reservation_id INT;
	DECLARE f_trip_train_id INT; # used  for increment seat procedure
	DECLARE f_trip_date DATE;
	DECLARE f_trip_seg_start INT;
	DECLARE f_trip_seg_ends INT;

	SET f_reservation_id = (SELECT reservation_id from trips WHERE trip_id = f_trip_id);

	SET qty_trips = (SELECT count(*) from trips WHERE reservation_id = f_reservation_id);

	SET f_trip_train_id = (SELECT trip_train_id from trips WHERE trip_id = f_trip_id);
	SET f_trip_date = (SELECT trip_date from trips WHERE trip_id = f_trip_id);
	SET f_trip_seg_start = (SELECT trip_seg_start from trips WHERE trip_id = f_trip_id);
	SET f_trip_seg_ends = (SELECT trip_seg_ends from trips WHERE trip_id = f_trip_id);

	CALL free_seat_increment(f_trip_train_id , f_trip_date , f_trip_seg_start , f_trip_seg_ends , 1);



	DELETE FROM trips WHERE trip_id = f_trip_id;

	IF qty_trips = 1 THEN

		DELETE FROM reservations WHERE reservation_id = f_reservation_id;

	END IF;


END//

CREATE PROCEDURE res_cancel(f_reservation_id int)
#This is a procedure that deletes a reservation
# ALL linked trips will be cancelled too
BEGIN
	DECLARE qty_trips INT; # used for increment seat procedure
	DECLARE f_trip_train_id INT; # used  for increment seat procedure
	DECLARE f_trip_date DATE;
	DECLARE f_trip_seg_start INT;
	DECLARE f_trip_seg_ends INT;

	SET qty_trips = (SELECT count(*) from trips WHERE reservation_id = f_reservation_id);

	SET f_trip_train_id = (SELECT trip_train_id from trips WHERE reservation_id = f_reservation_id LIMIT 1);
	SET f_trip_date = (SELECT trip_date 	from trips WHERE reservation_id = f_reservation_id LIMIT 1);
	SET f_trip_seg_start = (SELECT trip_seg_start from trips WHERE reservation_id = f_reservation_id LIMIT 1);
	SET f_trip_seg_ends = (SELECT trip_seg_ends from trips WHERE reservation_id = f_reservation_id LIMIT 1);

	CALL free_seat_increment(f_trip_train_id , f_trip_date , f_trip_seg_start , f_trip_seg_ends , qty_trips);

	DELETE FROM trips WHERE reservation_id = f_reservation_id;
	DELETE FROM reservations WHERE reservation_id = f_reservation_id;

END//


DELIMITER ;
