DROP FUNCTION IF EXISTS calc_base_fare_seg;
DELIMITER //

CREATE FUNCTION calc_base_fare_seg(seg_start int, seg_end int)
RETURNS DECIMAL(7,2)

BEGIN

	DECLARE base_fare DECIMAL(7,2);
	DECLARE segment_cursor INT;
	# Note: ALL Variables must be declared at very beginning beginning, before
	# the first variable is used. i.e. station_cursor must be declared before base_fare is initialized.



	IF seg_start >24 THEN
		SET seg_start = 24;
	END IF; 

	IF seg_end > 24 THEN
		SET seg_end = 24;
	END IF;

	IF seg_start < 1 THEN
		SET seg_start = 1;
	END IF; 

	IF seg_end < 1 THEN
		SET seg_end = 1;
	END IF;

	SET base_fare = 0.00;
	SET segment_cursor = seg_start;



	IF seg_end >= seg_start THEN

		WHILE segment_cursor <= seg_end DO
		SET base_fare = base_fare + (SELECT seg_fare FROM segments WHERE segment_cursor = segment_id);
		SET segment_cursor = segment_cursor + 1;
		END WHILE;

	ELSE

		WHILE segment_cursor >= seg_end DO
		SET base_fare = base_fare + (SELECT seg_fare FROM segments WHERE segment_cursor = segment_id);
		SET segment_cursor = segment_cursor - 1;
		END WHILE;

	END IF;

RETURN base_fare;



END//

DELIMITER ;
