#This version accounts for round trips and passenger types including pets
DROP PROCEDURE IF EXISTS create_trip_stations;
DELIMITER //

#This is a draft procedure for creating a trip and reservation
# This version takes inputs of stations instead of segments
# Will change based on GUI

CREATE PROCEDURE create_trip_stations(f_train_id int, f_trip_date DATE, 
							 f_station_start_name VARCHAR(40), f_station_end_name VARCHAR(40), 
							 f_qty_adult int,
							 f_qty_child int, 
							 f_qty_senior int, 
							 f_qty_military int , 
							 f_qty_pets int ,
							 f_paying_passenger_id INT,
							 f_card_number VARCHAR(16), f_billing_address varchar(100),
							 f_return_train_id int, f_return_trip_date DATE)
	NOT DETERMINISTIC
BEGIN


	DECLARE free_seat_bool_initial BOOLEAN; # True if there are free seats on the initial trip
	DECLARE free_seat_bool_return BOOLEAN; # True if there are free seats on the return trip
	DECLARE free_seat_bool BOOLEAN; 	#tests if we can make this reservation i.e. there are sufficient free seats
	DECLARE base_fare DECIMAL(7,2);
	DECLARE pet_surcharge_initial DECIMAL (7,2);
	DECLARE pet_surcharge_return DECIMAL (7,2);
	DECLARE f_res_id INT; 				#dummy variable to store newly created reservation_id
	DECLARE currentdatetime DATETIME; 	#currentdatetime is used to help locate reservation_id (along with paying_passenger_id)
	DECLARE f_fare_type INT;
	DECLARE qtyloopcounter INT;
	DECLARE f_trip_seg_start INT;
	DECLARE f_trip_seg_ends INT;
	DECLARE f_trip_station_start INT;
	DECLARE f_trip_station_ends INT;
	DECLARE f_quantity INT; #holds total number of people excluding pets

	SET f_trip_station_start = (SELECT station_id FROM stations WHERE f_station_start_name = station_name);
	SET f_trip_station_ends = (SELECT station_id FROM stations WHERE f_station_end_name = station_name);
	SET f_quantity = (f_qty_adult+f_qty_child+f_qty_senior+f_qty_military);


	#Check if user inputs erroneous information
	IF f_trip_station_start >25 THEN
		SET f_trip_station_start = 25;
	END IF; 

	IF f_trip_station_ends > 25 THEN
		SET f_trip_station_ends = 25;
	END IF;

	IF f_trip_station_start < 1 THEN
		SET f_trip_station_start = 1;
	END IF; 

	IF f_trip_station_ends < 1 THEN
		SET f_trip_station_ends = 1;
	END IF;



	IF f_trip_station_ends > f_trip_station_start THEN

		SET f_trip_seg_ends = f_trip_station_ends - 1;
		SET f_trip_seg_start = f_trip_station_start;

	END IF;


	IF f_trip_station_start > f_trip_station_ends THEN
		SET f_trip_seg_ends = f_trip_station_ends ;
		SET f_trip_seg_start = f_trip_station_start - 1;
	END IF;


	SET currentdatetime = CURRENT_TIMESTAMP();
	
	

	# First we check if we are able to add this trip
	SET free_seat_bool_initial = free_seat_check(f_train_id, f_trip_date,f_trip_seg_start,f_trip_seg_ends,f_quantity);

	# We also need to check for free seats on return trip of the round_trip
	# If it is not a roundtrip, then set the set the free_seat_bool_return to true

	IF ((f_return_train_id != '' AND f_return_train_id IS NOT NULL) AND (f_return_trip_date !='' AND f_return_trip_date IS NOT NULL)) THEN
			SET free_seat_bool_return = free_seat_check(f_return_train_id, f_return_trip_date,f_trip_seg_ends,f_trip_seg_start,f_quantity);
	ELSE
			SET free_seat_bool_return = 1;
	END IF;

	SET free_seat_bool = ( free_seat_bool_initial AND free_seat_bool_return);



	IF free_seat_bool = 1 AND (f_trip_station_ends != f_trip_station_start) THEN

		 call free_seat_decrement(f_train_id, f_trip_date, f_trip_seg_start, f_trip_seg_ends, f_quantity); #decrease number of free seats

		IF ((f_return_train_id != '' AND f_return_train_id IS NOT NULL) AND (f_return_trip_date !='' AND f_return_trip_date IS NOT NULL)) THEN
			call free_seat_decrement(f_return_train_id, f_return_trip_date, f_trip_seg_start, f_trip_seg_ends, f_quantity); #decrease number of free seats
		END IF;



		 IF (f_card_number IS NULL OR f_card_number = '') THEN

		 	SET f_card_number = (SELECT preferred_card_number from passengers WHERE passenger_id = f_paying_passenger_id);

		 END IF;

		 IF (f_billing_address IS NULL OR f_billing_address = '') THEN

		 	SET f_billing_address = (SELECT preferred_billing_address from passengers WHERE passenger_id = f_paying_passenger_id);

		 END IF;




		 #Create reservation first as it becomes a foreign key to trips
		 INSERT INTO reservations (
		 	reservation_date,	paying_passenger_id,	card_number,	billing_address)
		 VALUES (
		 	currentdatetime, 	f_paying_passenger_id, 	f_card_number,	f_billing_address
		 	);


		 SET f_res_id = (SELECT reservation_id from reservations 
		 			WHERE (reservation_date = currentdatetime AND paying_passenger_id = f_paying_passenger_id));
		 #I'm going to assume that unless there's identity theft, only one person can make one reservation at give moment


		SET base_fare = calc_base_fare(f_trip_station_start,f_trip_station_ends); #initialize base_fare

		SET f_fare_type = 5; #pets

		SET pet_surcharge_initial = f_qty_pets*(calc_full_fare(f_trip_date,f_fare_type,base_fare))/f_quantity;

		IF ((f_return_train_id != '' AND f_return_train_id IS NOT NULL) AND (f_return_trip_date !='' AND f_return_trip_date IS NOT NULL)) THEN
		 	SET pet_surcharge_return = f_qty_pets*(calc_full_fare(f_return_trip_date,f_fare_type,base_fare))/f_quantity;
		ELSE
		 	SET pet_surcharge_return = 0;
		END IF;



	


		SET qtyloopcounter = 0;
		SET f_fare_type = 1; # Set fare type to adults
		
		WHILE qtyloopcounter < f_qty_adult DO

			 INSERT INTO trips (trip_date,trip_seg_start,trip_seg_ends,fare_type,fare,trip_train_id,reservation_id)
			 VALUES (f_trip_date,f_trip_seg_start,f_trip_seg_ends,f_fare_type, 
			 		(calc_full_fare(f_trip_date,f_fare_type,base_fare)+pet_surcharge_initial), 
			 		f_train_id,f_res_id);
			 
			 IF ((f_return_train_id != '' AND f_return_train_id IS NOT NULL) AND (f_return_trip_date !='' AND f_return_trip_date IS NOT NULL)) THEN

			 	INSERT INTO trips (trip_date,trip_seg_start,trip_seg_ends,fare_type,fare,trip_train_id,reservation_id)
			 	VALUES (f_return_trip_date,f_trip_seg_ends,f_trip_seg_start,f_fare_type, 
			 		(calc_full_fare(f_return_trip_date,f_fare_type,base_fare)+pet_surcharge_return), 
			 		f_return_train_id,f_res_id);
			 END IF;

			 SET qtyloopcounter = qtyloopcounter + 1;


		END WHILE;





		SET qtyloopcounter = 0;
		SET f_fare_type = 2; # Set fare type to children
		
		WHILE qtyloopcounter < f_qty_child DO

			 INSERT INTO trips (trip_date,trip_seg_start,trip_seg_ends,fare_type,fare,trip_train_id,reservation_id)
			 VALUES (f_trip_date,f_trip_seg_start,f_trip_seg_ends,f_fare_type, 
			 		(calc_full_fare(f_trip_date,f_fare_type,base_fare)+pet_surcharge_initial), 
			 		f_train_id,f_res_id);
			 
			 IF ((f_return_train_id != '' AND f_return_train_id IS NOT NULL) AND (f_return_trip_date !='' AND f_return_trip_date IS NOT NULL)) THEN

			 	INSERT INTO trips (trip_date,trip_seg_start,trip_seg_ends,fare_type,fare,trip_train_id,reservation_id)
			 	VALUES (f_return_trip_date,f_trip_seg_ends,f_trip_seg_start,f_fare_type, 
			 		(calc_full_fare(f_return_trip_date,f_fare_type,base_fare)+pet_surcharge_return), 
			 		f_return_train_id,f_res_id);
			 END IF;

			 SET qtyloopcounter = qtyloopcounter + 1;


		END WHILE;


		SET qtyloopcounter = 0;
		SET f_fare_type = 3; # Set fare type to senior
		
		WHILE qtyloopcounter < f_qty_senior DO

			 INSERT INTO trips (trip_date,trip_seg_start,trip_seg_ends,fare_type,fare,trip_train_id,reservation_id)
			 VALUES (f_trip_date,f_trip_seg_start,f_trip_seg_ends,f_fare_type, 
			 		(calc_full_fare(f_trip_date,f_fare_type,base_fare)+pet_surcharge_initial), 
			 		f_train_id,f_res_id);
			 
			 IF ((f_return_train_id != '' AND f_return_train_id IS NOT NULL) AND (f_return_trip_date !='' AND f_return_trip_date IS NOT NULL)) THEN

			 	INSERT INTO trips (trip_date,trip_seg_start,trip_seg_ends,fare_type,fare,trip_train_id,reservation_id)
			 	VALUES (f_return_trip_date,f_trip_seg_ends,f_trip_seg_start,f_fare_type, 
			 		(calc_full_fare(f_return_trip_date,f_fare_type,base_fare)+pet_surcharge_return), 
			 		f_return_train_id,f_res_id);
			 END IF;

			 SET qtyloopcounter = qtyloopcounter + 1;

		 END WHILE;

		SET qtyloopcounter = 0;
		SET f_fare_type = 4; # Set fare type to senior


		 WHILE qtyloopcounter < f_qty_military DO

			 INSERT INTO trips (trip_date,trip_seg_start,trip_seg_ends,fare_type,fare,trip_train_id,reservation_id)
			 VALUES (f_trip_date,f_trip_seg_start,f_trip_seg_ends,f_fare_type, 
			 		(calc_full_fare(f_trip_date, f_fare_type,base_fare)+pet_surcharge_initial), 
			 		f_train_id,f_res_id);
			 
			 IF ((f_return_train_id != '' AND f_return_train_id IS NOT NULL) AND (f_return_trip_date !='' AND f_return_trip_date IS NOT NULL)) THEN

			 	INSERT INTO trips (trip_date,trip_seg_start,trip_seg_ends,fare_type,fare,trip_train_id,reservation_id)
			 	VALUES (f_return_trip_date,f_trip_seg_ends,f_trip_seg_start,f_fare_type, 
			 		(calc_full_fare(f_return_trip_date, f_fare_type, base_fare)+pet_surcharge_return), 
			 		f_return_train_id,f_res_id);
			 END IF;

			 SET qtyloopcounter = qtyloopcounter + 1;

		 END WHILE;



	ELSE
		
		SELECT "NO FREE SEATS" ; # MYSQL will return this phrase if there were no free seats
	
	END IF; # IF statement that checks if there are free seats


END//

DELIMITER ;
