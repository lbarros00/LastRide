import MySQLdb
from flask import Flask, flash, request, render_template, redirect, url_for
from flask_login import LoginManager, UserMixin, login_required, login_user, logout_user
from werkzeug.security import generate_password_hash, check_password_hash

# connects to the database
db = MySQLdb.connect("localhost", "root", "", "s17336team1")

# generate number of passengers to be input in a reservation
def num_passengers():
    number_of_passengers = []
    for i in range(21):
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
    ob = db.cursor()
    query = 'SELECT stations.station_name FROM s17336team1.stations'
    ob.execute(query)

    passengers = num_passengers()  # generate a list with max passenger number for reservation

    fetchedStations = [r[0] for r in ob.fetchall()]  # break down data for stations

    return render_template('index.html', my_stations=fetchedStations, numbers=passengers)


# routes to the results upon query
@app.route('/result', methods=['get', 'post'])
def result():
    tostation = request.form['tostation']
    fromstation = request.form['fromstation']
    dt = request.form['date']
    tm = request.form['time']
    adult = request.form['adult']
    # child = request.form['child']
    # senior = request.form['senior']
    # total = adult + child + senior

    # station_id = db.cursor()
    cur = db.cursor()

    # query = "SELECT stations.station_symbol FROM s17336team1.stations WHERE station_name LIKE '"+tostation+"';"

    # call procedure show_trains()
    cur.callproc('s17336team1.show_trains', [dt, tm, fromstation, tostation, adult])

    # break down of data from show_trains()
    fetchedData = [(r[0], r[2], r[4], r[5], r[6], r[7]) for r in cur.fetchall()]

    # m refers to object in the database to be rendered in results
    return render_template('results.html', m=fetchedData)


@app.route('/login', methods=['get', 'post'])
def login():
    return render_template('login.html')

@app.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('login'))

@app.route('/dashboard', methods=['get', 'post'])
@login_required
def success():
    return render_template('success.html')

def getlogin():
    email = request.form['email']
    passwrd = request.form['passwrd']

    # check whether or not password matches with the email
    cur = db.cursor()
    passes = "SELECT passengers.password from s17336team1.passengers WHERE email LIKE '" + email + "';"
    cur.execute(passes)

    fetchPass = [r[0] for r in cur.fetchall()]

    if check_password_hash(fetchPass[0], passwrd):
        user = User()
        user.id = email
        login_user(user)
        return redirect(url_for('success'))
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
