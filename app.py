import MySQLdb
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
def connect_to_cloudsql():
    # These environment variables are configured in app.yaml.
    CLOUDSQL_CONNECTION_NAME = os.environ.get('CLOUDSQL_CONNECTION_NAME')
    CLOUDSQL_USER = os.environ.get('CLOUDSQL_USER')
    CLOUDSQL_PASSWORD = os.environ.get('CLOUDSQL_PASSWORD')

    # When deployed to App Engine, the `SERVER_SOFTWARE` environment variable
    # will be set to 'Google App Engine/version'.
    if os.getenv('SERVER_SOFTWARE', '').startswith('Google App Engine/'):
        # Connect using the unix socket located at
        # /cloudsql/cloudsql-connection-name.
        cloudsql_unix_socket = os.path.join(
            '/cloudsql', CLOUDSQL_CONNECTION_NAME)

        db = MySQLdb.connect(
            unix_socket=cloudsql_unix_socket,
            user=CLOUDSQL_USER,
            passwd=CLOUDSQL_PASSWORD)

    # If the unix socket is unavailable, then try to connect using TCP. This
    # will work if you're running a local MySQL server or using the Cloud SQL
    # proxy, for example:
    #
    #   $ cloud_sql_proxy -instances=your-connection-name=tcp:3306
    #
    # If this was started using dev_appserver.py or on GCP
    elif CLOUDSQL_USER and CLOUDSQL_PASSWORD:
        db = MySQLdb.connect(
            host='127.0.0.1', user=CLOUDSQL_USER, passwd=CLOUDSQL_PASSWORD)
    # If this is being run on Laisa's computer.
    else:
        db = MySQLdb.connect("localhost", "root", "", "team1")  # connects to the database

    return db

@app.route('/', methods=['get', 'post'])
def home():  # index page index.html

    db = connect_to_cloudsql()
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
