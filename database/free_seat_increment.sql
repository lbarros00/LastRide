DROP PROCEDURE IF EXISTS free_seat_increment;
DELIMITER //

CREATE PROCEDURE free_seat_increment(f_train_id int, f_seat_free_date DATE, start_segment int, end_segment int, quantity int)
MODIFIES SQL DATA


BEGIN

	# start_station is the starting station, end_station is the ending station
	# quantity is the number of people we are checking for.

	
	DECLARE segment_cursor INT;
	DECLARE free_seats_left INT; # number of free seats left at a particular segment
	DECLARE max_free_seats INT;

	# Note: ALL Variables must be declared at very beginning beginning, before
	# the first variable is used. i.e. station_cursor must be declared before base_fare is initialized.

	IF start_segment >24 THEN
		SET start_segment = 24;
	END IF; 

	IF end_segment > 24 THEN
		SET end_segment = 24;
	END IF;

	IF start_segment < 1 THEN
		SET start_segment = 1;
	END IF; 

	IF end_segment < 1 THEN
		SET end_segment = 1;
	END IF;

	#SET free_seat_bool = 0;
	SET segment_cursor = start_segment;
	SET max_free_seats = 448;



	IF end_segment >= start_segment THEN

		segmentloop: WHILE segment_cursor <= end_segment DO


			SET free_seats_left = (SELECT freeseat FROM seats_free WHERE (f_train_id = train_id AND segment_cursor = segment_id AND f_seat_free_date = seat_free_date )) + quantity;
				IF free_seats_left > max_free_seats THEN
					SET free_seats_left = max_free_seats;
				END IF;

			UPDATE seats_free SET freeseat = free_seats_left WHERE (f_train_id = train_id AND segment_cursor = segment_id AND f_seat_free_date = seat_free_date );
			SET segment_cursor = segment_cursor + 1;

		END WHILE;

	 ELSE

		segmentloop2: WHILE segment_cursor >= end_segment DO

			SET free_seats_left = (SELECT freeseat FROM seats_free WHERE (f_train_id = train_id AND segment_cursor = segment_id AND f_seat_free_date = seat_free_date )) + quantity;
			IF free_seats_left > max_free_seats THEN
					SET free_seats_left = max_free_seats;
			END IF;
			UPDATE seats_free SET freeseat = free_seats_left WHERE (f_train_id = train_id AND segment_cursor = segment_id AND f_seat_free_date = seat_free_date );
			SET segment_cursor = segment_cursor - 1;
			

		END WHILE;
		

	END IF;

END//

DELIMITER ;
