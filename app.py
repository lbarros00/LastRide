import MySQLdb
import config # config.py, where our configuration variables are stored.
from flask import Flask, request, render_template
import datetime
import calendar
# For examining the environment of the interpreter.
import os

def add_days(sourcedate, months, days):
    month = sourcedate.month - 1 + months
    year = int(sourcedate.year + month / 12)
    month = month % 12 + 1
    day = min(sourcedate.day + days, calendar.monthrange(year, month)[1])
    return datetime.date(year, month, day)


app = Flask(__name__)

# Source: https://cloud.google.com/appengine/docs/standard/python/cloud-sql/
def create_db():
    # I can't detect local/live conditions yet, so for now I'll just use
    # try/catch blocks with more local options being fallbacks.

    # Try to connect as if deployed on GCP.
    try:
        db = MySQLdb.connect(
            unix_socket='/cloudsql/{connection}'.format(
                connection=config.CLOUDSQL_CONNECTION_NAME
                ),
                user=config.CLOUDSQL_USER,
                passwd=config.CLOUDSQL_PASSWORD,
                db=config.CLOUDSQL_DATABASE
            )
        return db
    except Exception as e:
        print("Not connecting on live environment.")
        print("Reason: {}".format(e))
    
    # Try to connect as if google-cloud-proxy is running.
    try:
        db = MySQLdb.connect(
                host="127.0.0.1",
                user=config.CLOUDSQL_USER,
                passwd=config.CLOUDSQL_PASSWORD,
                db=config.CLOUDSQL_DATABASE
            )
        return db
    except Exception as e:
        print("Couldn't connect to GCP DB through cloud-sql-proxy")
        print("Reason: {}".format(e))

    # Try to connect to Laisa's local database.
    try:
        db = MySQLdb.connect(
                "localhost",
                "root",
                "",
                "team1")  # connects to the database
        return db
    except Exception as e:
        print("Not able to connect to any of the databases.")
        print("Reason: {}".format(e))
        raise

@app.route('/', methods=['get', 'post'])
def home():  # index page index.html

    db = create_db()
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
    db = create_db()
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

@app.errorhandler(500)
def server_error(e):
    return """
    An internal error occurred: <pre>{}</pre>
    See logs for full stacktrace.
    """.format(e), 500


if __name__ == '__main__':
    app.run()
