# The show trains procedure shows what trains are available
# based on the trip date, time, and quantity of passengers, and origin and destination.
# this version takes quantities of adults, children, etc
# It displays a maximum of three trains
# and also displays the true total fare based on 
# passenger type and date of trips


DROP FUNCTION IF EXISTS find_dest_arr_time;
DROP FUNCTION IF EXISTS find_station_name;
DROP PROCEDURE IF EXISTS show_trains;



DELIMITER //

CREATE FUNCTION find_dest_arr_time(f_train_id INT,f_station_id INT)
	RETURNS TIME
	READS SQL DATA
BEGIN
	DECLARE arrival_time TIME;
	SET arrival_time = (SELECT time_in from stops_at WHERE train_id = f_train_id AND f_station_id = station_id);
	RETURN arrival_time;
END//

CREATE FUNCTION find_station_name(f_station_id INT)
	RETURNS varchar(40)	
	READS SQL DATA
BEGIN
	DECLARE stat_name varchar(40)	;
	SET stat_name = (SELECT station_name from stations WHERE f_station_id = station_id);
	RETURN stat_name;
END//





CREATE PROCEDURE show_trains(f_trip_date DATE, f_trip_time TIME,
							 f_station_start_name VARCHAR(40), f_station_end_name VARCHAR(40), 
							 f_qty_adult int, f_qty_child int, f_qty_senior int, f_qty_military int , f_qty_pets int
							 )
	READS SQL DATA


#This function prototype takes station ids as inputs (instead of station names); useful for debugging
/* 
CREATE PROCEDURE show_trains(f_trip_date DATE, f_trip_time TIME,
							 f_station_start int, f_station_end int, 
							 f_qty_adult int, f_qty_child int, f_qty_senior int, f_qty_military int 
							 )
*/

BEGIN

DECLARE isweekdaybool BOOLEAN;
DECLARE f_direction BOOLEAN;
DECLARE trainqty INT; 			#Number that holds number of availabe trains 
DECLARE f_start_segment INT;
DECLARE f_end_segment INT;
DECLARE f_station_start INT;
DECLARE f_station_end INT;
DECLARE f_quantity INT; 		#holds total number of people

SET f_station_start = (SELECT station_id FROM stations WHERE f_station_start_name = station_name);
SET f_station_end = (SELECT station_id FROM stations WHERE f_station_end_name = station_name);

SET f_quantity = (f_qty_adult+f_qty_child+f_qty_senior+f_qty_military);




IF f_station_end >= f_station_start THEN /* made it equal to so that f_direction won't be uninitialized*/
	SET f_direction = 0; # SOUTHBOUND
ELSE
	SET f_direction = 1; # NORTHBOUND
END IF;


# Setting the end segments:

IF f_direction = 0 THEN
	SET f_start_segment = f_station_start ;
	SET f_end_segment = (f_station_end - 1) ;
ELSE
	SET f_start_segment = (f_station_start - 1);
	SET f_end_segment = f_station_end;
END IF;


SET isweekdaybool = is_weekday(f_trip_date);



	
		#Goal is to create temporary table to hold all possible trains that can make the trip
		# Then we remove those trains that fail the free_seat_check test.
	

	DROP TEMPORARY TABLE IF EXISTS possible_trains; #table that holds trains that can possibly make the trip
	CREATE TEMPORARY TABLE possible_trains ( f_train_id tinyint );

	INSERT INTO possible_trains  (SELECT sa.train_id FROM stops_at AS sa WHERE sa.time_in > f_trip_time
									 AND sa.station_id = f_station_start 
									 AND sa.train_id IN 
									 (SELECT t.train_id FROM trains t WHERE (t.train_direction = f_direction AND t.train_days = isweekdaybool)));

	DELETE FROM possible_trains WHERE (free_seat_check(f_train_id,f_trip_date,f_start_segment,f_end_segment,f_quantity)=0);

	

	



 SELECT sa.train_id, 
	sa.station_id as 'Origin', 
	find_station_name(f_station_start) as 'Origin Station',
	f_station_end as 'Destination',

	find_station_name(f_station_end) as 'Destination Station',

	time_out as 'Leaves At',

	find_dest_arr_time(train_id,f_station_end) as 'Arrival Time',
	f_quantity as 'Number of Passengers',
	calc_full_fare(f_trip_date, 1, calc_base_fare(f_station_start,f_station_end))*f_qty_adult + 
	calc_full_fare(f_trip_date, 2, calc_base_fare(f_station_start,f_station_end))*f_qty_child + 
	calc_full_fare(f_trip_date, 3, calc_base_fare(f_station_start,f_station_end))*f_qty_senior + 
	calc_full_fare(f_trip_date, 4, calc_base_fare(f_station_start,f_station_end))*f_qty_military +
	calc_full_fare(f_trip_date, 5, calc_base_fare(f_station_start,f_station_end))*f_qty_pets 
	as 'Total Fare'
	

 FROM stops_at sa inner join stations st ON sa.station_id = st.station_id 
 WHERE sa.time_in > f_trip_time AND sa.station_id = f_station_start AND sa.train_id IN (SELECT p.f_train_id FROM possible_trains p   ) ORDER BY sa.train_id LIMIT 3 ;


	DROP TEMPORARY TABLE IF EXISTS possible_trains;





END//

DELIMITER ;
