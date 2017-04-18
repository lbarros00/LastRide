DROP PROCEDURE IF EXISTS create_trip;
DELIMITER //

#This is a draft procedure for creating a trip and reservation
# Will change based on GUI

CREATE PROCEDURE create_trip(f_train_id int, f_trip_date DATE, 
							 f_trip_seg_start int, f_trip_seg_ends int, 
							 quantity int, f_paying_passenger_id INT,
							 f_card_number VARCHAR(16), f_billing_address varchar(100))
BEGIN

	DECLARE free_seat_bool BOOLEAN; 	#tests if we can make this reservation i.e. there are sufficient free seats
	DECLARE total_fare DECIMAL(7,2);
	DECLARE f_res_id INT; 				#dummy variable to store newly created reservation_id
	DECLARE currentdatetime DATETIME; 	#currentdatetime is used to help locate reservation_id (along with paying_passenger_id)
	DECLARE f_fare_type INT;
	DECLARE qtyloopcounter INT;

	SET total_fare = calc_base_fare_seg(f_trip_seg_start,f_trip_seg_ends); #initialize total_fare
	SET currentdatetime = CURRENT_TIMESTAMP();
	SET f_fare_type = 1; # will need to change this based on GUI
	SET qtyloopcounter = 0;

	# First we check if we are able to add this trip
	SET free_seat_bool = free_seat_check(f_train_id, f_trip_date,f_trip_seg_start,f_trip_seg_ends,quantity);


	IF free_seat_bool = 1 THEN

		 call free_seat_decrement(f_train_id, f_trip_date, f_trip_seg_start, f_trip_seg_ends, quantity); #decrease number of free seats


		 #Create reservation first as it becomes a foreign key to trips
		 INSERT INTO reservations (
		 	reservation_date,	paying_passenger_id,	card_number,	billing_address)
		 VALUES (
		 	currentdatetime, 	f_paying_passenger_id, 	f_card_number,	f_billing_address
		 	);


		 SET f_res_id = (SELECT reservation_id from reservations 
		 			WHERE (reservation_date = currentdatetime AND paying_passenger_id = f_paying_passenger_id));
		 #I'm going to assume that unless there's identity theft, only one person can make one reservation at give moment


		 WHILE qtyloopcounter < quantity DO

			 INSERT INTO trips (trip_date,
			 					trip_seg_start,trip_seg_ends,
			 					fare_type,
			 					fare,
			 					trip_train_id,
			 					reservation_id)
			 VALUES (f_trip_date,
			 		f_trip_seg_start,f_trip_seg_ends,
			 		f_fare_type, 
			 		total_fare, 
			 		f_train_id,
			 		f_res_id);

			 SET qtyloopcounter = qtyloopcounter + 1;

		 END WHILE;

	ELSE
		
		SELECT "NO FREE SEATS" ; # MYSQL will return this phrase if there were no free seats
	
	END IF; # IF statement that checks if there are free seats


END//

DELIMITER ;
