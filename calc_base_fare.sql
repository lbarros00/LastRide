DROP FUNCTION IF EXISTS calc_base_fare;
DELIMITER //

CREATE FUNCTION calc_base_fare(start_station int, end_station int)
RETURNS DECIMAL(7,2)

BEGIN

	DECLARE base_fare DECIMAL(7,2);
	DECLARE station_cursor INT;
	# Note: ALL Variables must be declared at very beginning beginning, before
	# the first variable is used. i.e. station_cursor must be declared before base_fare is initialized.



	IF start_station >25 THEN
		SET start_station = 25;
	END IF; 

	IF end_station > 25 THEN
		SET end_station = 25;
	END IF;

	IF start_station < 0 THEN
		SET start_station = 0;
	END IF; 

	IF end_station < 0 THEN
		SET end_station = 0;
	END IF;

	SET base_fare = 0.00;
	SET station_cursor = start_station;



	IF end_station>start_station THEN

		WHILE station_cursor < end_station DO
		SET base_fare = base_fare + (SELECT seg_fare FROM segments WHERE seg_n_end = station_cursor);
		SET station_cursor = station_cursor + 1;
		END WHILE;

	ELSE

		WHILE station_cursor > end_station DO
		SET base_fare = base_fare + (SELECT seg_fare FROM segments WHERE seg_s_end = station_cursor);
		SET station_cursor = station_cursor - 1;
		END WHILE;

	END IF;

	RETURN base_fare;



END//

DELIMITER ;
