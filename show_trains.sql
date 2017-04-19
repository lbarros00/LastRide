DROP PROCEDURE IF EXISTS show_trains;
DELIMITER //

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

CREATE PROCEDURE show_trains(f_trip_date DATETIME, 
							 f_station_start int, f_station_end int, 
							 f_quantity int 
							 )
BEGIN

DECLARE isweekdaybool BOOLEAN;
DECLARE f_direction BOOLEAN;
DECLARE trainqty INT; #Number that holds number of availabe trains 
DECLARE f_start_segment INT;
DECLARE f_end_segment INT;


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


SET isweekdaybool = is_weekday(DATE(f_trip_date));

/*
	Need to determine direction to exclude half of the incorrect trains
	Filter out trains based on M-F or SSH schedule
 	Need to find the earliest time that a train arrives at that station based on 
 	my desired time i.e. f_trip_date (look into stops_at table)
 	After obtaining this info, display later trains that day.
 	Of course, always check for seats_free along the way.
	
	SELECT * FROM stops_at WHERE time_in > TIME('2017-04-03 02:15:00') AND station_id = 4 AND train_id IN (SELECT train_id FROM `trains` WHERE (train_direction = 0 AND train_days = 0)) LIMIT 3;
	
	
*/


SELECT * FROM stops_at WHERE time_in > TIME(f_trip_date) AND station_id = f_station_start AND
train_id IN 
(SELECT train_id FROM `trains` WHERE free_seat_check(train_id,DATE(f_trip_date),f_start_segment,f_end_segment,f_quantity) AND (train_direction = f_direction AND train_days = isweekdaybool)

	 ) LIMIT 3;

/*
IF trainqty > 3
	SET trainqty = 3;
END IF; # I only want to display three choices based on user input

*/


#need to check if free_seats available??? DONE
#need to check if you have at least three rows
#use a cursor?
#use LIMIT 1,1 to obtain the second row, LIMIT 2,1 to obtain 3rd row.

#Was thinking of storing values from select statement along with the other parameters (end station and quantity) in a temporary table, 
# We then call another procedure that grabs the info from this temporary table and also calls the create_trip procedure 

END//

DELIMITER ;
