import MySQLdb
from flask import Flask, request, render_template

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
    cur.callproc('s17336team1.show_trains', [dt, tm, fromstation, tostation, adult]) # call procedure show_trains()

    fetchedData = [(r[2], r[4], r[5], r[6], r[7]) for r in cur.fetchall()] # break down of data from show_trains()

    return render_template('results.html', m=fetchedData)  # m refers to object in the database to be rendered in results


@app.route('/login', methods=['get', 'post'])
def login():
    return render_template('login.html')


@app.route('/register', methods=['get', 'post'])
def register():
    # first = request.form['first']
    # last = request.form['last']
    # email = request.form['email']
    # passwrd = request.form['passwrd']
    # cardNum = request.form['cardnum']
    # address = request.form['address']
    # ob = db.cursor()
    # query = "INSERT INTO s17336team1.passengers (fname, lname, email, password, preferred_card_number, preferred_billing_address) VALUES ('')"
    return render_template('register.html')


if __name__ == '__main__':
    app.run()
