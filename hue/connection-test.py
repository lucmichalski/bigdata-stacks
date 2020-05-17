#!/usr/bin/python 
''' Run connection test to run hue only when mysql is already started  '''
import MySQLdb
from subprocess import call

hostname = 'database'
username = 'root'
password = 'secret'
database = 'hue' 

result = None
myConnection = None

while result is None:
    try:
        myConnection = MySQLdb.connect(host=hostname, user=username, passwd=password, db=database)
        cur = myConnection.cursor()
        cur.execute("SELECT version()")
        result = cur.fetchone()
    except Exception as e:
        print(str(e))
        pass

myConnection.close()
  

# print("Running HUE startup script...")
# call("./startup.sh")