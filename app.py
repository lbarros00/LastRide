from datetime import timedelta

import MySQLdb
from flask import Flask, flash, request, render_template, redirect, url_for, session
from flask_login import LoginManager, UserMixin, login_required, login_user, logout_user
from werkzeug.security import generate_password_hash, check_password_hash

# connects to the database
db = MySQLdb.connect("localhost", "root", "", "s17336team1")

# generate number of passengers to be input in a reservation
def num_passengers():
    number_of_passengers = []
    for i in range(16):
        number_of_passengers.append(i)
    return number_of_passengers

# get all emails in the passengers table
def giveMyUsers():
    cur = db.cursor()
    users = 'SELECT passengers.email from s17336team1.passengers;'
    cur.execute(users)
    fetchUsers = [r[0] for r in cur.fetchall()]
    return fetchUsers

app = Flask(__name__)
app.secret_key = 'supersecretstring'

login_manager = LoginManager()

login_manager.init_app(app)

users = giveMyUsers()

class User(UserMixin): pass

@app.before_request
def make_session_permanent():
    session.permanent = True
    app.permanent_session_lifetime = timedelta(hours=8)

@login_manager.user_loader
def user_loader(email):
    if email not in users:
        return

    user = User()
    user.id = email
    return user

@login_manager.request_loader
def request_loader(request):
    email = request.form.get('email')
    passwrd = request.form.get('passwrd')

    if email not in users:
        return

    user = User()
    user.id = email

    cur = db.cursor()
    passes = "SELECT passengers.password from s17336team1.passengers WHERE email LIKE '"+email+"';"
    cur.execute(passes)

    fetchPass = [r[0] for r in cur.fetchall()]

    if check_password_hash(fetchPass, passwrd):
        user.is_authenticated()

    return user

# renders index page index.html
@app.route('/', methods=['get', 'post'])
def home():
    passengers = num_passengers()  # generate a list with max passenger number for reservation

    return render_template('index.html', numbers=passengers)

@app.route('/passengers', methods=['get', 'post'])
def passengers():
    cur = db.cursor()
    query = 'SELECT * FROM s17336team1.passengers'
    cur.execute(query)
    fetchPassengersData = [(r[0], r[1], r[2], r[3], r[4], r[5], r[6]) for r in cur.fetchall()]

    return render_template('passengers.html', myPassengers=fetchPassengersData)

@app.route('/reservations', methods=['get', 'post'])
def reservations():
    cur = db.cursor()
    query = 'SELECT * FROM s17336team1.reservations'
    cur.execute(query)
    fetchedReservations = [(r[0], r[1], r[2], r[3], r[4]) for r in cur.fetchall()]
    return render_template('reservations.html', myReservations=fetchedReservations)

@app.route('/freeseats', methods=['get', 'post'])
def freeseats():
    cur = db.cursor()
    query = 'SELECT * FROM s17336team1.seats_free'
    cur.execute(query)
    fetchedSeats = [(r[0], r[1], r[2], r[3]) for r in cur.fetchall()]
    return render_template('freeseats.html', mySeats=fetchedSeats)

@app.route('/trips', methods=['get', 'post'])
def trips():
    cur = db.cursor()
    query = 'SELECT * FROM s17336team1.trips'
    cur.execute(query)
    fetchedTrips = [(r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7]) for r in cur.fetchall()]
    return render_template('trips.html', myTrips=fetchedTrips)

@app.route('/roundtrip', methods=['get', 'post'])
def roundtrip():
    ob = db.cursor()
    query = 'SELECT stations.station_name FROM s17336team1.stations'
    ob.execute(query)
    fetchedStations = [r[0] for r in ob.fetchall()]  # break down data for stations

    passengers = num_passengers()

    myStations = []
    myStations += ' '
    myStations += fetchedStations

    return render_template('roundtrip.html', numbers=passengers, myStations=myStations)

@app.route('/finish_booking', methods=['get', 'post'])
def finish_booking():
    return render_template('finish_booking.html')

@app.route('/reservation_number', methods=['get', 'post'])
def reservation_id():
    return render_template('reservation_number.html')

@app.route('/results_roundtrips', methods=['get', 'post'])
def results_roundtrips():
    tostationR = request.form['tostationR']
    fromstationR = request.form['fromstationR']
    dtR = request.form['dateR']
    tmR = request.form['timeR']
    adult = request.form['adult']
    child = request.form['child']
    senior = request.form['senior']
    military = request.form['military']
    pet = request.form['pet']

    cur2 = db.cursor()
    cur2.callproc('s17336team1.show_trains', [dtR, tmR, fromstationR, tostationR, adult, child, senior, military, pet])

    # break down of data from show_trains()
    fetchedDataR = [(r[0], r[5], r[6], r[8]) for r in cur2.fetchall()]

    return render_template('results_roundtrips.html', r=fetchedDataR, toR=tostationR, fromR=fromstationR)

# routes to the results upon query
@app.route('/result', methods=['get', 'post'])
def result():
    session['tostation'] = tostation = request.form['tostation']
    session['fromstation'] = fromstation = request.form['fromstation']
    session['dt'] = dt = request.form['date']
    tm = request.form['time']
    # tostationR = request.form['tostationR']
    # fromstationR = request.form['fromstationR']
    # dtR = request.form['dateR']
    # tmR = request.form['timeR']
    adult = request.form['adult']
    child = request.form['child']
    senior = request.form['senior']
    military = request.form['military']
    pet = request.form['pet']

    cur = db.cursor()

    # call procedure show_trains()
    cur.callproc('s17336team1.show_trains', [dt, tm, fromstation, tostation, adult, child, senior, military, pet])
    #for train_id, departure, arrival, fare in cur.fetchall():
    #    pass
    fetchedData = [(r[0], r[5], r[6], r[8]) for r in cur.fetchall()]

    # cur2 = db.cursor()
    # cur2.callproc('s17336team1.show_trains', [dtR, tmR, fromstationR, tostationR, adult, child, senior, military, pet])
    #
    # # break down of data from show_trains()
    # fetchedDataR = [(r[0], r[5], r[6], r[8]) for r in cur2.fetchall()]

    # m refers to object in the database to be rendered in results
    return render_template('results.html', m=fetchedData, to=tostation, fromS=fromstation, dt=dt)

@app.route('/login', methods=['get', 'post'])
def login():
    return render_template('login.html')

@app.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('login'))

@app.route('/dashboard', methods=['get', 'post'])
@login_required
def getlogin():
    email = request.form['email']
    passwrd = request.form['passwrd']

    # check whether or not password matches with the email
    cur = db.cursor()
    passes = "SELECT passengers.password from s17336team1.passengers WHERE email LIKE '" + email + "';"
    cur.execute(passes)

    fetchPass = [r[0] for r in cur.fetchall()]

    ob = db.cursor()
    query = 'SELECT stations.station_name FROM s17336team1.stations'
    ob.execute(query)
    fetchedStations = [r[0] for r in ob.fetchall()]  # break down data for stations

    passengers = num_passengers()

    myStations = []
    myStations += ' '
    myStations += fetchedStations

    if check_password_hash(fetchPass[0], passwrd):
        user = User()
        user.id = email
        login_user(user)
        return render_template('success.html', numbers=passengers, myStations=myStations)
    else:
        flash('Incorrect Password.')
        return redirect(url_for('login'))


# renders page where you can register for an account with LastRide
@app.route('/register', methods=['get', 'post'])
def register():
    return render_template('register.html')

# this method takes care of inserting new passenger data into the passengers table
@app.route('/welcome', methods=['get', 'post'])
def getUser():
    first = request.form['first']
    last = request.form['last']
    email = request.form['email']
    passwrd = request.form['passwrd']
    cardNum = request.form['cardnum']
    address = request.form['address']

    pw = generate_password_hash(passwrd)

    em = db.cursor()
    check_email = "SELECT passengers.email from s17336team1.passengers WHERE email LIKE '"+email+"';"
    em.execute(check_email)
    fetchEmail = [r[0] for r in em.fetchall()]

    # check whether or not email already exists
    if not fetchEmail:
        ob = db.cursor()
        query = ("INSERT INTO s17336team1.passengers" +
                 "(fname, lname, email, password, preferred_card_number, preferred_billing_address)" +
                 "VALUES ('{}', '{}', '{}', '{}', '{}', '{}');").format(first, last, email, pw, cardNum, address)
        ob.execute(query)

        # we must commit the data to the database in order for it to be inserted
        db.commit()
        # successful registration redirect to login page
        return redirect(url_for('login'))
    else:
        if fetchEmail[0] == email and email != '':
            flash('User ' + fetchEmail[0] + ' already exists.')
        else:
            flash('Please fill out blank fields.')
        return redirect(url_for('register'))


if __name__ == '__main__':
    app.run()
