DROP FUNCTION IF EXISTS find_dest_arr_time;
DROP FUNCTION IF EXISTS find_station_name;
DROP PROCEDURE IF EXISTS show_trains;



DELIMITER //

CREATE FUNCTION find_dest_arr_time(f_train_id INT,f_station_id INT)
	RETURNS TIME
BEGIN
	DECLARE arrival_time TIME;
	SET arrival_time = (SELECT time_in from stops_at WHERE train_id = f_train_id AND f_station_id = station_id);
	RETURN arrival_time;
END//

CREATE FUNCTION find_station_name(f_station_id INT)
	RETURNS varchar(40)	
BEGIN
	DECLARE stat_name varchar(40)	;
	SET stat_name = (SELECT station_name from stations WHERE f_station_id = station_id);
	RETURN stat_name;
END//


/*
This is a draft procedure for showing available trains
 Will change based on GUI
Idea is for the user to input in

	Station_start;
	station_end;
	Date and time;
	# of people;

After being shown choices, users will select:
The user at some point will also have to input in:

paying_passenger_id;
fare_type;
payment credit card number;

*/

CREATE PROCEDURE show_trains(f_trip_date DATE, f_trip_time TIME,
							 f_station_start_name VARCHAR(40), f_station_end_name VARCHAR(40), 
							 f_quantity int 
							 )
BEGIN

DECLARE isweekdaybool BOOLEAN;
DECLARE f_direction BOOLEAN;
DECLARE trainqty INT; #Number that holds number of availabe trains 
DECLARE f_start_segment INT;
DECLARE f_end_segment INT;
DECLARE f_station_start INT;
DECLARE f_station_end INT;

SET f_station_start = (SELECT station_id FROM stations WHERE f_station_start_name = station_name);
SET f_station_end = (SELECT station_id FROM stations WHERE f_station_end_name = station_name);




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



/*
	Need to determine direction to exclude half of the incorrect trains
	Filter out trains based on M-F or SSH schedule
 	Need to find the earliest time that a train arrives at that station based on 
 	my desired time i.e. f_trip_date (look into stops_at table)
 	After obtaining this info, display later trains that day.
 	Of course, always check for seats_free along the way.
	
	SELECT * FROM stops_at WHERE time_in > TIME('2017-04-03 02:15:00') AND station_id = 4 AND train_id IN (SELECT train_id FROM `trains` WHERE (train_direction = 0 AND train_days = 0)) LIMIT 3;
	
	
*/


SELECT train_id, 
	sa.station_id as 'Origin', 
	st.station_name as 'Origin Station',
	f_station_end as 'Destination',

	find_station_name(f_station_end) as 'Destination Station',

	sa.time_out as 'Leaves At',
	find_dest_arr_time(train_id,f_station_end) as 'Arrival Time',
	calc_base_fare(f_station_start,f_station_end) as 'Base Fare'
 FROM stops_at sa inner join stations st ON sa.station_id = st.station_id 
 WHERE sa.time_in > f_trip_time AND sa.station_id = f_station_start AND
sa.train_id IN 
(SELECT t.train_id FROM trains t  WHERE free_seat_check(t.train_id,f_trip_date,f_start_segment,f_end_segment,f_quantity) AND (t.train_direction = f_direction AND t.train_days = isweekdaybool)

	 ) LIMIT 3;

/*
WORKING BELOW:

SELECT train_id, 
	station_id as 'Origin', 
	f_station_end as 'Destination', 
	time_out as 'Leaves At',
	find_dest_arr_time(train_id,f_station_end) as 'Arrival Time'
 FROM stops_at WHERE time_in > TIME(f_trip_date) AND station_id = f_station_start AND
train_id IN 
(SELECT train_id FROM `trains` WHERE free_seat_check(train_id,DATE(f_trip_date),f_start_segment,f_end_segment,f_quantity) AND (train_direction = f_direction AND train_days = isweekdaybool)

	 ) LIMIT 3;

*/


#need to check if free_seats available??? DONE
#need to check if you have at least three rows
#use a cursor?
#use LIMIT 1,1 to obtain the second row, LIMIT 2,1 to obtain 3rd row.

#Was thinking of storing values from select statement along with the other parameters (end station and quantity) in a temporary table, 
# We then call another procedure that grabs the info from this temporary table and also calls the create_trip procedure 

END//

DELIMITER ;
