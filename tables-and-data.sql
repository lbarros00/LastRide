/* Table Definitions: {{{ *********************************/
/* train_id is foreign keys to train id */
/* segment_id is foreign keys to segment id */

CREATE TABLE trains (
	train_id INT PRIMARY KEY AUTO_INCREMENT,
	train_start INT NOT NULL,
	train_end INT NOT NULL,
	/* train_direction 0 is south, 1 is north */
	train_direction tinyint(1),
	/* 0 is a weekday train, 1 is a weekend train */
	train_days boolean
	);

CREATE TABLE stations (
	station_id INT(11) PRIMARY KEY AUTO_INCREMENT,
	station_name VARCHAR(40) NOT NULL,
	station_symbol CHAR(3) NOT NULL
	);

/* Stores information on registered passengers. */
CREATE TABLE passengers (
	passenger_id INT PRIMARY KEY AUTO_INCREMENT, 
	/* age INT, */
	fname varchar(30),
	lname varchar(100),
	email varchar(100),
	/* acct_name varchar(30), */
	password varchar(30), /* plaintext password */
	preferred_card_number varchar(16), /* at most 16 digit card numbers */
	preferred_billing_address varchar(100)
	);

CREATE TABLE segments (
	segment_id INT PRIMARY KEY AUTO_INCREMENT,
	seg_n_end INT NOT NULL, 
	seg_s_end INT NOT NULL,
	seg_fare DECIMAL(7,2) NOT NULL
	);

/* trip_seg_start and trip_seg_ends are foreign keys to segment_id */
/* trip_train_id is foreign keys to train_id */
/* reservation_id is foreign keys to reservation_id */
/* round_trip is foreign keys to trip_id */

CREATE TABLE trips (
    trip_id INT PRIMARY KEY AUTO_INCREMENT,
    trip_date DATE NOT NULL,
    trip_seg_start INT NOT NULL,
    trip_seg_ends INT NOT NULL,
    /* passenger_id INT NOT NULL, */
		fare_type INT NOT NULL, /* id of a fare_types table */
    fare DECIMAL(7,2) NOT NULL,
    trip_train_id INT NOT NULL, 
    reservation_id INT NOT NULL
    );

create table fare_types (
	fare_id INT PRIMARY KEY AUTO_INCREMENT,
	fare_name varchar(20),
	rate DECIMAL(3,2) /* A percentage */
)

CREATE TABLE seats_free (
    train_id INT NOT NULL,
    segment_id INT NOT NULL,
    seat_free_date DATE NOT NULL,
    freeseat INT NOT NULL DEFAULT 448
    );

CREATE TABLE stops_at (
	train_id INT NOT NULL,
	station_id INT NOT NULL,
	time_in TIME,
	time_out TIME
	);

/* Number of passengers should probably be in a view or something. Having
 * that data available here is duplicating data. */

CREATE TABLE reservations (
	reservation_id INT PRIMARY KEY AUTO_INCREMENT,
	paying_passenger_id INT NOT NULL,
	card_number varchar(16),
	billing_address varchar(100)
	);

/* }}} ****************************************************/

/* Data: {{{ **********************************************/

/* Passengers Data: {{{{ **********************************/

INSERT INTO passengers 
	(fname, lname, email, password,
		preferred_card_number, preferred_billing_address)
	VALUES (Garry, McCullough,
		Jonathon.Steuber21@gmail.com, ko5kJTG_6MWlkg_, 8850136093369684,
		'4558 Buckridge Hills, West Ebbachester, KY, 34770-0745');
INSERT INTO passengers 
	(fname, lname, email, password,
		preferred_card_number, preferred_billing_address)
	VALUES (Chyna, McClure,
		Zaria_OKeefe24@gmail.com, E0By2jrmfFNnUym, 3456375736386266,
		'362 Elna Radial, West Alvenastad, RI, 85964-8503');
INSERT INTO passengers 
	(fname, lname, email, password,
		preferred_card_number, preferred_billing_address)
	VALUES (Skye, Leffler,
		Johnny.Roob@hotmail.com, J4uxNkspoqWJCiw, 7714146550679142,
		'67291 Lenny Mountain, Rashadhaven, SC, 56836-5814');
INSERT INTO passengers 
	(fname, lname, email, password,
		preferred_card_number, preferred_billing_address)
	VALUES (Lonnie, Shanahan,
		Nannie39@hotmail.com, n1sPwJqValWQWYS, 1084413397495258,
		'87429 Paxton Mission, North Tyriquestad, MD, 94303-3848');
INSERT INTO passengers 
	(fname, lname, email, password,
		preferred_card_number, preferred_billing_address)
	VALUES (Brisa, Dickens,
		Zack_Herman@yahoo.com, MRyiEfzsFWGFg_P, 9351028438406063,
		'060 Lisa Drives, Staceybury, VA, 44123');
INSERT INTO passengers 
	(fname, lname, email, password,
		preferred_card_number, preferred_billing_address)
	VALUES (Mara, Howe,
		Dejon23@yahoo.com, UFB_G9_9qbILQ1p, 7515120697631151,
		'359 Kulas Drives, Willmsfort, ME, 18681-8700');
INSERT INTO passengers 
	(fname, lname, email, password,
		preferred_card_number, preferred_billing_address)
	VALUES (Emerson, Durgan,
		Alvena.Spencer@gmail.com, gmRpaCB4lmly7SO, 5740417469896007,
		'1847 Newell Extension, Kinghaven, FL, 11877');
INSERT INTO passengers 
	(fname, lname, email, password,
		preferred_card_number, preferred_billing_address)
	VALUES (Favian, Stark,
		Chad_Kassulke40@gmail.com, VxljiMfU0qSJSR5, 1332421835815362,
		'74490 Paul Plains, Naderburgh, AZ, 08973');
INSERT INTO passengers 
	(fname, lname, email, password,
		preferred_card_number, preferred_billing_address)
	VALUES (Neva, Smith,
		Prudence_Kuhn@hotmail.com, KeX9n8BkBDksYqw, 7636365681461415,
		'73426 Schaefer Neck, New Victorfort, UT, 85301-8355');
INSERT INTO passengers 
	(fname, lname, email, password,
		preferred_card_number, preferred_billing_address)
	VALUES (Vella, Stark,
		Loyce.Blick52@hotmail.com, u9j87RenP26iv5K, 9905721403761062,
		'4271 Madyson Wall, Ullrichburgh, AZ, 96439');

/* }}} ****************************************************/

/* Fare Types: {{{ ****************************************/

INSERT INTO fare_types
	(fare_name, rate)
	VALUES ('adult', 1.00);
INSERT INTO fare_types
	(fare_name, rate)
	VALUES ('child', 0.50);
INSERT INTO fare_types
	(fare_name, rate)
	VALUES ('senior', 0.70);

/* }}} ****************************************************/

/* Stations Data: {{{ ******************************************/

INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Boston, MA - South Station','BOS');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Boston, MA - Back Bay Station','BBY');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Route 128, MA','RTE');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Providence, RI','PVD');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Kingston, RI','KIN');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Westerly,RI','WLY');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Mystic, CT','MYS');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('New London, CT','NLC');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Old Saybrook, CT','OSB');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Springfield, MA','SPG');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Windsor Locks, CT','WNL');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Windsor, CT','WND');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Hartford, CT','HFD');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Berlin, CT','BER');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Meriden, CT','MDN');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Wallingford, CT','WFD');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('New Haven, CT','NHV');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Bridgeport, CT','BRP');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Stamford, CT','STM');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('New Rochelle, NY','NRO');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('New York, NY - Penn Station','NYP');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Newark, NJ','NWK');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Newark Liberty Intl. Air., NJ','EWR');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Metro Park, NJ','MET');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Trenton, NJ','TRE');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Philadelphia, PA - 30th Street Station','PHL');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Wilmington, DE - J.R. Biden, Jr. Station','WIL');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Aberdeen, MD','ABE');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Baltimore, MD - Penn Station','BAL');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('BWI Marshall Airport, MD','BWI');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('New Carrollton, MD','NCR');
INSERT INTO stations 
	(station_name,station_symbol) 
	VALUES ('Washington, DC - Union Station','WAS');

/* }}} ****************************************************/

/* Train Data: {{{ ****************************************/

/* These are the M-F Southbound towards DC */
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (1,1,32,0,b'0111110');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (2,1,32,0,b'0111110');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (3,1,32,0,b'0111110');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (4,1,32,0,b'0111110');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (5,1,32,0,b'0111110');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (6,1,32,0,b'0111110');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (7,1,32,0,b'0111110');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (8,1,32,0,b'0111110');

/* These are the M-F Northbound towards Boston */
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (9,1,32,1,b'0111110');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (10,1,32,1,b'0111110');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (11,1,32,1,b'0111110');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (12,1,32,1,b'0111110');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (13,1,32,1,b'0111110');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (14,1,32,1,b'0111110');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (15,1,32,1,b'0111110');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (16,1,32,1,b'0111110');

/* These are the SaSu Southbound towards DC */
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (17,1,32,0,b'1000001');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (18,1,32,0,b'1000001');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (19,1,32,0,b'1000001');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (20,1,32,0,b'1000001');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (21,1,32,0,b'1000001');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (22,1,32,0,b'1000001');

/* These are the SaSu Northbound toward Boston */
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (23,1,32,1,b'1000001');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (24,1,32,1,b'1000001');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (25,1,32,1,b'1000001');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (26,1,32,1,b'1000001');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (27,1,32,1,b'1000001');
INSERT INTO trains 
	(train_id,train_start,train_end,train_direction,train_days) 
	VALUES (28,1,32,1,b'1000001');

/* }}} ****************************************************/

/* Segments Data: {{{ *************************************/

INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (1,2,2.82);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (2,3,4.70);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (3,4,11.75);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (4,5,9.87);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (5,6,6.11);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (6,7,5.17);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (7,8,7.05);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (8,9,8.93);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (9,17,15.51);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (10,11,8.46);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (11,12,2.35);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (12,13,4.70);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (13,14,5.17);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (14,15,3.76);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (15,16,3.29);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (16,17,23.97);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (17,18,10.34);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (18,19,12.69);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (19,20,9.87);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (20,21,13.63);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (21,22,7.99);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (22,23,2.35);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (23,24,6.11);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (24,25,10.81);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (25,26,12.69);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (26,27,9.87);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (27,28,12.69);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (28,29,11.75);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (29,30,6.11);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (30,31,6.58);
INSERT INTO segments (seg_n_end,seg_s_end,seg_fare) VALUES (31,32,7.05);

/* }}} ****************************************************/

/* Stops_at Data: {{{ *************************************/

/* trains 1-8 are M-F southbound, 9-16 are M-F northbound */
/* trains 17-22 are SSH southbound, 23-28 are SSH northbound */

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 1 ,' 06:25:00 ',' 06:30:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 2 ,' 06:36:00 ',' 06:41:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 3 ,' 06:51:00 ',' 06:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 4 ,' 07:21:00 ',' 07:26:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 5 ,' 07:47:00 ',' 07:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 6 ,' 08:05:00 ',' 08:10:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 7 ,' 08:21:00 ',' 08:26:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 8 ,' 08:41:00 ',' 08:46:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 9 ,' 09:05:00 ',' 09:10:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 10 ,' 09:43:00 ',' 09:48:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 11 ,' 10:10:00 ',' 10:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 12 ,' 10:42:00 ',' 10:47:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 13 ,' 11:08:00 ',' 11:13:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 14 ,' 11:42:00 ',' 11:47:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 15 ,' 12:04:00 ',' 12:09:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 16 ,' 12:14:00 ',' 12:19:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 17 ,' 12:32:00 ',' 12:37:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 18 ,' 13:00:00 ',' 13:05:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 19 ,' 13:32:00 ',' 13:37:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 20 ,' 13:58:00 ',' 14:03:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 21 ,' 14:30:00 ',' 14:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 22 ,' 15:00:00 ',' 15:05:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 23 ,' 15:18:00 ',' 15:23:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 24 ,' 15:37:00 ',' 15:42:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (1, 25 ,' 15:57:00 ',' 16:02:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 1 ,' 07:55:00 ',' 08:00:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 2 ,' 08:06:00 ',' 08:11:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 3 ,' 08:21:00 ',' 08:26:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 4 ,' 08:51:00 ',' 08:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 5 ,' 09:17:00 ',' 09:22:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 6 ,' 09:35:00 ',' 09:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 7 ,' 09:51:00 ',' 09:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 8 ,' 10:11:00 ',' 10:16:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 9 ,' 10:35:00 ',' 10:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 10 ,' 11:13:00 ',' 11:18:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 11 ,' 11:40:00 ',' 11:45:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 12 ,' 12:12:00 ',' 12:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 13 ,' 12:38:00 ',' 12:43:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 14 ,' 13:12:00 ',' 13:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 15 ,' 13:34:00 ',' 13:39:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 16 ,' 13:44:00 ',' 13:49:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 17 ,' 14:02:00 ',' 14:07:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 18 ,' 14:30:00 ',' 14:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 19 ,' 15:02:00 ',' 15:07:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 20 ,' 15:28:00 ',' 15:33:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 21 ,' 16:00:00 ',' 16:05:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 22 ,' 16:30:00 ',' 16:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 23 ,' 16:48:00 ',' 16:53:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 24 ,' 17:07:00 ',' 17:12:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (2, 25 ,' 17:27:00 ',' 17:32:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 1 ,' 09:25:00 ',' 09:30:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 2 ,' 09:36:00 ',' 09:41:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 3 ,' 09:51:00 ',' 09:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 4 ,' 10:21:00 ',' 10:26:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 5 ,' 10:47:00 ',' 10:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 6 ,' 11:05:00 ',' 11:10:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 7 ,' 11:21:00 ',' 11:26:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 8 ,' 11:41:00 ',' 11:46:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 9 ,' 12:05:00 ',' 12:10:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 10 ,' 12:43:00 ',' 12:48:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 11 ,' 13:10:00 ',' 13:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 12 ,' 13:42:00 ',' 13:47:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 13 ,' 14:08:00 ',' 14:13:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 14 ,' 14:42:00 ',' 14:47:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 15 ,' 15:04:00 ',' 15:09:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 16 ,' 15:14:00 ',' 15:19:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 17 ,' 15:32:00 ',' 15:37:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 18 ,' 16:00:00 ',' 16:05:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 19 ,' 16:32:00 ',' 16:37:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 20 ,' 16:58:00 ',' 17:03:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 21 ,' 17:30:00 ',' 17:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 22 ,' 18:00:00 ',' 18:05:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 23 ,' 18:18:00 ',' 18:23:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 24 ,' 18:37:00 ',' 18:42:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (3, 25 ,' 18:57:00 ',' 19:02:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 1 ,' 15:55:00 ',' 16:00:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 2 ,' 16:06:00 ',' 16:11:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 3 ,' 16:21:00 ',' 16:26:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 4 ,' 16:51:00 ',' 16:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 5 ,' 17:17:00 ',' 17:22:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 6 ,' 17:35:00 ',' 17:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 7 ,' 17:51:00 ',' 17:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 8 ,' 18:11:00 ',' 18:16:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 9 ,' 18:35:00 ',' 18:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 10 ,' 19:13:00 ',' 19:18:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 11 ,' 19:40:00 ',' 19:45:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 12 ,' 20:12:00 ',' 20:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 13 ,' 20:38:00 ',' 20:43:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 14 ,' 21:12:00 ',' 21:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 15 ,' 21:34:00 ',' 21:39:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 16 ,' 21:44:00 ',' 21:49:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 17 ,' 22:02:00 ',' 22:07:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 18 ,' 22:30:00 ',' 22:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 19 ,' 23:02:00 ',' 23:07:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 20 ,' 23:28:00 ',' 23:33:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 21 ,' 00:00:00 ',' 00:05:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 22 ,' 00:30:00 ',' 00:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 23 ,' 00:48:00 ',' 00:53:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 24 ,' 01:07:00 ',' 01:12:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (4, 25 ,' 01:27:00 ',' 01:32:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 1 ,' 17:25:00 ',' 17:30:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 2 ,' 17:36:00 ',' 17:41:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 3 ,' 17:51:00 ',' 17:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 4 ,' 18:21:00 ',' 18:26:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 5 ,' 18:47:00 ',' 18:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 6 ,' 19:05:00 ',' 19:10:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 7 ,' 19:21:00 ',' 19:26:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 8 ,' 19:41:00 ',' 19:46:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 9 ,' 20:05:00 ',' 20:10:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 10 ,' 20:43:00 ',' 20:48:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 11 ,' 21:10:00 ',' 21:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 12 ,' 21:42:00 ',' 21:47:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 13 ,' 22:08:00 ',' 22:13:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 14 ,' 22:42:00 ',' 22:47:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 15 ,' 23:04:00 ',' 23:09:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 16 ,' 23:14:00 ',' 23:19:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 17 ,' 23:32:00 ',' 23:37:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 18 ,' 00:00:00 ',' 00:05:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 19 ,' 00:32:00 ',' 00:37:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 20 ,' 00:58:00 ',' 01:03:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 21 ,' 01:30:00 ',' 01:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 22 ,' 02:00:00 ',' 02:05:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 23 ,' 02:18:00 ',' 02:23:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 24 ,' 02:37:00 ',' 02:42:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (5, 25 ,' 02:57:00 ',' 03:02:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 1 ,' 18:55:00 ',' 19:00:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 2 ,' 19:06:00 ',' 19:11:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 3 ,' 19:21:00 ',' 19:26:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 4 ,' 19:51:00 ',' 19:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 5 ,' 20:17:00 ',' 20:22:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 6 ,' 20:35:00 ',' 20:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 7 ,' 20:51:00 ',' 20:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 8 ,' 21:11:00 ',' 21:16:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 9 ,' 21:35:00 ',' 21:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 10 ,' 22:13:00 ',' 22:18:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 11 ,' 22:40:00 ',' 22:45:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 12 ,' 23:12:00 ',' 23:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 13 ,' 23:38:00 ',' 23:43:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 14 ,' 00:12:00 ',' 00:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 15 ,' 00:34:00 ',' 00:39:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 16 ,' 00:44:00 ',' 00:49:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 17 ,' 01:02:00 ',' 01:07:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 18 ,' 01:30:00 ',' 01:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 19 ,' 02:02:00 ',' 02:07:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 20 ,' 02:28:00 ',' 02:33:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 21 ,' 03:00:00 ',' 03:05:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 22 ,' 03:30:00 ',' 03:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 23 ,' 03:48:00 ',' 03:53:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 24 ,' 04:07:00 ',' 04:12:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (6, 25 ,' 04:27:00 ',' 04:32:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 1 ,' 20:25:00 ',' 20:30:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 2 ,' 20:36:00 ',' 20:41:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 3 ,' 20:51:00 ',' 20:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 4 ,' 21:21:00 ',' 21:26:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 5 ,' 21:47:00 ',' 21:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 6 ,' 22:05:00 ',' 22:10:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 7 ,' 22:21:00 ',' 22:26:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 8 ,' 22:41:00 ',' 22:46:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 9 ,' 23:05:00 ',' 23:10:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 10 ,' 23:43:00 ',' 23:48:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 11 ,' 00:10:00 ',' 00:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 12 ,' 00:42:00 ',' 00:47:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 13 ,' 01:08:00 ',' 01:13:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 14 ,' 01:42:00 ',' 01:47:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 15 ,' 02:04:00 ',' 02:09:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 16 ,' 02:14:00 ',' 02:19:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 17 ,' 02:32:00 ',' 02:37:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 18 ,' 03:00:00 ',' 03:05:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 19 ,' 03:32:00 ',' 03:37:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 20 ,' 03:58:00 ',' 04:03:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 21 ,' 04:30:00 ',' 04:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 22 ,' 05:00:00 ',' 05:05:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 23 ,' 05:18:00 ',' 05:23:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 24 ,' 05:37:00 ',' 05:42:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (7, 25 ,' 05:57:00 ',' 06:02:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 1 ,' 21:55:00 ',' 22:00:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 2 ,' 22:06:00 ',' 22:11:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 3 ,' 22:21:00 ',' 22:26:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 4 ,' 22:51:00 ',' 22:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 5 ,' 23:17:00 ',' 23:22:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 6 ,' 23:35:00 ',' 23:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 7 ,' 23:51:00 ',' 23:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 8 ,' 00:11:00 ',' 00:16:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 9 ,' 00:35:00 ',' 00:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 10 ,' 01:13:00 ',' 01:18:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 11 ,' 01:40:00 ',' 01:45:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 12 ,' 02:12:00 ',' 02:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 13 ,' 02:38:00 ',' 02:43:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 14 ,' 03:12:00 ',' 03:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 15 ,' 03:34:00 ',' 03:39:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 16 ,' 03:44:00 ',' 03:49:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 17 ,' 04:02:00 ',' 04:07:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 18 ,' 04:30:00 ',' 04:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 19 ,' 05:02:00 ',' 05:07:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 20 ,' 05:28:00 ',' 05:33:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 21 ,' 06:00:00 ',' 06:05:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 22 ,' 06:30:00 ',' 06:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 23 ,' 06:48:00 ',' 06:53:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 24 ,' 07:07:00 ',' 07:12:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (8, 25 ,' 07:27:00 ',' 07:32:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 1 ,' 06:25:00 ',' 06:30:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 2 ,' 06:45:00 ',' 06:50:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 3 ,' 07:04:00 ',' 07:09:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 4 ,' 07:22:00 ',' 07:27:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 5 ,' 07:52:00 ',' 07:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 6 ,' 08:24:00 ',' 08:29:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 7 ,' 08:50:00 ',' 08:55:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 8 ,' 09:22:00 ',' 09:27:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 9 ,' 09:50:00 ',' 09:55:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 10 ,' 10:08:00 ',' 10:13:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 11 ,' 10:18:00 ',' 10:23:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 12 ,' 10:40:00 ',' 10:45:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 13 ,' 11:14:00 ',' 11:19:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 14 ,' 11:40:00 ',' 11:45:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 15 ,' 12:12:00 ',' 12:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 16 ,' 12:39:00 ',' 12:44:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 17 ,' 13:17:00 ',' 13:22:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 18 ,' 13:41:00 ',' 13:46:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 19 ,' 14:01:00 ',' 14:06:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 20 ,' 14:17:00 ',' 14:22:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 21 ,' 14:35:00 ',' 14:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 22 ,' 15:01:00 ',' 15:06:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 23 ,' 15:31:00 ',' 15:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 24 ,' 15:46:00 ',' 15:51:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (9, 25 ,' 15:57:00 ',' 16:02:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 1 ,' 07:55:00 ',' 08:00:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 2 ,' 08:15:00 ',' 08:20:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 3 ,' 08:34:00 ',' 08:39:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 4 ,' 08:52:00 ',' 08:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 5 ,' 09:22:00 ',' 09:27:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 6 ,' 09:54:00 ',' 09:59:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 7 ,' 10:20:00 ',' 10:25:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 8 ,' 10:52:00 ',' 10:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 9 ,' 11:20:00 ',' 11:25:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 10 ,' 11:38:00 ',' 11:43:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 11 ,' 11:48:00 ',' 11:53:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 12 ,' 12:10:00 ',' 12:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 13 ,' 12:44:00 ',' 12:49:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 14 ,' 13:10:00 ',' 13:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 15 ,' 13:42:00 ',' 13:47:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 16 ,' 14:09:00 ',' 14:14:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 17 ,' 14:47:00 ',' 14:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 18 ,' 15:11:00 ',' 15:16:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 19 ,' 15:31:00 ',' 15:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 20 ,' 15:47:00 ',' 15:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 21 ,' 16:05:00 ',' 16:10:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 22 ,' 16:31:00 ',' 16:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 23 ,' 17:01:00 ',' 17:06:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 24 ,' 17:16:00 ',' 17:21:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (10, 25 ,' 17:27:00 ',' 17:32:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 1 ,' 09:25:00 ',' 09:30:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 2 ,' 09:45:00 ',' 09:50:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 3 ,' 10:04:00 ',' 10:09:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 4 ,' 10:22:00 ',' 10:27:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 5 ,' 10:52:00 ',' 10:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 6 ,' 11:24:00 ',' 11:29:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 7 ,' 11:50:00 ',' 11:55:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 8 ,' 12:22:00 ',' 12:27:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 9 ,' 12:50:00 ',' 12:55:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 10 ,' 13:08:00 ',' 13:13:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 11 ,' 13:18:00 ',' 13:23:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 12 ,' 13:40:00 ',' 13:45:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 13 ,' 14:14:00 ',' 14:19:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 14 ,' 14:40:00 ',' 14:45:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 15 ,' 15:12:00 ',' 15:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 16 ,' 15:39:00 ',' 15:44:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 17 ,' 16:17:00 ',' 16:22:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 18 ,' 16:41:00 ',' 16:46:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 19 ,' 17:01:00 ',' 17:06:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 20 ,' 17:17:00 ',' 17:22:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 21 ,' 17:35:00 ',' 17:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 22 ,' 18:01:00 ',' 18:06:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 23 ,' 18:31:00 ',' 18:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 24 ,' 18:46:00 ',' 18:51:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (11, 25 ,' 18:57:00 ',' 19:02:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 1 ,' 15:55:00 ',' 16:00:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 2 ,' 16:15:00 ',' 16:20:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 3 ,' 16:34:00 ',' 16:39:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 4 ,' 16:52:00 ',' 16:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 5 ,' 17:22:00 ',' 17:27:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 6 ,' 17:54:00 ',' 17:59:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 7 ,' 18:20:00 ',' 18:25:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 8 ,' 18:52:00 ',' 18:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 9 ,' 19:20:00 ',' 19:25:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 10 ,' 19:38:00 ',' 19:43:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 11 ,' 19:48:00 ',' 19:53:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 12 ,' 20:10:00 ',' 20:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 13 ,' 20:44:00 ',' 20:49:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 14 ,' 21:10:00 ',' 21:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 15 ,' 21:42:00 ',' 21:47:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 16 ,' 22:09:00 ',' 22:14:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 17 ,' 22:47:00 ',' 22:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 18 ,' 23:11:00 ',' 23:16:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 19 ,' 23:31:00 ',' 23:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 20 ,' 23:47:00 ',' 23:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 21 ,' 00:05:00 ',' 00:10:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 22 ,' 00:31:00 ',' 00:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 23 ,' 01:01:00 ',' 01:06:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 24 ,' 01:16:00 ',' 01:21:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (12, 25 ,' 01:27:00 ',' 01:32:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 1 ,' 17:25:00 ',' 17:30:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 2 ,' 17:45:00 ',' 17:50:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 3 ,' 18:04:00 ',' 18:09:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 4 ,' 18:22:00 ',' 18:27:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 5 ,' 18:52:00 ',' 18:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 6 ,' 19:24:00 ',' 19:29:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 7 ,' 19:50:00 ',' 19:55:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 8 ,' 20:22:00 ',' 20:27:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 9 ,' 20:50:00 ',' 20:55:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 10 ,' 21:08:00 ',' 21:13:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 11 ,' 21:18:00 ',' 21:23:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 12 ,' 21:40:00 ',' 21:45:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 13 ,' 22:14:00 ',' 22:19:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 14 ,' 22:40:00 ',' 22:45:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 15 ,' 23:12:00 ',' 23:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 16 ,' 23:39:00 ',' 23:44:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 17 ,' 00:17:00 ',' 00:22:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 18 ,' 00:41:00 ',' 00:46:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 19 ,' 01:01:00 ',' 01:06:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 20 ,' 01:17:00 ',' 01:22:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 21 ,' 01:35:00 ',' 01:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 22 ,' 02:01:00 ',' 02:06:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 23 ,' 02:31:00 ',' 02:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 24 ,' 02:46:00 ',' 02:51:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (13, 25 ,' 02:57:00 ',' 03:02:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 1 ,' 18:55:00 ',' 19:00:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 2 ,' 19:15:00 ',' 19:20:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 3 ,' 19:34:00 ',' 19:39:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 4 ,' 19:52:00 ',' 19:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 5 ,' 20:22:00 ',' 20:27:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 6 ,' 20:54:00 ',' 20:59:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 7 ,' 21:20:00 ',' 21:25:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 8 ,' 21:52:00 ',' 21:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 9 ,' 22:20:00 ',' 22:25:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 10 ,' 22:38:00 ',' 22:43:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 11 ,' 22:48:00 ',' 22:53:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 12 ,' 23:10:00 ',' 23:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 13 ,' 23:44:00 ',' 23:49:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 14 ,' 00:10:00 ',' 00:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 15 ,' 00:42:00 ',' 00:47:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 16 ,' 01:09:00 ',' 01:14:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 17 ,' 01:47:00 ',' 01:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 18 ,' 02:11:00 ',' 02:16:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 19 ,' 02:31:00 ',' 02:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 20 ,' 02:47:00 ',' 02:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 21 ,' 03:05:00 ',' 03:10:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 22 ,' 03:31:00 ',' 03:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 23 ,' 04:01:00 ',' 04:06:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 24 ,' 04:16:00 ',' 04:21:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (14, 25 ,' 04:27:00 ',' 04:32:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 1 ,' 20:25:00 ',' 20:30:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 2 ,' 20:45:00 ',' 20:50:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 3 ,' 21:04:00 ',' 21:09:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 4 ,' 21:22:00 ',' 21:27:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 5 ,' 21:52:00 ',' 21:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 6 ,' 22:24:00 ',' 22:29:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 7 ,' 22:50:00 ',' 22:55:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 8 ,' 23:22:00 ',' 23:27:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 9 ,' 23:50:00 ',' 23:55:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 10 ,' 00:08:00 ',' 00:13:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 11 ,' 00:18:00 ',' 00:23:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 12 ,' 00:40:00 ',' 00:45:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 13 ,' 01:14:00 ',' 01:19:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 14 ,' 01:40:00 ',' 01:45:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 15 ,' 02:12:00 ',' 02:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 16 ,' 02:39:00 ',' 02:44:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 17 ,' 03:17:00 ',' 03:22:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 18 ,' 03:41:00 ',' 03:46:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 19 ,' 04:01:00 ',' 04:06:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 20 ,' 04:17:00 ',' 04:22:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 21 ,' 04:35:00 ',' 04:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 22 ,' 05:01:00 ',' 05:06:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 23 ,' 05:31:00 ',' 05:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 24 ,' 05:46:00 ',' 05:51:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (15, 25 ,' 05:57:00 ',' 06:02:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 1 ,' 21:55:00 ',' 22:00:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 2 ,' 22:15:00 ',' 22:20:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 3 ,' 22:34:00 ',' 22:39:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 4 ,' 22:52:00 ',' 22:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 5 ,' 23:22:00 ',' 23:27:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 6 ,' 23:54:00 ',' 23:59:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 7 ,' 00:20:00 ',' 00:25:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 8 ,' 00:52:00 ',' 00:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 9 ,' 01:20:00 ',' 01:25:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 10 ,' 01:38:00 ',' 01:43:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 11 ,' 01:48:00 ',' 01:53:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 12 ,' 02:10:00 ',' 02:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 13 ,' 02:44:00 ',' 02:49:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 14 ,' 03:10:00 ',' 03:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 15 ,' 03:42:00 ',' 03:47:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 16 ,' 04:09:00 ',' 04:14:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 17 ,' 04:47:00 ',' 04:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 18 ,' 05:11:00 ',' 05:16:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 19 ,' 05:31:00 ',' 05:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 20 ,' 05:47:00 ',' 05:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 21 ,' 06:05:00 ',' 06:10:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 22 ,' 06:31:00 ',' 06:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 23 ,' 07:01:00 ',' 07:06:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 24 ,' 07:16:00 ',' 07:21:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (16, 25 ,' 07:27:00 ',' 07:32:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 1 ,' 07:55:00 ',' 08:00:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 2 ,' 08:06:00 ',' 08:11:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 3 ,' 08:21:00 ',' 08:26:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 4 ,' 08:51:00 ',' 08:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 5 ,' 09:17:00 ',' 09:22:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 6 ,' 09:35:00 ',' 09:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 7 ,' 09:51:00 ',' 09:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 8 ,' 10:11:00 ',' 10:16:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 9 ,' 10:35:00 ',' 10:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 10 ,' 11:13:00 ',' 11:18:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 11 ,' 11:40:00 ',' 11:45:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 12 ,' 12:12:00 ',' 12:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 13 ,' 12:38:00 ',' 12:43:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 14 ,' 13:12:00 ',' 13:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 15 ,' 13:34:00 ',' 13:39:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 16 ,' 13:44:00 ',' 13:49:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 17 ,' 14:02:00 ',' 14:07:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 18 ,' 14:30:00 ',' 14:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 19 ,' 15:02:00 ',' 15:07:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 20 ,' 15:28:00 ',' 15:33:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 21 ,' 16:00:00 ',' 16:05:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 22 ,' 16:30:00 ',' 16:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 23 ,' 16:48:00 ',' 16:53:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 24 ,' 17:07:00 ',' 17:12:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (17, 25 ,' 17:27:00 ',' 17:32:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 1 ,' 09:55:00 ',' 10:00:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 2 ,' 10:06:00 ',' 10:11:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 3 ,' 10:21:00 ',' 10:26:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 4 ,' 10:51:00 ',' 10:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 5 ,' 11:17:00 ',' 11:22:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 6 ,' 11:35:00 ',' 11:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 7 ,' 11:51:00 ',' 11:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 8 ,' 12:11:00 ',' 12:16:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 9 ,' 12:35:00 ',' 12:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 10 ,' 13:13:00 ',' 13:18:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 11 ,' 13:40:00 ',' 13:45:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 12 ,' 14:12:00 ',' 14:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 13 ,' 14:38:00 ',' 14:43:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 14 ,' 15:12:00 ',' 15:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 15 ,' 15:34:00 ',' 15:39:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 16 ,' 15:44:00 ',' 15:49:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 17 ,' 16:02:00 ',' 16:07:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 18 ,' 16:30:00 ',' 16:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 19 ,' 17:02:00 ',' 17:07:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 20 ,' 17:28:00 ',' 17:33:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 21 ,' 18:00:00 ',' 18:05:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 22 ,' 18:30:00 ',' 18:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 23 ,' 18:48:00 ',' 18:53:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 24 ,' 19:07:00 ',' 19:12:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (18, 25 ,' 19:27:00 ',' 19:32:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 1 ,' 11:55:00 ',' 12:00:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 2 ,' 12:06:00 ',' 12:11:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 3 ,' 12:21:00 ',' 12:26:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 4 ,' 12:51:00 ',' 12:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 5 ,' 13:17:00 ',' 13:22:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 6 ,' 13:35:00 ',' 13:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 7 ,' 13:51:00 ',' 13:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 8 ,' 14:11:00 ',' 14:16:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 9 ,' 14:35:00 ',' 14:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 10 ,' 15:13:00 ',' 15:18:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 11 ,' 15:40:00 ',' 15:45:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 12 ,' 16:12:00 ',' 16:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 13 ,' 16:38:00 ',' 16:43:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 14 ,' 17:12:00 ',' 17:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 15 ,' 17:34:00 ',' 17:39:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 16 ,' 17:44:00 ',' 17:49:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 17 ,' 18:02:00 ',' 18:07:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 18 ,' 18:30:00 ',' 18:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 19 ,' 19:02:00 ',' 19:07:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 20 ,' 19:28:00 ',' 19:33:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 21 ,' 20:00:00 ',' 20:05:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 22 ,' 20:30:00 ',' 20:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 23 ,' 20:48:00 ',' 20:53:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 24 ,' 21:07:00 ',' 21:12:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (19, 25 ,' 21:27:00 ',' 21:32:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 1 ,' 15:55:00 ',' 16:00:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 2 ,' 16:06:00 ',' 16:11:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 3 ,' 16:21:00 ',' 16:26:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 4 ,' 16:51:00 ',' 16:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 5 ,' 17:17:00 ',' 17:22:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 6 ,' 17:35:00 ',' 17:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 7 ,' 17:51:00 ',' 17:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 8 ,' 18:11:00 ',' 18:16:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 9 ,' 18:35:00 ',' 18:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 10 ,' 19:13:00 ',' 19:18:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 11 ,' 19:40:00 ',' 19:45:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 12 ,' 20:12:00 ',' 20:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 13 ,' 20:38:00 ',' 20:43:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 14 ,' 21:12:00 ',' 21:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 15 ,' 21:34:00 ',' 21:39:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 16 ,' 21:44:00 ',' 21:49:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 17 ,' 22:02:00 ',' 22:07:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 18 ,' 22:30:00 ',' 22:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 19 ,' 23:02:00 ',' 23:07:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 20 ,' 23:28:00 ',' 23:33:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 21 ,' 00:00:00 ',' 00:05:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 22 ,' 00:30:00 ',' 00:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 23 ,' 00:48:00 ',' 00:53:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 24 ,' 01:07:00 ',' 01:12:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (20, 25 ,' 01:27:00 ',' 01:32:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 1 ,' 17:55:00 ',' 18:00:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 2 ,' 18:06:00 ',' 18:11:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 3 ,' 18:21:00 ',' 18:26:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 4 ,' 18:51:00 ',' 18:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 5 ,' 19:17:00 ',' 19:22:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 6 ,' 19:35:00 ',' 19:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 7 ,' 19:51:00 ',' 19:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 8 ,' 20:11:00 ',' 20:16:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 9 ,' 20:35:00 ',' 20:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 10 ,' 21:13:00 ',' 21:18:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 11 ,' 21:40:00 ',' 21:45:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 12 ,' 22:12:00 ',' 22:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 13 ,' 22:38:00 ',' 22:43:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 14 ,' 23:12:00 ',' 23:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 15 ,' 23:34:00 ',' 23:39:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 16 ,' 23:44:00 ',' 23:49:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 17 ,' 00:02:00 ',' 00:07:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 18 ,' 00:30:00 ',' 00:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 19 ,' 01:02:00 ',' 01:07:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 20 ,' 01:28:00 ',' 01:33:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 21 ,' 02:00:00 ',' 02:05:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 22 ,' 02:30:00 ',' 02:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 23 ,' 02:48:00 ',' 02:53:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 24 ,' 03:07:00 ',' 03:12:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (21, 25 ,' 03:27:00 ',' 03:32:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 1 ,' 19:55:00 ',' 20:00:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 2 ,' 20:06:00 ',' 20:11:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 3 ,' 20:21:00 ',' 20:26:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 4 ,' 20:51:00 ',' 20:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 5 ,' 21:17:00 ',' 21:22:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 6 ,' 21:35:00 ',' 21:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 7 ,' 21:51:00 ',' 21:56:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 8 ,' 22:11:00 ',' 22:16:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 9 ,' 22:35:00 ',' 22:40:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 10 ,' 23:13:00 ',' 23:18:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 11 ,' 23:40:00 ',' 23:45:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 12 ,' 00:12:00 ',' 00:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 13 ,' 00:38:00 ',' 00:43:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 14 ,' 01:12:00 ',' 01:17:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 15 ,' 01:34:00 ',' 01:39:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 16 ,' 01:44:00 ',' 01:49:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 17 ,' 02:02:00 ',' 02:07:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 18 ,' 02:30:00 ',' 02:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 19 ,' 03:02:00 ',' 03:07:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 20 ,' 03:28:00 ',' 03:33:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 21 ,' 04:00:00 ',' 04:05:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 22 ,' 04:30:00 ',' 04:35:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 23 ,' 04:48:00 ',' 04:53:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 24 ,' 05:07:00 ',' 05:12:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (22, 25 ,' 05:27:00 ',' 05:32:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 1 ,' 07:55:00 ',' 08:00:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 2 ,' 08:15:00 ',' 08:20:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 3 ,' 08:34:00 ',' 08:39:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 4 ,' 08:52:00 ',' 08:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 5 ,' 09:22:00 ',' 09:27:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 6 ,' 09:54:00 ',' 09:59:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 7 ,' 10:20:00 ',' 10:25:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 8 ,' 10:52:00 ',' 10:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 9 ,' 11:20:00 ',' 11:25:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 10 ,' 11:38:00 ',' 11:43:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 11 ,' 11:48:00 ',' 11:53:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 12 ,' 12:10:00 ',' 12:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 13 ,' 12:44:00 ',' 12:49:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 14 ,' 13:10:00 ',' 13:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 15 ,' 13:42:00 ',' 13:47:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 16 ,' 14:09:00 ',' 14:14:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 17 ,' 14:47:00 ',' 14:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 18 ,' 15:11:00 ',' 15:16:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 19 ,' 15:31:00 ',' 15:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 20 ,' 15:47:00 ',' 15:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 21 ,' 16:05:00 ',' 16:10:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 22 ,' 16:31:00 ',' 16:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 23 ,' 17:01:00 ',' 17:06:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 24 ,' 17:16:00 ',' 17:21:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (23, 25 ,' 17:27:00 ',' 17:32:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 1 ,' 09:55:00 ',' 10:00:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 2 ,' 10:15:00 ',' 10:20:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 3 ,' 10:34:00 ',' 10:39:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 4 ,' 10:52:00 ',' 10:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 5 ,' 11:22:00 ',' 11:27:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 6 ,' 11:54:00 ',' 11:59:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 7 ,' 12:20:00 ',' 12:25:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 8 ,' 12:52:00 ',' 12:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 9 ,' 13:20:00 ',' 13:25:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 10 ,' 13:38:00 ',' 13:43:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 11 ,' 13:48:00 ',' 13:53:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 12 ,' 14:10:00 ',' 14:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 13 ,' 14:44:00 ',' 14:49:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 14 ,' 15:10:00 ',' 15:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 15 ,' 15:42:00 ',' 15:47:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 16 ,' 16:09:00 ',' 16:14:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 17 ,' 16:47:00 ',' 16:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 18 ,' 17:11:00 ',' 17:16:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 19 ,' 17:31:00 ',' 17:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 20 ,' 17:47:00 ',' 17:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 21 ,' 18:05:00 ',' 18:10:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 22 ,' 18:31:00 ',' 18:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 23 ,' 19:01:00 ',' 19:06:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 24 ,' 19:16:00 ',' 19:21:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (24, 25 ,' 19:27:00 ',' 19:32:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 1 ,' 11:55:00 ',' 12:00:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 2 ,' 12:15:00 ',' 12:20:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 3 ,' 12:34:00 ',' 12:39:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 4 ,' 12:52:00 ',' 12:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 5 ,' 13:22:00 ',' 13:27:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 6 ,' 13:54:00 ',' 13:59:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 7 ,' 14:20:00 ',' 14:25:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 8 ,' 14:52:00 ',' 14:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 9 ,' 15:20:00 ',' 15:25:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 10 ,' 15:38:00 ',' 15:43:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 11 ,' 15:48:00 ',' 15:53:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 12 ,' 16:10:00 ',' 16:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 13 ,' 16:44:00 ',' 16:49:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 14 ,' 17:10:00 ',' 17:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 15 ,' 17:42:00 ',' 17:47:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 16 ,' 18:09:00 ',' 18:14:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 17 ,' 18:47:00 ',' 18:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 18 ,' 19:11:00 ',' 19:16:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 19 ,' 19:31:00 ',' 19:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 20 ,' 19:47:00 ',' 19:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 21 ,' 20:05:00 ',' 20:10:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 22 ,' 20:31:00 ',' 20:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 23 ,' 21:01:00 ',' 21:06:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 24 ,' 21:16:00 ',' 21:21:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (25, 25 ,' 21:27:00 ',' 21:32:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 1 ,' 15:55:00 ',' 16:00:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 2 ,' 16:15:00 ',' 16:20:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 3 ,' 16:34:00 ',' 16:39:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 4 ,' 16:52:00 ',' 16:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 5 ,' 17:22:00 ',' 17:27:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 6 ,' 17:54:00 ',' 17:59:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 7 ,' 18:20:00 ',' 18:25:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 8 ,' 18:52:00 ',' 18:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 9 ,' 19:20:00 ',' 19:25:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 10 ,' 19:38:00 ',' 19:43:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 11 ,' 19:48:00 ',' 19:53:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 12 ,' 20:10:00 ',' 20:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 13 ,' 20:44:00 ',' 20:49:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 14 ,' 21:10:00 ',' 21:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 15 ,' 21:42:00 ',' 21:47:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 16 ,' 22:09:00 ',' 22:14:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 17 ,' 22:47:00 ',' 22:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 18 ,' 23:11:00 ',' 23:16:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 19 ,' 23:31:00 ',' 23:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 20 ,' 23:47:00 ',' 23:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 21 ,' 00:05:00 ',' 00:10:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 22 ,' 00:31:00 ',' 00:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 23 ,' 01:01:00 ',' 01:06:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 24 ,' 01:16:00 ',' 01:21:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (26, 25 ,' 01:27:00 ',' 01:32:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 1 ,' 17:55:00 ',' 18:00:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 2 ,' 18:15:00 ',' 18:20:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 3 ,' 18:34:00 ',' 18:39:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 4 ,' 18:52:00 ',' 18:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 5 ,' 19:22:00 ',' 19:27:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 6 ,' 19:54:00 ',' 19:59:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 7 ,' 20:20:00 ',' 20:25:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 8 ,' 20:52:00 ',' 20:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 9 ,' 21:20:00 ',' 21:25:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 10 ,' 21:38:00 ',' 21:43:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 11 ,' 21:48:00 ',' 21:53:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 12 ,' 22:10:00 ',' 22:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 13 ,' 22:44:00 ',' 22:49:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 14 ,' 23:10:00 ',' 23:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 15 ,' 23:42:00 ',' 23:47:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 16 ,' 00:09:00 ',' 00:14:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 17 ,' 00:47:00 ',' 00:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 18 ,' 01:11:00 ',' 01:16:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 19 ,' 01:31:00 ',' 01:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 20 ,' 01:47:00 ',' 01:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 21 ,' 02:05:00 ',' 02:10:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 22 ,' 02:31:00 ',' 02:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 23 ,' 03:01:00 ',' 03:06:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 24 ,' 03:16:00 ',' 03:21:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (27, 25 ,' 03:27:00 ',' 03:32:00 ');

INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 1 ,' 19:55:00 ',' 20:00:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 2 ,' 20:15:00 ',' 20:20:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 3 ,' 20:34:00 ',' 20:39:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 4 ,' 20:52:00 ',' 20:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 5 ,' 21:22:00 ',' 21:27:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 6 ,' 21:54:00 ',' 21:59:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 7 ,' 22:20:00 ',' 22:25:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 8 ,' 22:52:00 ',' 22:57:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 9 ,' 23:20:00 ',' 23:25:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 10 ,' 23:38:00 ',' 23:43:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 11 ,' 23:48:00 ',' 23:53:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 12 ,' 00:10:00 ',' 00:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 13 ,' 00:44:00 ',' 00:49:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 14 ,' 01:10:00 ',' 01:15:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 15 ,' 01:42:00 ',' 01:47:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 16 ,' 02:09:00 ',' 02:14:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 17 ,' 02:47:00 ',' 02:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 18 ,' 03:11:00 ',' 03:16:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 19 ,' 03:31:00 ',' 03:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 20 ,' 03:47:00 ',' 03:52:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 21 ,' 04:05:00 ',' 04:10:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 22 ,' 04:31:00 ',' 04:36:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 23 ,' 05:01:00 ',' 05:06:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 24 ,' 05:16:00 ',' 05:21:00 ');
INSERT INTO stops_at (train_id,station_id,time_in,time_out) 
	VALUES (28, 25 ,' 05:27:00 ',' 05:32:00 ');

/* }}} ****************************************************/

/* }}} ****************************************************/

/* Constraints: {{{ ***************************************/

ALTER TABLE trains 
	ADD foreign key(train_start) references stations(station_id);
ALTER TABLE trains 
	ADD foreign key(train_end) references stations(station_id);

alter table segments 
	add foreign key(seg_n_end) references stations(station_id);
alter table segments 
	add foreign key(seg_s_end) references stations(station_id);

ALTER TABLE seats_free 
	ADD foreign key(segment_id) REFERENCES segments(segment_id);
ALTER TABLE seats_free 
	ADD foreign key(train_id) REFERENCES trains(train_id);

ALTER TABLE trips 
	ADD foreign key(trip_seg_start) REFERENCES segments(segment_id);
ALTER TABLE trips 
	ADD foreign key(trip_seg_ends) REFERENCES segments(segment_id);
ALTER TABLE trips 
	ADD foreign key(trip_train_id) REFERENCES trains(train_id);
ALTER TABLE trips 
	ADD foreign key(reservation_id) REFERENCES reservations(reservation_id);
ALTER TABLE trips
	ADD foreign key(fare_type) REFERENCES fare_types(fare_id);

ALTER TABLE stops_at 
	ADD PRIMARY KEY (train_id,station_id);
ALTER TABLE stops_at 
	ADD foreign key(train_id) references trains(train_id)
ALTER TABLE stops_at 
	ADD foreign key(station_id) references stations(station_id)

/* Indexes: {{{********************************************/

create unique index station_sym_ind on stations (station_symbol);

/* Index:
 * seats_free on dates and segments, so that we can quickly see if a segment is free on a particular date.
 * trips on reservation_id, so we can quickly find all the tickets for a reservation.

/* }}} ****************************************************/

/* }}} ****************************************************/

