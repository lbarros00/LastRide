## LastRide

In order to run this application you will need to have installed: <br/>
<br/>
Flask 0.12.1 <br/>
Jinja2 2.9.6 <br/>
MySQL-python 1.2.5 <br/>
Werkzeug 0.12.1 <br/>
mysql 0.0.1 <br/>
mysql-connector-python 2.1.5 <br/>
pip 9.0.1 <br/>
setuptools 28.8.0 <br/>
<br/>
Once you have all the required packages installed just run: <br/>
<br/>
<code>python app.py</code>
<br/>


## Index Page 

This is the initial page (defined in 'templates/index.html') you see when you open the app. It provides you with some of the tables within the database so that you can see what has been modified within the table.
These tables are passengers ('templates/passengers.html'), reservations ('templates/reservations.html'), free seats ('templates/freeseats.html'), and trips ('templates/trips.html'). <br/>


## Register

The register page (defined in 'templates/register.html') allows you to register as a user to save reservations you have made. <br/>

## Login

Upon login (defined in 'templates/login.html') you can find a trip by being redirected to the dashboard (defined in 'templates/success.html'). <br/>

## Results 

This page (defined in 'templates/results.html') retrives the results from (database/show_trains_v3.sql) for one way trip. <br/>

## Round Trip

Upon selecting your one way trip, you are redirected to a new page (defined in 'templates/roundtrip.html') where you can either select a round trip and be redirected to the results for your round trip (defined in 'templates/results_roundtrip.html') or you can finalize your booking (defined in 'templates/finish_booking.html'). <br/>

## Finish Booking and Reservations

By clicking book your trip, we are creating a trip and reservation ID (database/create_trip_stations_v2.sql), you can now have a reservation number for which you will be able to cancel (database/trip_res_cancel_v2.sql) it if you no longer wish to travel in the page defined in 'templates/reservation_number.html' <br/>

## Problems

Here are some problems that we encountered on the development of this application: <br/>
- setting up login. <br/><b>Solution:</b> Flask-Login package
- when trying to call show_trains procedure twice with different cursors in a function in the front end. <br/><b>Solution:</b> break it down into different templates so that we are using different functions to call show_trains procedure for round trip
- taking into account that once you call a procedure that changes one of the tables in the database, you have to commit it in the front end in order for the table to change in the back end. <br/><b>Solution:</b> calling db.commit() after calling the create_trip_stations procedure and trip_cancel procedure as well as after inserting into passengers table
<br/>
## Enjoy the ride!
