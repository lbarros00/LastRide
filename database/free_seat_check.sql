DROP FUNCTION IF EXISTS free_seat_check;
DELIMITER //

CREATE FUNCTION free_seat_check(f_train_id int, f_seat_free_date DATE, start_segment int, end_segment int, quantity int)
RETURNS BOOLEAN
READS SQL DATA

BEGIN

	# start_segment is the starting segment, end_segment is the ending segment
	# quantity is the number of people we are checking for.

	DECLARE free_seat_bool BOOLEAN;
	DECLARE segment_cursor INT;
	DECLARE free_seats_left INT; # number of free seats left at a particular segment

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

	SET free_seat_bool = 0;
	SET segment_cursor = start_segment;



	IF end_segment >= start_segment THEN

		segmentloop: WHILE segment_cursor <= end_segment DO


			SET free_seats_left = (SELECT freeseat FROM seats_free WHERE (f_train_id = train_id AND segment_cursor = segment_id AND f_seat_free_date = seat_free_date ));
				
			IF free_seats_left >= quantity THEN
					SET free_seat_bool = 1;
				ELSE
					SET free_seat_bool = 0;
					LEAVE segmentloop;
			END IF;
			SET segment_cursor = segment_cursor + 1;

		END WHILE;

	ELSE

		segmentloop2: WHILE segment_cursor >= end_segment DO

			SET free_seats_left = (SELECT freeseat FROM seats_free WHERE (f_train_id = train_id AND segment_cursor = segment_id AND f_seat_free_date = seat_free_date ));
				
			IF free_seats_left >= quantity THEN
					SET free_seat_bool = 1;
				ELSE
					SET free_seat_bool = 0;
					LEAVE segmentloop2;
			END IF;
			SET segment_cursor = segment_cursor - 1;
			

		END WHILE;
		

	END IF;

	RETURN free_seat_bool;



END//

DELIMITER ;
