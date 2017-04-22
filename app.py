import MySQLdb
from flask import Flask, request, render_template
import datetime
import calendar

def add_days(sourcedate, months, days):
    month = sourcedate.month - 1 + months
    year = int(sourcedate.year + month / 12)
    month = month % 12 + 1
    day = min(sourcedate.day + days, calendar.monthrange(year, month)[1])
    return datetime.date(year, month, day)


app = Flask(__name__)


@app.route('/', methods=['get', 'post'])
def home():  # index page index.html
    db = MySQLdb.connect("localhost", "root", "", "team1")  # connects to the database
    ob = db.cursor()
    query = 'SELECT stations.station_name FROM s17336team1.stations'
    ob.execute(query)

    now = datetime.date(datetime.date.today().year, 1, 1)
    print(now)
    my_list = []
    for n in range(12):
        for i in range(31):
            d = add_days(now, n, i)
            d.strftime("%m-%d-%Y")
            my_list.append(d)
            print(my_list[n])
            if (my_list[len(my_list)-1] != d):
                my_list.append(d)

    return render_template('index.html', my_stations=ob.fetchall(), dates=my_list)


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
