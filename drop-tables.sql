/* This procedure drops tables in such a valid order.
 * Tables that are referred to by other tables can't be deleted
 * first. */

/* trips        : Nothing refers to trips */
/* seats_free   : Nothing refers to seats_free */
/* stops_at     : Nothing refers to stops at */
/* fare_types   : Only trips referred to fares */
/* reservations : Only trips referred to reservations */
/* passengers   : Only reservations refers to passengers */
/* trains       : trips, seats, and stops referred to trains */
/* segments     : trips, seats referred to segments */
/* stations     : trains, segments, stops referred to stations */

DELIMITER //

drop procedure if exists drop_tables;
create procedure drop_tables()
begin
	drop table if exists 
    trips,
    seats_free,
    stops_at,
    fare_types,
    reservations,
    passengers,
    trains,
    segments,
    stations;
end//

DELIMITER ;


