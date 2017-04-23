import MySQLdb
from flask import Flask, request, render_template
import datetime
import calendar

def add_days(sourcedate, months, days):     # increments by days and months to generate dates
    month = sourcedate.month - 1 + months
    year = int(sourcedate.year + month / 12)
    month = month % 12 + 1
    day = min(sourcedate.day + days, calendar.monthrange(year, month)[1])
    return datetime.date(year, month, day)

def add_hours(sourcetime, hrs, mins):       # add hours and minutes to generate times
    hr = sourcetime.hour + hrs
    min = sourcetime.minute + mins
    sec = sourcetime.second
    if min > 59:
        return datetime.time(hr, 0, sec)
    else:
        return datetime.time(hr, min, sec)

def my_dates_list():
    now = datetime.date(datetime.date.today().year, 1, 1)
    my_dates = []                 # array to store generated dates

    for n in range(12):           # generates dates starting from 01-01-(Current Year) for 365 days
        for i in range(31):
            d = add_days(now, n, i)
            d.strftime("%m-%d-%Y")
            my_dates.append(d)
            if (my_dates[len(my_dates) - 1] != d):
                my_dates.append(d)
    return my_dates

def my_times_list():
    hrs = datetime.time(0, 0, 0)  # initialize time to midnight
    my_times = []                 # array to store all possible times

    for i in range(24):
        for j in range(1):
            h = add_hours(hrs, i, 30)
            f = datetime.time(i, 0, 0)
            h.strftime("%H:%M:%S")
            f.strftime("%H:%M:%S")
            my_times.append(f)
            my_times.append(h)
    return my_times

def num_passengers():
    number_of_passengers = []
    for i in range(21):
        number_of_passengers.append(i)
    return number_of_passengers

app = Flask(__name__)


@app.route('/', methods=['get', 'post'])
def home():  # index page index.html
    db = MySQLdb.connect("localhost", "root", "", "team1")  # connects to the database
    ob = db.cursor()
    query = 'SELECT stations.station_name FROM s17336team1.stations'
    ob.execute(query)

    my_dates = my_dates_list()
    my_times = my_times_list()
    passengers = num_passengers()

    fetchedStations = [r[0] for r in ob.fetchall()]

    return render_template('index.html', my_stations=fetchedStations, dates=my_dates, times=my_times, numbers=passengers)


@app.route('/result', methods=['post'])
def result():  # routes to the results upon query
    station = request.form['station']
    db = MySQLdb.connect("localhost", "root", "", "team1")  # connects to the database
    ob = db.cursor()
    query = 'SELECT stations.station_name FROM s17336team1.stations'
    ob.execute(query)
    return render_template('results.html', m=ob.fetchall())  # m refers to object in the database to be rendered in results


@app.route('/login', methods=['get', 'post'])
def login():
    return render_template('login.html')


@app.route('/register', methods=['get', 'post'])
def register():
    return render_template('register.html')


if __name__ == '__main__':
    app.run()
