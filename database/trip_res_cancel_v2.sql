#This version also takes care of round trips

DROP PROCEDURE IF EXISTS trip_cancel;
DROP PROCEDURE IF EXISTS res_cancel;
DELIMITER //

#This is a procedure that removes a specific trip
#If it is the last/only remaining trip as part of a reservation, then it will remove the reservation too.


CREATE PROCEDURE trip_cancel(f_trip_id int)
MODIFIES SQL DATA
BEGIN

	DECLARE qty_trips INT; # used to test if we should delete corresponding reservation
	DECLARE f_reservation_id INT;
	DECLARE f_trip_train_id INT; # used  for increment seat procedure
	DECLARE f_trip_return_train_id INT; 
	DECLARE f_trip_return_trip_id INT;
	DECLARE f_fare_type INT;
	DECLARE f_trip_date DATE;
	DECLARE f_trip_return_date DATE;
	DECLARE f_trip_seg_start INT;
	DECLARE f_trip_seg_ends INT;
	DECLARE round_trip INT; #1 if roundtrip, 0 if not roundtrip

	SET f_reservation_id = (SELECT reservation_id from trips WHERE trip_id = f_trip_id);

	SET round_trip = (SELECT count(distinct trip_date) FROM trips WHERE reservation_id = f_reservation_id);
	SET round_trip = round_trip - 1;

	

	SET f_trip_train_id = (SELECT trip_train_id from trips WHERE trip_id = f_trip_id);
	SET f_trip_date = (SELECT trip_date from trips WHERE trip_id = f_trip_id);
	SET f_trip_seg_start = (SELECT trip_seg_start from trips WHERE trip_id = f_trip_id);
	SET f_trip_seg_ends = (SELECT trip_seg_ends from trips WHERE trip_id = f_trip_id);


	IF round_trip = 1 THEN
		
		SET f_fare_type = (SELECT fare_type from trips WHERE trip_id = f_trip_id);
		SET f_trip_return_date = (SELECT trip_date FROM trips WHERE reservation_id = f_reservation_id AND f_trip_date != trip_date group by trip_date) ;
		SET f_trip_return_trip_id = (SELECT trip_id from trips WHERE trip_id != f_trip_id AND reservation_id = f_reservation_id AND fare_type = f_fare_type AND trip_date = f_trip_return_date LIMIT 1);
		SET f_trip_return_train_id = (SELECT trip_train_id from trips WHERE trip_id = f_trip_return_trip_id);
		CALL free_seat_increment(f_trip_return_train_id , f_trip_return_date , f_trip_seg_start , f_trip_seg_ends , 1);
		DELETE FROM trips WHERE trip_id = f_trip_return_trip_id;

	END IF;

	# need to call delete command for the initial trip after the round_trip part
	# because you need to access information from the initial trip
	# If you delete the initial trip row, then you won't be able to determine f_fare_type
	CALL free_seat_increment(f_trip_train_id , f_trip_date , f_trip_seg_start , f_trip_seg_ends , 1);
	DELETE FROM trips WHERE trip_id = f_trip_id;


	SET qty_trips = (SELECT count(*) from trips WHERE reservation_id = f_reservation_id);
	IF qty_trips = 0 THEN

		DELETE FROM reservations WHERE reservation_id = f_reservation_id;

	END IF;


END//




CREATE PROCEDURE res_cancel(f_reservation_id int)
MODIFIES SQL DATA
#This is a procedure that deletes a reservation
# ALL linked trips will be cancelled too
BEGIN
	DECLARE qty_trips_initial INT; # used for increment seat procedure
	DECLARE qty_trips_return INT;
	DECLARE f_trip_train_id INT; # used  for increment seat procedure
	DECLARE f_trip_date DATE;
	DECLARE f_trip_return_date DATE;
	DECLARE f_trip_seg_start INT;
	DECLARE f_trip_seg_ends INT;
	DECLARE round_trip INT; #1 if roundtrip, 0 if not roundtrip

	SET round_trip = (SELECT count(distinct trip_date) FROM trips WHERE reservation_id = f_reservation_id);
	SET round_trip = round_trip - 1;

	SET f_trip_date = (SELECT trip_date FROM trips WHERE reservation_id = f_reservation_id group by trip_date order by trip_date limit 0,1);


	SET f_trip_train_id = (SELECT trip_train_id from trips WHERE reservation_id = f_reservation_id AND trip_date = f_trip_date LIMIT 1);

	SET f_trip_seg_start = (SELECT trip_seg_start from trips WHERE reservation_id = f_reservation_id AND trip_date = f_trip_date LIMIT 1);
	SET f_trip_seg_ends = (SELECT trip_seg_ends from trips WHERE reservation_id = f_reservation_id AND trip_date = f_trip_date LIMIT 1);

	SET qty_trips_initial = (SELECT count(*) from trips WHERE reservation_id = f_reservation_id and trip_date = f_trip_date);

	CALL free_seat_increment(f_trip_train_id , f_trip_date , f_trip_seg_start , f_trip_seg_ends , qty_trips_initial);


	IF round_trip = 1 THEN
		SET f_trip_return_date = (SELECT trip_date FROM trips WHERE reservation_id = f_reservation_id AND trip_date != f_trip_date group by trip_date) ; # select return trip date
		SET f_trip_train_id = (SELECT trip_train_id from trips WHERE reservation_id = f_reservation_id AND trip_date = f_trip_return_date LIMIT 1);
		SET f_trip_seg_start = (SELECT trip_seg_start from trips WHERE reservation_id = f_reservation_id AND trip_date = f_trip_return_date LIMIT 1);
		SET f_trip_seg_ends = (SELECT trip_seg_ends from trips WHERE reservation_id = f_reservation_id AND trip_date = f_trip_return_date LIMIT 1);

		SET qty_trips_return = (SELECT count(*) from trips WHERE reservation_id = f_reservation_id and trip_date = f_trip_return_date);
		CALL free_seat_increment(f_trip_train_id , f_trip_return_date , f_trip_seg_start , f_trip_seg_ends , qty_trips_return);

	END IF;

	DELETE FROM trips WHERE reservation_id = f_reservation_id;
	DELETE FROM reservations WHERE reservation_id = f_reservation_id;
	
	

END//


DELIMITER ;
