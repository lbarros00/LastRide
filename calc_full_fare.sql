# This function determines the full fare for a single passenger type on a given date
# Decided to increase it by 1% per day up to 30% on the day of the travel

DROP FUNCTION IF EXISTS calc_full_fare;
DELIMITER //

CREATE FUNCTION calc_full_fare(f_trip_date DATE,f_fare_name varchar(20), f_base_fare DECIMAL(7,2) )
RETURNS DECIMAL(7,2)

BEGIN

	DECLARE full_fare DECIMAL(7,2);
	DECLARE currentdate DATE;
	DECLARE date_diff INT; 
	DECLARE percent_increase DECIMAL(7,2);
	DECLARE fare_discount DECIMAL(3,2);


	SET currentdate = date(now());
	SET date_diff = datediff(f_trip_date,date(now()));

	IF date_diff > 30 THEN
		SET date_diff = 30 ;
	END IF;

	SET fare_discount = (SELECT rate from fare_types WHERE fare_name = f_fare_name );


	SET percent_increase = 0.01*(30-date_diff);
	SET full_fare = fare_discount*f_base_fare*(1+percent_increase);












	RETURN full_fare;



END//

DELIMITER ;