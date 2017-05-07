import MySQLdb
from flask import Flask, request, render_template, session

db = MySQLdb.connect("localhost", "root", "", "s17336team1")  # connects to the database

# generate number of passengers to be input in a reservation
def num_passengers():
    number_of_passengers = []
    for i in range(21):
        number_of_passengers.append(i)
    return number_of_passengers

app = Flask(__name__)

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

    cur = db.cursor()

    # call procedure show_trains()
    cur.callproc('s17336team1.show_trains', [dt, tm, fromstation, tostation, adult])

    # break down of data from show_trains()
    fetchedData = [(r[0], r[2], r[4], r[5], r[6], r[7]) for r in cur.fetchall()]

    # m refers to object in the database to be rendered in results
    return render_template('results.html', m=fetchedData)


@app.route('/login', methods=['get', 'post'])
def login():
    # email = request.form['email']
    # passwrd = request.form['passwrd']
    cur = db.cursor()
    # query = "SELECT * from s17336team1.passengers WHERE passengers.email LIKE '"+email+"'"
    # cur.execute(query)
    # return render_template('login.html')

    return render_template('login.html')

# def getlogin():
#     email = request.form['email']
#     # passwrd = request.form['passwrd']
#     cur = db.cursor()
#     query = "SELECT * from s17336team1.passengers WHERE passengers.email LIKE '" + email + "';"
#     cur.execute(query)
#     return render_template('success.html')

@app.route('/logout')
def logout():
    session.pop('username', None)
    return render_template('login.html')

@app.route('/dashboard', methods=['get', 'post'])
def success():
    return render_template('success.html')

# renders page where you can register for an account with LastRide
@app.route('/register', methods=['get', 'post'])
def register():
    return render_template('register.html')

# this method takes care of inserting new passenger data into the passengers table
@app.route('/welcome', methods=['get','post'])
def getUser():
    first = request.form['first']
    last = request.form['last']
    email = request.form['email']
    passwrd = request.form['passwrd']
    cardNum = request.form['cardnum']
    address = request.form['address']

    ob = db.cursor()
    query = ("INSERT INTO s17336team1.passengers" +
             "(fname, lname, email, password, preferred_card_number, preferred_billing_address)" +
             "VALUES ('{}', '{}', '{}', '{}', '{}', '{}');").format(first, last, email, passwrd, cardNum, address)
    ob.execute(query)

    # we must commit the data to the database in order for it to be inserted
    db.commit()
    return render_template('success.html')


if __name__ == '__main__':
    app.run()

