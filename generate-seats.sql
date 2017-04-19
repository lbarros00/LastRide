/* Create stored procedure to generate free seats. */

/* I have to look at the start date, then figure out the date 6 months
 * from then. Then, I have to generate one tuple for each element of the
* cross product of the dates in our interval of dates, each train (if the
	* train runs on that date), and each segment that the train runs on. */

DROP PROCEDURE IF EXISTS generate_free_seats;
DROP FUNCTION IF EXISTS is_weekday;

CREATE FUNCTION is_weekday(d date)
	RETURNS BOOLEAN
	RETURN dayofweek(d) between 2 and 6;


/* From the start date, generate a year's worth of seat information, six
 * months from the start date. This way, passengers have a chance to sign
 * up for seats. */

DELIMITER //
CREATE PROCEDURE generate_free_seats(in start_date date)
begin
	/* DECLARE start_date date DEFAULT CURDATE() */
	DECLARE end_date date;
	DECLARE curdate date;
	DECLARE time_shift INT;
	DECLARE interval_length INT;
	SET time_shift = 6;
	SET interval_length = 12;
	SET curdate = DATE_ADD(start_date, INTERVAL time_shift MONTH);
	SET end_date = DATE_ADD(curdate, INTERVAL interval_length MONTH);

	/* Since we're generating new info, clear out old info. */
	TRUNCATE TABLE seats_free;

	/* Create a table of dates */
	DROP TEMPORARY TABLE IF EXISTS dates;
	CREATE TEMPORARY TABLE dates ( dates date );
	WHILE curdate <= end_date DO
		INSERT INTO dates (dates) VALUES (curdate);
		SET curdate = DATE_ADD(curdate, INTERVAL 1 DAY);
	END WHILE;

	/* The entires in seats_free is the cross product of dates, segments
	 * and trains, such that the train runs on the date and the train travels   * that segment.
	 */
	INSERT INTO seats_free (train_id, segment_id, seat_free_date)
		SELECT tr.train_id, se.segment_id, d.dates FROM trains tr
			JOIN segments se ON
				se.seg_n_end BETWEEN tr.train_start AND tr.train_end
				AND 
				se.seg_s_end BETWEEN tr.train_start AND tr.train_end
			JOIN dates d ON
				(is_weekday(d.dates) AND  tr.train_days)
				OR
				( is_weekday(d.dates) AND tr.train_days)
/*
				(is_weekday(d.dates) AND NOT tr.train_days)
				OR
				(NOT is_weekday(d.dates) AND tr.train_days)*/ #Original; changed by TQ on 2017-04-19
			;

	DROP TEMPORARY TABLE IF EXISTS dates;

END//

DELIMITER ;
