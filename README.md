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
python app.py
<br/>

## Index Page (defined in 'index.html' within the templates directory)

This is the initial page you see when you open the app. It provides you with some of the tables within the database so that you can see what has been modified within the table.
These tables are passengers, reservations, free seats, and trips. <br/>
<br/>

## Register (defined in 'register.html' within the templates directory)

Allows you to register as a user to save reservations you have made.

## Login (defined in 'login.html' within the templates directory)

Upon login you can find a trip (defined in 'success.html' within the templates directory).

## Results (defined in 'results.html' within the templates directory)  

Results are shown (show_trains_v3.sql) for one way or round trip. Upon selecting your trip (create_trip_stations_v2.sql), you can now have a reservation number for which you will be able to cancel (trip_res_cancel_v2.sql) it if you no longer wish to travel.

## Enjoy the ride!
