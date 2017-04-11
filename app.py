import MySQLdb
from flask import Flask, request, render_template

app = Flask(__name__)

@app.route('/')
def home(): # index page index.html
    return render_template('index.html')

@app.route('/result', methods=['post'])
def result(): # routes to the results upon query
    station = request.form['station']
    db = MySQLdb.connect("localhost","root","","team1") # connects to the database
    ob = db.cursor()
    query = 'select * from team1.stations WHERE stations.station_symbol LIKE "'+station+'"'
    ob.execute(query)
    return render_template('results.html', m=ob.fetchone()) # m refers to object in the database to be rendered in results

if __name__ == '__main__':
    app.run()
